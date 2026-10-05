import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/server_config.dart';
import '../../core/config/theme.dart';
import '../../data/providers.dart';
import '../player/player_providers.dart';
import '../security/app_lock.dart';
import '../security/app_icon.dart';
import '../security/app_lock_gate.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(serverConfigProvider);
    final version = ref.watch(serverVersionProvider);
    final themeMode = ref.watch(themeModeProvider);
    final preferredStream = ref.watch(preferredStreamProvider);
    final accent = ref.watch(accentColorProvider);
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text('Accent color', style: theme.textTheme.bodyLarge),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                for (final MapEntry(key: name, value: color) in accentColors.entries)
                  _AccentSwatch(
                    name: name,
                    color: color,
                    selected: color.toARGB32() == accent.toARGB32(),
                    onTap: () => ref.read(accentColorProvider.notifier).set(color),
                  ),
              ],
            ),
          ),
          const _SectionTitle('Playback'),
          ListTile(
            leading: const Icon(Icons.high_quality_outlined),
            title: const Text('Preferred quality'),
            subtitle: Text(preferredStream ?? 'Original file – change it via ⚙ in the player'),
            trailing: preferredStream == null
                ? null
                : TextButton(
                    onPressed: () => ref.read(preferredStreamProvider.notifier).set(null),
                    child: const Text('Reset'),
                  ),
          ),
          const _SectionTitle('Privacy & security'),
          const _SecuritySettings(),
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

/// App lock (11.1) and app switcher privacy (11.2).
class _SecuritySettings extends ConsumerWidget {
  const _SecuritySettings();

  static final _delays = {
    Duration.zero: 'Immediately',
    const Duration(minutes: 1): 'After 1 minute',
    const Duration(minutes: 5): 'After 5 minutes',
    const Duration(minutes: 15): 'After 15 minutes',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appLockSettingsProvider);
    final notifier = ref.read(appLockSettingsProvider.notifier);
    final biometricsAvailable = ref.watch(_biometricsAvailableProvider).value ?? false;

    return Column(
      children: [
        SwitchListTile(
          secondary: const Icon(Icons.lock_outline),
          title: const Text('App lock'),
          subtitle: const Text('Ask for a PIN when opening the app'),
          value: settings.enabled,
          onChanged: (on) async {
            if (on) {
              final pin = await showCreatePin(context);
              if (pin != null) await notifier.enable(pin);
            } else if (await confirmPin(context, ref)) {
              await notifier.disable();
            }
          },
        ),
        if (settings.enabled) ...[
          if (biometricsAvailable)
            SwitchListTile(
              secondary: const Icon(Icons.fingerprint),
              title: const Text('Unlock with Face ID / fingerprint'),
              value: settings.biometrics,
              onChanged: notifier.setBiometrics,
            ),
          ListTile(
            leading: const Icon(Icons.timer_outlined),
            title: const Text('Lock'),
            trailing: DropdownButton<Duration>(
              value: _delays.containsKey(settings.lockAfter) ? settings.lockAfter : Duration.zero,
              underline: const SizedBox.shrink(),
              items: [
                for (final MapEntry(:key, :value) in _delays.entries) DropdownMenuItem(value: key, child: Text(value)),
              ],
              onChanged: (v) {
                if (v != null) notifier.setLockAfter(v);
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.pin_outlined),
            title: const Text('Change PIN'),
            onTap: () async {
              if (!await confirmPin(context, ref)) return;
              if (!context.mounted) return;
              final pin = await showCreatePin(context);
              if (pin != null) await notifier.enable(pin);
            },
          ),
        ],
        const _AppIconTile(),
        SwitchListTile(
          secondary: const Icon(Icons.visibility_off_outlined),
          title: const Text('Hide in app switcher'),
          subtitle: const Text('Covers the app in the recent apps view. On Android this also blocks screenshots.'),
          value: settings.hideInSwitcher,
          onChanged: notifier.setHideInSwitcher,
        ),
      ],
    );
  }
}

/// Disguised launcher icon (11.3).
class _AppIconTile extends ConsumerWidget {
  const _AppIconTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(appIconProvider);
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.asset(current.preview, width: 28, height: 28),
      ),
      title: const Text('App icon'),
      subtitle: Text(current.label),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => showModalBottomSheet<void>(
        context: context,
        useRootNavigator: true,
        showDragHandle: true,
        builder: (sheetContext) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('App icon', style: Theme.of(sheetContext).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  'On Android the name on the home screen changes too and the launcher may need a moment. '
                  'On iOS only the icon changes and the system shows a confirmation.',
                  style: Theme.of(sheetContext).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (final choice in AppIconChoice.values)
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () async {
                          final messenger = ScaffoldMessenger.of(context);
                          Navigator.pop(sheetContext);
                          try {
                            await ref.read(appIconProvider.notifier).set(choice);
                          } catch (e) {
                            messenger.showSnackBar(SnackBar(content: Text('Couldn\'t change the icon: $e')));
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: choice == current
                                        ? Theme.of(sheetContext).colorScheme.primary
                                        : Colors.transparent,
                                    width: 3,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(13),
                                  child: Image.asset(choice.preview, width: 64, height: 64),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(choice.label),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final _biometricsAvailableProvider =
    FutureProvider.autoDispose<bool>((ref) => ref.watch(biometricAuthProvider).isAvailable());

class _AccentSwatch extends StatelessWidget {
  const _AccentSwatch({required this.name, required this.color, required this.selected, required this.onTap});

  final String name;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final onColor = ThemeData.estimateBrightnessForColor(color) == Brightness.dark ? Colors.white : Colors.black;
    return Tooltip(
      message: name,
      child: Semantics(
        label: '$name accent color',
        selected: selected,
        button: true,
        child: InkResponse(
          onTap: onTap,
          radius: 26,
          child: Container(
            width: 44,
            height: 44,
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: selected ? Border.all(color: Theme.of(context).colorScheme.onSurface, width: 3) : null,
            ),
            child: selected ? Icon(Icons.check, color: onColor) : null,
          ),
        ),
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
