import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/server_config.dart';
import '../../l10n/l10n.dart';
import 'appearance_picker.dart';

/// Whether the theme picker is still to be shown: set when the first server
/// is added (the first login), cleared once it was shown. Stored, so it
/// still shows when the app was closed in between.
class ThemeWelcomeNotifier extends Notifier<bool> {
  static const _key = 'theme_welcome_pending';

  @override
  bool build() => ref.watch(sharedPreferencesProvider).getBool(_key) ?? false;

  Future<void> request() async {
    state = true;
    await ref.read(sharedPreferencesProvider).setBool(_key, true);
  }

  Future<void> done() async {
    state = false;
    await ref.read(sharedPreferencesProvider).remove(_key);
  }
}

final themeWelcomeProvider = NotifierProvider<ThemeWelcomeNotifier, bool>(ThemeWelcomeNotifier.new);

/// Shows the theme picker once if it is pending; call after a frame.
Future<void> showThemeWelcomeIfPending(BuildContext context, WidgetRef ref) async {
  if (!ref.read(themeWelcomeProvider)) return;
  await ref.read(themeWelcomeProvider.notifier).done();
  if (!context.mounted) return;
  await showDialog<void>(context: context, builder: (_) => const ThemeWelcomeDialog());
}

/// "Choose your look": light, system or dark and the accent color, applied
/// live behind and in the dialog.
class ThemeWelcomeDialog extends StatelessWidget {
  const ThemeWelcomeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return AlertDialog(
      // The app icon (tool/generate_app_icon.py); centered, as the dialog
      // stretches its icon across the width.
      icon: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset('assets/icons/stashtube.png', width: 64, height: 64),
        ),
      ),
      title: Text(l.themeWelcomeTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l.themeWelcomeText,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 20),
            const FittedBox(child: ThemeModeSelector()),
            const SizedBox(height: 16),
            Text(l.accentColor, style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            const AccentColorPicker(alignment: WrapAlignment.center),
          ],
        ),
      ),
      actions: [FilledButton(onPressed: () => Navigator.of(context).pop(), child: Text(l.done))],
    );
  }
}
