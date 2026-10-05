import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/models/group.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/features/library/watch_later.dart';
import 'package:stash_app_mobile/features/player/playback_tracker.dart';
import 'package:stash_app_mobile/features/player/player_providers.dart';

import 'fake_player.dart';

class _NoopActivity implements PlaybackActivityApi {
  @override
  Future<void> addPlay(String sceneId) async {}
  @override
  Future<void> saveActivity(String sceneId, {required double resumeTime, required double playDuration}) async {}
}

Scene _scene(String id) => Scene(id: id, title: 'Scene $id', streamUrl: 'http://s/scene/$id/stream');

void main() {
  test('history and group queries', () {
    final history = SceneQuery(sort: SceneSort.lastPlayed, playedOnly: true);
    expect(history.toSceneFilter(), {
      'play_count': {'value': 0, 'modifier': 'GREATER_THAN'},
    });
    final group = SceneQuery(groupId: '5', sort: SceneSort.groupOrder);
    expect(group.toSceneFilter(), {
      'groups': {
        'value': ['5'],
        'modifier': 'INCLUDES',
      },
    });
    expect(group.direction, 'ASC');
    expect(group.sortField, 'group_scene_number');
    expect(SceneSort.feed, isNot(contains(SceneSort.groupOrder)));
  });

  test('Group.fromJson', () {
    final g = Group.fromJson({
      'id': '5',
      'name': 'Trilogy',
      'duration': 5400,
      'front_image_path': 'http://s/g',
      'scene_count': 3,
      'studio': {'id': '1', 'name': 'Studio'},
    });
    expect(g.name, 'Trilogy');
    expect(g.duration, 5400);
    expect(g.sceneCount, 3);
    expect(g.studio?.name, 'Studio');
  });

  test('findScenesByIds keeps the requested order and skips unknown ids', () async {
    final repo = StashRepository(GraphQLClient(
      // The fake response only has the fields this test needs.
      cache: GraphQLCache(partialDataPolicy: PartialDataCachePolicy.accept),
      link: Link.function((request, [forward]) => Stream.value(const Response(
            response: {},
            data: {
              '__typename': 'Query',
              'findScenes': {
                '__typename': 'FindScenesResultType',
                'scenes': [
                  {'__typename': 'Scene', 'id': '1', 'title': 'One'},
                  {'__typename': 'Scene', 'id': '3', 'title': 'Three'},
                ],
              },
            },
          ))),
    ));
    final scenes = await repo.findScenesByIds(['3', '2', '1']);
    expect(scenes.map((s) => s.id), ['3', '1']);
    expect(await repo.findScenesByIds(const []), isEmpty);
  });

  group('watch later and the play queue', () {
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

    test('watch later toggles and is stored on the device', () async {
      final wl = container.read(watchLaterProvider.notifier);
      expect(await wl.toggle('1'), isTrue);
      expect(await wl.toggle('2'), isTrue);
      expect(await wl.toggle('1'), isFalse);
      expect(container.read(watchLaterProvider), ['2']);
      final server = container.read(activeServerIdProvider);
      expect(server, isNotNull, reason: 'the legacy login was migrated into a server profile');
      expect(container.read(sharedPreferencesProvider).getStringList('watch_later:$server'), ['2']);
    });

    testWidgets('a queue plays in order and advances when a scene ends', (tester) async {
      final notifier = container.read(nowPlayingProvider.notifier);
      notifier.playQueue([_scene('a'), _scene('b'), _scene('c')], title: 'Watch later');
      await tester.pump();
      expect(container.read(nowPlayingProvider)?.id, 'a');
      expect(container.read(playQueueProvider)?.index, 0);

      player.completed.add(true);
      await tester.pump();
      expect(container.read(nowPlayingProvider)?.id, 'b');
      expect(player.opened.last.uri, 'http://s/scene/b/stream');

      // Jumping within the queue moves its position.
      notifier.play(container.read(playQueueProvider)!.scenes[2]);
      expect(container.read(playQueueProvider)?.index, 2);

      // The end of the queue: nothing more to play.
      player.completed.add(true);
      await tester.pump();
      expect(container.read(nowPlayingProvider)?.id, 'c');
    });

    testWidgets('playing a scene outside the queue ends it', (tester) async {
      final notifier = container.read(nowPlayingProvider.notifier);
      notifier.playQueue([_scene('a'), _scene('b')], title: 'Group');
      notifier.play(_scene('x'));
      await tester.pump();
      expect(container.read(playQueueProvider), isNull);
    });
  });
}
