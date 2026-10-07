import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/l10n.dart';
import '../settings/settings_page.dart';
import 'app_shell.dart';
import 'nav_bar_config.dart';
import 'navigation.dart';

/// Every view of the app, opened from the middle of the navigation bar
/// (13.10). A view that is a tab of the bar switches to that tab; any
/// other opens in the current tab.
Future<void> showAllViews(BuildContext context) => showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => const AllViewsSheet(),
    );

class AllViewsSheet extends ConsumerWidget {
  const AllViewsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final config = ref.watch(navBarConfigProvider);
    final current = ref.watch(currentTabProvider);

    void open(VoidCallback action) {
      HapticFeedback.selectionClick();
      Navigator.pop(context);
      action();
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 12),
              child: Text(l.allViews, style: Theme.of(context).textTheme.titleMedium),
            ),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 0.95,
              children: [
                for (final tab in AppTab.values)
                  _ViewTile(
                    icon: tab == current ? tab.selectedIcon : tab.icon,
                    label: tab.label(l),
                    selected: tab == current,
                    onTap: () => open(() {
                      if (config.isVisible(tab)) {
                        ref.read(currentTabProvider.notifier).select(tab);
                      } else {
                        openPage(ref, AppShell.rootPage(tab));
                      }
                    }),
                  ),
                _ViewTile(
                  icon: Icons.settings_outlined,
                  label: l.settingsTitle,
                  onTap: () => open(() => openPage(ref, const SettingsPage())),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewTile extends StatelessWidget {
  const _ViewTile({required this.icon, required this.label, required this.onTap, this.selected = false});

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: selected ? colors.secondaryContainer : colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: selected ? colors.onSecondaryContainer : colors.onSurfaceVariant),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
