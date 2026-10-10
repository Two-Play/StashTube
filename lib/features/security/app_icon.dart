import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/server_config.dart';
import '../../l10n/gen/app_localizations.dart';

/// Launcher icons (11.3). On Android the name changes too; iOS can only
/// change the icon (and shows a system confirmation).
enum AppIconChoice {
  stash('DefaultIcon', null, 'assets/icons/stashy.png'),
  notes('NotesIcon', 'AppIcon-Notes', 'assets/icons/notes.png'),
  calculator('CalculatorIcon', 'AppIcon-Calculator', 'assets/icons/calculator.png');

  const AppIconChoice(this.androidAlias, this.iosIconName, this.preview);

  /// Matches the alias's label on Android (`@string/` resources).
  String label(AppLocalizations l) => switch (this) {
        stash => l.appIconStash,
        notes => l.appIconNotes,
        calculator => l.appIconCalculator,
      };

  /// activity-alias name in AndroidManifest.xml.
  final String androidAlias;

  /// Alternate icon set in Assets.xcassets; null = the regular icon.
  final String? iosIconName;
  final String preview;
}

/// Switches the launcher icon natively; abstracted for tests.
abstract interface class AppIconSwitcher {
  Future<void> apply(AppIconChoice choice);
}

class PlatformAppIconSwitcher implements AppIconSwitcher {
  static const _channel = MethodChannel('stash/appicon');

  @override
  Future<void> apply(AppIconChoice choice) async {
    final argument = switch (defaultTargetPlatform) {
      TargetPlatform.android => choice.androidAlias,
      TargetPlatform.iOS => choice.iosIconName,
      _ => throw UnsupportedError('Changing the app icon is only supported on Android and iOS'),
    };
    await _channel.invokeMethod<void>('setIcon', argument);
  }
}

final appIconSwitcherProvider = Provider<AppIconSwitcher>((ref) => PlatformAppIconSwitcher());

class AppIconNotifier extends Notifier<AppIconChoice> {
  static const _key = 'app_icon';

  @override
  AppIconChoice build() {
    final name = ref.watch(sharedPreferencesProvider).getString(_key);
    return AppIconChoice.values.firstWhere((c) => c.name == name, orElse: () => AppIconChoice.stash);
  }

  /// Applies [choice]; throws (and keeps the old icon) if the platform refuses.
  Future<void> set(AppIconChoice choice) async {
    if (choice == state) return;
    await ref.read(appIconSwitcherProvider).apply(choice);
    await ref.read(sharedPreferencesProvider).setString(_key, choice.name);
    state = choice;
  }
}

final appIconProvider = NotifierProvider<AppIconNotifier, AppIconChoice>(AppIconNotifier.new);
