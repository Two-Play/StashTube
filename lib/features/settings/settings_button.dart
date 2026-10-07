import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/l10n.dart';
import 'settings_page.dart';

/// Gear in the app bars of the tab pages; opens the settings sheet.
class SettingsButton extends ConsumerWidget {
  const SettingsButton({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) => IconButton(
        tooltip: context.l10n.settingsTitle,
        color: color,
        icon: const Icon(Icons.settings_outlined),
        onPressed: () => openSettings(context, ref),
      );
}

/// Opens the settings as a sheet over the whole app, closed with its X or
/// by swiping it down (on Android too). Its sub-pages open inside the sheet.
Future<void> openSettings(BuildContext context, WidgetRef ref) async {
  final open = ref.read(settingsOpenProvider.notifier);
  open.set(true);
  try {
    await showCupertinoSheet<void>(
      context: context,
      useNestedNavigation: true,
      scrollableBuilder: (_, controller) => SettingsPage(scrollController: controller),
    );
  } finally {
    open.set(false);
  }
}

/// Whether the settings sheet covers the app, e.g. so the shorts pause.
class SettingsOpenNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool open) => state = open;
}

final settingsOpenProvider = NotifierProvider<SettingsOpenNotifier, bool>(SettingsOpenNotifier.new);
