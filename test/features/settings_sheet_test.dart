import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/providers.dart';
import 'package:stash_app_mobile/features/security/app_lock.dart';
import 'package:stash_app_mobile/features/settings/nav_bar_settings_page.dart';
import 'package:stash_app_mobile/features/settings/settings_button.dart';
import 'package:stash_app_mobile/features/settings/settings_categories.dart';
import 'package:stash_app_mobile/features/settings/settings_page.dart';

import 'app_lock_test.dart' show FakeBiometrics;

void main() {
  late ProviderContainer container;

  Future<void> pumpApp(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'url': 'http://s'});
    final prefs = await SharedPreferences.getInstance();
    container = ProviderContainer(overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      biometricAuthProvider.overrideWithValue(FakeBiometrics()),
      serverVersionProvider.overrideWith((ref) async => 'v0.28.0'),
    ]);
    addTearDown(container.dispose);
    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        home: Scaffold(appBar: AppBar(actions: const [SettingsButton()])),
      ),
    ));
  }

  testWidgets('the settings open as a sheet and close with the X', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.byType(SettingsButton));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsPage), findsOneWidget);
    expect(container.read(settingsOpenProvider), isTrue);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsPage), findsNothing);
    expect(container.read(settingsOpenProvider), isFalse);
  });

  testWidgets('swiping the sheet down closes it', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.byType(SettingsButton));
    await tester.pumpAndSettle();

    await tester.fling(find.byType(SettingsPage), const Offset(0, 500), 2000);
    await tester.pumpAndSettle();
    expect(find.byType(SettingsPage), findsNothing);
  });

  testWidgets('the root lists the categories with summaries', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.byType(SettingsButton));
    await tester.pumpAndSettle();

    for (final title in ['Server', 'Appearance', 'Playback', 'Previews & cards', 'Privacy & security', 'About']) {
      expect(find.text(title), findsOneWidget, reason: title);
    }
    expect(find.textContaining('Stash v0.28.0'), findsOneWidget);
    expect(find.textContaining('App lock off'), findsOneWidget);
    expect(find.textContaining('Quality: Original'), findsOneWidget);
    // The destructive action lives only on the server page.
    expect(find.text('Remove this server'), findsNothing);
  });

  testWidgets('sub-pages open inside the sheet', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.byType(SettingsButton));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Appearance'));
    await tester.pumpAndSettle();
    expect(find.byType(AppearanceSettingsPage), findsOneWidget);
    await tester.tap(find.byIcon(Icons.space_dashboard_outlined));
    await tester.pumpAndSettle();
    expect(find.byType(NavBarSettingsPage), findsOneWidget);

    // Back returns through the settings, not out of the sheet.
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(AppearanceSettingsPage), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(SettingsPage), findsOneWidget);
    expect(find.byIcon(Icons.close), findsOneWidget);
  });

  testWidgets('the server page asks before removing the server, as its last entry', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.byType(SettingsButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Server'));
    await tester.pumpAndSettle();
    expect(find.byType(ServerSettingsPage), findsOneWidget);
    expect(find.text('Switch server'), findsOneWidget);

    final tiles = tester.widgetList<ListTile>(
      find.descendant(of: find.byType(ServerSettingsPage), matching: find.byType(ListTile)),
    );
    expect((tiles.last.title! as Text).data, 'Remove this server');

    await tester.tap(find.text('Remove this server'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    // Cancelling keeps the server and the page.
    await tester.tap(find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton)).first);
    await tester.pumpAndSettle();
    expect(find.byType(ServerSettingsPage), findsOneWidget);
    expect(container.read(serverProfilesProvider).profiles, hasLength(1));
  });
}
