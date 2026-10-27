import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../../core/config/server_config.dart';
import '../../data/models/scene.dart';
import '../../data/models/scene_details.dart';
import '../../data/providers.dart';
import '../../data/repositories/stash_repository.dart';
import '../../data/repositories/stash_session.dart';
import '../cast/cast_media.dart';
import '../cast/cast_providers.dart';
import '../cast/cast_service.dart' show CastKind;
import 'playback_tracker.dart';
import 'sliding_panel.dart';
import 'video_zoom.dart';

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

final miniplayerControllerProvider = Provider<SlidingPanelController>((ref) => SlidingPanelController());

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
  Map<String, double> build() {
    ref.watch(activeServerIdProvider); // scene ids are per server
    return const {};
  }

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
  // While casting, the TV plays and the local player only waits (paused):
  // the tracker then follows the cast device instead.
  bool casting() => ref.read(isCastingProvider);
  final subscriptions = [
    player.stream.position.listen((position) {
      if (!casting()) tracker.onPosition(position);
    }),
    player.stream.playing.listen((playing) {
      if (!casting()) tracker.onPlaying(playing);
    }),
    player.stream.duration.listen(tracker.onDuration),
  ];
  ref.listen(castPlaybackProvider, (_, next) {
    final playback = next.value;
    if (playback == null || !casting()) return;
    tracker.onPlaying(playback.playing);
    tracker.onPosition(playback.position);
  });
  // Handing over in either direction ends a stretch of watching: save it.
  ref.listen(isCastingProvider, (_, _) => tracker.onPlaying(false));
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

/// Stream label (e.g. "HLS 720p") to use when available, see
/// [pickPreferredStream]; null = direct file.
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

  bool get hasPrevious => index > 0;

  PlayQueue at(int index) => PlayQueue(title: title, scenes: scenes, index: index);
}

class PlayQueueNotifier extends Notifier<PlayQueue?> {
  @override
  PlayQueue? build() {
    ref.watch(activeServerIdProvider);
    return null;
  }

  void set(PlayQueue? queue) => state = queue;
}

final playQueueProvider = NotifierProvider<PlayQueueNotifier, PlayQueue?>(PlayQueueNotifier.new);

/// A scene left in the open player, and where.
typedef PlayerHistoryEntry = ({Scene scene, double at});

/// The scenes left in the open player, like a browser's history: [back]
/// (newest last) and, after going back, [forward] (next one last).
class PlayerHistory {
  const PlayerHistory({this.back = const [], this.forward = const []});

  final List<PlayerHistoryEntry> back;
  final List<PlayerHistoryEntry> forward;

  bool get canGoBack => back.isNotEmpty;
  bool get canGoForward => forward.isNotEmpty;
  bool get isEmpty => back.isEmpty && forward.isEmpty;
}

/// See [PlayerHistory]; [NowPlayingNotifier.goBack]/[NowPlayingNotifier.goForward]
/// move through it.
class PlayerHistoryNotifier extends Notifier<PlayerHistory> {
  /// Enough to retrace a browsing session, not a whole evening.
  static const limit = 20;

  @override
  PlayerHistory build() => const PlayerHistory();

  static List<PlayerHistoryEntry> _add(List<PlayerHistoryEntry> list, PlayerHistoryEntry entry) {
    final kept = [for (final e in list) if (e.scene.id != entry.scene.id) e, entry];
    return kept.length > limit ? kept.sublist(kept.length - limit) : kept;
  }

  /// A new scene was picked: [left] goes back, the way forward is gone.
  void push(PlayerHistoryEntry left) => state = PlayerHistory(back: _add(state.back, left));

  /// The scene to go back to; [current] becomes the way forward.
  PlayerHistoryEntry? back(PlayerHistoryEntry current) {
    if (!state.canGoBack) return null;
    final target = state.back.last;
    state = PlayerHistory(back: state.back.sublist(0, state.back.length - 1), forward: _add(state.forward, current));
    return target;
  }

