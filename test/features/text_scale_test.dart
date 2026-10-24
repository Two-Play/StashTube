import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/secret_store.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/core/config/theme.dart';
import 'package:stash_app_mobile/data/models/gallery.dart';
import 'package:stash_app_mobile/data/models/group.dart';
import 'package:stash_app_mobile/data/models/image_item.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/data/models/page_result.dart';
import 'package:stash_app_mobile/data/models/performer.dart';
import 'package:stash_app_mobile/data/models/saved_filter.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/models/server_task.dart';
import 'package:stash_app_mobile/data/models/stats.dart';
import 'package:stash_app_mobile/data/models/studio.dart';
import 'package:stash_app_mobile/data/models/tag.dart';
import 'package:stash_app_mobile/data/providers.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/features/auth/login_page.dart';
import 'package:stash_app_mobile/features/home/home_page.dart';
import 'package:stash_app_mobile/features/library/library_page.dart';
import 'package:stash_app_mobile/features/performers/performer_page.dart';
import 'package:stash_app_mobile/features/search/search_page.dart';
import 'package:stash_app_mobile/features/security/app_lock.dart';
import 'package:stash_app_mobile/features/settings/settings_button.dart';
import 'package:stash_app_mobile/features/shell/navigation.dart';
import 'package:stash_app_mobile/l10n/gen/app_localizations.dart';

import '../helpers.dart';
import 'app_lock_test.dart' show FakeBiometrics;

/// Every list full of long names, so text has to wrap or fade.
class _Repo implements StashRepository {
  static const _studio = Studio(id: 'st1', name: 'A studio with a rather long name');
  static const _performers = [
    Performer(id: 'p1', name: 'Performer with a long name'),
    Performer(id: 'p2', name: 'Second Performer'),
  ];

  @override
  Future<PageResult<Scene>> findScenes(SceneQuery query, {int page = 1, int perPage = 24}) async {
    final shorts = query.filter.portraitOnly;
    final count = shorts ? 6 : 30;
    return PageResult(
      items: page > 1
          ? const []
          : [
              for (var i = 0; i < count; i++)
                Scene(
                  id: '${shorts ? 's' : 'v'}$i',
                  title: 'A scene title long enough to need two lines on a phone $i',
                  duration: 3725,
                  playCount: 12,
                  rating100: 80,
                  height: 1080,
                  resumeTime: i == 0 ? 600 : 0,
                  streamUrl: 'http://s/$i',
                  studio: _studio,
                  performers: _performers,
                ),
            ],
      totalCount: count,
    );
  }

  @override
  Future<List<Scene>> findScenesByIds(List<String> ids) async => const [];

  @override
  Future<PageResult<Performer>> findPerformers(PerformerQuery query, {int page = 1, int perPage = 24}) async =>
      PageResult(items: page > 1 ? const [] : _performers, totalCount: _performers.length);

  @override
  Future<Performer> findPerformer(String id) async => const Performer(
        id: 'p1',
        name: 'Performer with a long name',
        disambiguation: 'the other one',
        country: 'DE',
        gender: 'FEMALE',
        details: 'Some words about this performer that go on for a while.',
        favorite: true,
        rating100: 60,
        sceneCount: 30,
      );

  @override
  Future<PageResult<Studio>> findStudios(StudioQuery query, {int page = 1, int perPage = 24}) async =>
      PageResult(items: page > 1 ? const [] : const [_studio], totalCount: 1);

  @override
  Future<PageResult<Tag>> findTags(TagQuery query, {int page = 1, int perPage = 24}) async => PageResult(
        items: page > 1 ? const [] : const [Tag(id: 't1', name: 'A long tag name', sceneCount: 12)],
        totalCount: 1,
      );

  @override
  Future<PageResult<ImageItem>> findImages(ImageQuery query, {int page = 1, int perPage = 24}) async =>
      const PageResult(items: [], totalCount: 0);

  @override
  Future<PageResult<Gallery>> findGalleries(GalleryQuery query, {int page = 1, int perPage = 24}) async =>
      const PageResult(items: [], totalCount: 0);

  @override
  Future<PageResult<Group>> findGroups(GroupQuery query, {int page = 1, int perPage = 24}) async =>
      const PageResult(items: [], totalCount: 0);

  @override
  Future<List<SavedFilter>> savedSceneFilters() async => const [];

  @override
  Future<List<ServerJob>> jobQueue() async => const [];

