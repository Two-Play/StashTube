import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/data/models/page_result.dart';
import 'package:stash_app_mobile/data/models/studio.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/features/studios/studios_page.dart';

class FakeServerRepository implements StashRepository {
  FakeServerRepository(this.url);

  final String url;

  @override
  Future<PageResult<Studio>> findStudios(StudioQuery query, {int page = 1, int perPage = 24}) async =>
      PageResult(items: [Studio(id: '1', name: 'studio from $url')], totalCount: 1);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  for (final visible in [true, false]) {
    testWidgets('studios reload after switching servers (tab ${visible ? 'visible' : 'in the background'})',
        (tester) async {
      final c = (await tester.runAsync(() async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();
        final c = ProviderContainer(
          retry: (_, __) => null,
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            stashRepositoryProvider.overrideWith((ref) => FakeServerRepository(ref.watch(serverConfigProvider)!.baseUrl)),
          ],
        );
        await c.read(serverProfilesProvider.notifier).add(const ServerConfig(baseUrl: 'http://a'));
        return c;
      }))!;
      addTearDown(c.dispose);

      Widget app(bool tickers) => UncontrolledProviderScope(
            container: c,
            child: MaterialApp(home: TickerMode(enabled: tickers, child: const StudiosPage())),
          );
      await tester.pumpWidget(app(true));
      await _settle(tester);
      expect(find.text('studio from http://a'), findsOneWidget);

      // Like a tab in the IndexedStack: hidden while the server changes.
      await tester.pumpWidget(app(visible));
      await tester.runAsync(() async {
        await c.read(serverProfilesProvider.notifier).add(const ServerConfig(baseUrl: 'http://b'));
        await Future<void>.delayed(const Duration(milliseconds: 20));
      });
      await _settle(tester);
      await tester.pumpWidget(app(true));
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
      await _settle(tester);

      expect(find.text('studio from http://a'), findsNothing);
      expect(find.text('studio from http://b'), findsOneWidget);
    });
  }
}
