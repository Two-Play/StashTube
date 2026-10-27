import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/haptics.dart';
import '../../core/config/locale.dart';
import '../../core/config/server_config.dart';
import '../../core/pagination/paging_mode.dart';
import '../../data/models/scene_details.dart';
import '../../data/providers.dart';
import '../../l10n/l10n.dart';
import '../../widgets/animated_previews.dart';
import '../auth/server_switcher.dart';
import '../notifications/notifications.dart';
import '../pip/pip.dart';
import '../player/gesture_hints.dart';
import '../player/lock_screen.dart';
import '../player/player_providers.dart';
import '../player/seek_settings.dart';
import '../security/app_icon.dart';
import '../security/app_lock.dart';
import '../security/app_lock_gate.dart';
import '../server_tasks/server_tasks_page.dart';
import '../shell/nav_bar_config.dart';
import '../intro/intro_tour.dart';
import '../whats_new/whats_new.dart';
import 'about.dart';
import 'appearance_picker.dart';
import 'nav_bar_settings_page.dart';
import 'scene_card_config.dart';

/// The sub-pages of the settings (SET-1), pushed inside the settings sheet's
/// own navigator, so their app bars show a back button instead of the X.
class SettingsSubPage extends StatelessWidget {
  const SettingsSubPage({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: ListView(padding: const EdgeInsets.only(bottom: 16), children: children),
  );
}

/// A setting picked from a menu: the menu sits at the end of the tile, or
/// under the title when it would take more than half the row, e.g. with
/// large text (A11Y-3), where it would squeeze the title out.
class SettingsDropdownTile<T> extends StatelessWidget {
  const SettingsDropdownTile({
    super.key,
    required this.leading,
    required this.title,
    required this.dropdown,
    this.subtitle,
    this.enabled = true,
    this.isThreeLine = false,
  });

  final Widget leading;
  final Widget title;
  final Widget? subtitle;
  final DropdownButton<T> dropdown;
  final bool enabled;
  final bool isThreeLine;

  /// From this text scale on the menu always moves under the title.
  static const largeTextScale = 1.3;

  /// The menu's width from its widest text label, or null if an item isn't
  /// plain text.
  double? _menuWidth(BuildContext context) {
    final style = dropdown.style ?? Theme.of(context).textTheme.titleMedium;
    var widest = 0.0;
    for (final item in dropdown.items ?? <DropdownMenuItem<T>>[]) {
      final child = item.child;
      if (child is! Text || child.data == null) return null;
      final painter = TextPainter(
        text: TextSpan(text: child.data, style: style),
        textDirection: Directionality.of(context),
        textScaler: MediaQuery.textScalerOf(context),
      )..layout();
      if (painter.width > widest) widest = painter.width;
      painter.dispose();
    }
    return widest + dropdown.iconSize + 8;
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, constraints) {
        final scale = MediaQuery.textScalerOf(context).scale(10) / 10;
        final menuWidth = _menuWidth(context);
        final below = scale >= largeTextScale || (menuWidth != null && menuWidth > constraints.maxWidth / 2);
        if (!below) {
          return ListTile(
            leading: leading,
            title: title,
            subtitle: subtitle,
            enabled: enabled,
            isThreeLine: isThreeLine,
            trailing: dropdown,
          );
        }
        return ListTile(
          leading: leading,
          title: title,
          enabled: enabled,
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ?subtitle,
              DropdownButton<T>(
                value: dropdown.value,
                items: dropdown.items,
                onChanged: dropdown.onChanged,
                underline: dropdown.underline,
                isExpanded: true,
              ),
            ],
          ),
        );
      });
}

/// Inside the settings sheet.
void openServerTasks(BuildContext context) =>
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const ServerTasksPage()));

/// The active server: its address and access, switching, the server's
/// tasks and, last and set apart, removing it.
class ServerSettingsPage extends ConsumerWidget {
  const ServerSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(serverConfigProvider);
    final profiles = ref.watch(serverProfilesProvider).profiles;
    final server = ref.watch(serverProfilesProvider).active;
    final version = ref.watch(serverVersionProvider);
    final theme = Theme.of(context);
    final l = context.l10n;