  /// The scene to go forward to; [current] goes back again.
  PlayerHistoryEntry? forward(PlayerHistoryEntry current) {
    if (!state.canGoForward) return null;
    final target = state.forward.last;
    state = PlayerHistory(back: _add(state.back, current), forward: state.forward.sublist(0, state.forward.length - 1));
    return target;
  }

  void clear() {
    if (!state.isEmpty) state = const PlayerHistory();
  }
}

final playerHistoryProvider = NotifierProvider<PlayerHistoryNotifier, PlayerHistory>(PlayerHistoryNotifier.new);

/// Emits true when the current media played to the end.
final playerCompletedProvider = StreamProvider<bool>((ref) => ref.watch(playerProvider).stream.completed);

/// A playback failure of the main player: mpv's message and the last
/// position that played before it, if any (to retry from there).
class PlaybackError {
  const PlaybackError(this.message, {this.position});

  final String message;
  final Duration? position;
}

/// The current playback error of the main player, or null (WATCH-1).
///
/// mpv also reports errors it recovers from (a broken frame), so an error
/// only counts once playback hasn't moved on for [confirmDelay]; playback
/// moving forward afterwards clears it again, and so does opening a file
/// (another scene, quality or [retry]). Watches the player only while a
/// scene is open, so the native player isn't created just for this.
class PlaybackErrorNotifier extends Notifier<PlaybackError?> {
  static const confirmDelay = Duration(seconds: 2);

  /// Last position that played since the current file was opened.
  Duration? _played;
  Duration? _pendingFrom;
  Timer? _confirm;

  @override
  PlaybackError? build() {
    _reset();
    _played = null;
    final sceneId = ref.watch(nowPlayingProvider.select((s) => s?.id));
    if (sceneId == null) return null;
    final player = ref.watch(playerProvider);
    final subscriptions = [
      player.stream.error.listen(_onError),
      player.stream.position.listen(_onPosition),
      // A file is opening (quality switch, retry).
      player.stream.playlist.listen((_) => clear()),
    ];
    ref.onDispose(() {
      _confirm?.cancel();
      for (final s in subscriptions) {
        s.cancel();
      }
    });
    return null;
  }

  void _onError(String message) {
    // While casting the local player only waits; the TV plays.
    if (ref.read(isCastingProvider) || _confirm != null) return;
    final from = _played;
    _pendingFrom = from ?? Duration.zero;
    _confirm = Timer(confirmDelay, () {
      _confirm = null;
      if (!ref.mounted || _pendingFrom == null) return;
      _pendingFrom = null;
      state = PlaybackError(message, position: from);
    });
  }

  void _onPosition(Duration position) {
    final from = _pendingFrom ?? state?.position ?? (state != null ? Duration.zero : null);
    if (from != null && position > from + const Duration(seconds: 1)) {
      // Playback went on: the error didn't stop it.
      _reset();
      if (state != null) state = null;
    }
    if (position > Duration.zero) _played = position;
  }

  void _reset() {
    _confirm?.cancel();
    _confirm = null;
    _pendingFrom = null;
  }

  /// Opens the scene again from where it stopped, or where it was opened
  /// if it never played.
  void retry() {
    final start = state?.position;
    clear();
    ref.read(nowPlayingProvider.notifier).reopen(start);
  }

  /// A new file is opening: forget the old one's error and position.
  void clear() {
    _reset();
    _played = null;
    if (state != null) state = null;
  }
}

final playbackErrorProvider =
    NotifierProvider<PlaybackErrorNotifier, PlaybackError?>(PlaybackErrorNotifier.new);

/// The scene in the player, or null when the player is closed.
class NowPlayingNotifier extends Notifier<Scene?> {
  /// Last position reported by the cast device, to continue locally after
  /// disconnecting.
  Duration _lastCastPosition = Duration.zero;

  /// Where the current file was opened, to retry from there when it failed
  /// before playing.
  Duration _openedAt = Duration.zero;

