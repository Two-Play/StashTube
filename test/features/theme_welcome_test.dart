import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/core/config/theme.dart';
import 'package:stash_app_mobile/features/settings/theme_welcome.dart';

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  ProviderContainer container() {
    final c = ProviderContainer(overrides: [sharedPreferencesProvider.overrideWithValue(prefs)]);
    addTearDown(c.dispose);
    return c;
  }

  test('pending after the first login, also after a restart, until shown', () async {
    final c = container();
    expect(c.read(themeWelcomeProvider), isFalse);
    await c.read(themeWelcomeProvider.notifier).request();

    final restarted = container();
    expect(restarted.read(themeWelcomeProvider), isTrue);
    await restarted.read(themeWelcomeProvider.notifier).done();
    expect(container().read(themeWelcomeProvider), isFalse);
  });

  testWidgets('shows once and applies the choice right away', (tester) async {
    final c = container();
    await c.read(themeWelcomeProvider.notifier).request();
    late WidgetRef widgetRef;
    await tester.pumpWidget(UncontrolledProviderScope(
      container: c,
      child: MaterialApp(
        home: Consumer(builder: (context, ref, _) {
          widgetRef = ref;
          return const Scaffold();
        }),
      ),
    ));
    final context = tester.element(find.byType(Scaffold));

    showThemeWelcomeIfPending(context, widgetRef);
    await tester.pumpAndSettle();
    expect(find.text('Choose your look'), findsOneWidget);
    expect(c.read(themeWelcomeProvider), isFalse, reason: 'not shown again after a restart');

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    expect(c.read(themeModeProvider), ThemeMode.dark);

    await tester.tap(find.byTooltip('Green'));
    await tester.pumpAndSettle();
    expect(c.read(accentColorProvider).toARGB32(), accentColors['Green']!.toARGB32());

    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(find.text('Choose your look'), findsNothing);

    showThemeWelcomeIfPending(context, widgetRef);
    await tester.pumpAndSettle();
    expect(find.text('Choose your look'), findsNothing);
  });
}
