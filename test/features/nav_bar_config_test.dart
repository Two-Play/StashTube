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
  test('the standard bar keeps the tabs the app always had', () {
    expect(NavBarConfig.standard.visible,
        [AppTab.home, AppTab.performers, AppTab.studios, AppTab.library, AppTab.settings]);
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
    expect(find.text('Start,Performer,Studios,Bibliothek,Optionen'), findsOneWidget);
  });

  test('settings cannot be hidden, and the bar keeps 2 to 5 tabs', () {
    var config = NavBarConfig.standard;
    expect(config.canToggle(AppTab.settings), isFalse);
    expect(config.toggle(AppTab.settings), config);

    // Five tabs shown: nothing more can be added.
    expect(config.canToggle(AppTab.tags), isFalse);
    config = config.toggle(AppTab.studios).toggle(AppTab.tags);
    expect(config.visible, contains(AppTab.tags));
    expect(config.visible, isNot(contains(AppTab.studios)));

    config = config.toggle(AppTab.home).toggle(AppTab.performers).toggle(AppTab.library);
    expect(config.visible, [AppTab.tags, AppTab.settings]);
    expect(config.canToggle(AppTab.tags), isFalse);
  });

  test('moving a tab uses the target index', () {
    final config = NavBarConfig.standard.move(AppTab.values.indexOf(AppTab.settings), 0);
    expect(config.order.first, AppTab.settings);
    expect(config.move(0, 2).order.take(3), [AppTab.home, AppTab.performers, AppTab.settings]);
  });

  test('a stored order missing new tabs gets them appended', () {
    final config = NavBarConfig(order: [AppTab.settings, AppTab.home, AppTab.home]);
    expect(config.order.length, AppTab.values.length);
    expect(config.order.take(2), [AppTab.settings, AppTab.home]);
  });

  test('changes are stored and survive a restart', () async {
    final c = await _container();
    await c.read(navBarConfigProvider.notifier).move(AppTab.values.indexOf(AppTab.library), 0);
    await c.read(navBarConfigProvider.notifier).toggle(AppTab.studios);
    await c.read(navBarConfigProvider.notifier).toggle(AppTab.search);

    final restarted = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(await SharedPreferences.getInstance())],
    );
    addTearDown(restarted.dispose);
    expect(restarted.read(navBarConfigProvider).visible,
        [AppTab.library, AppTab.home, AppTab.performers, AppTab.search, AppTab.settings]);
    // The app starts on the first tab of the bar.
    expect(restarted.read(currentTabProvider), AppTab.library);

    await restarted.read(navBarConfigProvider.notifier).reset();
    expect(restarted.read(navBarConfigProvider), NavBarConfig.standard);
  });

  test('a broken stored config falls back to the standard bar', () async {
    final c = await _container({
      'nav_bar_order': ['settings'],
      'nav_bar_hidden': AppTab.values.map((t) => t.name).toList(),
    });
    expect(c.read(navBarConfigProvider), NavBarConfig.standard);
  });

  test('hiding the selected tab moves to the first tab', () async {
    final c = await _container();
    c.listen(currentTabProvider, (_, _) {});
    c.read(currentTabProvider.notifier).select(AppTab.studios);

    await c.read(navBarConfigProvider.notifier).toggle(AppTab.studios);
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
    expect(tile('Settings').onChanged, isNull);
    expect(find.text('Always shown'), findsOneWidget);
    // The bar is full, so hidden tabs can't be switched on yet.
    expect(tile('Tags').onChanged, isNull);

    await tester.tap(find.text('Studios'));
    await tester.pump();
    await tester.tap(find.text('Tags'));
    await tester.pump();
    expect(c.read(navBarConfigProvider).visible,
        [AppTab.home, AppTab.performers, AppTab.library, AppTab.tags, AppTab.settings]);

    await tester.tap(find.text('Reset'));
    await tester.pump();
    expect(c.read(navBarConfigProvider), NavBarConfig.standard);
  });
}
