import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/providers.dart';
import 'package:stash_app_mobile/features/auth/server_avatar.dart';
import 'package:stash_app_mobile/features/auth/server_switcher.dart';
import 'package:stash_app_mobile/features/security/app_lock.dart';
import 'package:stash_app_mobile/features/server_tasks/server_tasks_page.dart';
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
        home: Scaffold(appBar: AppBar(actions: const [ServerAvatarButton()])),
      ),
    ));
  }

  /// Through the server avatar's account sheet (NAV-2).
  Future<void> openSettingsSheet(WidgetTester tester) async {
    await tester.tap(find.byType(ServerAvatarButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
  }

  testWidgets('the settings open as a sheet and close with the X', (tester) async {
    await pumpApp(tester);
    await openSettingsSheet(tester);
    expect(find.byType(SettingsPage), findsOneWidget);
    expect(container.read(settingsOpenProvider), isTrue);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsPage), findsNothing);
    expect(container.read(settingsOpenProvider), isFalse);
  });

  testWidgets('swiping the sheet down closes it', (tester) async {
    await pumpApp(tester);
    await openSettingsSheet(tester);

    await tester.fling(find.byType(SettingsPage), const Offset(0, 500), 2000);
    await tester.pumpAndSettle();
    expect(find.byType(SettingsPage), findsNothing);
  });

  testWidgets('the root lists the categories with summaries', (tester) async {
    await pumpApp(tester);
    await openSettingsSheet(tester);

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
    await openSettingsSheet(tester);

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
    await openSettingsSheet(tester);
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

  testWidgets('the server avatar shows the server and opens the account sheet', (tester) async {
    await pumpApp(tester);
    final server = container.read(serverProfilesProvider).active!;
    expect(find.byTooltip(server.name), findsOneWidget);

    await tester.tap(find.byType(ServerAvatarButton));
    await tester.pumpAndSettle();
    expect(find.byType(AccountSheet), findsOneWidget);
    expect(find.text(server.baseUrl), findsOneWidget);

    await tester.tap(find.text('Switch server'));
    await tester.pumpAndSettle();
    expect(find.byType(AccountSheet), findsNothing);
    expect(find.byType(ServerSwitcher), findsOneWidget);
  });

  testWidgets('the account sheet opens the server tasks inside the settings', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.byType(ServerAvatarButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Server tasks'));
    await tester.pumpAndSettle();
    expect(find.byType(ServerTasksPage), findsOneWidget);
    expect(container.read(settingsOpenProvider), isTrue);

    // Back leads to the settings.
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(SettingsPage), findsOneWidget);
  });
}
