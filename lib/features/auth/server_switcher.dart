import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/server_config.dart';
import 'login_page.dart';

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
        title: Text('Remove "${server.name}"?'),
        content: const Text('Its URL and API key, watch later list and search history are removed from this device.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Remove')),
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
            child: Text('Servers', style: theme.textTheme.titleMedium),
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
                      tooltip: 'Server options',
                      onSelected: (action) async {
                        if (action == 'rename') {
                          await _rename(context, ref, server);
                        } else if (action == 'remove' && await confirmRemoveServer(context, server)) {
                          await ref.read(serverProfilesProvider.notifier).remove(server.id);
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'rename', child: Text('Rename')),
                        PopupMenuItem(value: 'remove', child: Text('Remove')),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add server'),
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
        title: const Text('Rename server'),
        content: TextField(controller: _controller, autofocus: true, decoration: const InputDecoration(labelText: 'Name')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, _controller.text), child: const Text('Save')),
        ],
      );
}
