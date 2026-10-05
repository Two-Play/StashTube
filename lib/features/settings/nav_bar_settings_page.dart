import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shell/nav_bar_config.dart';
import '../shell/navigation.dart';

/// Choose and order the tabs of the bottom navigation bar (13.7). Changes
/// apply right away, so the bar below shows the result.
class NavBarSettingsPage extends ConsumerWidget {
  const NavBarSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(navBarConfigProvider);
    final notifier = ref.read(navBarConfigProvider.notifier);
    final theme = Theme.of(context);

    String? subtitle(AppTab tab) {
      if (tab == AppTab.settings) return 'Always shown';
      if (!config.canToggle(tab)) {
        return config.isVisible(tab) ? 'At least ${NavBarConfig.minVisible} tabs' : 'At most ${NavBarConfig.maxVisible} tabs';
      }
      return null;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation bar'),
        actions: [
          TextButton(
            onPressed: config == NavBarConfig.standard ? null : notifier.reset,
            child: const Text('Reset'),
          ),
        ],
      ),
      body: ReorderableListView(
        buildDefaultDragHandles: false,
        header: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text(
            'Choose up to ${NavBarConfig.maxVisible} tabs and drag them into order. '
            'The first tab opens when the app starts.',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
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
                  Flexible(child: Text(tab.label, maxLines: 1, overflow: TextOverflow.ellipsis)),
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
