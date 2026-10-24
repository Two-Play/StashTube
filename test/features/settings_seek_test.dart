import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/features/player/seek_settings.dart';
import 'package:stash_app_mobile/features/settings/settings_categories.dart';

void main() {
  late SharedPreferences prefs;

  Future<ProviderContainer> container([Map<String, Object> stored = const {}]) async {
    SharedPreferences.setMockInitialValues(stored);
    prefs = await SharedPreferences.getInstance();
    final c = ProviderContainer(overrides: [sharedPreferencesProvider.overrideWithValue(prefs)]);
    addTearDown(c.dispose);
    return c;
  }

  test('defaults: on, 5 s, cumulative', () async {
    final c = await container();
    expect(c.read(seekSettingsProvider), const SeekSettings());
    expect(c.read(seekSettingsProvider).step, const Duration(seconds: 5));
  });

  test('the settings persist for the device', () async {
    final c = await container();
    final notifier = c.read(seekSettingsProvider.notifier);
    await notifier.setStep(const Duration(seconds: 15));
    await notifier.setCumulative(false);
    await notifier.setEnabled(false);
    expect(c.read(seekSettingsProvider),
        const SeekSettings(enabled: false, step: Duration(seconds: 15), cumulative: false));

    // A restart reads them back.
    final again = ProviderContainer(overrides: [sharedPreferencesProvider.overrideWithValue(prefs)]);
    addTearDown(again.dispose);
    expect(again.read(seekSettingsProvider),
        const SeekSettings(enabled: false, step: Duration(seconds: 15), cumulative: false));
  });

  testWidgets('the playback settings change them', (tester) async {
    final c = await container();
    await tester.pumpWidget(UncontrolledProviderScope(
      container: c,
      child: const MaterialApp(home: PlaybackSettingsPage()),
    ));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Keep tapping to skip further'), 100);
    expect(find.text('Double-tap to seek'), findsOneWidget);
    expect(find.text('In total: 5, 10, 20, 30 s …'), findsOneWidget);

    await tester.tap(find.text('5 s'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('10 s').last);
    await tester.pumpAndSettle();
    expect(c.read(seekSettingsProvider).step, const Duration(seconds: 10));
    expect(find.text('In total: 10, 20, 40, 60 s …'), findsOneWidget);

    await tester.tap(find.text('Keep tapping to skip further'));
    await tester.pumpAndSettle();
    expect(c.read(seekSettingsProvider).cumulative, isFalse);
    expect(find.text('In total: 10, 20, 30, 40 s …'), findsOneWidget);

    await tester.tap(find.text('Double-tap seeking'));
    await tester.pumpAndSettle();
    expect(c.read(seekSettingsProvider).enabled, isFalse);
    expect(prefs.getBool('seek_double_tap'), isFalse);
    // The step and the mode are disabled with it.
    await tester.tap(find.text('Keep tapping to skip further'));
    await tester.pumpAndSettle();
    expect(c.read(seekSettingsProvider).cumulative, isFalse);
  });
}
