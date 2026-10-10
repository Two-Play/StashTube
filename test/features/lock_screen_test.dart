import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/models/performer.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/models/studio.dart';
import 'package:stash_app_mobile/features/pip/pip.dart';
import 'package:stash_app_mobile/features/player/lock_screen.dart';

void main() {
  group('what the lock screen shows', () {
    test('title, channel, length and the picture with the auth headers', () {
      const scene = Scene(
        id: '1',
        title: 'Beach',
        duration: 90.5,
        screenshotUrl: 'http://s/scene/1/screenshot',
        studio: Studio(id: '2', name: 'Studio'),
      );
      final item = lockScreenItem(scene, headers: const {'ApiKey': 'k'});
      expect(item.id, '1');
      expect(item.title, 'Beach');
      expect(item.artist, 'Studio');
      expect(item.duration, const Duration(milliseconds: 90500));
      expect(item.artUri, Uri.parse('http://s/scene/1/screenshot'));
      expect(item.artHeaders, {'ApiKey': 'k'});
    });

    test('the first performer without a studio, nothing missing made up', () {
      const scene = Scene(id: '1', title: 'A', performers: [Performer(id: '3', name: 'Alice')]);
      final item = lockScreenItem(scene);
      expect(item.artist, 'Alice');
      expect(item.duration, isNull);
      expect(item.artUri, isNull);
      expect(item.artHeaders, isNull);
    });

    test('controls follow playing, buffering and the queue', () {
      final playing = lockScreenState(playing: true, buffering: false, position: const Duration(seconds: 5));
      expect(playing.controls, [MediaControl.rewind, MediaControl.pause, MediaControl.fastForward]);
      expect(playing.processingState, AudioProcessingState.ready);
      expect(playing.updatePosition, const Duration(seconds: 5));
      expect(playing.systemActions, contains(MediaAction.seek));

      final paused = lockScreenState(playing: false, buffering: true, position: Duration.zero, hasNext: true);
      expect(paused.controls, [MediaControl.rewind, MediaControl.play, MediaControl.fastForward, MediaControl.skipToNext]);
      expect(paused.processingState, AudioProcessingState.buffering);
    });
  });

  test('the buttons reach the player', () async {
    final calls = <String>[];
    final handler = StashAudioHandler()
      ..commands = LockScreenCommands(
        play: () => calls.add('play'),
        pause: () => calls.add('pause'),
        seek: (p) => calls.add('seek ${p.inSeconds}'),
        skipToNext: () => calls.add('next'),
        stop: () => calls.add('stop'),
      );
    handler.show(null, lockScreenState(playing: true, buffering: false, position: const Duration(seconds: 5)));
    await handler.play();
    await handler.pause();
    await handler.seek(const Duration(seconds: 30));
    await handler.fastForward();
    await handler.rewind();
    await handler.skipToNext();
    await handler.stop();
    expect(calls, ['play', 'pause', 'seek 30', 'seek 15', 'seek 0', 'next', 'stop']);
  });

  test('off by default, for discretion, and remembered', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final c = ProviderContainer(overrides: [sharedPreferencesProvider.overrideWithValue(prefs)]);
    addTearDown(c.dispose);
    expect(c.read(playbackModesProvider).lockScreen, isFalse);
    await c.read(playbackModesProvider.notifier).setLockScreen(true);
    expect(prefs.getBool('lock_screen_controls'), isTrue);
  });
}
