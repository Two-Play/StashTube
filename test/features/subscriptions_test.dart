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
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/features/shell/nav_bar_config.dart';
import 'package:stash_app_mobile/features/shell/navigation.dart';
import 'package:stash_app_mobile/features/subscriptions/subscriptions_page.dart';

import '../helpers.dart';

const _anna = Performer(id: 'p1', name: 'Anna', favorite: true);
const _bea = Performer(id: 'p2', name: 'Bea', favorite: true);

class _Repo implements StashRepository {
  _Repo({this.favorites = const [_anna, _bea]});

  final List<Performer> favorites;
  final performerQueries = <PerformerQuery>[];
  final sceneQueries = <SceneQuery>[];

  @override
  Future<PageResult<Performer>> findPerformers(PerformerQuery query, {int page = 1, int perPage = 24}) async {
    performerQueries.add(query);
    return PageResult(items: page > 1 ? const [] : favorites, totalCount: favorites.length);
  }

  @override
  Future<PageResult<Scene>> findScenes(SceneQuery query, {int page = 1, int perPage = 24}) async {
    sceneQueries.add(query);
    // Since the last visit only Anna has a new scene.
    final scenes = query.createdAfter != null
        ? [const Scene(id: 'n1', title: 'New with Anna', performers: [_anna])]
        : [
            const Scene(id: 'n1', title: 'New with Anna', performers: [_anna]),
            const Scene(id: 'o1', title: 'Older with Bea', performers: [_bea]),
          ];
    return PageResult(items: page > 1 ? const [] : scenes, totalCount: scenes.length);
  }

  @override
  Future<List<SavedFilter>> savedSceneFilters() async => const [];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  final lastVisit = DateTime(2026, 10, 1);

  Future<void> pumpPage(WidgetTester tester, _Repo repo, {Map<String, Object> stored = const {}}) async {
    final prefs = (await tester.runAsync(() async {
      SharedPreferences.setMockInitialValues(stored);
      return SharedPreferences.getInstance();
    }))!;
    await tester.pumpWidget(ProviderScope(
      overrides: [
        ...testServer,
        sharedPreferencesProvider.overrideWithValue(prefs),
        stashRepositoryProvider.overrideWithValue(repo),
      ],
      child: const MaterialApp(home: SubscriptionsPage()),
    ));
    // Image placeholders may shimmer: pump a while instead of settling.
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  testWidgets('shows the favorites as avatars and the newest scenes of favorites', (tester) async {
    final repo = _Repo();
    await pumpPage(tester, repo, stored: {'last_visit:test-server': lastVisit.millisecondsSinceEpoch});

    expect(repo.performerQueries.first.sort, PerformerSort.favorites);
    expect(repo.performerQueries.first.toPerformerFilter(), {'filter_favorites': true});
    expect(find.text('Anna'), findsWidgets);
    expect(find.text('Bea'), findsWidgets);
    final feed = repo.sceneQueries.firstWhere((q) => q.createdAfter == null);
    expect(feed, SceneQuery.newFromFavorites(), reason: "shares home's shelf");
    expect(find.text('New with Anna'), findsOneWidget);
    expect(find.text('Older with Bea'), findsOneWidget);

    // A dot only on the performer with scenes added since the last visit.
    final dots = repo.sceneQueries.firstWhere((q) => q.createdAfter != null);
    expect(dots.favoritePerformersOnly, isTrue);
    expect(dots.createdAfter, lastVisit);
    expect(find.byKey(const ValueKey('new-p1')), findsOneWidget);
    expect(find.byKey(const ValueKey('new-p2')), findsNothing);
    expect(find.bySemanticsLabel('Anna, new scenes'), findsOneWidget);
  });

  testWidgets('no dots on the first visit', (tester) async {
    await pumpPage(tester, _Repo());
    expect(find.text('New with Anna'), findsOneWidget);
    expect(find.byKey(const ValueKey('new-p1')), findsNothing);
  });

  testWidgets('without favorites a hint explains how to subscribe', (tester) async {
    await pumpPage(tester, _Repo(favorites: const []));
    expect(find.text('No favorites yet'), findsOneWidget);
    expect(find.text('Mark performers as favorites to see their newest scenes here.'), findsOneWidget);
    expect(find.text('New with Anna'), findsNothing);
  });

  test('subscriptions are an optional tab, hidden by default and after an update', () async {
    expect(NavBarConfig.standard.isVisible(AppTab.subscriptions), isFalse);
    SharedPreferences.setMockInitialValues({
      'nav_bar_order': ['home', 'shorts', 'library', 'you'],
      'nav_bar_hidden': <String>[],
    });
    final instance = await SharedPreferences.getInstance();
    final c = ProviderContainer(overrides: [sharedPreferencesProvider.overrideWithValue(instance)]);
    addTearDown(c.dispose);
    final config = c.read(navBarConfigProvider);
    expect(config.isVisible(AppTab.subscriptions), isFalse);
    expect(config.toggle(AppTab.subscriptions).isVisible(AppTab.subscriptions), isTrue);
  });
}
