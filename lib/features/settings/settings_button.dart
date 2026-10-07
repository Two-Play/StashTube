import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/l10n.dart';
import '../shell/navigation.dart';
import 'settings_page.dart';

/// Gear in the app bars of the tab pages; opens the settings in the
/// current tab (the settings are no longer a tab of their own).
class SettingsButton extends ConsumerWidget {
  const SettingsButton({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) => IconButton(
        tooltip: context.l10n.settingsTitle,
        color: color,
        icon: const Icon(Icons.settings_outlined),
        onPressed: () => openPage(ref, const SettingsPage()),
      );
}
