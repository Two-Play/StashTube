import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/data/models/page_result.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/widgets/scene_feed.dart';

/// Server B answers only when [gate] completes, or fails if [failB].
class FakeServerRepository implements StashRepository {
  FakeServerRepository(this.url, this.gate, {this.failB = false});

  final String url;
  final Completer<void> gate;
  final bool failB;

  @override
  Future<PageResult<Scene>> findScenes(SceneQuery query, {int page = 1, int perPage = 24}) async {
    if (url.contains('b')) {
      await gate.future;
      if (failB) throw const StashApiException('Server B is down', isNetworkError: true);
    }
    return PageResult(items: [Scene(id: '1', title: 'video from $url')], totalCount: 1);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  Future<({ProviderContainer container, Completer<void> gate})> pumpFeed(WidgetTester tester, {bool failB = false}) async {
    final setup = await tester.runAsync(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final gate = Completer<void>();
      final c = ProviderContainer(
        // Like the app: only network errors are retried, and only briefly.
        retry: (count, error) => null,
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          stashRepositoryProvider.overrideWith(
            (ref) => FakeServerRepository(ref.watch(serverConfigProvider)!.baseUrl, gate, failB: failB),
          ),
        ],
      );
      await c.read(serverProfilesProvider.notifier).add(const ServerConfig(baseUrl: 'http://a'));
      return (container: c, gate: gate);
    });
    addTearDown(setup!.container.dispose);
    await tester.pumpWidget(UncontrolledProviderScope(
      container: setup.container,
      child: MaterialApp(home: Scaffold(body: SceneFeedView(initialQuery: SceneQuery(), sorts: const []))),
    ));
    await _settle(tester);
    expect(find.text('video from http://a'), findsOneWidget);
    return setup;
  }

  testWidgets('switching servers never shows the old server\'s videos', (tester) async {
    final setup = await pumpFeed(tester);
    await tester.runAsync(() => setup.container.read(serverProfilesProvider.notifier).add(const ServerConfig(baseUrl: 'http://b')));
    await tester.pump();
    expect(find.text('video from http://a'), findsNothing, reason: 'old videos gone while B loads');
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // The switch (and B's request) ran in real async code: answer there too.
    await tester.runAsync(() async {
      setup.gate.complete();
      await Future<void>.delayed(const Duration(milliseconds: 20));
    });
    await _settle(tester);
    expect(find.text('video from http://b'), findsOneWidget);
  });

  testWidgets('if the new server fails, an error shows instead of the old videos', (tester) async {
    final setup = await pumpFeed(tester, failB: true);
    await tester.runAsync(() => setup.container.read(serverProfilesProvider.notifier).add(const ServerConfig(baseUrl: 'http://b')));
    // The switch (and B's request) ran in real async code: answer there too.
    await tester.runAsync(() async {
      setup.gate.complete();
      await Future<void>.delayed(const Duration(milliseconds: 20));
    });
    await _settle(tester);
    expect(find.text('video from http://a'), findsNothing);
    expect(find.text('Something went wrong'), findsOneWidget);
  });
}

/// A few frames: the loading spinner never settles, so no pumpAndSettle.
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}