    return SettingsSubPage(
      title: l.sectionServer,
      children: [
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
          trailing: const Icon(Icons.edit_outlined),
          onTap: server == null ? null : () => openServerEditor(context, server),
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
          title: Text(l.serverAccess),
          subtitle: Text(switch (config) {
            ServerConfig(apiKey: final key?) when key.isNotEmpty => '${l.apiKey}: ${l.isSet}',
            ServerConfig(hasCredentials: true, :final username?) => l.signedInAs(username),
            _ => l.notSet,
          }),
          trailing: const Icon(Icons.edit_outlined),
          onTap: server == null ? null : () => openServerEditor(context, server),
        ),
        ListTile(
          leading: const Icon(Icons.task_alt),
          title: Text(l.serverTasks),
          subtitle: Text(l.serverTasksSubtitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => openServerTasks(context),
        ),
        const SizedBox(height: 24),
        const Divider(),
        ListTile(
          leading: Icon(Icons.logout, color: theme.colorScheme.error),
          title: Text(l.removeThisServer, style: TextStyle(color: theme.colorScheme.error)),
          onTap: () async {
            if (server == null || !await confirmRemoveServer(context, server)) return;
            // The sheet sits on the root navigator, above the login page
            // that follows removing the last server.
            if (context.mounted) CupertinoSheetRoute.popSheet(context);
            ref.read(nowPlayingProvider.notifier).close();
            await ref.read(serverProfilesProvider.notifier).remove(server.id);
          },
        ),
      ],
    );
  }
}

class AppearanceSettingsPage extends ConsumerWidget {
  const AppearanceSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l = context.l10n;
    final locale = ref.watch(appLocaleProvider);

    return SettingsSubPage(
      title: l.sectionAppearance,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ThemeModeSelector(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Text(l.accentColor, style: theme.textTheme.bodyLarge),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: AccentColorPicker(),
        ),
        ListTile(
          leading: const Icon(Icons.space_dashboard_outlined),
          title: Text(l.navBarTitle),
          subtitle: Text(ref.watch(navBarConfigProvider).visible.map((t) => t.label(context.l10n)).join(' · ')),
          trailing: const Icon(Icons.chevron_right),
          // Inside the settings sheet.
          onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const NavBarSettingsPage())),
        ),
        SettingsDropdownTile(
          leading: const Icon(Icons.translate),
          title: Text(l.language),
          dropdown: DropdownButton<String>(
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
        SettingsDropdownTile(
          leading: const Icon(Icons.view_agenda_outlined),
          title: Text(l.listPaging),
          dropdown: DropdownButton<PagingMode>(
            value: ref.watch(pagingModeProvider),
            underline: const SizedBox.shrink(),
            items: [
              DropdownMenuItem(value: PagingMode.infinite, child: Text(l.pagingInfinite)),
              DropdownMenuItem(value: PagingMode.pages, child: Text(l.pagingPages)),
            ],
            onChanged: (mode) {
              if (mode != null) ref.read(pagingModeProvider.notifier).set(mode);
            },
          ),
        ),
        SettingsDropdownTile(
          leading: const Icon(Icons.vibration),
          title: Text(l.haptics),
          dropdown: DropdownButton<HapticLevel>(
            value: ref.watch(hapticLevelProvider),
            underline: const SizedBox.shrink(),
            items: [
              DropdownMenuItem(value: HapticLevel.off, child: Text(l.hapticsOff)),
              DropdownMenuItem(value: HapticLevel.light, child: Text(l.hapticsLight)),
              DropdownMenuItem(value: HapticLevel.normal, child: Text(l.hapticsNormal)),
            ],
            onChanged: (level) {
              if (level != null) ref.read(hapticLevelProvider.notifier).set(level);
            },
          ),
        ),
      ],
    );
  }
}

class PlaybackSettingsPage extends ConsumerWidget {
  const PlaybackSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SettingsSubPage(
    title: context.l10n.sectionPlayback,
    children: [
      _QualityTile(preferred: ref.watch(preferredStreamProvider)),
      const _PlaybackModeTiles(),
      // CTRL-2: disabled until the tips were dismissed again.
      ListTile(
        leading: const Icon(Icons.touch_app_outlined),
        title: Text(context.l10n.showGestureTipsAgain),
        subtitle: Text(context.l10n.showGestureTipsAgainSubtitle),
        enabled: ref.watch(gestureTipsSeenProvider),
        onTap: () {
          Haptics.light();
          ref.read(gestureTipsSeenProvider.notifier).reset();
        },
      ),
      const _SeekSettingsTiles(),
    ],
  );
}

