import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shell/nav_bar_config.dart';
import '../shell/navigation.dart';
import '../../l10n/l10n.dart';

/// Choose and order the tabs of the bottom navigation bar (13.7). Changes
/// apply right away, so the bar below shows the result.
class NavBarSettingsPage extends ConsumerWidget {
  const NavBarSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(navBarConfigProvider);
    final notifier = ref.read(navBarConfigProvider.notifier);
    final theme = Theme.of(context);
    final l = context.l10n;

    // A full bar is explained once by the count in the header.
    String? subtitle(AppTab tab) => switch (tab) {
          NavBarConfig.alwaysShown => l.navBarAlwaysShown,
          _ when config.isVisible(tab) && !config.canToggle(tab) => l.navBarAtLeast(NavBarConfig.minVisible),
          _ => null,
        };

    return Scaffold(
      appBar: AppBar(
        title: Text(l.navBarTitle),
        actions: [
          TextButton(
            onPressed: config == NavBarConfig.standard ? null : notifier.reset,
            child: Text(l.reset),
          ),
        ],
      ),
      body: ReorderableListView(
        buildDefaultDragHandles: false,
        header: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.navBarIntro(NavBarConfig.maxVisible),
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 8),
              Text(
                l.navBarCount(config.visible.length, NavBarConfig.maxVisible),
                style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary),
              ),
            ],
          ),
        ),
        onReorderItem: notifier.move,
        children: [
          for (final (i, tab) in config.order.indexed)
            CheckboxListTile(
              key: ValueKey(tab),
              value: config.isVisible(tab),
              onChanged: config.canToggle(tab) ? (_) => notifier.toggle(tab) : null,
              controlAffinity: ListTileControlAffinity.leading,
              secondary: ReorderableDragStartListener(
                index: i,
                child: const Padding(padding: EdgeInsets.all(8), child: Icon(Icons.drag_handle)),
              ),
              title: Row(
                children: [
                  Icon(tab.icon, size: 20),
                  const SizedBox(width: 12),
                  Flexible(child: Text(tab.title(l), maxLines: 1, overflow: TextOverflow.ellipsis)),
                ],
              ),
              subtitle: switch (subtitle(tab)) {
                final text? => Text(text),
                null => null,
              },
            ),
        ],
      ),
    );
  }
}
