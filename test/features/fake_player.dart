import 'dart:async';

import 'package:media_kit/media_kit.dart';

/// Minimal stand-in for media_kit's native [Player] in widget tests.
class FakePlayer implements Player {
  FakePlayer({Duration duration = const Duration(seconds: 100), bool playing = false, Duration position = Duration.zero})
      : _state = PlayerState(duration: duration, playing: playing, position: position);

  PlayerState _state;
  final seeks = <Duration>[];
  final position = StreamController<Duration>.broadcast();
  final completed = StreamController<bool>.broadcast();

  @override
  PlayerState get state => _state;

  @override
  PlayerStream get stream => PlayerStream(
        const Stream.empty(), // playlist
        const Stream.empty(), // playing
        completed.stream,
        position.stream,
        const Stream.empty(), // duration
        const Stream.empty(), // volume
        const Stream.empty(), // rate
        const Stream.empty(), // pitch
        const Stream.empty(), // buffering
        const Stream.empty(), // bufferingPercentage
        const Stream.empty(), // buffer
        const Stream.empty(), // playlistMode
        const Stream.empty(), // shuffle
        const Stream.empty(), // audioParams
        const Stream.empty(), // videoParams
        const Stream.empty(), // audioBitrate
        const Stream.empty(), // audioDevice
        const Stream.empty(), // audioDevices
        const Stream.empty(), // track
        const Stream.empty(), // tracks
        const Stream.empty(), // width
        const Stream.empty(), // height
        const Stream.empty(), // subtitle
        const Stream.empty(), // log
        const Stream.empty(), // error
      );

  @override
  Future<void> seek(Duration duration) async {
    seeks.add(duration);
    _state = _state.copyWith(position: duration);
    position.add(duration);
  }

  int playOrPauseCalls = 0;
  int pauseCalls = 0;

  /// Opened media with whether it started playing.
  final opened = <({String uri, bool play})>[];

  @override
  Future<void> open(Playable playable, {bool play = true}) async {
    opened.add((uri: (playable as Media).uri, play: play));
    _state = _state.copyWith(playing: play);
  }

  @override
  Future<void> pause() async {
    pauseCalls++;
    _state = _state.copyWith(playing: false);
  }

  @override
  Future<void> stop() async {}

  @override
  Future<void> playOrPause() async => playOrPauseCalls++;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
