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
import 'package:stash_app_mobile/data/models/marker.dart';
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
import 'package:stash_app_mobile/features/auth/server_avatar.dart';
import 'package:stash_app_mobile/features/home/home_page.dart';
import 'package:stash_app_mobile/features/library/library_page.dart';
import 'package:stash_app_mobile/features/performers/performer_page.dart';
import 'package:stash_app_mobile/features/search/search_page.dart';
import 'package:stash_app_mobile/features/security/app_lock.dart';
import 'package:stash_app_mobile/features/player/player_providers.dart';
import 'package:stash_app_mobile/features/shell/app_shell.dart';
import 'package:stash_app_mobile/features/shell/navigation.dart';
import 'package:stash_app_mobile/features/you/you_page.dart';
import 'package:stash_app_mobile/l10n/gen/app_localizations.dart';
import 'package:stash_app_mobile/widgets/sliver_columns.dart';

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
  Future<PageResult<Group>> findGroups(GroupQuery query, {int page = 1, int perPage = 24}) async => PageResult(
        items: page > 1
            ? const []
            : const [Group(id: 'g1', name: 'A group with a name long enough to wrap', sceneCount: 12)],
        totalCount: 1,
      );

  @override
  Future<PageResult<Marker>> findMarkers(MarkerQuery query, {int page = 1, int perPage = 24}) async => PageResult(
        items: page > 1
            ? const []
            : const [
                Marker(
                  id: 'm1',
                  title: 'A marker title that goes on',
                  seconds: 3600,
                  tag: Tag(id: 't1', name: 'A long tag name'),
                  scene: Scene(id: 'v1', title: 'A scene title long enough to need two lines'),
                ),
              ],
        totalCount: 1,
      );

  @override
  Future<List<SavedFilter>> savedSceneFilters() async => const [];

  @override
  Future<List<ServerJob>> jobQueue() async => const [];

  @override
  Future<PreviewCheck> checkPreviews({int sample = 8}) async => const PreviewCheck();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Overflows already reported but not fixed yet; a pattern matches the
/// error's text. Remove an entry once it is fixed, so the test guards it
/// again.
// Overflows that are known and not fixed yet (none at the moment); each
// applies to the cases [when] accepts.
final _knownOverflows = <({RegExp pattern, bool Function(_Case) when})>[];

/// One screen the pages are checked on.
class _Case {
  const _Case(this.size, this.scale, this.locale);

  final Size size;
  final double scale;
  final String locale;

  @override
  String toString() => '${size.width.toInt()}x${size.height.toInt()}, ${scale}x text, $locale';
}

