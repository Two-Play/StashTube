import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/locale.dart';
import '../../core/config/server_config.dart';
import '../../core/config/theme.dart';
import '../../data/providers.dart';
import '../player/player_providers.dart';
import '../security/app_lock.dart';
import '../auth/server_switcher.dart';
import '../security/app_icon.dart';
import '../security/app_lock_gate.dart';
import '../shell/nav_bar_config.dart';
import '../shell/navigation.dart';
import 'nav_bar_settings_page.dart';
import '../../l10n/l10n.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(serverConfigProvider);
    final profiles = ref.watch(serverProfilesProvider).profiles;
    final server = ref.watch(serverProfilesProvider).active;
    final version = ref.watch(serverVersionProvider);
    final themeMode = ref.watch(themeModeProvider);
    final preferredStream = ref.watch(preferredStreamProvider);
    final accent = ref.watch(accentColorProvider);
    final theme = Theme.of(context);
    final l = context.l10n;
    final locale = ref.watch(appLocaleProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.settingsTitle)),
      body: ListView(
        children: [
          _SectionTitle(l.sectionServer),
          ListTile(
            leading: const Icon(Icons.dns_outlined),
            title: Text(server?.name ?? '-', maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text(
              '${config?.baseUrl ?? ''}\n${switch (version) {
                AsyncData(:final value) => l.stashVersion(value ?? l.unknownVersion),
                AsyncError() => l.notReachable,
                _ => l.checking,
              }}',
            ),
            isThreeLine: true,
          ),
          ListTile(
            leading: const Icon(Icons.swap_horiz),
            title: Text(l.switchServer),
            subtitle: Text(l.savedServersCount(profiles.length)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showServerSwitcher(context),
          ),
          ListTile(
            leading: const Icon(Icons.key_outlined),
            title: Text(l.apiKey),
            subtitle: Text(config?.apiKey == null ? l.notSet : l.isSet),
          ),
          _SectionTitle(l.sectionAppearance),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SegmentedButton<ThemeMode>(
              segments: [
                ButtonSegment(
                  value: ThemeMode.light,
                  label: Text(l.themeLight),
                  icon: const Icon(Icons.light_mode_outlined),
                ),
                ButtonSegment(
                  value: ThemeMode.system,
                  label: Text(l.themeSystem),
                  icon: const Icon(Icons.brightness_auto_outlined),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  label: Text(l.themeDark),
                  icon: const Icon(Icons.dark_mode_outlined),
                ),
              ],
              selected: {themeMode},
              onSelectionChanged: (s) => ref.read(themeModeProvider.notifier).set(s.first),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(l.accentColor, style: theme.textTheme.bodyLarge),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                for (final MapEntry(key: name, value: color) in accentColors.entries)
                  _AccentSwatch(
                    name: accentColorName(l, name),
                    color: color,
                    selected: color.toARGB32() == accent.toARGB32(),
                    onTap: () => ref.read(accentColorProvider.notifier).set(color),
                  ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.space_dashboard_outlined),
            title: Text(l.navBarTitle),
            subtitle: Text(ref.watch(navBarConfigProvider).visible.map((t) => t.label(context.l10n)).join(' · ')),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => openPage(ref, const NavBarSettingsPage()),
          ),
          ListTile(
            leading: const Icon(Icons.translate),
            title: Text(l.language),
            trailing: DropdownButton<String>(
              value: locale?.languageCode ?? '',
              underline: const SizedBox.shrink(),
              items: [
                DropdownMenuItem(value: '', child: Text(l.languageSystem)),
                // Each language in its own name, so it can be found in either.
                const DropdownMenuItem(value: 'de', child: Text('Deutsch')),
                const DropdownMenuItem(value: 'en', child: Text('English')),
              ],
              onChanged: (code) =>
                  ref.read(appLocaleProvider.notifier).set(code == null || code.isEmpty ? null : Locale(code)),
            ),
          ),
          _SectionTitle(l.sectionPlayback),
          ListTile(
            leading: const Icon(Icons.high_quality_outlined),
            title: Text(l.preferredQuality),
            subtitle: Text(preferredStream ?? l.preferredQualityDefault),
            trailing: preferredStream == null
                ? null
                : TextButton(
                    onPressed: () => ref.read(preferredStreamProvider.notifier).set(null),
                    child: Text(l.reset),
                  ),
          ),
          _SectionTitle(l.sectionPrivacy),
          const _SecuritySettings(),
          const SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.logout, color: theme.colorScheme.error),
            title: Text(l.removeThisServer, style: TextStyle(color: theme.colorScheme.error)),
            onTap: () async {
              if (server == null || !await confirmRemoveServer(context, server)) return;
              ref.read(nowPlayingProvider.notifier).close();
              await ref.read(serverProfilesProvider.notifier).remove(server.id);
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

  static Map<Duration, String> _delays(AppLocalizations l) => {
    Duration.zero: l.lockImmediately,
    for (final minutes in const [1, 5, 15]) Duration(minutes: minutes): l.lockAfterMinutes(minutes),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appLockSettingsProvider);
    final notifier = ref.read(appLockSettingsProvider.notifier);
    final biometricsAvailable = ref.watch(_biometricsAvailableProvider).value ?? false;
    final l = context.l10n;
    final delays = _delays(l);

    return Column(
      children: [
        SwitchListTile(
          secondary: const Icon(Icons.lock_outline),
          title: Text(l.appLock),
          subtitle: Text(l.appLockSubtitle),
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
              title: Text(l.unlockBiometric),
              value: settings.biometrics,
              onChanged: notifier.setBiometrics,
            ),
          ListTile(
            leading: const Icon(Icons.timer_outlined),
            title: Text(l.lockNow),
            trailing: DropdownButton<Duration>(
              value: delays.containsKey(settings.lockAfter) ? settings.lockAfter : Duration.zero,
              underline: const SizedBox.shrink(),
              items: [
                for (final MapEntry(:key, :value) in delays.entries) DropdownMenuItem(value: key, child: Text(value)),
              ],
              onChanged: (v) {
                if (v != null) notifier.setLockAfter(v);
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.pin_outlined),
            title: Text(l.changePin),
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
          title: Text(l.hideInSwitcher),
          subtitle: Text(l.hideInSwitcherSubtitle),
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
      title: Text(context.l10n.appIcon),
      subtitle: Text(current.label(context.l10n)),
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
                Text(context.l10n.appIcon, style: Theme.of(sheetContext).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(context.l10n.appIconHint, style: Theme.of(sheetContext).textTheme.bodySmall),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (final choice in AppIconChoice.values)
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () async {
                          final messenger = ScaffoldMessenger.of(context);
                          final l = context.l10n;
                          Navigator.pop(sheetContext);
                          try {
                            await ref.read(appIconProvider.notifier).set(choice);
                          } catch (e) {
                            messenger.showSnackBar(SnackBar(content: Text(l.appIconFailed(errorText(l, e)))));
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
                              Text(choice.label(context.l10n)),
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

final _biometricsAvailableProvider = FutureProvider.autoDispose<bool>(
  (ref) => ref.watch(biometricAuthProvider).isAvailable(),
);

class _AccentSwatch extends StatelessWidget {
  const _AccentSwatch({required this.name, required this.color, required this.selected, required this.onTap});

  final String name;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Shown as it will look in the current light/dark mode.
    final shown = AppTheme.accentFor(color, Theme.of(context).brightness);
    return Tooltip(
      message: name,
      child: Semantics(
        label: context.l10n.accentColorLabel(name),
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
              color: shown,
              shape: BoxShape.circle,
              border: selected ? Border.all(color: Theme.of(context).colorScheme.onSurface, width: 3) : null,
            ),
            child: selected ? Icon(Icons.check, color: readableOn(shown)) : null,
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

/// Display name of an entry of [accentColors].
String accentColorName(AppLocalizations l, String name) => switch (name) {
  'Red' => l.colorRed,
  'Pink' => l.colorPink,
  'Purple' => l.colorPurple,
  'Indigo' => l.colorIndigo,
  'Blue' => l.colorBlue,
  'Teal' => l.colorTeal,
  'Green' => l.colorGreen,
  'Orange' => l.colorOrange,
  'Amber' => l.colorAmber,
  _ => name,
};