/// "Double-tap to seek": on/off, the step and whether further taps grow
/// ([SeekSettings.total]).
class _SeekSettingsTiles extends ConsumerWidget {
  const _SeekSettingsTiles();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final seek = ref.watch(seekSettingsProvider);
    final notifier = ref.read(seekSettingsProvider.notifier);
    final totals = [for (var taps = 1; taps <= 4; taps++) seek.total(taps).inSeconds].join(', ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionTitle(l.sectionDoubleTapSeek),
        SwitchListTile(
          secondary: const Icon(Icons.touch_app_outlined),
          title: Text(l.doubleTapSeek),
          subtitle: Text(l.doubleTapSeekSubtitle),
          value: seek.enabled,
          onChanged: withHaptic(notifier.setEnabled),
        ),
        SettingsDropdownTile(
          leading: const Icon(Icons.fast_forward_outlined),
          title: Text(l.seekStep),
          enabled: seek.enabled,
          dropdown: DropdownButton<Duration>(
            value: seek.step,
            underline: const SizedBox.shrink(),
            items: [
              for (final step in {...SeekSettings.steps, seek.step})
                DropdownMenuItem(value: step, child: Text(l.secondsValue(step.inSeconds.toDouble()))),
            ],
            onChanged: seek.enabled
                ? (step) {
                    if (step != null) notifier.setStep(step);
                  }
                : null,
          ),
        ),
        SwitchListTile(
          secondary: const Icon(Icons.keyboard_double_arrow_right),
          title: Text(l.seekCumulative),
          // The totals of the first taps, for the current step and mode.
          subtitle: Text(l.seekSequenceExample(totals)),
          value: seek.cumulative,
          onChanged: seek.enabled ? withHaptic(notifier.setCumulative) : null,
        ),
      ],
    );
  }
}

/// Animated previews in lists and markers, and what the scene cards show.
class PreviewSettingsPage extends ConsumerWidget {
  const PreviewSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l = context.l10n;
    final cardConfig = ref.watch(sceneCardConfigProvider);
    final previewsOn = ref.watch(feedPreviewsProvider);

