import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/server_config.dart';
import '../../core/config/theme.dart';
import '../../l10n/l10n.dart';
import '../../widgets/stash_image.dart';
import '../server_tasks/server_tasks_page.dart';
import '../settings/settings_button.dart';
import 'server_switcher.dart';

/// The active server's name, or its host while no profile is saved (tests).
String _serverName(WidgetRef ref) {
  final server = ref.watch(serverProfilesProvider).active;
  if (server != null) return server.name;
  final url = ref.watch(serverConfigProvider)?.baseUrl;
  return url == null ? '' : Uri.tryParse(url)?.host ?? url;
}

/// The active server as a round avatar with its initial (NAV-2), at the end
/// of the tab pages' app bars. Opens the account sheet: switch server,
/// server tasks and the settings.
class ServerAvatarButton extends ConsumerWidget {
  const ServerAvatarButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = _serverName(ref);
    return IconButton(
      tooltip: name,
      icon: ChannelAvatar(name: name, radius: 15),
      onPressed: () => showAccountSheet(context, ref),
    );
  }
}

/// The account sheet: the active server, switching servers, its tasks and
/// the settings. Each entry closes the sheet first and then opens from
/// [context] (the avatar's), which outlives the sheet.
Future<void> showAccountSheet(BuildContext context, WidgetRef ref) => showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        void then(void Function() action) {
          Navigator.pop(sheetContext);
          action();
        }

        return AccountSheet(
          onSwitchServer: () => then(() => showServerSwitcher(context)),
          onServerTasks: () => then(() => openSettings(context, ref, initialPage: const ServerTasksPage())),
          onSettings: () => then(() => openSettings(context, ref)),
        );
      },
    );

class AccountSheet extends ConsumerWidget {
  const AccountSheet({super.key, required this.onSwitchServer, required this.onServerTasks, required this.onSettings});

  final VoidCallback onSwitchServer;
  final VoidCallback onServerTasks;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final name = _serverName(ref);
    final url = ref.watch(serverConfigProvider)?.baseUrl;
    final count = ref.watch(serverProfilesProvider).profiles.length;
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              leading: ChannelAvatar(name: name, radius: 20),
              title: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: url == null ? null : Text(url, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
            const Divider(height: AppSpacing.l),
            ListTile(
              leading: const Icon(Icons.swap_horiz),
              title: Text(l.switchServer),
              subtitle: count > 0 ? Text(l.savedServersCount(count)) : null,
              onTap: onSwitchServer,
            ),
            ListTile(
              leading: const Icon(Icons.task_alt),
              title: Text(l.serverTasks),
              subtitle: Text(l.serverTasksSubtitle),
              onTap: onServerTasks,
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: Text(l.settingsTitle),
              onTap: onSettings,
            ),
          ],
        ),
      ),
    );
  }
}
