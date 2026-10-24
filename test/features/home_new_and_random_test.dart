import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/data/models/page_result.dart';
import 'package:stash_app_mobile/data/models/saved_filter.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/features/home/home_page.dart';
import 'package:stash_app_mobile/features/player/player_providers.dart';
import 'package:stash_app_mobile/features/subscriptions/last_visit.dart';

import '../helpers.dart';

/// Five scenes for every list; [newScenes] of them were added at [_added].
final _added = DateTime(2026, 10, 10);

class _Repo implements StashRepository {
  _Repo({this.newScenes = 3, this.empty = false});

  final int newScenes;
  final bool empty;
  final queries = <(SceneQuery, int)>[];

  @override
  Future<PageResult<Scene>> findScenes(SceneQuery query, {int page = 1, int perPage = 24}) async {
    queries.add((query, perPage));
    if (empty) return const PageResult(items: [], totalCount: 0);
    final after = query.createdAfter;
    final count = after == null ? 5 : (after.isBefore(_added) ? newScenes : 0);
    final items = [for (var i = 0; i < count; i++) Scene(id: 'v$i', title: 'Video $i', streamUrl: 'http://s/$i')];
    return PageResult(items: page > 1 ? const [] : items.take(perPage).toList(), totalCount: count);
  }

  @override
  Future<List<SavedFilter>> savedSceneFilters() async => const [];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Playing extends NowPlayingNotifier {
  final played = <String>[];

  @override
  Scene? build() => null;

  @override
  void play(Scene scene, {double? at}) => played.add(scene.id);
}

void main() {
  late SharedPreferences prefs;
  late _Playing playing;

  Future<void> pumpHome(WidgetTester tester, _Repo repo, {Map<String, Object> stored = const {}}) async {
    prefs = (await tester.runAsync(() async {
      SharedPreferences.setMockInitialValues(stored);
      return SharedPreferences.getInstance();
    }))!;
    playing = _Playing();
    await tester.pumpWidget(ProviderScope(
      overrides: [
        ...testServer,
        sharedPreferencesProvider.overrideWithValue(prefs),
        stashRepositoryProvider.overrideWithValue(repo),
        nowPlayingProvider.overrideWith(() => playing),
      ],
      child: const MaterialApp(home: HomePage()),
    ));
    await tester.pumpAndSettle();
  }

  final lastVisit = DateTime(2026, 10, 1, 12);

  testWidgets('the dice plays one scene picked by a random sort', (tester) async {
    final repo = _Repo();
    await pumpHome(tester, repo);
    repo.queries.clear();

    await tester.tap(find.byTooltip('Play a random scene'));
    await tester.pumpAndSettle();

    final (query, perPage) = repo.queries.single;
    expect(query.sort, SceneSort.random);
    expect(query.sortField, startsWith('random_'));
    expect(query.toSceneFilter(), isNull, reason: 'the whole library');
    expect(perPage, 1);
    expect(playing.played, ['v0']);
  });

  testWidgets('the dice says so when there is nothing to play', (tester) async {
    await pumpHome(tester, _Repo(empty: true));
    await tester.tap(find.byTooltip('Play a random scene'));
    await tester.pumpAndSettle();
    expect(playing.played, isEmpty);
    expect(find.text('There are no scenes to pick from'), findsOneWidget);
  });

  testWidgets('the first visit shows no banner and stores the time', (tester) async {
    await pumpHome(tester, _Repo());
    expect(find.textContaining('since your last visit'), findsNothing);
    expect(prefs.getInt('last_visit:test-server'), isNotNull);
  });

  testWidgets('shows the scenes added since the last visit and opens them', (tester) async {
    final repo = _Repo();
    await pumpHome(tester, repo, stored: {'last_visit:test-server': lastVisit.millisecondsSinceEpoch});
    expect(find.text('3 new videos since your last visit'), findsOneWidget);
    final (count, perPage) = repo.queries.firstWhere((q) => q.$1.createdAfter != null);
    expect(count.createdAfter, lastVisit);
    expect(count.toSceneFilter()?['created_at'], {'value': stashTimestamp(lastVisit), 'modifier': 'GREATER_THAN'});
    expect(perPage, 1, reason: 'only the count');

    // Dismissed: seen, so the banner goes away and the time moves on.
    await tester.tap(find.byTooltip('Close'));
    await tester.pumpAndSettle();
    expect(find.textContaining('since your last visit'), findsNothing);
    expect(prefs.getInt('last_visit:test-server'), greaterThan(lastVisit.millisecondsSinceEpoch));
  });

  testWidgets('one new scene reads in the singular', (tester) async {
    await pumpHome(tester, _Repo(newScenes: 1), stored: {'last_visit:test-server': lastVisit.millisecondsSinceEpoch});
    expect(find.text('1 new video since your last visit'), findsOneWidget);
  });

  testWidgets('nothing new: no banner', (tester) async {
    await pumpHome(tester, _Repo(newScenes: 0), stored: {'last_visit:test-server': lastVisit.millisecondsSinceEpoch});
    expect(find.textContaining('since your last visit'), findsNothing);
  });

  test('a visit continues after a short break and ends after a long one', () async {
    SharedPreferences.setMockInitialValues({'last_visit:test-server': lastVisit.millisecondsSinceEpoch});
    final instance = await SharedPreferences.getInstance();
    final c = ProviderContainer(overrides: [...testServer, sharedPreferencesProvider.overrideWithValue(instance)]);
    addTearDown(c.dispose);
    var now = DateTime.utc(2026, 10, 24, 20);
    LastVisitNotifier.clock = () => now;
    addTearDown(() => LastVisitNotifier.clock = DateTime.now);

    expect(c.read(lastVisitProvider), lastVisit);
    final notifier = c.read(lastVisitProvider.notifier);

    await notifier.left();
    expect(instance.getInt('last_visit:test-server'), now.millisecondsSinceEpoch);
    now = now.add(const Duration(minutes: 5));
    notifier.returned();
    expect(c.read(lastVisitProvider), lastVisit, reason: 'the same visit');

    final leftAt = now;
    await notifier.left();
    now = now.add(const Duration(hours: 2));
    notifier.returned();
    expect(c.read(lastVisitProvider), leftAt, reason: 'a new visit counts from the end of the previous one');
  });

  test('every server has its own last visit', () async {
    SharedPreferences.setMockInitialValues({'last_visit:other': lastVisit.millisecondsSinceEpoch});
    final instance = await SharedPreferences.getInstance();
    final c = ProviderContainer(overrides: [...testServer, sharedPreferencesProvider.overrideWithValue(instance)]);
    addTearDown(c.dispose);
    expect(c.read(lastVisitProvider), isNull);
    expect(instance.getInt('last_visit:other'), lastVisit.millisecondsSinceEpoch);
  });

  test('timestamps go to Stash in UTC without fractions', () {
    expect(stashTimestamp(DateTime.utc(2026, 1, 2, 3, 4, 5, 678)), '2026-01-02T03:04:05Z');
    expect(SceneQuery(createdAfter: lastVisit), SceneQuery(createdAfter: lastVisit));
    expect(SceneQuery(createdAfter: lastVisit) == SceneQuery(), isFalse);
    expect(SceneQuery(createdAfter: lastVisit).copyWith(sort: SceneSort.title).createdAfter, lastVisit);
  });
}