    return SettingsSubPage(
      title: l.sectionPreviewsCards,
      children: [
        SwitchListTile(
          secondary: const Icon(Icons.motion_photos_on_outlined),
          title: Text(l.feedPreviews),
          subtitle: Text(l.feedPreviewsSubtitle),
          value: previewsOn,
          onChanged: withHaptic((v) => ref.read(feedPreviewsProvider.notifier).set(v)),
        ),
        SettingsDropdownTile(
          leading: const Icon(Icons.movie_filter_outlined),
          title: Text(l.previewSource),
          enabled: previewsOn,
          dropdown: DropdownButton<PreviewSource>(
            value: ref.watch(previewSourceProvider),
            underline: const SizedBox.shrink(),
            items: [
              DropdownMenuItem(value: PreviewSource.animatedImage, child: Text(l.previewSourceAnimated)),
              DropdownMenuItem(value: PreviewSource.video, child: Text(l.previewSourceVideo)),
            ],
            onChanged: previewsOn
                ? (source) {
                    if (source != null) ref.read(previewSourceProvider.notifier).set(source);
                  }
                : null,
          ),
        ),
        // How the two formats differ, so the choice is an informed one.
        if (previewsOn)
          ListTile(
            leading: Icon(Icons.info_outline, color: theme.colorScheme.tertiary),
            subtitle: Text(l.previewSourceVideoHint),
          ),
        SettingsDropdownTile(
          leading: const Icon(Icons.timer_outlined),
          title: Text(l.feedPreviewDelay),
          enabled: previewsOn,
          dropdown: DropdownButton<Duration>(
            value: ref.watch(feedPreviewDelayProvider),
            underline: const SizedBox.shrink(),
            items: [
              for (final delay in {...FeedPreviewDelayNotifier.choices, ref.watch(feedPreviewDelayProvider)})
                DropdownMenuItem(value: delay, child: Text(l.secondsValue(delay.inMilliseconds / 1000))),
            ],
            onChanged: previewsOn
                ? (delay) {
                    if (delay != null) ref.read(feedPreviewDelayProvider.notifier).set(delay);
                  }
                : null,
          ),
        ),
        SwitchListTile(
          secondary: const Icon(Icons.bookmarks_outlined),
          title: Text(l.markerPreviews),
          subtitle: Text(l.markerPreviewsSubtitle),
          value: ref.watch(markerPreviewsProvider),
          onChanged: withHaptic((v) => ref.read(markerPreviewsProvider.notifier).set(v)),
        ),
        SwitchListTile(
          secondary: const Icon(Icons.wifi),
          title: Text(l.previewsWifiOnly),
          subtitle: Text(l.previewsWifiOnlySubtitle),
          value: ref.watch(previewsWifiOnlyProvider),
          onChanged: withHaptic((v) => ref.read(previewsWifiOnlyProvider.notifier).set(v)),
        ),
        // Stash creates only MP4 previews by default; the app plays the
        // WebP ones, which need no video player per tile.
        ListTile(
          leading: const Icon(Icons.info_outline),
          subtitle: Text(l.previewsHint),
        ),
        ListTile(
          leading: const Icon(Icons.fact_check_outlined),
          title: Text(l.previewsOnServer),
          subtitle: Text(l.previewsOnServerSubtitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => openServerTasks(context),
        ),
        SettingsSectionTitle(l.sectionSceneCards),
        SettingsDropdownTile(
          leading: const Icon(Icons.account_circle_outlined),
          title: Text(l.cardChannel),
          dropdown: DropdownButton<CardChannel>(
            value: cardConfig.channel,
            underline: const SizedBox.shrink(),
            items: [
              DropdownMenuItem(value: CardChannel.studio, child: Text(l.cardChannelStudio)),
              DropdownMenuItem(value: CardChannel.performers, child: Text(l.cardChannelPerformers)),
            ],
            onChanged: (channel) => ref.read(sceneCardConfigProvider.notifier).set(cardConfig.copyWith(channel: channel)),
          ),
        ),
        SettingsDropdownTile(
          leading: const Icon(Icons.crop_outlined),
          title: Text(l.thumbnailFit),
          dropdown: DropdownButton<ThumbnailFit>(
            value: cardConfig.thumbnailFit,
            underline: const SizedBox.shrink(),
            items: [
              DropdownMenuItem(value: ThumbnailFit.whole, child: Text(l.thumbnailFitWhole)),
              DropdownMenuItem(value: ThumbnailFit.fill, child: Text(l.thumbnailFitFill)),
            ],
            onChanged: (fit) => ref.read(sceneCardConfigProvider.notifier).set(cardConfig.copyWith(thumbnailFit: fit)),
          ),
        ),
        SwitchListTile(
          secondary: const Icon(Icons.visibility_outlined),
          title: Text(l.cardShowPlays),
          value: cardConfig.showPlays,
          onChanged: withHaptic(
            (v) => ref.read(sceneCardConfigProvider.notifier).set(cardConfig.copyWith(showPlays: v)),
          ),
        ),
        SwitchListTile(
          secondary: const Icon(Icons.star_outline),
          title: Text(l.cardShowRating),
          value: cardConfig.showRating,
          onChanged: withHaptic(
            (v) => ref.read(sceneCardConfigProvider.notifier).set(cardConfig.copyWith(showRating: v)),
          ),
        ),
      ],
    );
  }
}

class PrivacySettingsPage extends StatelessWidget {
  const PrivacySettingsPage({super.key});

  @override
  Widget build(BuildContext context) =>
      SettingsSubPage(
        title: context.l10n.sectionPrivacy,
        children: const [_SecuritySettings(), NotificationSettingsSection()],
      );
}

class AboutSettingsPage extends StatelessWidget {
  const AboutSettingsPage({super.key});

  @override
  Widget build(BuildContext context) =>
      SettingsSubPage(
        title: context.l10n.sectionAbout,
        children: [
          // The tour from the first login, again.
          ListTile(
            leading: const Icon(Icons.tour_outlined),
            title: Text(context.l10n.introTour),
            subtitle: Text(context.l10n.introTourSubtitle),
            onTap: () => showIntroTour(context),
          ),
          ListTile(
            leading: const Icon(Icons.auto_awesome_outlined),
            title: Text(context.l10n.whatsNewTitle),
            subtitle: Text(context.l10n.whatsNewSubtitle),
            onTap: () => showWhatsNew(context),
          ),
          const AboutSettings(),
        ],
      );
}

