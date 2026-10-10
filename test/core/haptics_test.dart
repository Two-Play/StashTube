import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/haptics.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late List<String?> played;

  setUp(() {
    played = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'HapticFeedback.vibrate') played.add(call.arguments as String?);
        return null;
      },
    );
  });
  tearDown(() => Haptics.level = HapticLevel.normal);

  void everything() {
    Haptics.selection();
    Haptics.light();
    Haptics.medium();
    Haptics.heavy();
  }

  test('normal plays as named, light one step softer, off nothing', () {
    Haptics.level = HapticLevel.normal;
    everything();
    expect(played, [
      'HapticFeedbackType.selectionClick',
      'HapticFeedbackType.lightImpact',
      'HapticFeedbackType.mediumImpact',
      'HapticFeedbackType.heavyImpact',
    ]);

    played.clear();
    Haptics.level = HapticLevel.light;
    everything();
    expect(played, [
      'HapticFeedbackType.selectionClick',
      'HapticFeedbackType.selectionClick',
      'HapticFeedbackType.lightImpact',
      'HapticFeedbackType.mediumImpact',
    ]);

    played.clear();
    Haptics.level = HapticLevel.off;
    everything();
    Haptics.error();
    expect(played, isEmpty);
  });

  test('the setting is stored and applied', () async {
    SharedPreferences.setMockInitialValues({'haptics': 'light'});
    final prefs = await SharedPreferences.getInstance();
    final c = ProviderContainer(overrides: [sharedPreferencesProvider.overrideWithValue(prefs)]);
    addTearDown(c.dispose);
    expect(c.read(hapticLevelProvider), HapticLevel.light);
    expect(Haptics.level, HapticLevel.light);

    await c.read(hapticLevelProvider.notifier).set(HapticLevel.off);
    expect(Haptics.level, HapticLevel.off);
    expect(prefs.getString('haptics'), 'off');
  });
}
