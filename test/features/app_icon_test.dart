import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/features/security/app_icon.dart';

class FakeSwitcher implements AppIconSwitcher {
  final applied = <AppIconChoice>[];
  bool fail = false;

  @override
  Future<void> apply(AppIconChoice choice) async {
    if (fail) throw PlatformException(code: 'failed', message: 'not allowed');
    applied.add(choice);
  }
}

void main() {
  late SharedPreferences prefs;
  late FakeSwitcher switcher;
  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    switcher = FakeSwitcher();
    container = ProviderContainer(overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      appIconSwitcherProvider.overrideWithValue(switcher),
    ]);
  });
  tearDown(() => container.dispose());

  test('defaults to the regular icon', () {
    expect(container.read(appIconProvider), AppIconChoice.stash);
  });

  test('switching applies natively and is remembered', () async {
    await container.read(appIconProvider.notifier).set(AppIconChoice.notes);
    expect(switcher.applied, [AppIconChoice.notes]);
    expect(container.read(appIconProvider), AppIconChoice.notes);
    expect(prefs.getString('app_icon'), 'notes');

    // Choosing the current icon again does nothing.
    await container.read(appIconProvider.notifier).set(AppIconChoice.notes);
    expect(switcher.applied, hasLength(1));
  });

  test('a refused switch keeps the old icon', () async {
    switcher.fail = true;
    await expectLater(
      container.read(appIconProvider.notifier).set(AppIconChoice.calculator),
      throwsA(isA<PlatformException>()),
    );
    expect(container.read(appIconProvider), AppIconChoice.stash);
    expect(prefs.getString('app_icon'), isNull);
  });

  test('platform names match the native configuration', () {
    expect(AppIconChoice.values.map((c) => c.androidAlias), ['DefaultIcon', 'NotesIcon', 'CalculatorIcon']);
    expect(AppIconChoice.stash.iosIconName, isNull, reason: 'nil restores the regular icon on iOS');
    expect(AppIconChoice.notes.iosIconName, 'AppIcon-Notes');
  });
}