class SettingsSectionTitle extends StatelessWidget {
  const SettingsSectionTitle(this.text, {super.key});

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

/// Picture-in-picture when leaving the app (Android) and background
/// playback (4.12).
class _PlaybackModeTiles extends ConsumerWidget {
  const _PlaybackModeTiles();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final modes = ref.watch(playbackModesProvider);
    return Column(
      children: [
        if (ref.watch(pipServiceProvider).canAutoEnter)
          SwitchListTile(
            secondary: const Icon(Icons.picture_in_picture_alt_outlined),
            title: Text(l.autoPip),
            subtitle: Text(l.autoPipSubtitle),
            value: modes.autoPip,
            onChanged: withHaptic((v) => ref.read(playbackModesProvider.notifier).setAutoPip(v)),
          ),
        SwitchListTile(
          secondary: const Icon(Icons.headphones_outlined),
          title: Text(l.backgroundPlayback),
          subtitle: Text(l.backgroundPlaybackSubtitle),
          value: modes.background,
          onChanged: withHaptic((v) => ref.read(playbackModesProvider.notifier).setBackground(v)),
        ),
        if (ref.watch(lockScreenSupportedProvider))
          SwitchListTile(
            secondary: const Icon(Icons.lock_outline),
            title: Text(l.lockScreenControls),
            subtitle: Text(l.lockScreenControlsSubtitle),
            isThreeLine: true,
            value: modes.lockScreen,
            onChanged: withHaptic((v) => ref.read(playbackModesProvider.notifier).setLockScreen(v)),
          ),
      ],
    );
  }
}

/// Default resolution of new scenes (4.10). Stored as a stream label like
/// the player's HD choice; picking a height here keeps that choice's format
/// (HLS by default), see `pickPreferredStream`.
class _QualityTile extends ConsumerWidget {
  const _QualityTile({required this.preferred});

  final String? preferred;

  static const _heights = [1080, 720, 480, 240];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final height = preferred == null ? null : streamHeightOf(preferred!);
    final heights = [
      if (height != null && !_heights.contains(height)) height,
      ..._heights,
    ];
    return SettingsDropdownTile(
      leading: const Icon(Icons.high_quality_outlined),
      title: Text(l.preferredQuality),
      subtitle: Text(l.preferredQualityHint),
      isThreeLine: true,
      dropdown: DropdownButton<int>(
        // 0 = the original file.
        value: height ?? 0,
        underline: const SizedBox.shrink(),
        items: [
          DropdownMenuItem(value: 0, child: Text(l.qualityOriginal)),
          for (final h in heights) DropdownMenuItem(value: h, child: Text(h == 2160 ? '4K' : '${h}p')),
        ],
        onChanged: (h) {
          final format = preferred == null ? 'HLS' : streamFormatOf(preferred!);
          ref.read(preferredStreamProvider.notifier).set(h == null || h == 0 ? null : '$format ${h}p');
        },
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
          onChanged: withHaptic((on) async {
            if (on) {
              final pin = await showCreatePin(context);
              if (pin != null) await notifier.enable(pin);
            } else if (await confirmPin(context, ref)) {
              await notifier.disable();
            }
          }),
        ),
        if (settings.enabled) ...[
          if (biometricsAvailable)
            SwitchListTile(
              secondary: const Icon(Icons.fingerprint),
              title: Text(l.unlockBiometric),
              value: settings.biometrics,
              // Turning it on asks once, so it surely works.
              onChanged: withHaptic((on) async {
                final reason = l.unlockReason;
                if (on && !await ref.read(biometricAuthProvider).authenticate(reason)) return;
                await notifier.setBiometrics(on);
              }),
            ),
          SettingsDropdownTile(
            leading: const Icon(Icons.timer_outlined),
            title: Text(l.lockNow),
            dropdown: DropdownButton<Duration>(
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
          subtitle: Text(settings.enabled ? l.hideInSwitcherLocked : l.hideInSwitcherSubtitle),
          // Always on while the app lock is on.
          value: settings.hidesApp,
          onChanged: withHaptic(settings.enabled ? null : notifier.setHideInSwitcher),
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
