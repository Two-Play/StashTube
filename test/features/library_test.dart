import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/core/config/theme.dart';
import 'package:stash_app_mobile/data/models/stats.dart';
import 'package:stash_app_mobile/data/providers.dart';
import 'package:stash_app_mobile/features/library/stats_tab.dart';

void main() {
  Future<void> pumpStats(WidgetTester tester, {ActivityStats? activity}) => tester.pumpWidget(ProviderScope(
        overrides: [
          libraryStatsProvider.overrideWith((ref) async => const LibraryStats(
                sceneCount: 1234,
                scenesSize: 2 * 1024 * 1024 * 1024,
                scenesDuration: 36000,
                performerCount: 5,
              )),
          activityStatsProvider.overrideWith((ref) async => activity),
        ],
        child: const MaterialApp(home: Scaffold(body: StatsTab())),
      ));

  testWidgets('shows library totals and hides activity on older servers', (tester) async {
    await pumpStats(tester);
    await tester.pumpAndSettle();
    expect(find.text('1,234'), findsOneWidget);
    expect(find.text('2.0 GB • 10h 0m'), findsOneWidget);
    expect(find.text('Watching'), findsNothing);
  });

  testWidgets('shows activity when the server supports it', (tester) async {
    await pumpStats(tester, activity: const ActivityStats(playCount: 42, playDuration: 5400));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Watching'), 200);
    expect(find.text('42'), findsOneWidget);
    expect(find.text('1h 30m'), findsOneWidget);
  });

  test('accent color is persisted and drives the theme', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(overrides: [sharedPreferencesProvider.overrideWithValue(prefs)]);
    addTearDown(container.dispose);

    expect(container.read(accentColorProvider), accentColors['Red']);
    await container.read(accentColorProvider.notifier).set(accentColors['Amber']!);
    expect(prefs.getInt('accent_color'), accentColors['Amber']!.toARGB32());

    final theme = AppTheme.light(accentColors['Amber']!);
    // Amber is too light for a white page: darkened, same hue.
    expect(theme.colorScheme.primary, AppTheme.accentFor(accentColors['Amber']!, Brightness.light));
    expect(HSLColor.fromColor(theme.colorScheme.primary).hue,
        closeTo(HSLColor.fromColor(accentColors['Amber']!).hue, 1));
    // On the dark page it is used as is, with dark text on top.
    final dark = AppTheme.dark(accentColors['Amber']!).colorScheme;
    expect(dark.primary, accentColors['Amber']);
    expect(dark.onPrimary, Colors.black);
  });
}
