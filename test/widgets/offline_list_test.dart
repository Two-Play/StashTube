import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/data/models/page_result.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/providers.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/widgets/scene_feed.dart';

import '../helpers.dart';

/// Answers until [offline] is set, then fails like an unreachable server.
class _FlakyRepository implements StashRepository {
  bool offline = false;

  @override
  Future<PageResult<Scene>> findScenes(SceneQuery query, {int page = 1, int perPage = 24}) async {
    if (offline) throw const StashApiException('unreachable', isNetworkError: true);
    return PageResult(
      items: [for (var i = (page - 1) * perPage; i < page * perPage && i < 60; i++) Scene(id: '$i', title: 'Scene $i')],
      totalCount: 60,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  // STATE-1: the connection banner explains an unreachable server; lists
  // keep what they showed instead of turning into error pages.
  testWidgets('a list keeps its items when reloading can\'t reach the server', (tester) async {
    final repo = _FlakyRepository();
    final container = ProviderContainer(
      retry: (_, _) => null,
      overrides: [stashRepositoryProvider.overrideWithValue(repo), ...testServer],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: MaterialApp(home: Scaffold(body: SceneFeedView(initialQuery: SceneQuery(), sorts: const []))),
    ));
    await _settle(tester);
    expect(find.text('Scene 0'), findsOneWidget);

    repo.offline = true;
    container.invalidate(sceneListProvider); // what the banner's reload does
    await _settle(tester);
    expect(find.text('Scene 0'), findsOneWidget);
    expect(find.text('Something went wrong'), findsNothing);
  });

  testWidgets('a list keeps its items when the next page can\'t be loaded', (tester) async {
    final repo = _FlakyRepository();
    final container = ProviderContainer(
      retry: (_, _) => null,
      overrides: [stashRepositoryProvider.overrideWithValue(repo), ...testServer],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: MaterialApp(home: Scaffold(body: SceneFeedView(initialQuery: SceneQuery(), sorts: const []))),
    ));
    await _settle(tester);

    repo.offline = true;
    await container.read(sceneListProvider(SceneQuery()).notifier).loadMore();
    await _settle(tester);
    expect(find.text('Scene 0'), findsOneWidget);
    expect(find.text('Something went wrong'), findsNothing);
  });
}

/// A few frames: loading placeholders never settle, so no pumpAndSettle.
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}