  @override
  Future<PreviewCheck> checkPreviews({int sample = 8}) async => const PreviewCheck();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Overflows already reported but not fixed yet, matched against the
/// widget that overflowed. Remove an entry once it is fixed, so the test
/// guards it again.
/// Overflows that are known and not fixed yet (none at the moment); a
/// pattern matches the error's text.
final _knownOverflows = <RegExp>[];

/// A11Y-3: the main pages at 100 %, 150 % and 200 % text on a 360×780
/// phone, without overflow.
void main() {
  const scales = [1.0, 1.5, 2.0];

  Future<SharedPreferences> prefsWith(WidgetTester tester, Map<String, Object> values) async =>
      (await tester.runAsync(() async {
        SharedPreferences.setMockInitialValues(values);
        return SharedPreferences.getInstance();
      }))!;

  Future<ProviderContainer> pumpPage(
    WidgetTester tester,
    Widget page, {
    required double scale,
    List<Override> overrides = const [],
    bool server = true,
  }) async {
    tester.view.physicalSize = const Size(360, 780);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final prefs = await prefsWith(tester, {});
    final container = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        if (server) ...testServer,
        sharedPreferencesProvider.overrideWithValue(prefs),
        stashRepositoryProvider.overrideWithValue(_Repo()),
        serverVersionProvider.overrideWith((ref) async => 'v0.28.1'),
        libraryStatsProvider.overrideWith((ref) async => const LibraryStats(sceneCount: 1234, performerCount: 5)),
        activityStatsProvider.overrideWith((ref) async => null),
        ...overrides,
      ],
    );
    addTearDown(container.dispose);
    final navigatorKey = server ? container.read(tabNavigatorKeysProvider)[container.read(currentTabProvider)] : null;
    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        navigatorKey: navigatorKey,
        theme: AppTheme.light(stashTubeBlue),
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
          child: child!,
        ),
        home: page,
      ),
    ));
    await settle(tester);
    return container;
  }

  // Layout errors collected while a test runs, with the widget that caused
  // them (tester.takeException would keep only the first, without it).
  final errors = <FlutterErrorDetails>[];

  void testScaled(String description, Future<void> Function(WidgetTester tester) body) {
    testWidgets(description, (tester) async {
      errors.clear();
      final previous = FlutterError.onError;
      FlutterError.onError = errors.add;
      try {
        await body(tester);
      } finally {
        FlutterError.onError = previous;
      }
    });
  }

  void expectNoOverflow(WidgetTester tester, String what) {
    final found = [...errors.where((e) => !_knownOverflows.any((known) => known.hasMatch(e.toString())))];
    errors.clear();
    expect(found, isEmpty, reason: '$what:\n${found.map((e) => e.toString()).join('\n')}');
  }

  for (final scale in scales) {
    group('at ${scale}x text', () {
      testScaled('home', (tester) async {
        await pumpPage(tester, const HomePage(), scale: scale);
        expect(find.textContaining('A scene title'), findsWidgets);
        expectNoOverflow(tester, 'home');
        await tester.drag(find.byType(CustomScrollView).first, const Offset(0, -1500));
        await settle(tester);
        expectNoOverflow(tester, 'home, scrolled');
      });

      testScaled('search: discover and results', (tester) async {
        await pumpPage(tester, const SearchPage(autofocus: false), scale: scale);
        expectNoOverflow(tester, 'search discover');

        await tester.enterText(find.byType(TextField), 'scene');
        await tester.testTextInput.receiveAction(TextInputAction.search);
        await settle(tester);
        expect(find.textContaining('A scene title'), findsWidgets);
        expectNoOverflow(tester, 'search results');

        await tester.enterText(find.byType(TextField), 'zebra');
        await tester.testTextInput.receiveAction(TextInputAction.search);
        await settle(tester);
        expectNoOverflow(tester, 'search results for another term');
      });

      testScaled('library', (tester) async {
        await pumpPage(tester, const LibraryPage(), scale: scale);
        expect(find.byType(TabBar), findsOneWidget);
        expect(find.textContaining('A scene title'), findsWidgets);
        expectNoOverflow(tester, 'library');
      });

      testScaled('performer channel', (tester) async {
        await pumpPage(tester, const PerformerPage(performerId: 'p1'), scale: scale);
        expect(find.text('Performer with a long name'), findsWidgets);
        expectNoOverflow(tester, 'performer');
        await tester.drag(find.byType(CustomScrollView).first, const Offset(0, -800));
        await settle(tester);
        expectNoOverflow(tester, 'performer, scrolled');
      });

      testScaled('settings and its pages', (tester) async {
        await pumpPage(
          tester,
          Scaffold(appBar: AppBar(actions: const [SettingsButton()])),
          scale: scale,
          overrides: [biometricAuthProvider.overrideWithValue(FakeBiometrics())],
        );
        await tester.tap(find.byType(SettingsButton));
        await settle(tester);
        expectNoOverflow(tester, 'settings');

        for (final category in ['Server', 'Appearance', 'Playback', 'Previews & cards', 'Privacy & security', 'About']) {
          await tester.ensureVisible(find.text(category));
          await settle(tester);
          await tester.tap(find.text(category));
          await settle(tester);
          expectNoOverflow(tester, 'settings: $category');
          await tester.drag(find.byType(Scrollable).last, const Offset(0, -1500));
          await settle(tester);
          expectNoOverflow(tester, 'settings: $category, scrolled');
          await tester.pageBack();
          await settle(tester);
        }
      });

      testScaled('login steps 1 and 2', (tester) async {
        Future<void> verify(ServerConfig config) async {
          if (config.baseUrl != 'http://nas:9999') {
            throw const StashApiException('unreachable', isNetworkError: true, kind: StashErrorKind.unreachable);
          }
          if (config.apiKey != 'key') throw const StashApiException('no', kind: StashErrorKind.unauthorized);
        }

        await pumpPage(
          tester,
          const LoginPage(),
          scale: scale,
          server: false,
          overrides: [
            secretStoreProvider.overrideWithValue(MemorySecretStore()),
            serverVerifierProvider.overrideWithValue(verify),
          ],
        );
        expectNoOverflow(tester, 'login step 1');

        await tester.enterText(find.widgetWithText(TextFormField, 'Server URL'), 'nas');
        await tester.ensureVisible(find.text('Connect'));
        await tester.tap(find.text('Connect'));
        await settle(tester);
        expect(find.byType(TextFormField), findsWidgets);
        expect(find.widgetWithText(TextFormField, 'Server URL'), findsNothing, reason: 'step 2 is shown');
        expectNoOverflow(tester, 'login step 2');
      });
    });
  }
}

/// A few frames: loading placeholders and previews never settle.
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 8; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}
