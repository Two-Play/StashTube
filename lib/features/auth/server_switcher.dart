import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/server_config.dart';
import 'login_page.dart';
import '../../l10n/l10n.dart';

/// Sheet listing saved servers (2.6): switch, rename, remove, add.
Future<void> showServerSwitcher(BuildContext context) => showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => const ServerSwitcher(),
    );

Future<bool> confirmRemoveServer(BuildContext context, ServerProfile server) async =>
    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.removeServerTitle(server.name)),
        content: Text(context.l10n.removeServerBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(context.l10n.cancel)),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(context.l10n.remove)),
        ],
      ),
    ) ??
    false;

class ServerSwitcher extends ConsumerWidget {
  const ServerSwitcher({super.key});

  Future<void> _rename(BuildContext context, WidgetRef ref, ServerProfile server) async {
    final name = await showDialog<String>(context: context, builder: (_) => _RenameDialog(initial: server.name));
    if (name != null) await ref.read(serverProfilesProvider.notifier).rename(server.id, name);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(serverProfilesProvider);
    final theme = Theme.of(context);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(context.l10n.servers, style: theme.textTheme.titleMedium),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final server in state.profiles)
                  ListTile(
                    leading: Icon(
                      server.id == state.activeId ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                      color: server.id == state.activeId ? theme.colorScheme.primary : null,
                    ),
                    title: Text(server.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text(server.baseUrl, maxLines: 1, overflow: TextOverflow.ellipsis),
                    onTap: () {
                      Navigator.pop(context);
                      if (server.id != state.activeId) ref.read(serverProfilesProvider.notifier).activate(server.id);
                    },
                    trailing: PopupMenuButton<String>(
                      tooltip: context.l10n.serverOptions,
                      onSelected: (action) async {
                        if (action == 'rename') {
                          await _rename(context, ref, server);
                        } else if (action == 'remove' && await confirmRemoveServer(context, server)) {
                          await ref.read(serverProfilesProvider.notifier).remove(server.id);
                        }
                      },
                      itemBuilder: (_) => [
                        PopupMenuItem(value: 'rename', child: Text(context.l10n.rename)),
                        PopupMenuItem(value: 'remove', child: Text(context.l10n.remove)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.add),
            title: Text(context.l10n.addServer),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context, rootNavigator: true)
                  .push(MaterialPageRoute<void>(builder: (_) => const LoginPage(addServer: true)));
            },
          ),
        ],
      ),
    );
  }
}

class _RenameDialog extends StatefulWidget {
  const _RenameDialog({required this.initial});

  final String initial;

  @override
  State<_RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends State<_RenameDialog> {
  late final _controller = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(context.l10n.renameServer),
        content: TextField(controller: _controller, autofocus: true, decoration: InputDecoration(labelText: context.l10n.name)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(context.l10n.cancel)),
          FilledButton(onPressed: () => Navigator.pop(context, _controller.text), child: Text(context.l10n.save)),
        ],
      );
}
