import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/data/models/page_result.dart';
import 'package:stash_app_mobile/data/models/saved_filter.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/models/server_task.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/features/home/home_page.dart';
import 'package:stash_app_mobile/features/server_tasks/server_tasks_page.dart';
import 'package:stash_app_mobile/features/shell/all_views_page.dart';
import 'package:stash_app_mobile/features/shorts/shorts_feed.dart';
import 'package:stash_app_mobile/features/shorts/shorts_shelf.dart';

import '../helpers.dart';

/// 30 scenes for every list ([videos]), 6 portrait ones for the shorts.
class _Repo implements StashRepository {
  _Repo({this.videos = 30});

  final int videos;

  @override
  Future<List<ServerJob>> jobQueue() async => const [];

  @override
  Future<PreviewCheck> checkPreviews({int sample = 8}) async => const PreviewCheck();

  @override
  Future<PageResult<Scene>> findScenes(SceneQuery query, {int page = 1, int perPage = 24}) async {
    final shorts = query.filter.portraitOnly;
    final count = shorts ? 6 : videos;
    return PageResult(
      items: page > 1
          ? const []
          : [
              for (var i = 0; i < count; i++)
                Scene(id: '${shorts ? 's' : 'v'}$i', title: '${shorts ? 'Short' : 'Video'} $i', streamUrl: 'http://s/$i'),
            ],
      totalCount: count,
    );
  }

  @override
  Future<List<SavedFilter>> savedSceneFilters() async => const [];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late ProviderContainer container;

  Future<void> pumpHome(
    WidgetTester tester, {
    Map<String, Object> prefs = const {},
    Widget home = const HomePage(),
    _Repo? repo,
  }) async {
    final instance = (await tester.runAsync(() async {
      SharedPreferences.setMockInitialValues(prefs);
      return SharedPreferences.getInstance();
    }))!;
    await tester.pumpWidget(ProviderScope(
      overrides: [
        ...testServer,
        sharedPreferencesProvider.overrideWithValue(instance),
        stashRepositoryProvider.overrideWithValue(repo ?? _Repo()),
      ],
      child: MaterialApp(home: home),
    ));
    await tester.pumpAndSettle();
    container = ProviderScope.containerOf(tester.element(find.byWidget(home)));
  }

  double barOffset(WidgetTester tester) => tester.widget<AnimatedSlide>(find.byType(AnimatedSlide)).offset.dy;

  testWidgets('the app bar hides while scrolling down and comes back when scrolling up', (tester) async {
    await pumpHome(tester);
    expect(barOffset(tester), 0);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -600));
    await tester.pumpAndSettle();
    expect(barOffset(tester), -1);
    expect(tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity).first).opacity, 0);
    expect(find.byIcon(Icons.search).hitTestable(), findsNothing, reason: 'hidden, not over the status bar');

    await tester.drag(find.byType(CustomScrollView), const Offset(0, 100));
    await tester.pumpAndSettle();
    expect(barOffset(tester), 0);
    // Not part of the list, so a tap reaches its buttons.
    expect(tester.widget<IconButton>(find.widgetWithIcon(IconButton, Icons.search)).onPressed, isNotNull);
  });

  void phoneSize(WidgetTester tester) {
    tester.view.physicalSize = const Size(390 * 3, 844 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
  }

  testWidgets('shows a row of four portrait shorts on a phone', (tester) async {
    phoneSize(tester);
    await pumpHome(tester);
    expect(find.byType(ShortsShelf), findsOneWidget);
    final row = find.descendant(of: find.byType(ShortsShelf), matching: find.byType(ListView));
    expect(tester.widget<ListView>(row).scrollDirection, Axis.horizontal);
    expect(tester.getSize(row).height, ShortsShelf.height, reason: 'a row, not a 2×2 grid');
    final tile = tester.getSize(find.ancestor(of: find.text('Short 0'), matching: find.byType(ClipRRect)).first);
    expect(tile.width / tile.height, closeTo(9 / 16, 0.01));
    await tester.drag(row, const Offset(-600, 0));
    await tester.pumpAndSettle();
    expect(find.text('Short 3'), findsOneWidget);
    expect(find.text('Short 4'), findsNothing);
  });

  testWidgets('wide layouts fill the row with more shorts', (tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await pumpHome(tester);
    for (var i = 0; i < 6; i++) {
      expect(find.text('Short $i'), findsOneWidget);
    }
  });

  test('more tiles than lanes take further shorts from the lanes in turn', () {
    Scene short(String id) => Scene(id: id, title: id);
    final lane = [short('a'), short('b'), short('c')];
    final picks = shelfPicks([lane, lane], tiles: 4);
    expect([for (final p in picks) p?.scene.id], ['a', 'b', 'c', null]);
    expect([for (final p in picks) p?.lane], [0, 1, 0, null]);
    expect(picks[2]?.index, 2);
  });

  testWidgets('the sort chips and the filter button stay reachable while scrolling', (tester) async {
    phoneSize(tester);
    await pumpHome(tester);
    final filter = find.byIcon(Icons.tune);
    expect(tester.getTopLeft(filter).dy, greaterThanOrEqualTo(kToolbarHeight), reason: 'under the app bar');

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -1500));
    await tester.pumpAndSettle();
    expect(barOffset(tester), -1);
    expect(filter.hitTestable(), findsOneWidget);
    expect(tester.getTopLeft(filter).dy, lessThan(kToolbarHeight), reason: 'at the top while the bar is hidden');

    await tester.drag(find.byType(CustomScrollView), const Offset(0, 100));
    await tester.pumpAndSettle();
    expect(barOffset(tester), 0);
    expect(tester.getTopLeft(filter).dy, greaterThanOrEqualTo(kToolbarHeight), reason: 'back under the app bar');
    expect(filter.hitTestable(), findsOneWidget);
  });

  testWidgets('an empty library explains the scan and opens the server tasks', (tester) async {
    phoneSize(tester);
    await pumpHome(tester, repo: _Repo(videos: 0));
    expect(find.text('Your library is still empty'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Open server tasks'), 200, scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open server tasks'));
    await tester.pumpAndSettle();
    expect(find.byType(ServerTasksPage), findsOneWidget);

    // Back leads to the settings.
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(ServerTasksPage), findsNothing);
    expect(find.text('Settings'), findsWidgets);
  });

  testWidgets('every tile of the shelf has a queue of its own', (tester) async {
    await pumpHome(tester);
    for (var lane = 0; lane < ShortsShelf.count; lane++) {
      expect(container.exists(shortsFeedFamily(ShortsSource.lane(lane))), isTrue);
    }
    expect(container.exists(shortsFeedProvider), isFalse, reason: 'the tab feed loads only when opened');
  });

  test('shelf tiles skip shorts an earlier tile shows', () {
    Scene short(String id) => Scene(id: id, title: id);
    final picks = shelfPicks([
      [short('a'), short('b')],
      [short('a'), short('c')],
      [short('a'), short('c')],
      [],
    ]);
    expect([for (final p in picks) p?.scene.id], ['a', 'c', null, null]);
    expect(picks[1]?.index, 1, reason: 'opens its queue where the tile\'s short is');
  });

  testWidgets('"all views" lists only what is not in the bar, plus the settings', (tester) async {
    await pumpHome(tester, home: const AllViewsPage());
    expect(find.text('Studios'), findsOneWidget);
    expect(find.text('Stats'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Performers'), findsNothing, reason: 'in the standard bar');
    expect(find.text('Home'), findsNothing);
  });
}
