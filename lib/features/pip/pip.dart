import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../../core/config/server_config.dart';
import '../../data/models/scene_details.dart';
import '../../data/providers.dart';
import '../../data/repositories/stash_session.dart';
import '../cast/cast_media.dart';
import '../cast/cast_providers.dart';
import '../player/player_providers.dart';
import '../security/app_lock.dart';
import 'pip_service.dart';

/// Overridden in tests with a fake.
final pipServiceProvider = Provider<PipService>((ref) => PipService.create());

/// Picture-in-picture and background playback (4.12), chosen in the
/// settings and stored for all servers.
class PlaybackModes {
  const PlaybackModes({this.autoPip = true, this.background = false});

  /// Android: a playing video continues in picture-in-picture when the user
  /// leaves the app.
  final bool autoPip;

  /// The sound keeps playing while the app is in the background; otherwise
  /// the player pauses.
  final bool background;

  PlaybackModes copyWith({bool? autoPip, bool? background}) =>
      PlaybackModes(autoPip: autoPip ?? this.autoPip, background: background ?? this.background);
}

class PlaybackModesNotifier extends Notifier<PlaybackModes> {
  static const _autoPipKey = 'auto_pip';
  static const _backgroundKey = 'background_playback';

  @override
  PlaybackModes build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return PlaybackModes(
      autoPip: prefs.getBool(_autoPipKey) ?? true,
      background: prefs.getBool(_backgroundKey) ?? false,
    );
  }

  Future<void> setAutoPip(bool value) async {
    state = state.copyWith(autoPip: value);
    await ref.read(sharedPreferencesProvider).setBool(_autoPipKey, value);
  }

  Future<void> setBackground(bool value) async {
    state = state.copyWith(background: value);
    await ref.read(sharedPreferencesProvider).setBool(_backgroundKey, value);
  }
}

final playbackModesProvider = NotifierProvider<PlaybackModesNotifier, PlaybackModes>(PlaybackModesNotifier.new);

/// Whether the main player is playing; only watched while a scene is open,
/// so the native player isn't created just for this.
final playerPlayingProvider = StreamProvider<bool>((ref) => ref.watch(playerProvider).stream.playing);

/// Whether a scene is open and playing in the app.
final _mainPlayingProvider = Provider<bool>(
  (ref) => ref.watch(nowPlayingProvider) != null && (ref.watch(playerPlayingProvider).value ?? false),
);

/// Whether leaving the app should enter picture-in-picture right now.
final _autoPipWantedProvider = Provider<bool>((ref) {
  if (!ref.watch(pipServiceProvider).canAutoEnter) return false;
  if (!ref.watch(playbackModesProvider.select((m) => m.autoPip))) return false;
  if (ref.watch(appLockedProvider) || ref.watch(isCastingProvider)) return false;
  return ref.watch(_mainPlayingProvider);
});

/// Width / height of the playing video, within what Android accepts.
double _videoAspect(Player player) {
  final width = player.state.width;
  final height = player.state.height;
  final aspect = width == null || height == null || width <= 0 || height <= 0 ? 16 / 9 : width / height;
  return aspect.clamp(0.42, 2.38);
}

/// Whether the app is in picture-in-picture: Android's small window, or on
/// iOS the native player's.
class PipNotifier extends Notifier<bool> {
  /// iOS: the scene the native player took over; null when it isn't playing.
  String? _nativeSceneId;

  /// When picture-in-picture last ended; closing the window also hides the
  /// app, which shouldn't count as "playing in the background".
  DateTime? _endedAt;

  bool endedJustNow() => _endedAt != null && DateTime.now().difference(_endedAt!) < const Duration(seconds: 2);

  @override
  bool build() {
    final service = ref.watch(pipServiceProvider);
    final events = service.events.listen(_onEvent);
    ref.onDispose(events.cancel);

    ref.listen(_autoPipWantedProvider, (_, wanted) {
      unawaited(service.setAutoEnter(enabled: wanted, aspect: _videoAspect(ref.read(playerProvider))));
    });
    // Another scene, a closed player or playing in the app again ends the
    // native picture-in-picture.
    ref.listen(nowPlayingProvider, (_, scene) {
      if (_nativeSceneId != null && scene?.id != _nativeSceneId) _stopNative();
    });
    if (service.isSupported && !service.canAutoEnter) {
      ref.listen(_mainPlayingProvider, (_, playing) {
        if (_nativeSceneId != null && playing) _stopNative();
      });
    }
    return false;
  }

