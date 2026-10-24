import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/features/player/player_providers.dart';
import 'package:stash_app_mobile/features/shell/app_shell.dart';
import 'package:stash_app_mobile/features/shell/navigation.dart';
import 'package:stash_app_mobile/features/shell/shell_layout.dart';
import 'package:stash_app_mobile/features/shorts/shorts_page.dart';
import 'package:stash_app_mobile/l10n/gen/app_localizations.dart';

import '../helpers.dart';

/// NAV-4: bottom bar on phones, navigation rail from 600 dp, extended rail
/// from 1240 dp.
void main() {
  void setSize(WidgetTester tester, Size size, {EdgeInsets padding = EdgeInsets.zero}) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    tester.view.padding = FakeViewPadding(
      left: padding.left,
      top: padding.top,
      right: padding.right,
      bottom: padding.bottom,
    );
    addTearDown(tester.view.reset);
  }

  group('ShellLayout', () {
    const destinations = <ShellDestination>[
      (icon: Icons.home_outlined, selectedIcon: Icons.home, label: 'Home'),
      (icon: Icons.slow_motion_video_outlined, selectedIcon: Icons.slow_motion_video, label: 'Shorts'),
      (icon: Icons.search, selectedIcon: Icons.saved_search, label: 'Search'),
      (icon: Icons.video_library_outlined, selectedIcon: Icons.video_library, label: 'Library'),
      (icon: Icons.account_circle_outlined, selectedIcon: Icons.account_circle, label: 'You'),
    ];
    const contentKey = Key('content');
    const panelKey = Key('panel');

    late ValueNotifier<double> height;

    Future<void> pump(
      WidgetTester tester, {
      bool player = false,
      bool hideNavigation = false,
      double textScale = 1,
      List<ShellDestination> destinations = destinations,
    }) async {
      height = ValueNotifier(kMiniPlayerHeight);
      addTearDown(height.dispose);
      await tester.pumpWidget(MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        ),
        home: Builder(
          builder: (context) {
            final maxHeight = MediaQuery.sizeOf(context).height;
            return ShellLayout(
              destinations: destinations,
              selectedIndex: 0,
              onSelect: (_) {},
              playerHeight: height,
              hideNavigation: hideNavigation,
              content: const SizedBox.expand(key: contentKey),
              miniplayer: !player
                  ? null
                  : Miniplayer(
                      valueNotifier: height,
                      minHeight: kMiniPlayerHeight,
                      maxHeight: maxHeight,
                      builder: (_, _) => const ColoredBox(key: panelKey, color: Colors.red),
                    ),
            );
          },
        ),
      ));
    }

    testWidgets('bottom bar below 600 dp', (tester) async {
      setSize(tester, const Size(400, 800));
      await pump(tester);
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);
      expect(tester.getRect(find.byKey(contentKey)).left, 0);
    });

    testWidgets('navigation rail with labels from 600 dp, content right of it', (tester) async {
      setSize(tester, const Size(1024, 768));
      await pump(tester);
      expect(find.byType(NavigationBar), findsNothing);
      final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
      expect(rail.extended, isFalse);
      expect(rail.labelType, NavigationRailLabelType.all);
      expect(find.text('Library'), findsOneWidget);
      expect(tester.getRect(find.byKey(contentKey)), const Rect.fromLTRB(ShellNavigationRail.width, 0, 1024, 768));
    });

    testWidgets('extended rail from 1240 dp', (tester) async {
      setSize(tester, const Size(1366, 1024));
      await pump(tester);
      expect(tester.widget<NavigationRail>(find.byType(NavigationRail)).extended, isTrue);
      expect(tester.getRect(find.byKey(contentKey)).left, ShellNavigationRail.extendedWidth);
    });

    testWidgets('long labels at 200 % text fit the rail and the extended rail', (tester) async {
      const long = [
        ...destinations,
        (icon: Icons.history, selectedIcon: Icons.history, label: 'Wiedergabeverlauf und mehr'),
      ];
      for (final width in [1024.0, 1366.0]) {
        setSize(tester, Size(width, 1024));
        await pump(tester, textScale: 2, destinations: long);
        expect(tester.takeException(), isNull, reason: 'at $width');
        expect(find.byType(NavigationRail), findsOneWidget);
      }
    });

    testWidgets('a phone in landscape gets the rail, beside the notch, without overflow', (tester) async {
      setSize(tester, const Size(844, 390), padding: const EdgeInsets.only(left: 47, right: 47, bottom: 21));
      await pump(tester, player: true);
      expect(tester.takeException(), isNull);
      expect(find.byType(NavigationRail), findsOneWidget);
      // The rail takes the notch's safe area; the content doesn't get it again.
      const railRight = 47 + ShellNavigationRail.width;
      expect(tester.getRect(find.byType(NavigationRail)).right, railRight);
      expect(tester.getRect(find.byKey(contentKey)).left, railRight);
      expect(MediaQuery.paddingOf(tester.element(find.byKey(contentKey))).left, 0);
      // The collapsed player sits right of the rail, above the home indicator.
      expect(tester.getRect(find.byKey(panelKey)), const Rect.fromLTRB(railRight, 390 - 21 - kMiniPlayerHeight, 844, 390 - 21));
      expect(tester.getRect(find.byKey(contentKey)).bottom, 390 - 21 - kMiniPlayerHeight);
    });

    testWidgets('the collapsed player sits right of the rail; expanded it covers the rail', (tester) async {
      setSize(tester, const Size(1024, 768));
      await pump(tester, player: true);
      final content = tester.getRect(find.byKey(contentKey));
      expect(tester.getRect(find.byKey(panelKey)), const Rect.fromLTRB(ShellNavigationRail.width, 768 - kMiniPlayerHeight, 1024, 768));
      expect(MediaQuery.sizeOf(tester.element(find.byKey(panelKey))).width, 1024 - ShellNavigationRail.width);

      // Halfway: the panel's left edge moves over the rail; the content
      // keeps its size (no layout jumps while dragging).
      height.value = (768 + kMiniPlayerHeight) / 2;
      await tester.pump();
      final half = tester.getRect(find.byKey(panelKey));
      expect(half.left, inExclusiveRange(0, ShellNavigationRail.width));
      expect(tester.getRect(find.byKey(contentKey)), content);

      height.value = 768;
      await tester.pump();
      expect(tester.getRect(find.byKey(panelKey)), const Rect.fromLTRB(0, 0, 1024, 768));
      expect(MediaQuery.sizeOf(tester.element(find.byKey(panelKey))).width, 1024);
      // A tap where the rail is reaches the player, not the rail.
      final hits = tester.hitTestOnBinding(const Offset(ShellNavigationRail.width / 2, 300));
      final panelBox = tester.renderObject(find.byKey(panelKey));
      expect(hits.path.any((entry) => entry.target == panelBox), isTrue);
      expect(tester.getRect(find.byKey(contentKey)), content);
    });

    testWidgets('the shorts fullscreen hides the rail', (tester) async {
      setSize(tester, const Size(1024, 768));
      await pump(tester, hideNavigation: true);
      expect(find.byType(NavigationRail), findsNothing);
      expect(find.byType(NavigationBar), findsNothing);
      expect(tester.getRect(find.byKey(contentKey)).left, 0);
    });
  });

  group('AppShell on a tablet', () {
    late ProviderContainer container;

    Future<void> pumpShell(WidgetTester tester, Size size) async {
      setSize(tester, size);
      final prefs = (await tester.runAsync(() async {
        SharedPreferences.setMockInitialValues({});
        return SharedPreferences.getInstance();
      }))!;
      container = ProviderContainer(overrides: [
        ...testServer,
        sharedPreferencesProvider.overrideWithValue(prefs),
        nowPlayingProvider.overrideWith(_NothingPlaying.new),
      ]);
      addTearDown(container.dispose);
      await tester.pumpWidget(UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: AppShell(
            pageBuilder: (tab) => Scaffold(
              body: ListView(
                children: [for (var i = 0; i < 100; i++) SizedBox(height: 50, child: Text('${tab.name} $i'))],
              ),
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();
    }

    testWidgets('switches tabs through the rail', (tester) async {
      await pumpShell(tester, const Size(1024, 768));
      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.text('home 0'), findsOneWidget);

      await tester.tap(find.descendant(of: find.byType(NavigationRail), matching: find.text('Search')));
      await tester.pumpAndSettle();
      expect(container.read(currentTabProvider), AppTab.search);
      expect(find.text('search 0'), findsOneWidget);
      expect(tester.widget<NavigationRail>(find.byType(NavigationRail)).selectedIndex, 2);
    });

    testWidgets('re-selecting the tab in the rail scrolls to the top', (tester) async {
      await pumpShell(tester, const Size(1024, 768));
      await tester.drag(find.byType(ListView), const Offset(0, -2000));
      await tester.pumpAndSettle();
      final controller = container.read(tabScrollControllersProvider)[AppTab.home]!;
      expect(controller.offset, greaterThan(0));

      await tester.tap(find.descendant(of: find.byType(NavigationRail), matching: find.text('Home')));
      await tester.pumpAndSettle();
      expect(controller.offset, 0);
    });

    testWidgets('the shorts fullscreen hides the rail', (tester) async {
      await pumpShell(tester, const Size(1024, 768));
      container.read(shortsFullscreenProvider.notifier).set(true);
      await tester.pumpAndSettle();
      expect(find.byType(NavigationRail), findsNothing);
      container.read(shortsFullscreenProvider.notifier).set(false);
      await tester.pumpAndSettle();
      expect(find.byType(NavigationRail), findsOneWidget);
    });

    testWidgets('a phone keeps the bottom bar', (tester) async {
      await pumpShell(tester, const Size(390, 844));
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);
    });
  });
}

class _NothingPlaying extends NowPlayingNotifier {
  @override
  Scene? build() => null;
}
