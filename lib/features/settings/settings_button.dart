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
///
/// With [initialPage] that sub-page opens on top, as if picked in the
/// settings: back leads to the settings, the X or a swipe down closes it.
Future<void> openSettings(BuildContext context, WidgetRef ref, {Widget? initialPage}) async {
  final open = ref.read(settingsOpenProvider.notifier);
  open.set(true);
  try {
    await showCupertinoSheet<void>(
      context: context,
      useNestedNavigation: true,
      scrollableBuilder: (_, controller) {
        final settings = SettingsPage(scrollController: controller);
        return initialPage == null ? settings : _PushOnStart(page: initialPage, child: settings);
      },
    );
  } finally {
    open.set(false);
  }
}

/// Pushes [page] over [child] once it is shown.
class _PushOnStart extends StatefulWidget {
  const _PushOnStart({required this.page, required this.child});

  final Widget page;
  final Widget child;

  @override
  State<_PushOnStart> createState() => _PushOnStartState();
}

class _PushOnStartState extends State<_PushOnStart> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => widget.page));
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// Whether a sheet (the settings, an edit form) covers the app, e.g. so the
/// shorts pause.
class SettingsOpenNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool open) => state = open;
}

final settingsOpenProvider = NotifierProvider<SettingsOpenNotifier, bool>(SettingsOpenNotifier.new);
