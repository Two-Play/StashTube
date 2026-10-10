import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/scene.dart';
import '../../data/repositories/stash_session.dart';
import '../cast/cast_providers.dart';
import '../pip/pip.dart';
import 'player_providers.dart';

// Lock screen and notification controls (4.12): title, picture and
// play/pause/seek on the iOS lock screen and in Android's media
// notification, through audio_service (which also keeps Android's
// background playback alive). Off unless chosen in the settings, for
// discretion: the title and picture would show on the lock screen.

/// The [MediaItem] shown for [scene]; the picture loads with [headers].
MediaItem lockScreenItem(Scene scene, {Map<String, String> headers = const {}}) {
  final screenshot = scene.screenshotUrl;
  return MediaItem(
    id: scene.id,
    title: scene.title,
    artist: scene.studio?.name ?? scene.performers.firstOrNull?.name,
    duration: scene.duration > 0 ? Duration(milliseconds: (scene.duration * 1000).round()) : null,
    artUri: screenshot == null ? null : Uri.parse(screenshot),
    artHeaders: screenshot == null || headers.isEmpty ? null : headers,
  );
}

/// The controls and position for the player's state. The platform moves
/// the position on by itself while playing, from [position] at [now].
PlaybackState lockScreenState({
  required bool playing,
  required bool buffering,
  required Duration position,
  double speed = 1,
  bool hasNext = false,
  DateTime? now,
}) =>
    PlaybackState(
      controls: [
        MediaControl.rewind,
        playing ? MediaControl.pause : MediaControl.play,
        MediaControl.fastForward,
        if (hasNext) MediaControl.skipToNext,
      ],
      systemActions: const {MediaAction.seek, MediaAction.seekForward, MediaAction.seekBackward},
      androidCompactActionIndices: const [0, 1, 2],
      processingState: buffering ? AudioProcessingState.buffering : AudioProcessingState.ready,
      playing: playing,
      updatePosition: position,
      speed: speed,
      updateTime: now,
    );

/// Nothing to show: clears the lock screen and the notification.
final _idle = PlaybackState(processingState: AudioProcessingState.idle);

/// What the lock screen's buttons do; set by [lockScreenControlsProvider].
class LockScreenCommands {
  const LockScreenCommands({
    required this.play,
    required this.pause,
    required this.seek,
    required this.skipToNext,
    required this.stop,
  });

  final VoidCallback play;
  final VoidCallback pause;
  final ValueChanged<Duration> seek;
  final VoidCallback skipToNext;
  final VoidCallback stop;
}

/// Forwards the lock screen's buttons to [commands] and shows what
/// [show] publishes.
class StashAudioHandler extends BaseAudioHandler with SeekHandler {
  LockScreenCommands? commands;

  /// Shown on the lock screen and in the notification; null clears them.
  void show(MediaItem? item, PlaybackState state) {
    mediaItem.add(item);
    playbackState.add(state);
  }

  void clear() => show(null, _idle);

  @override
  Future<void> play() async => commands?.play();

  @override
  Future<void> pause() async => commands?.pause();

  @override
  Future<void> seek(Duration position) async => commands?.seek(position);

  @override
  Future<void> skipToNext() async => commands?.skipToNext();

  @override
  Future<void> stop() async => commands?.stop();

  @override
  Future<void> fastForward() async => _seekBy(const Duration(seconds: 10));

  @override
  Future<void> rewind() async => _seekBy(const Duration(seconds: -10));

  Future<void> _seekBy(Duration offset) async {
    final position = playbackState.value.position + offset;
    commands?.seek(position < Duration.zero ? Duration.zero : position);
  }
}

/// AudioService.init may run only once per process: created on first use,
/// so nothing appears (and no service starts) until it is switched on.
Future<StashAudioHandler>? _handler;

Future<StashAudioHandler> _audioHandler() => _handler ??= AudioService.init(
      builder: StashAudioHandler.new,
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'stashy.playback',
        androidNotificationChannelName: 'Playback',
        androidNotificationIcon: 'mipmap/ic_launcher_monochrome',
        fastForwardInterval: Duration(seconds: 10),
        rewindInterval: Duration(seconds: 10),
      ),
    );

/// Whether this platform has lock screen controls.
final lockScreenSupportedProvider = Provider<bool>((ref) => !kIsWeb && (Platform.isAndroid || Platform.isIOS));

/// Keeps the lock screen in sync with the main player while switched on, a
/// scene is open and it plays on this device (not while casting).
final lockScreenControlsProvider = Provider<void>((ref) {
  if (!ref.watch(lockScreenSupportedProvider)) return;
  final enabled = ref.watch(playbackModesProvider.select((m) => m.lockScreen));
  final scene = ref.watch(nowPlayingProvider);
  final casting = ref.watch(isCastingProvider);
  if (!enabled || scene == null || casting) {
    // Clears it again after it was on; never starts the service otherwise.
    _handler?.then((handler) => handler.clear());
    return;
  }

  final player = ref.read(playerProvider);
  final item = lockScreenItem(scene, headers: ref.read(authHeadersProvider));
  final subscriptions = <StreamSubscription<Object?>>[];
  var disposed = false;
  ref.onDispose(() {
    disposed = true;
    for (final s in subscriptions) {
      s.cancel();
    }
  });

  unawaited(_audioHandler().then((handler) {
    if (disposed) return;
    handler.commands = LockScreenCommands(
      play: player.play,
      pause: player.pause,
      seek: player.seek,
      skipToNext: () => ref.read(nowPlayingProvider.notifier).playNext(),
      stop: () => ref.read(nowPlayingProvider.notifier).dismiss(),
    );

    // Where the platform expects the position, to only send jumps (seeks).
    var sentPosition = Duration.zero;
    var sentAt = DateTime.now();
    var sentPlaying = false;
    void publish() {
      final state = player.state;
      sentPosition = state.position;
      sentAt = DateTime.now();
      sentPlaying = state.playing;
      handler.show(
        item,
        lockScreenState(
          playing: state.playing,
          buffering: state.buffering,
          position: state.position,
          speed: state.rate,
          hasNext: ref.read(playQueueProvider)?.hasNext ?? false,
          now: sentAt,
        ),
      );
    }

    publish();
    subscriptions.addAll([
      player.stream.playing.listen((_) => publish()),
      player.stream.buffering.listen((_) => publish()),
      player.stream.rate.listen((_) => publish()),
      player.stream.position.listen((position) {
        final elapsed = sentPlaying ? DateTime.now().difference(sentAt) * player.state.rate : Duration.zero;
        if ((position - (sentPosition + elapsed)).abs() > const Duration(seconds: 2)) publish();
      }),
    ]);
  }));
});
