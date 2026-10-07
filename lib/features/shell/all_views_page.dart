import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/l10n.dart';
import '../settings/settings_page.dart';
import 'app_shell.dart';
import 'nav_bar_config.dart';
import 'navigation.dart';

/// The views that aren't in the navigation bar, plus the settings (13.10):
/// the root page of the "all" tab, which is always last in the bar. A view
/// picked here opens inside this tab, so the tab stays selected;
/// re-selecting the tab comes back here.
class AllViewsPage extends ConsumerWidget {
  const AllViewsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final config = ref.watch(navBarConfigProvider);

    void open(Widget page) {
      HapticFeedback.selectionClick();
      openPage(ref, page);
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.allViews)),
      body: GridView.count(
        padding: const EdgeInsets.all(12),
        crossAxisCount: 4,
        childAspectRatio: 0.95,
        children: [
          for (final tab in AppTab.values)
            if (!config.isVisible(tab))
              _ViewTile(icon: tab.icon, label: tab.label(l), onTap: () => open(AppShell.rootPage(tab))),
          _ViewTile(icon: Icons.settings_outlined, label: l.settingsTitle, onTap: () => open(const SettingsPage())),
        ],
      ),
    );
  }
}

class _ViewTile extends StatelessWidget {
  const _ViewTile({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

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
              color: colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: colors.onSurfaceVariant),
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
