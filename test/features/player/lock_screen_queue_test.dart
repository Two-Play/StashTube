import 'package:audio_service/audio_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/features/player/lock_screen.dart';

void main() {
  group('previous and next on the lock screen', () {
    PlaybackState state({bool hasPrevious = false, bool hasNext = false}) => lockScreenState(
          playing: true,
          buffering: false,
          position: const Duration(seconds: 5),
          hasPrevious: hasPrevious,
          hasNext: hasNext,
        );

    test('on iOS a queue drops the skip buttons so previous and next show', () {
      PlaybackState ios({bool hasPrevious = false, bool hasNext = false}) => lockScreenState(
            playing: true,
            buffering: false,
            position: Duration.zero,
            hasPrevious: hasPrevious,
            hasNext: hasNext,
            skipsHideTracks: true,
          );
      expect(ios(hasPrevious: true, hasNext: true).controls,
          [MediaControl.skipToPrevious, MediaControl.pause, MediaControl.skipToNext]);
      expect(ios(hasPrevious: true, hasNext: true).androidCompactActionIndices, [0, 1, 2]);
      expect(ios(hasNext: true).controls, [MediaControl.pause, MediaControl.skipToNext]);
      expect(ios(hasNext: true).androidCompactActionIndices, [0, 1]);
      // Without a queue the skip buttons stay.
      expect(ios().controls, [MediaControl.rewind, MediaControl.pause, MediaControl.fastForward]);
    });

    test('none without a queue', () {
      final s = state();
      expect(s.controls, isNot(contains(MediaControl.skipToPrevious)));
      expect(s.controls, isNot(contains(MediaControl.skipToNext)));
      expect(s.systemActions, isNot(contains(MediaAction.skipToPrevious)));
      expect(s.systemActions, isNot(contains(MediaAction.skipToNext)));
    });

    test('follow the queue, the compact view keeps rewind, play/pause, fast-forward', () {
      final middle = state(hasPrevious: true, hasNext: true);
      expect(middle.controls, [
        MediaControl.skipToPrevious,
        MediaControl.rewind,
        MediaControl.pause,
        MediaControl.fastForward,
        MediaControl.skipToNext,
      ]);
      expect(middle.androidCompactActionIndices, [1, 2, 3]);

      final last = state(hasPrevious: true);
      expect(last.controls.first, MediaControl.skipToPrevious);
      expect(last.controls, isNot(contains(MediaControl.skipToNext)));
      expect(last.androidCompactActionIndices, [1, 2, 3]);

      final first = state(hasNext: true);
      expect(first.controls.first, MediaControl.rewind);
      expect(first.controls.last, MediaControl.skipToNext);
      expect(first.androidCompactActionIndices, [0, 1, 2]);
    });
  });

  test('previous and next reach the player', () async {
    final calls = <String>[];
    final handler = StashAudioHandler()
      ..commands = LockScreenCommands(
        play: () => calls.add('play'),
        pause: () => calls.add('pause'),
        seek: (p) => calls.add('seek ${p.inSeconds}'),
        skipToNext: () => calls.add('next'),
        skipToPrevious: () => calls.add('previous'),
        stop: () => calls.add('stop'),
      );
    await handler.skipToPrevious();
    await handler.skipToNext();
    expect(calls, ['previous', 'next']);
  });

  test('previous without a handler for it does nothing', () async {
    final handler = StashAudioHandler()
      ..commands = LockScreenCommands(play: () {}, pause: () {}, seek: (_) {}, skipToNext: () {}, stop: () {});
    await expectLater(handler.skipToPrevious(), completes);
  });
}
