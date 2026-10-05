import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:miniplayer/miniplayer.dart';

import '../../core/config/server_config.dart';
import '../../data/models/scene.dart';
import '../../data/models/scene_details.dart';
import '../../data/providers.dart';
import '../../data/repositories/stash_repository.dart';
import '../cast/cast_media.dart';
import '../cast/cast_providers.dart';
import 'playback_tracker.dart';

const double kMiniPlayerHeight = 64;

/// One player for the whole app, so playback survives expanding/collapsing
/// the miniplayer and navigating between tabs.
final playerProvider = Provider<Player>((ref) {
  final player = Player();
  ref.onDispose(player.dispose);
  return player;
});

final videoControllerProvider = Provider<VideoController>(
  (ref) => VideoController(ref.watch(playerProvider)),
);

final miniplayerControllerProvider = Provider<MiniplayerController>((ref) {
  final controller = MiniplayerController();
  ref.onDispose(controller.dispose);
  return controller;
});

/// Current miniplayer height in pixels; drives the bottom navigation bar.
final miniplayerHeightProvider = Provider<ValueNotifier<double>>((ref) {
  final notifier = ValueNotifier<double>(kMiniPlayerHeight);
  ref.onDispose(notifier.dispose);
  return notifier;
});

/// Resume positions saved during this app session, by scene id. Lists use
/// them so progress bars are current without refetching.
class ResumeTimesNotifier extends Notifier<Map<String, double>> {
  @override
  Map<String, double> build() => const {};

  void set(String sceneId, double resumeTime) => state = {...state, sceneId: resumeTime};
}

final resumeTimesProvider = NotifierProvider<ResumeTimesNotifier, Map<String, double>>(ResumeTimesNotifier.new);

/// Resume position of [scene], preferring what was saved in this session.
double effectiveResumeTime(WidgetRef ref, Scene scene) =>
    ref.watch(resumeTimesProvider.select((m) => m[scene.id])) ?? scene.resumeTime;

/// Connects the player's streams to a [PlaybackTracker] (resume + play count).
final playbackTrackerProvider = Provider<PlaybackTracker>((ref) {
  final player = ref.watch(playerProvider);
  final tracker = PlaybackTracker(
    api: ref.watch(stashRepositoryProvider),
    onResumeSaved: (id, time) => ref.read(resumeTimesProvider.notifier).set(id, time),
  );
  final subscriptions = [
    player.stream.position.listen(tracker.onPosition),
    player.stream.playing.listen(tracker.onPlaying),
    player.stream.duration.listen(tracker.onDuration),
  ];
  // Save progress when the app is backgrounded or closed.
  final lifecycle = AppLifecycleListener(onHide: tracker.flush, onDetach: tracker.flush);

  ref.onDispose(() {
    for (final s in subscriptions) {
      s.cancel();
    }
    lifecycle.dispose();
    unawaited(tracker.stop());
  });
  return tracker;
});

/// Stream label (e.g. "HLS 720p") to use when available; null = direct file.
class PreferredStreamNotifier extends Notifier<String?> {
  static const _key = 'preferred_stream';

  @override
  String? build() => ref.watch(sharedPreferencesProvider).getString(_key);

  Future<void> set(String? label) async {
    state = label;
    final prefs = ref.read(sharedPreferencesProvider);
    if (label == null) {
      await prefs.remove(_key);
    } else {
      await prefs.setString(_key, label);
    }
  }
}

final preferredStreamProvider = NotifierProvider<PreferredStreamNotifier, String?>(PreferredStreamNotifier.new);

/// The transcode currently playing; null while playing the direct file.
class CurrentStreamNotifier extends Notifier<SceneStream?> {
  @override
  SceneStream? build() => null;

  void set(SceneStream? stream) => state = stream;
}

final currentStreamProvider = NotifierProvider<CurrentStreamNotifier, SceneStream?>(CurrentStreamNotifier.new);

/// True while the miniplayer slides away after tapping close.
class PlayerClosingNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool closing) => state = closing;
}

final playerClosingProvider = NotifierProvider<PlayerClosingNotifier, bool>(PlayerClosingNotifier.new);

/// Scenes played one after another (watch later, a group), with the one
/// currently playing.
class PlayQueue {
  const PlayQueue({required this.title, required this.scenes, this.index = 0});

  final String title;
  final List<Scene> scenes;
  final int index;

  bool get hasNext => index + 1 < scenes.length;

  PlayQueue at(int index) => PlayQueue(title: title, scenes: scenes, index: index);
}

class PlayQueueNotifier extends Notifier<PlayQueue?> {
  @override
  PlayQueue? build() => null;

  void set(PlayQueue? queue) => state = queue;
}

final playQueueProvider = NotifierProvider<PlayQueueNotifier, PlayQueue?>(PlayQueueNotifier.new);

/// Emits true when the current media played to the end.
final playerCompletedProvider = StreamProvider<bool>((ref) => ref.watch(playerProvider).stream.completed);

/// The scene in the player, or null when the player is closed.
class NowPlayingNotifier extends Notifier<Scene?> {
  /// Last position reported by the cast device, to continue locally after
  /// disconnecting.
  Duration _lastCastPosition = Duration.zero;

  @override
  Scene? build() {
    // Autoplay: continue with the next scene of the queue.
    ref.listen(playerCompletedProvider, (_, next) {
      if (next.value == true) playNext();
    });
    ref.listen(castPlaybackProvider, (_, next) {
      final position = next.value?.position;
      if (position != null && position > Duration.zero) _lastCastPosition = position;
    });
    ref.listen(isCastingProvider, (wasCasting, casting) {
      final scene = state;
      if (scene == null) return;
      final player = ref.read(playerProvider);
      if (casting && wasCasting != true) {
        // Hand the current scene over to the cast device.
        player.pause();
        unawaited(_castScene(scene, player.state.position));
      } else if (!casting && wasCasting == true) {
        // Continue locally where the cast device was (paused).
        player.seek(_lastCastPosition);
      }
    });
    return null;
  }

