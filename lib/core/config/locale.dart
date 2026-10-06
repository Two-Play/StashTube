import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'server_config.dart';

/// The app language chosen in the settings (13.3); null follows the device.
class AppLocaleNotifier extends Notifier<Locale?> {
  static const _key = 'locale';

  /// Languages the app has texts for.
  static const supported = [Locale('en'), Locale('de')];

  @override
  Locale? build() {
    final code = ref.watch(sharedPreferencesProvider).getString(_key);
    return supported.where((l) => l.languageCode == code).firstOrNull;
  }

  Future<void> set(Locale? locale) async {
    state = locale;
    final prefs = ref.read(sharedPreferencesProvider);
    if (locale == null) {
      await prefs.remove(_key);
    } else {
      await prefs.setString(_key, locale.languageCode);
    }
  }
}

final appLocaleProvider = NotifierProvider<AppLocaleNotifier, Locale?>(AppLocaleNotifier.new);
