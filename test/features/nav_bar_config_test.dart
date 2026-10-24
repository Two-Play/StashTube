import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/features/library/library_page.dart';
import 'package:stash_app_mobile/features/settings/nav_bar_settings_page.dart';
import 'package:stash_app_mobile/features/shell/nav_bar_config.dart';
import 'package:stash_app_mobile/features/shell/navigation.dart';
import 'package:stash_app_mobile/l10n/l10n.dart';

Future<ProviderContainer> _container([Map<String, Object> prefs = const {}]) async {
  SharedPreferences.setMockInitialValues(prefs);
  final instance = await SharedPreferences.getInstance();
  final c = ProviderContainer(overrides: [sharedPreferencesProvider.overrideWithValue(instance)]);
  addTearDown(c.dispose);
  return c;
}

void main() {
  test('the standard bar is home, shorts, search, library and "You"', () {
    expect(NavBarConfig.standard.visible, [AppTab.home, AppTab.shorts, AppTab.search, AppTab.library, AppTab.you]);
  });

  test('a full stored bar makes room for "You" by dropping its last hideable tab', () async {
    final c = await _container({
      'nav_bar_order': ['home', 'performers', 'studios', 'library', 'stats'],
      'nav_bar_hidden': <String>[],
    });
    expect(c.read(navBarConfigProvider).visible,
        [AppTab.home, AppTab.performers, AppTab.studios, AppTab.library, AppTab.you]);
  });

  test('a stored "all views" tab becomes "You" at its place, the other choices stay', () async {
    final c = await _container({
      'nav_bar_order': ['home', 'all', 'performers', 'library', 'shorts', 'studios', 'search', 'tags'],
      'nav_bar_hidden': ['studios', 'search', 'tags'],
    });
    final config = c.read(navBarConfigProvider);
    expect(config.visible, [AppTab.home, AppTab.you, AppTab.performers, AppTab.library, AppTab.shorts]);
    expect(config.order.take(3), [AppTab.home, AppTab.you, AppTab.performers]);
    expect(config.isVisible(AppTab.stats), isFalse, reason: 'tabs missing from the stored order start hidden');
  });

  test('a stored bar with "all views" last keeps "You" last and fits it to five tabs', () async {
    final c = await _container({
      'nav_bar_order': ['home', 'performers', 'studios', 'library', 'shorts', 'all'],
      'nav_bar_hidden': <String>[],
    });
    expect(c.read(navBarConfigProvider).visible,
        [AppTab.home, AppTab.performers, AppTab.studios, AppTab.library, AppTab.you]);
  });

  test('a stored bar with the old settings tab gets stats in its place', () async {
    final c = await _container({
      'nav_bar_order': ['home', 'settings', 'library', 'stats'],
      'nav_bar_hidden': ['stats'],
    });
    final config = c.read(navBarConfigProvider);
    expect(config.visible, [AppTab.home, AppTab.stats, AppTab.library, AppTab.you],
        reason: 'tabs missing from the stored order start hidden, except "You"');
  });

  test('every part of the library can be its own tab', () {
    for (final section in LibrarySection.values) {
      expect(AppTab.values.where((t) => t.section == section), hasLength(1), reason: section.name);
    }
  });

  testWidgets('the bar is translated', (tester) async {
    final c = (await tester.runAsync(_container))!;
    await tester.pumpWidget(UncontrolledProviderScope(
      container: c,
      child: MaterialApp(
        locale: const Locale('de'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Text(
            [for (final tab in c.read(navBarConfigProvider).visible) tab.label(context.l10n)].join(','),
          ),
        ),
      ),
    ));
    expect(find.text('Start,Shorts,Suche,Bibliothek,Du'), findsOneWidget);
  });

  test('"You" cannot be hidden, and the bar keeps 2 to 5 tabs', () {
    var config = NavBarConfig.standard;
    expect(config.canToggle(AppTab.you), isFalse);
    expect(config.toggle(AppTab.you), config);

    // Five tabs shown: nothing more can be added.
    expect(config.canToggle(AppTab.tags), isFalse);
    config = config.toggle(AppTab.search).toggle(AppTab.tags);
    expect(config.visible, contains(AppTab.tags));
    expect(config.visible, isNot(contains(AppTab.search)));

    config = config.toggle(AppTab.home).toggle(AppTab.library).toggle(AppTab.shorts);
    expect(config.visible, [AppTab.tags, AppTab.you]);
    expect(config.canToggle(AppTab.tags), isFalse);
  });

  test('moving a tab uses the target index', () {
    final config = NavBarConfig.standard.move(AppTab.values.indexOf(AppTab.stats), 0);
    expect(config.order.first, AppTab.stats);
    expect(config.move(0, 2).order.take(3), [AppTab.home, AppTab.shorts, AppTab.stats]);
  });

  test('a stored order missing new tabs gets them appended', () {
    final config = NavBarConfig(order: [AppTab.stats, AppTab.home, AppTab.home]);
    expect(config.order.length, AppTab.values.length);
    expect(config.order.take(2), [AppTab.stats, AppTab.home]);
  });

  test('changes are stored and survive a restart', () async {
    final c = await _container();
    await c.read(navBarConfigProvider.notifier).move(AppTab.values.indexOf(AppTab.library), 0);
    await c.read(navBarConfigProvider.notifier).toggle(AppTab.search);
    await c.read(navBarConfigProvider.notifier).toggle(AppTab.performers);

    final restarted = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(await SharedPreferences.getInstance())],
    );
    addTearDown(restarted.dispose);
    expect(restarted.read(navBarConfigProvider).visible,
        [AppTab.library, AppTab.home, AppTab.shorts, AppTab.performers, AppTab.you]);
    // The app starts on the first tab of the bar.
    expect(restarted.read(currentTabProvider), AppTab.library);

    await restarted.read(navBarConfigProvider.notifier).reset();
    expect(restarted.read(navBarConfigProvider), NavBarConfig.standard);
  });

  test('a broken stored config falls back to the standard bar', () async {
    final c = await _container({
      'nav_bar_order': ['stats'],
      'nav_bar_hidden': AppTab.values.map((t) => t.name).toList(),
    });
    expect(c.read(navBarConfigProvider), NavBarConfig.standard);
  });

  test('hiding the selected tab moves to the first tab', () async {
    final c = await _container();
    c.listen(currentTabProvider, (_, _) {});
    c.read(currentTabProvider.notifier).select(AppTab.search);

    await c.read(navBarConfigProvider.notifier).toggle(AppTab.search);
    expect(c.read(currentTabProvider), AppTab.home);
  });

  testWidgets('the settings page shows and hides tabs', (tester) async {
    final c = (await tester.runAsync(_container))!;
    // Tall enough to build every tab of the list.
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(UncontrolledProviderScope(
      container: c,
      child: const MaterialApp(home: NavBarSettingsPage()),
    ));

    CheckboxListTile tile(String label) =>
        tester.widget(find.ancestor(of: find.text(label), matching: find.byType(CheckboxListTile)));
    expect(tile('You').onChanged, isNull);
    expect(find.text('Always shown'), findsOneWidget);
    // The bar is full, so hidden tabs can't be switched on yet.
    expect(tile('Tags').onChanged, isNull);

    await tester.tap(find.text('Search'));
    await tester.pump();
    await tester.tap(find.text('Tags'));
    await tester.pump();
    expect(c.read(navBarConfigProvider).visible,
        [AppTab.home, AppTab.shorts, AppTab.library, AppTab.tags, AppTab.you]);

    await tester.tap(find.text('Reset'));
    await tester.pump();
    expect(c.read(navBarConfigProvider), NavBarConfig.standard);
  });
}
