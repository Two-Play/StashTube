import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/features/player/playback_tracker.dart';
import 'package:stash_app_mobile/features/player/player_providers.dart';

import '../fake_player.dart';

class _NoopActivity implements PlaybackActivityApi {
  @override
  Future<void> addPlay(String sceneId) async {}
  @override
  Future<void> saveActivity(String sceneId, {required double resumeTime, required double playDuration}) async {}
}

Scene _scene(String id) => Scene(id: id, title: 'Scene $id', streamUrl: 'http://s/scene/$id/stream');

void main() {
  late FakePlayer player;
  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues({'url': 'http://s'});
    final prefs = await SharedPreferences.getInstance();
    player = FakePlayer();
    container = ProviderContainer(overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      playerProvider.overrideWithValue(player),
      playbackTrackerProvider.overrideWithValue(PlaybackTracker(api: _NoopActivity())),
    ]);
    container.listen(nowPlayingProvider, (_, _) {});
  });
  tearDown(() => container.dispose());

  NowPlayingNotifier notifier() => container.read(nowPlayingProvider.notifier);
  List<String> history() => [for (final e in container.read(playerHistoryProvider).back) e.scene.id];
  List<String> ahead() => [for (final e in container.read(playerHistoryProvider).forward) e.scene.id];

  /// The panel's height, as the shell's panel would set it.
  void setOpen(bool open) => container.read(miniplayerHeightProvider).value = open ? 800 : kMiniPlayerHeight;

  testWidgets('a video picked in the open player remembers the one it replaces', (tester) async {
    notifier().play(_scene('a'));
    setOpen(true);
    await player.seek(const Duration(seconds: 42));
    notifier().play(_scene('b'));
    expect(history(), ['a']);
    expect(container.read(playerHistoryProvider).back.single.at, 42);

    expect(notifier().goBack(), isTrue);
    expect(container.read(nowPlayingProvider)?.id, 'a');
    expect(player.openedStarts.last, const Duration(seconds: 42), reason: 'continues where it was left');
    expect(history(), isEmpty);
    expect(ahead(), ['b'], reason: 'the way forward');
    expect(notifier().goBack(), isFalse);
  });

  testWidgets('forward returns to where back came from, at its position', (tester) async {
    notifier().play(_scene('a'));
    setOpen(true);
    notifier().play(_scene('b'));
    await player.seek(const Duration(seconds: 7));
    notifier().goBack();
    expect(notifier().goForward(), isTrue);
    expect(container.read(nowPlayingProvider)?.id, 'b');
    expect(player.openedStarts.last, const Duration(seconds: 7));
    expect(history(), ['a']);
    expect(ahead(), isEmpty);
    expect(notifier().goForward(), isFalse);
  });

  testWidgets('picking a new video drops the way forward, like a browser', (tester) async {
    notifier().play(_scene('a'));
    setOpen(true);
    notifier().play(_scene('b'));
    notifier().goBack();
    notifier().play(_scene('c'));
    expect(history(), ['a']);
    expect(ahead(), isEmpty);
  });

  testWidgets('back retraces several videos, newest first', (tester) async {
    notifier().play(_scene('a'));
    setOpen(true);
    notifier().play(_scene('b'));
    notifier().play(_scene('c'));
    expect(history(), ['a', 'b']);
    notifier().goBack();
    expect(container.read(nowPlayingProvider)?.id, 'b');
    notifier().goBack();
    expect(container.read(nowPlayingProvider)?.id, 'a');
  });

  testWidgets('a video started from a list while the player is collapsed is not remembered', (tester) async {
    notifier().play(_scene('a'));
    setOpen(false);
    notifier().play(_scene('b'));
    expect(history(), isEmpty);
  });

  testWidgets('moves inside a queue are not remembered', (tester) async {
    setOpen(true);
    notifier().playQueue([_scene('a'), _scene('b')], title: 'Group');
    notifier().playNext();
    expect(container.read(nowPlayingProvider)?.id, 'b');
    expect(history(), isEmpty);
  });

  testWidgets('a scene shows up once, at its latest place; closing forgets all', (tester) async {
    notifier().play(_scene('a'));
    setOpen(true);
    notifier().play(_scene('b'));
    notifier().play(_scene('a'));
    notifier().play(_scene('c'));
    expect(history(), ['b', 'a']);

    notifier().goBack();
    notifier().close();
    expect(container.read(playerHistoryProvider).isEmpty, isTrue);
  });

  test('keeps at most the newest entries', () {
    final history = container.read(playerHistoryProvider.notifier);
    for (var i = 0; i < PlayerHistoryNotifier.limit + 5; i++) {
      history.push((scene: _scene('$i'), at: 0));
    }
    final ids = [for (final e in container.read(playerHistoryProvider).back) e.scene.id];
    expect(ids, hasLength(PlayerHistoryNotifier.limit));
    expect(ids.first, '5');
    expect(ids.last, '${PlayerHistoryNotifier.limit + 4}');
  });
}
