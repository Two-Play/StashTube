import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/models/gallery.dart';
import 'package:stash_app_mobile/data/models/image_item.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/data/models/page_result.dart';
import 'package:stash_app_mobile/data/models/performer.dart';
import 'package:stash_app_mobile/data/models/saved_filter.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/models/studio.dart';
import 'package:stash_app_mobile/data/models/tag.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/features/search/search_history.dart';
import 'package:stash_app_mobile/features/search/search_page.dart';
import 'package:stash_app_mobile/features/shell/navigation.dart';

import '../helpers.dart';

/// Matches only for terms starting with "an"; everything else is empty.
class _Repository implements StashRepository {
  final sceneQueries = <SceneQuery>[];
  final imageQueries = <ImageQuery>[];
  final performerQueries = <PerformerQuery>[];

  bool _hits(String? term) => term?.toLowerCase().startsWith('an') ?? false;

  @override
  Future<PageResult<Scene>> findScenes(SceneQuery query, {int page = 1, int perPage = 24}) async {
    sceneQueries.add(query);
    return const PageResult(items: [], totalCount: 0);
  }

  @override
  Future<PageResult<Performer>> findPerformers(PerformerQuery query, {int page = 1, int perPage = 24}) async {
    performerQueries.add(query);
    if (!_hits(query.search)) return const PageResult(items: [], totalCount: 0);
    final items = [for (var i = 1; i <= 5; i++) Performer(id: 'p$i', name: 'Anna $i')];
    return PageResult(items: items, totalCount: items.length);
  }

  @override
  Future<PageResult<Tag>> findTags(TagQuery query, {int page = 1, int perPage = 24}) async {
    if (!_hits(query.search)) return const PageResult(items: [], totalCount: 0);
    return const PageResult(items: [Tag(id: 't1', name: 'Animals', sceneCount: 2)], totalCount: 1);
  }

  @override
  Future<PageResult<Studio>> findStudios(StudioQuery query, {int page = 1, int perPage = 24}) async {
    if (!_hits(query.search)) return const PageResult(items: [], totalCount: 0);
    return const PageResult(items: [Studio(id: 's1', name: 'Andromeda')], totalCount: 1);
  }

  @override
  Future<PageResult<ImageItem>> findImages(ImageQuery query, {int page = 1, int perPage = 24}) async {
    imageQueries.add(query);
    return const PageResult(items: [], totalCount: 0);
  }

  @override
  Future<PageResult<Gallery>> findGalleries(GalleryQuery query, {int page = 1, int perPage = 24}) async =>
      const PageResult(items: [], totalCount: 0);

  @override
  Future<List<SavedFilter>> savedSceneFilters() async => const [];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late _Repository repo;
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    repo = _Repository();
  });

  Future<ProviderContainer> pumpSearch(WidgetTester tester) async {
    // Tall enough for all suggestions.
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final c = ProviderContainer(overrides: [
      ...testServer,
      sharedPreferencesProvider.overrideWithValue(prefs),
      stashRepositoryProvider.overrideWithValue(repo),
    ]);
    addTearDown(c.dispose);
    final navigatorKey = c.read(tabNavigatorKeysProvider)[c.read(currentTabProvider)];
    await tester.pumpWidget(UncontrolledProviderScope(
      container: c,
      child: MaterialApp(navigatorKey: navigatorKey, home: const SearchPage()),
    ));
    await tester.pumpAndSettle();
    return c;
  }

  Future<void> typeOnly(WidgetTester tester, String term) async {
    await tester.enterText(find.byType(TextField), term);
    await tester.pump(const Duration(milliseconds: 500)); // debounce
    await tester.pumpAndSettle();
  }

  group('typeahead (SEARCH-1)', () {
    testWidgets('suggests up to three performers, tags and studios', (tester) async {
      await pumpSearch(tester);
      await typeOnly(tester, 'an');

      expect(find.text('Search scenes for "an"'), findsOneWidget);
      expect(find.widgetWithText(ListTile, 'Anna 1'), findsOneWidget);
      expect(find.widgetWithText(ListTile, 'Anna 3'), findsOneWidget);
      expect(find.widgetWithText(ListTile, 'Anna 4'), findsNothing);
      expect(find.widgetWithText(ListTile, 'Animals'), findsOneWidget);
      expect(find.widgetWithText(ListTile, 'Andromeda'), findsOneWidget);
    });

    testWidgets('the search row submits and hides the suggestions', (tester) async {
      final c = await pumpSearch(tester);
      await typeOnly(tester, 'an');

      await tester.tap(find.text('Search scenes for "an"'));
      await tester.pumpAndSettle();
      expect(c.read(searchHistoryProvider), ['an']);
      expect(find.widgetWithText(ListTile, 'Animals'), findsNothing);
      expect(repo.sceneQueries.last.search, 'an');
    });

    testWidgets('the keyboard search action hides the suggestions', (tester) async {
      await pumpSearch(tester);
      await typeOnly(tester, 'an');
      expect(find.widgetWithText(ListTile, 'Andromeda'), findsOneWidget);

      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();
      expect(find.widgetWithText(ListTile, 'Andromeda'), findsNothing);
    });

    testWidgets('losing focus hides the suggestions', (tester) async {
      await pumpSearch(tester);
      await typeOnly(tester, 'an');
      expect(find.widgetWithText(ListTile, 'Andromeda'), findsOneWidget);

      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      expect(find.widgetWithText(ListTile, 'Andromeda'), findsNothing);
    });

    testWidgets('a performer suggestion opens the performer', (tester) async {
      await pumpSearch(tester);
      await typeOnly(tester, 'an');

      await tester.tap(find.widgetWithText(ListTile, 'Anna 2'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(SearchPage), findsNothing);
    });
  });

  group('no results (SEARCH-2)', () {
    testWidgets('offers the other areas', (tester) async {
      await pumpSearch(tester);
      await tester.enterText(find.byType(TextField), 'zebra');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      expect(find.text('No scenes match "zebra"'), findsOneWidget);
      expect(find.text('Search other areas'), findsOneWidget);
      expect(find.text('Clear filters'), findsNothing);

      await tester.tap(find.widgetWithText(ActionChip, 'Images'));
      await tester.pumpAndSettle();
      expect(repo.imageQueries.last.search, 'zebra');
      expect(find.text('Nothing matches "zebra"'), findsOneWidget);
      expect(find.widgetWithText(ActionChip, 'Scenes'), findsOneWidget);
    });

    testWidgets('clears active scene filters', (tester) async {
      await pumpSearch(tester);
      await tester.enterText(find.byType(TextField), 'zebra');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.tune));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Over 30 min'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Over 30 min'));
      await tester.pump();
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();
      expect(repo.sceneQueries.last.filter.isEmpty, isFalse);

      await tester.tap(find.text('Clear filters'));
      await tester.pumpAndSettle();
      expect(repo.sceneQueries.last.filter.isEmpty, isTrue);
      expect(find.text('Clear filters'), findsNothing);
    });
  });
}