  /// Plays [scenes] in order, starting at [start] (9.3, 9.4).
  void playQueue(List<Scene> scenes, {required String title, int start = 0}) {
    if (scenes.isEmpty) return;
    final queue = PlayQueue(title: title, scenes: scenes, index: start.clamp(0, scenes.length - 1));
    ref.read(playQueueProvider.notifier).set(queue);
    play(queue.scenes[queue.index]);
  }

  /// Next scene of the queue, if any.
  void playNext() {
    final queue = ref.read(playQueueProvider);
    if (queue == null || !queue.hasNext) return;
    ref.read(playQueueProvider.notifier).set(queue.at(queue.index + 1));
    play(queue.scenes[queue.index + 1]);
  }

  /// Plays [scene]. Inside the active queue this moves the queue position;
  /// any other scene ends the queue.
  void play(Scene scene) {
    final url = scene.streamUrl;
    if (url == null) return;

    final queue = ref.read(playQueueProvider);
    if (queue != null) {
      final i = queue.scenes.indexWhere((s) => s.id == scene.id);
      ref.read(playQueueProvider.notifier).set(i < 0 ? null : queue.at(i));
    }

    if (state == null) ref.read(miniplayerHeightProvider).value = kMiniPlayerHeight;
    ref.read(playerClosingProvider.notifier).set(false);
    if (state?.id != scene.id) {
      // Prefer the position saved in this session over the (possibly stale) list data.
      final resume = ref.read(resumeTimesProvider)[scene.id] ?? scene.resumeTime;
      unawaited(ref.read(playbackTrackerProvider).start(scene.copyWith(resumeTime: resume)));
      ref.read(currentStreamProvider.notifier).set(null);
      final start = Duration(milliseconds: (resume * 1000).round());
      unawaited(_openPreferredStream(scene, url, start));
      if (ref.read(isCastingProvider)) unawaited(_castScene(scene, start));
    }
    state = scene;
    // On first play the miniplayer is only mounted in the next frame.
    WidgetsBinding.instance.addPostFrameCallback((_) => expand());
  }

  /// Opens the user's preferred transcode if this scene offers it, else the
  /// direct file. Only waits for the stream list when a preference is set.
  Future<void> _openPreferredStream(Scene scene, String directUrl, Duration start) async {
    SceneStream? stream;
    final preferred = ref.read(preferredStreamProvider);
    if (preferred != null) {
      final details = ref.listen(sceneDetailsProvider(scene.id).future, (_, __) {});
      try {
        stream = (await details.read()).streams.where((s) => s.label == preferred).firstOrNull;
      } catch (_) {
        // Fall back to the direct file.
      } finally {
        details.close();
      }
      if (state?.id != scene.id) return; // another scene was picked meanwhile
    }
    // While casting, prepare the scene locally but play it on the cast device.
    _open(stream?.url ?? directUrl, start, play: !ref.read(isCastingProvider));
    ref.read(currentStreamProvider.notifier).set(stream);
  }

  /// Plays [scene] on the connected cast device from [start].
  Future<void> _castScene(Scene scene, Duration start) async {
    final details = ref.listen(sceneDetailsProvider(scene.id).future, (_, __) {});
    try {
      final media = castMediaFor(
        scene,
        await details.read().catchError((Object _) => const SceneDetails()),
        apiKey: ref.read(serverConfigProvider)?.apiKey,
        start: start,
      );
      if (state?.id != scene.id) return;
      await ref.read(castServiceProvider).load(media);
    } catch (e) {
      debugPrint('Casting failed: $e');
    } finally {
      details.close();
    }
  }

  /// Switches the quality of the current scene, keeping the position, and
  /// remembers the choice for future scenes.
  Future<void> selectStream(SceneStream stream) async {
    if (state == null) return;
    _open(stream.url, ref.read(playerProvider).state.position, play: !ref.read(isCastingProvider));
    ref.read(currentStreamProvider.notifier).set(stream.isDirect ? null : stream);
    await ref.read(preferredStreamProvider.notifier).set(stream.isDirect ? null : stream.label);
  }

  void seekTo(double seconds) =>
      ref.read(playerProvider).seek(Duration(milliseconds: (seconds * 1000).round()));

  void _open(String url, Duration start, {bool play = true}) {
    ref.read(playerProvider).open(
          Media(
            url,
            httpHeaders: ref.read(authHeadersProvider),
            start: start > Duration.zero ? start : null,
          ),
          play: play,
        );
  }

  void expand() => ref.read(miniplayerControllerProvider).animateToHeight(state: PanelState.MAX);

  void collapse() => ref.read(miniplayerControllerProvider).animateToHeight(state: PanelState.MIN);

  /// Shows edited metadata for the playing scene without reopening it.
  void replaceScene(Scene scene) {
    if (state?.id == scene.id) state = scene;
  }

  /// Closes with an animation: pauses right away, the shell slides the
  /// miniplayer down and then calls [close].
  void dismiss() {
    if (state == null) return;
    ref.read(playerProvider).pause();
    ref.read(playerClosingProvider.notifier).set(true);
  }

  void close() {
    ref.read(playerClosingProvider.notifier).set(false);
    ref.read(playQueueProvider.notifier).set(null);
    unawaited(ref.read(playbackTrackerProvider).stop());
    ref.read(playerProvider).stop();
    state = null;
  }
}

final nowPlayingProvider = NotifierProvider<NowPlayingNotifier, Scene?>(NowPlayingNotifier.new);
