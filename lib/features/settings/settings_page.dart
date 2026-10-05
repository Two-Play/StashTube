import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/server_config.dart';
import '../../core/config/theme.dart';
import '../../data/providers.dart';
import '../player/player_providers.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(serverConfigProvider);
    final version = ref.watch(serverVersionProvider);
    final themeMode = ref.watch(themeModeProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _SectionTitle('Server'),
          ListTile(
            leading: const Icon(Icons.dns_outlined),
            title: Text(config?.baseUrl ?? '-'),
            subtitle: Text(switch (version) {
              AsyncData(:final value) => 'Stash ${value ?? 'unknown version'}',
              AsyncError() => 'Not reachable',
              _ => 'Checking…',
            }),
          ),
          ListTile(
            leading: const Icon(Icons.key_outlined),
            title: const Text('API key'),
            subtitle: Text(config?.apiKey == null ? 'Not set' : 'Set'),
          ),
          const _SectionTitle('Appearance'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(value: ThemeMode.light, label: Text('Light'), icon: Icon(Icons.light_mode_outlined)),
                ButtonSegment(value: ThemeMode.system, label: Text('System'), icon: Icon(Icons.brightness_auto_outlined)),
                ButtonSegment(value: ThemeMode.dark, label: Text('Dark'), icon: Icon(Icons.dark_mode_outlined)),
              ],
              selected: {themeMode},
              onSelectionChanged: (s) => ref.read(themeModeProvider.notifier).set(s.first),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.logout, color: theme.colorScheme.error),
            title: Text('Disconnect from server', style: TextStyle(color: theme.colorScheme.error)),
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Disconnect?'),
                  content: const Text('The server URL and API key will be removed from this device.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                    FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Disconnect')),
                  ],
                ),
              );
              if (confirmed != true) return;
              ref.read(nowPlayingProvider.notifier).close();
              await ref.read(serverConfigProvider.notifier).clear();
            },
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
        child: Text(
          text,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.primary),
        ),
      );
}