/// A11Y-3: the main pages at 100 %, 150 % and 200 % text on a 360×780
/// phone, at 100 % and 200 % on a narrow 320×640 one and on a 1024×768
/// tablet (columns, navigation rail; NAV-4), in English and German (longer
/// labels), without overflow.
void main() {
  const screens = [
    (Size(360, 780), [1.0, 1.5, 2.0]),
    (Size(320, 640), [1.0, 2.0]),
    (Size(1024, 768), [1.0, 2.0]),
  ];
  final cases = [
    for (final (size, scales) in screens)
      for (final scale in scales)
        for (final locale in ['en', 'de']) _Case(size, scale, locale),
  ];

  Future<SharedPreferences> prefsWith(WidgetTester tester, Map<String, Object> values) async =>
      (await tester.runAsync(() async {
        SharedPreferences.setMockInitialValues(values);
        return SharedPreferences.getInstance();
      }))!;

  Future<ProviderContainer> pumpPage(
    WidgetTester tester,
    Widget page, {
    required _Case at,
    List<Override> overrides = const [],
    bool server = true,
    // The shell brings the tab navigators itself.
    bool tabNavigator = true,
  }) async {
    tester.view.physicalSize = at.size;
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
    final navigatorKey = server && tabNavigator ? container.read(tabNavigatorKeysProvider)[container.read(currentTabProvider)] : null;
    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        navigatorKey: navigatorKey,
        theme: AppTheme.light(stashTubeBlue),
        locale: Locale(at.locale),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(at.scale)),
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

  void expectNoOverflow(_Case at, String what) {
    bool known(FlutterErrorDetails e) =>
        _knownOverflows.any((k) => k.when(at) && k.pattern.hasMatch(e.toString()));
    final found = [...errors.where((e) => !known(e))];
    errors.clear();
    expect(found, isEmpty, reason: '$what:\n${found.map((e) => e.toString()).join('\n')}');
  }

  for (final at in cases) {
    final l = lookupAppLocalizations(Locale(at.locale));
    group('$at', () {
      testScaled('navigation bar or rail', (tester) async {
        await pumpPage(
          tester,
          AppShell(pageBuilder: (tab) => Scaffold(appBar: AppBar(title: Text(tab.title(l))))),
          at: at,
          overrides: [nowPlayingProvider.overrideWith(_NothingPlaying.new)],
          tabNavigator: false,
        );
        final wide = at.size.width >= kWideLayoutBreakpoint;
        expect(find.byType(NavigationRail), wide ? findsOneWidget : findsNothing);
        expect(find.byType(NavigationBar), wide ? findsNothing : findsOneWidget);
        expectNoOverflow(at, 'navigation');
      });

      testScaled('home', (tester) async {
        await pumpPage(tester, const HomePage(), at: at);
        expect(find.textContaining('A scene title'), findsWidgets);
        expectNoOverflow(at, 'home');
        await tester.drag(find.byType(CustomScrollView).first, const Offset(0, -1500));
        await settle(tester);
        expectNoOverflow(at, 'home, scrolled');
      });

      testScaled('search: discover and results', (tester) async {
        await pumpPage(tester, const SearchPage(autofocus: false), at: at);
        expectNoOverflow(at, 'search discover');

        await tester.enterText(find.byType(TextField), 'scene');
        await tester.testTextInput.receiveAction(TextInputAction.search);
        await settle(tester);
        // Offstage too: on a small screen the performers come first and the
        // scenes start below the fold.
        expect(find.textContaining('A scene title', skipOffstage: false), findsWidgets);
        expectNoOverflow(at, 'search results');

        await tester.enterText(find.byType(TextField), 'zebra');
        await tester.testTextInput.receiveAction(TextInputAction.search);
        await settle(tester);
        expectNoOverflow(at, 'search results for another term');
      });

      testScaled('library', (tester) async {
        await pumpPage(tester, const LibraryPage(), at: at);
        expect(find.byType(TabBar), findsOneWidget);
        expect(find.textContaining('A scene title'), findsWidgets);
        expectNoOverflow(at, 'library');
      });

      testScaled('you', (tester) async {
        await pumpPage(tester, const YouPage(), at: at);
        expect(find.textContaining('A scene title'), findsWidgets);
        expectNoOverflow(at, 'you');
        await tester.scrollUntilVisible(find.text(l.settingsTitle), 400, scrollable: find.byType(Scrollable).first);
        await settle(tester);
        expectNoOverflow(at, 'you, scrolled');
      });

      testScaled('performer channel', (tester) async {
        await pumpPage(tester, const PerformerPage(performerId: 'p1'), at: at);
        expect(find.text('Performer with a long name'), findsWidgets);
        expectNoOverflow(at, 'performer');
        await tester.drag(find.byType(CustomScrollView).first, const Offset(0, -800));
        await settle(tester);
        expectNoOverflow(at, 'performer, scrolled');
      });

      testScaled('settings and its pages', (tester) async {
        await pumpPage(
          tester,
          Scaffold(appBar: AppBar(actions: const [ServerAvatarButton()])),
          at: at,
          overrides: [biometricAuthProvider.overrideWithValue(FakeBiometrics())],
        );
        await tester.tap(find.byType(ServerAvatarButton));
        await settle(tester);
        expect(find.byType(AccountSheet), findsOneWidget);
        expectNoOverflow(at, 'account sheet');
        await tester.ensureVisible(find.text(l.settingsTitle));
        await settle(tester);
        await tester.tap(find.text(l.settingsTitle));
        await settle(tester);
        expectNoOverflow(at, 'settings');

        for (final category in [
          l.sectionServer,
          l.sectionAppearance,
          l.sectionPlayback,
          l.sectionPreviewsCards,
          l.sectionPrivacy,
          l.sectionAbout,
        ]) {
          await tester.ensureVisible(find.text(category));
          await settle(tester);
          await tester.tap(find.text(category));
          await settle(tester);
          expectNoOverflow(at, 'settings: $category');
          await tester.drag(find.byType(Scrollable).last, const Offset(0, -1500));
          await settle(tester);
          expectNoOverflow(at, 'settings: $category, scrolled');
          // pageBack looks for the English tooltip only.
          final back = MaterialLocalizations.of(tester.element(find.byType(Scaffold).last)).backButtonTooltip;
          await tester.tap(find.byTooltip(back).last);
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
          at: at,
          server: false,
          overrides: [
            secretStoreProvider.overrideWithValue(MemorySecretStore()),
            serverVerifierProvider.overrideWithValue(verify),
          ],
        );
        expectNoOverflow(at, 'login step 1');

        await tester.enterText(find.widgetWithText(TextFormField, l.serverUrl), 'nas');
        await tester.ensureVisible(find.text(l.connect));
        await tester.tap(find.text(l.connect));
        await settle(tester);
        expect(find.byType(TextFormField), findsWidgets);
        expect(find.widgetWithText(TextFormField, l.serverUrl), findsNothing, reason: 'step 2 is shown');
        expectNoOverflow(at, 'login step 2');
      });
    });
  }
}

class _NothingPlaying extends NowPlayingNotifier {
  @override
  Scene? build() => null;
}

/// A few frames: loading placeholders and previews never settle.
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 8; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}
