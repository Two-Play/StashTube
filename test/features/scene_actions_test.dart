import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/data/models/page_result.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/models/scene_details.dart';
import 'package:stash_app_mobile/data/models/tag.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/features/player/player_providers.dart';
import 'package:stash_app_mobile/features/player/scene_actions.dart';
import 'package:stash_app_mobile/features/player/scene_edits.dart';

import 'fake_player.dart';

class FakeRepository implements StashRepository {
  final ratings = <int?>[];
  int oCount = 3;
  bool fail = false;
  Completer<void>? gate;
  final markers = <Map<String, Object>>[];

  @override
  Future<void> setSceneRating(String sceneId, int? rating100) async {
    await gate?.future;
    if (fail) throw const StashApiException('denied');
    ratings.add(rating100);
  }

  @override
  Future<int> addSceneO(String sceneId) async {
    if (fail) throw const StashApiException('denied');
    return ++oCount;
  }

  @override
  Future<int> removeSceneO(String sceneId) async => --oCount;

  @override
  Future<PageResult<Tag>> findTags(TagQuery query, {int page = 1, int perPage = 24}) async => const PageResult(
        items: [Tag(id: '7', name: 'Intro', sceneCount: 3)],
        totalCount: 1,
      );

  @override
  Future<SceneMarker> createMarker({
    required String sceneId,
    required double seconds,
    required String primaryTagId,
    String title = '',
  }) async {
    markers.add({'scene': sceneId, 'seconds': seconds, 'tag': primaryTagId, 'title': title});
    return SceneMarker(id: '1', title: title, seconds: seconds);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const scene = Scene(id: 's1', title: 'A', rating100: 60, oCounter: 3);

void main() {
  late FakeRepository repo;
  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    repo = FakeRepository();
    container = ProviderContainer(overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      stashRepositoryProvider.overrideWithValue(repo),
      playerProvider.overrideWithValue(FakePlayer(position: const Duration(seconds: 75))),
    ]);
  });
  tearDown(() => container.dispose());

  group('SceneEditsNotifier', () {
    test('rating is optimistic and reverted on failure', () async {
      repo.gate = Completer();
      final future = container.read(sceneEditsProvider.notifier).rate(scene, 5);
      expect(container.read(sceneEditsProvider)['s1']?.rating100, 100, reason: 'visible immediately');
      repo.gate!.complete();
      await future;
      expect(repo.ratings, [100]);

      repo.gate = null;
      repo.fail = true;
      await expectLater(container.read(sceneEditsProvider.notifier).rate(scene, 2), throwsA(isA<StashApiException>()));
      expect(container.read(sceneEditsProvider)['s1']?.rating100, 100, reason: 'reverted');
    });

    test('removing the rating sends null', () async {
      await container.read(sceneEditsProvider.notifier).rate(scene, 0);
      expect(repo.ratings, [null]);
      expect(container.read(sceneEditsProvider)['s1']?.ratingChanged, isTrue);
    });

    test('O-counter uses the count from the server and can be undone', () async {
      expect(await container.read(sceneEditsProvider.notifier).addO(scene), 4);
      expect(container.read(sceneEditsProvider)['s1']?.oCounter, 4);
      await container.read(sceneEditsProvider.notifier).removeO(scene);
      expect(container.read(sceneEditsProvider)['s1']?.oCounter, 3);
    });
  });

  Future<void> pumpActions(WidgetTester tester) => tester.pumpWidget(UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: Scaffold(body: SceneActions(scene: scene))),
      ));

  testWidgets('stars show the rating; tapping sets it, tapping again removes it', (tester) async {
    await pumpActions(tester);
    expect(find.byIcon(Icons.star_rounded), findsNWidgets(3), reason: 'rating100 60 = 3 stars');

    await tester.tap(find.byTooltip('Rate 4 stars'));
    await tester.pump();
    expect(find.byIcon(Icons.star_rounded), findsNWidgets(4));
    expect(repo.ratings, [80]);

    await tester.tap(find.byTooltip('Remove rating'));
    await tester.pump();
    expect(find.byIcon(Icons.star_rounded), findsNothing);
    expect(repo.ratings, [80, null]);
  });

  testWidgets('O button counts up and offers undo', (tester) async {
    await pumpActions(tester);
    await tester.tap(find.text('3'));
    await tester.pumpAndSettle();
    expect(find.text('4'), findsOneWidget);
    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(repo.oCount, 3);
  });

  testWidgets('the O snack bar goes away by itself', (tester) async {
    await pumpActions(tester);
    await tester.tap(find.text('3'));
    await tester.pumpAndSettle();
    expect(find.text('Undo'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    expect(find.text('Undo'), findsNothing);
  });

  testWidgets('adding a marker requires a tag and uses the player position', (tester) async {
    await pumpActions(tester);
    await tester.tap(find.text('Marker'));
    await tester.pumpAndSettle();
    expect(find.text('Add marker at 1:15'), findsOneWidget);

    final addButton = find.widgetWithText(FilledButton, 'Add marker');
    expect(tester.widget<FilledButton>(addButton).onPressed, isNull, reason: 'primary tag required');

    await tester.enterText(find.widgetWithText(TextField, 'Title (optional)'), 'Kiss');
    await tester.tap(find.text('#Intro'));
    await tester.pump();
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    expect(repo.markers.single, {'scene': 's1', 'seconds': 75.0, 'tag': '7', 'title': 'Kiss'});
    expect(find.text('Marker added at 1:15'), findsOneWidget);
  });
}