  void _onEvent(PipEvent event) {
    switch (event) {
      case PipModeChanged(:final active):
        if (!active) _endedAt = DateTime.now();
        state = active;
      case PipStopped(:final position, :final playing):
        final sceneId = _nativeSceneId;
        _nativeSceneId = null;
        _endedAt = DateTime.now();
        state = false;
        // Continue in the app where picture-in-picture was.
        if (sceneId == null || ref.read(nowPlayingProvider)?.id != sceneId) return;
        final player = ref.read(playerProvider);
        unawaited(player.seek(position));
        if (playing) unawaited(player.play());
    }
  }

  void _stopNative() {
    _nativeSceneId = null;
    unawaited(ref.read(pipServiceProvider).stopNative());
  }

  /// Shows the playing scene in picture-in-picture. [from] is the video's
  /// place on screen, where iOS's window grows out of. Returns whether it
  /// started.
  Future<bool> enter({Rect? from}) async {
    final scene = ref.read(nowPlayingProvider);
    if (scene == null) return false;
    final service = ref.read(pipServiceProvider);
    final player = ref.read(playerProvider);
    if (!service.canAutoEnter && service.isSupported) {
      // iOS: AVPlayer plays MP4/MOV originals or Stash's HLS, like AirPlay.
      final details = ref.listen(sceneDetailsProvider(scene.id).future, (_, _) {});
      final SceneDetails loaded;
      try {
        loaded = await details.read().catchError((Object _) => const SceneDetails());
      } finally {
        details.close();
      }
      if (!ref.mounted || ref.read(nowPlayingProvider)?.id != scene.id) return false;
      final stream = pickAirPlayStream(scene, loaded);
      if (stream.url.isEmpty) return false;
      final wasPlaying = player.state.playing;
      final start = player.state.position;
      // Pause first, so both don't play while the native player starts.
      await player.pause();
      final started = await service.startNative(
        url: withApiKey(stream.url, ref.read(serverConfigProvider)?.apiKey),
        headers: ref.read(authHeadersProvider),
        start: start,
        from: from ?? Rect.zero,
      );
      if (!ref.mounted) return started;
      if (started) {
        _nativeSceneId = scene.id;
        state = true;
      } else if (wasPlaying) {
        await player.play();
      }
      return started;
    }
    return service.enter(aspect: _videoAspect(player));
  }
}

final pipProvider = NotifierProvider<PipNotifier, bool>(PipNotifier.new);

/// What happens to the main player when the app goes to the background:
/// with background playback only the sound continues (mpv stops decoding
/// the video until the app is back), otherwise it pauses. Not while casting
/// or in picture-in-picture.
final backgroundPlaybackProvider = Provider<void>((ref) {
  var videoOff = false;

  void setVideo(bool on) {
    final platform = ref.read(playerProvider).platform;
    if (platform is NativePlayer) unawaited(platform.setProperty('vid', on ? 'auto' : 'no'));
    videoOff = !on;
  }

  final lifecycle = AppLifecycleListener(
    onHide: () {
      if (ref.read(nowPlayingProvider) == null || ref.read(isCastingProvider)) return;
      final pip = ref.read(pipProvider.notifier);
      if (ref.read(pipProvider) && !pip.endedJustNow()) return;
      final player = ref.read(playerProvider);
      if (!player.state.playing) return;
      if (ref.read(playbackModesProvider).background && !pip.endedJustNow()) {
        setVideo(false);
      } else {
        unawaited(player.pause());
      }
    },
    onShow: () {
      if (videoOff) setVideo(true);
    },
  );
  ref.onDispose(lifecycle.dispose);
});

/// Above the app: in Android's picture-in-picture window only the video is
/// shown. Also keeps picture-in-picture and background playback running.
class PipScope extends ConsumerWidget {
  const PipScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(backgroundPlaybackProvider);
    final pip = ref.watch(pipProvider);
    final appWindow = pip && ref.watch(pipServiceProvider).canAutoEnter;
    return Stack(
      children: [
        child,
        if (appWindow)
          Positioned.fill(
            child: ColoredBox(
              color: Colors.black,
              child: Video(
                controller: ref.watch(videoControllerProvider),
                controls: (_) => const SizedBox.shrink(),
                wakelock: false,
                pauseUponEnteringBackgroundMode: false,
              ),
            ),
          ),
      ],
    );
  }
}
