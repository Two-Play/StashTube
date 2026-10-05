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
final currentStreamProvider = StateProvider<SceneStream?>((ref) => null);

/// The scene in the player, or null when the player is closed.
class NowPlayingNotifier extends Notifier<Scene?> {
  @override
  Scene? build() => null;

  void play(Scene scene) {
    final url = scene.streamUrl;
    if (url == null) return;

    if (state == null) ref.read(miniplayerHeightProvider).value = kMiniPlayerHeight;
    if (state?.id != scene.id) {
      // Prefer the position saved in this session over the (possibly stale) list data.
      final resume = ref.read(resumeTimesProvider)[scene.id] ?? scene.resumeTime;
      unawaited(ref.read(playbackTrackerProvider).start(scene.copyWith(resumeTime: resume)));
      ref.read(currentStreamProvider.notifier).state = null;
      unawaited(_openPreferredStream(scene, url, Duration(milliseconds: (resume * 1000).round())));
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
    _open(stream?.url ?? directUrl, start);
    ref.read(currentStreamProvider.notifier).state = stream;
  }

  /// Switches the quality of the current scene, keeping the position, and
  /// remembers the choice for future scenes.
  Future<void> selectStream(SceneStream stream) async {
    if (state == null) return;
    _open(stream.url, ref.read(playerProvider).state.position);
    ref.read(currentStreamProvider.notifier).state = stream.isDirect ? null : stream;
    await ref.read(preferredStreamProvider.notifier).set(stream.isDirect ? null : stream.label);
  }

  void seekTo(double seconds) =>
      ref.read(playerProvider).seek(Duration(milliseconds: (seconds * 1000).round()));

  void _open(String url, Duration start) {
    ref.read(playerProvider).open(Media(
      url,
      httpHeaders: ref.read(authHeadersProvider),
      start: start > Duration.zero ? start : null,
    ));
  }

  void expand() => ref.read(miniplayerControllerProvider).animateToHeight(state: PanelState.MAX);

  void collapse() => ref.read(miniplayerControllerProvider).animateToHeight(state: PanelState.MIN);

  void close() {
    unawaited(ref.read(playbackTrackerProvider).stop());
    ref.read(playerProvider).stop();
    state = null;
  }
}

final nowPlayingProvider = NotifierProvider<NowPlayingNotifier, Scene?>(NowPlayingNotifier.new);