  @override
  Scene? build() {
    // Switching servers: the scene belongs to the old server.
    ref.listen(activeServerIdProvider, (previous, next) {
      if (previous != next && state != null) close();
    });
    ref.listen(castPlaybackProvider, (_, next) {
      final position = next.value?.position;
      if (position != null && position > Duration.zero && ref.read(isCastingProvider)) _lastCastPosition = position;
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

  /// Listens for "playback finished" only once a queue exists, so the native
  /// player isn't created just to watch for it.
  ProviderSubscription<AsyncValue<bool>>? _autoplay;

  /// Plays [scenes] in order, starting at [start] (9.3, 9.4); the next one
  /// starts automatically when a scene ends.
  void playQueue(List<Scene> scenes, {required String title, int start = 0}) {
    if (scenes.isEmpty) return;
    _autoplay ??= ref.listen(playerCompletedProvider, (_, next) {
      if (next.value == true) playNext();
    });
    final queue = PlayQueue(title: title, scenes: scenes, index: start.clamp(0, scenes.length - 1));
    ref.read(playQueueProvider.notifier).set(queue);
    play(queue.scenes[queue.index], remember: false);
  }

  /// Next scene of the queue, if any.
  void playNext() {
    final queue = ref.read(playQueueProvider);
    if (queue == null || !queue.hasNext) return;
    ref.read(playQueueProvider.notifier).set(queue.at(queue.index + 1));
    play(queue.scenes[queue.index + 1], remember: false);
  }

  /// How far into a scene "previous" restarts it instead of going back.
  static const restartThreshold = Duration(seconds: 3);

  /// Back in the queue like a media player: restarts the scene once more
  /// than [restartThreshold] has played (or at the queue's start), else
  /// plays the previous scene.
  void playPrevious() {
    if (state == null) return;
    final queue = ref.read(playQueueProvider);
    if (queue == null || !queue.hasPrevious || currentPosition() > restartThreshold) {
      if (ref.read(isCastingProvider)) {
        unawaited(ref.read(castServiceProvider).seek(Duration.zero));
      } else {
        ref.read(playerProvider).seek(Duration.zero);
      }
      return;
    }
    ref.read(playQueueProvider.notifier).set(queue.at(queue.index - 1));
    play(queue.scenes[queue.index - 1], remember: false);
  }

  /// Plays [scene]. Inside the active queue this moves the queue position;
  /// any other scene ends the queue.
  /// Plays [scene], from [at] seconds if given (e.g. a marker), else from
  /// its resume position.
  ///
  /// Picked in the open player ("Up next", a channel opened from it), the
  /// scene it replaces goes into [playerHistoryProvider] unless [remember]
  /// is false (queue moves, going back or forward).
  void play(Scene scene, {double? at, bool remember = true}) {
    final url = scene.streamUrl;
    if (url == null) return;

    final here = _here;
    if (remember && here != null && here.scene.id != scene.id && _isOpen) {
      ref.read(playerHistoryProvider.notifier).push(here);
    }

    final queue = ref.read(playQueueProvider);
    if (queue != null) {
      final i = queue.scenes.indexWhere((s) => s.id == scene.id);
      ref.read(playQueueProvider.notifier).set(i < 0 ? null : queue.at(i));
    }

    if (state == null) ref.read(miniplayerHeightProvider).value = kMiniPlayerHeight;
    ref.read(playerClosingProvider.notifier).set(false);
    if (state?.id != scene.id) {
      // A zoom belongs to its video; mpv would keep it for the next file.
      ref.read(videoZoomProvider.notifier).reset();
      // Prefer the position saved in this session over the (possibly stale) list data.
      final resume = at ?? ref.read(resumeTimesProvider)[scene.id] ?? scene.resumeTime;
      unawaited(ref.read(playbackTrackerProvider).start(scene.copyWith(resumeTime: resume)));
      ref.read(currentStreamProvider.notifier).set(null);
      final start = Duration(milliseconds: (resume * 1000).round());
      unawaited(_openPreferredStream(scene, url, start));
      if (ref.read(isCastingProvider)) unawaited(_castScene(scene, start));
    } else if (at != null) {
      seekTo(at);
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
      final details = ref.listen(sceneDetailsProvider(scene.id).future, (_, _) {});
      try {
        stream = pickPreferredStream((await details.read()).streams, preferred);
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
    // Until the device reports its own: not the position of an earlier scene.
    _lastCastPosition = start;
    final details = ref.listen(sceneDetailsProvider(scene.id).future, (_, _) {});
    try {
      final media = castMediaFor(
        scene,
        await details.read().catchError((Object _) => const SceneDetails()),
        apiKey: ref.read(serverConfigProvider)?.apiKey,
        start: start,
        kind: ref.read(castConnectionProvider).value?.kind ?? CastKind.googleCast,
      );
      if (state?.id != scene.id) return;
      await ref.read(castServiceProvider).load(media);
    } catch (e) {
      debugPrint('Casting failed: $e');
      if (ref.mounted) {
        ref.read(castFailureProvider.notifier).report(e, ref.read(castConnectionProvider).value?.deviceName);
      }
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

  /// Opens the current scene's stream again from [start], else from where
  /// it was opened, e.g. after a playback error ([PlaybackErrorNotifier.retry]).
  void reopen([Duration? start]) {
    final scene = state;
    if (scene == null) return;
    final url = ref.read(currentStreamProvider)?.url ?? scene.streamUrl;
    if (url == null) return;
    _open(url, start ?? _openedAt, play: !ref.read(isCastingProvider));
  }

  /// Where playback is: on the cast device while casting, else in the
  /// local player.
  Duration currentPosition() =>
      ref.read(isCastingProvider) ? _lastCastPosition : ref.read(playerProvider).state.position;

  void seekTo(double seconds) =>
      ref.read(playerProvider).seek(Duration(milliseconds: (seconds * 1000).round()));

  void _open(String url, Duration start, {bool play = true}) {
    _openedAt = start;
    ref.read(playerProvider).open(
          Media(
            url,
            httpHeaders: ref.read(authHeadersProvider),
            start: start > Duration.zero ? start : null,
          ),
          play: play,
        );
  }

  /// Whether the panel is open, not just the mini bar.
  bool get _isOpen => ref.read(miniplayerHeightProvider).value > kMiniPlayerHeight;

  /// The current scene and position, for the history.
  PlayerHistoryEntry? get _here {
    final scene = state;
    return scene == null ? null : (scene: scene, at: currentPosition().inMilliseconds / 1000);
  }

  /// Back to the scene left last in the open player, where it was; false
  /// when there is none.
  bool goBack() {
    if (!ref.read(playerHistoryProvider).canGoBack) return false;
    final here = _here;
    final entry = here == null ? null : ref.read(playerHistoryProvider.notifier).back(here);
    if (entry == null) return false;
    play(entry.scene, at: entry.at, remember: false);
    return true;
  }

  /// Forward again after [goBack]; false when there is nothing.
  bool goForward() {
    if (!ref.read(playerHistoryProvider).canGoForward) return false;
    final here = _here;
    final entry = here == null ? null : ref.read(playerHistoryProvider.notifier).forward(here);
    if (entry == null) return false;
    play(entry.scene, at: entry.at, remember: false);
    return true;
  }

  void expand() => ref.read(miniplayerControllerProvider).expand();

  void collapse() => ref.read(miniplayerControllerProvider).collapse();

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
    ref.read(playerHistoryProvider.notifier).clear();
    _autoplay?.close();
    _autoplay = null;
    unawaited(ref.read(playbackTrackerProvider).stop());
    ref.read(videoZoomProvider.notifier).reset();
    ref.read(playerProvider).stop();
    state = null;
  }
}

final nowPlayingProvider = NotifierProvider<NowPlayingNotifier, Scene?>(NowPlayingNotifier.new);
