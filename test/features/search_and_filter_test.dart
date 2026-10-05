import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/data/models/page_result.dart';
import 'package:stash_app_mobile/data/models/performer.dart';
import 'package:stash_app_mobile/data/models/saved_filter.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/models/scene_filter.dart';
import 'package:stash_app_mobile/data/models/tag.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/features/search/search_history.dart';
import 'package:stash_app_mobile/features/search/search_page.dart';
import 'package:stash_app_mobile/widgets/scene_feed.dart';
import 'package:stash_app_mobile/widgets/scene_filter_sheet.dart';

class FakeRepository implements StashRepository {
  final sceneQueries = <SceneQuery>[];
  List<SavedFilter> saved = const [];

  @override
  Future<PageResult<Scene>> findScenes(SceneQuery query, {int page = 1, int perPage = 24}) async {
    sceneQueries.add(query);
    return const PageResult(items: [], totalCount: 0);
  }

  @override
  Future<PageResult<Performer>> findPerformers(PerformerQuery query, {int page = 1, int perPage = 24}) async =>
      const PageResult(items: [], totalCount: 0);

  @override
  Future<PageResult<Tag>> findTags(TagQuery query, {int page = 1, int perPage = 24}) async => const PageResult(
        items: [Tag(id: '1', name: 'Outdoor', sceneCount: 4)],
        totalCount: 1,
      );

  @override
  Future<List<SavedFilter>> savedSceneFilters() async => saved;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late FakeRepository repo;
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    repo = FakeRepository();
  });

  ProviderContainer container() {
    final c = ProviderContainer(overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      stashRepositoryProvider.overrideWithValue(repo),
    ]);
    addTearDown(c.dispose);
    return c;
  }

  group('search history', () {
    test('newest first, case-insensitive de-duplication, capped, persisted', () async {
      final c = container();
      final history = c.read(searchHistoryProvider.notifier);
      await history.add('beach');
      await history.add('Sunset');
      await history.add('BEACH');
      expect(c.read(searchHistoryProvider), ['BEACH', 'Sunset']);

      for (var i = 0; i < 30; i++) {
        await history.add('term $i');
      }
      expect(c.read(searchHistoryProvider), hasLength(SearchHistoryNotifier.maxEntries));
      expect(c.read(searchHistoryProvider).first, 'term 29');
      expect(prefs.getStringList('search_history')?.first, 'term 29');

      await history.remove('term 29');
      expect(c.read(searchHistoryProvider).first, 'term 28');
      await history.clear();
      expect(c.read(searchHistoryProvider), isEmpty);
    });

    testWidgets('submitted searches appear as recent searches and can be picked again', (tester) async {
      final c = container();
      await tester.pumpWidget(UncontrolledProviderScope(container: c, child: const MaterialApp(home: SearchPage())));
      await tester.pumpAndSettle();
      expect(find.text('Popular tags'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'sunset');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();
      expect(c.read(searchHistoryProvider), ['sunset']);

      await tester.tap(find.byIcon(Icons.close).first); // clear the field
      await tester.pumpAndSettle();
      expect(find.text('Recent searches'), findsOneWidget);

      await tester.tap(find.widgetWithText(ListTile, 'sunset'));
      await tester.pumpAndSettle();
      expect(repo.sceneQueries.last.search, 'sunset');
    });
  });

  testWidgets('filter sheet returns the chosen filter', (tester) async {
    final c = container();
    SceneFilter? result;
    await tester.pumpWidget(UncontrolledProviderScope(
      container: c,
      child: MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async => result = await showSceneFilterSheet(context, SceneFilter.none),
            child: const Text('open'),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    // The sheet scrolls on the small test screen.
    Future<void> pick(String label) async {
      await tester.ensureVisible(find.text(label));
      await tester.pumpAndSettle();
      await tester.tap(find.text(label));
      await tester.pump();
    }

    await pick('#Outdoor');
    await pick('4★');
    await pick('Over 30 min');
    await pick('1080p+');
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();

    expect(result?.tags.single.id, '1');
    expect(result?.minStars, 4);
    expect(result?.duration, DurationFilter.long);
    expect(result?.resolution, ResolutionFilter.fullHd);
  });

  testWidgets('feed applies a saved filter and turns it off again', (tester) async {
    repo.saved = [
      const SavedFilter(id: '1', name: 'Best of', sceneFilter: {'organized': true}, search: 'beach', sort: 'rating'),
    ];
    final c = container();
    await tester.pumpWidget(UncontrolledProviderScope(
      container: c,
      child: MaterialApp(
        home: Scaffold(
          body: SceneFeedView(initialQuery: SceneQuery(), filterable: true, showSavedFilters: true),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Best of'));
    await tester.pumpAndSettle();
    final applied = repo.sceneQueries.last;
    expect(applied.toSceneFilter(), containsPair('organized', true));
    expect(applied.search, 'beach');
    expect(applied.sort, SceneSort.topRated);

    await tester.tap(find.text('Best of'));
    await tester.pumpAndSettle();
    expect(repo.sceneQueries.last.toSceneFilter(), isNull);
    expect(repo.sceneQueries.last.search, isNull);
  });
}
