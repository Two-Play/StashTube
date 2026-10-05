import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/locale.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/l10n/l10n.dart';

void main() {
  test('the chosen language is stored; null follows the device', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    ProviderContainer container() {
      final c = ProviderContainer(overrides: [sharedPreferencesProvider.overrideWithValue(prefs)]);
      addTearDown(c.dispose);
      return c;
    }

    final c = container();
    expect(c.read(appLocaleProvider), isNull);
    await c.read(appLocaleProvider.notifier).set(const Locale('de'));
    expect(container().read(appLocaleProvider), const Locale('de'));

    await c.read(appLocaleProvider.notifier).set(null);
    expect(container().read(appLocaleProvider), isNull);
  });

  test('both languages are supported', () {
    expect(AppLocalizations.supportedLocales.map((l) => l.languageCode), containsAll(['en', 'de']));
    expect(lookupAppLocalizations(const Locale('de')).scenesCount(1234), '1.234 Szenen');
    expect(lookupAppLocalizations(const Locale('en')).scenesCount(1), '1 scene');
  });
}
