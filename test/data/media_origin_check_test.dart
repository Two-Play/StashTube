import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/media_origin_check.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/data/models/page_result.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/widgets/connection_banner.dart';

class _OneScene implements StashRepository {
  _OneScene(this.screenshotUrl);

  final String screenshotUrl;
  int calls = 0;

  @override
  Future<PageResult<Scene>> findScenes(SceneQuery query, {int page = 1, int perPage = 24}) async {
    calls++;
    return PageResult(items: [Scene(id: '1', title: 'A', screenshotUrl: screenshotUrl)], totalCount: 1);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('compares the media URL with the server address by origin', () {
    expect(mediaOriginMismatch('https://stash.example', 'https://stash.example/scene/1/screenshot'), isNull);
    expect(mediaOriginMismatch('https://stash.example', 'https://stash.example:443/x'), isNull);
    expect(
      mediaOriginMismatch('https://stash.example', 'http://stash.example/scene/1/screenshot'),
      const MediaOriginMismatch(server: 'https://stash.example', media: 'http://stash.example'),
      reason: 'X-Forwarded-Proto missing',
    );
    expect(
      mediaOriginMismatch('https://stash.example', 'http://localhost:9999/scene/1/screenshot'),
      const MediaOriginMismatch(server: 'https://stash.example', media: 'http://localhost:9999'),
      reason: 'Host header not passed on',
    );
    expect(mediaOriginMismatch('https://stash.example', '/relative'), isNull);
    expect(mediaOriginMismatch('https://stash.example', null), isNull);
  });

  group('check', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    ProviderContainer container(ServerConfig config, StashRepository repo) {
      final c = ProviderContainer(overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        activeServerIdProvider.overrideWithValue('a'),
        serverConfigProvider.overrideWithValue(config),
        stashRepositoryProvider.overrideWithValue(repo),
      ]);
      addTearDown(c.dispose);
      return c;
    }

    test('warns when a server with credentials hands out media elsewhere', () async {
      final c = container(
        const ServerConfig(baseUrl: 'https://stash.example', apiKey: 'k'),
        _OneScene('http://stash.example/scene/1/screenshot'),
      );
      expect(await c.read(mediaOriginMismatchProvider.future), isNotNull);
      expect(c.read(mediaOriginWarningProvider)?.media, 'http://stash.example');

      await c.read(mediaOriginHintHiddenProvider.notifier).hide(c.read(mediaOriginWarningProvider)!);
      expect(c.read(mediaOriginWarningProvider), isNull);
      expect(prefs.getString('media_origin_hint_hidden:a'), 'http://stash.example');
    });

    test('no check without credentials: nothing to lose', () async {
      final repo = _OneScene('http://elsewhere/scene/1/screenshot');
      final c = container(const ServerConfig(baseUrl: 'https://stash.example'), repo);
      expect(await c.read(mediaOriginMismatchProvider.future), isNull);
      expect(repo.calls, 0);
    });
  });

  testWidgets('the banner names both addresses and hides for good', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        activeServerIdProvider.overrideWithValue('a'),
        mediaOriginMismatchProvider.overrideWith(
          (ref) async => const MediaOriginMismatch(server: 'https://stash.example', media: 'http://stash.example'),
        ),
      ],
      child: const MaterialApp(home: ConnectionBannerScope(child: Text('content'))),
    ));
    await tester.pumpAndSettle();
    expect(find.text('Images and videos may not load'), findsOneWidget);
    expect(find.textContaining('http://stash.example, but StashTube connects to https://stash.example'), findsOneWidget);

    await tester.tap(find.text('Hide'));
    await tester.pumpAndSettle();
    expect(find.text('Images and videos may not load'), findsNothing);
    expect(find.text('content'), findsOneWidget);
    expect(prefs.getString('media_origin_hint_hidden:a'), 'http://stash.example');
  });
}
