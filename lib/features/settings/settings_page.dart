import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/server_config.dart';
import '../../core/config/theme.dart';
import '../../data/models/scene_details.dart';
import '../../data/providers.dart';
import '../../l10n/l10n.dart';
import '../../widgets/animated_previews.dart';
import '../pip/pip.dart';
import '../player/player_providers.dart';
import '../security/app_icon.dart';
import '../security/app_lock.dart';
import 'about.dart';
import 'appearance_picker.dart';
import 'scene_card_config.dart';
import 'settings_categories.dart';

/// Shown as a sheet by `openSettings`: one entry per category with a short
/// summary of its current values (SET-1); each opens its page inside the
/// sheet. [scrollController] lets swiping the list down past its top close
/// the sheet.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key, this.scrollController});

  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final server = ref.watch(serverProfilesProvider).active;
    final version = ref.watch(serverVersionProvider);
    final accent = ref.watch(accentColorProvider);
    final accentName = accentColors.entries
        .where((e) => e.value.toARGB32() == accent.toARGB32())
        .map((e) => accentColorName(l, e.key))
        .firstOrNull;
    final preferred = ref.watch(preferredStreamProvider);
    final height = preferred == null ? null : streamHeightOf(preferred);
    final cards = ref.watch(sceneCardConfigProvider);
    final appInfo = ref.watch(appInfoProvider).value;

    String join(Iterable<String?> parts) => parts.whereType<String>().join(' · ');

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(l.settingsTitle),
        actions: [
          IconButton(
            tooltip: l.close,
            icon: const Icon(Icons.close),
            onPressed: () => CupertinoSheetRoute.popSheet(context),
          ),
        ],
      ),
      body: ListView(
        controller: scrollController,
        children: [
          _CategoryTile(
            icon: Icons.dns_outlined,
            title: l.sectionServer,
            summary: join([
              server?.name,
              switch (version) {
                AsyncData(:final value) => l.stashVersion(value ?? l.unknownVersion),
                AsyncError() => l.notReachable,
                _ => l.checking,
              },
            ]),
            page: const ServerSettingsPage(),
          ),
          _CategoryTile(
            icon: Icons.palette_outlined,
            title: l.sectionAppearance,
            summary: join([
              switch (ref.watch(themeModeProvider)) {
                ThemeMode.light => l.themeLight,
                ThemeMode.dark => l.themeDark,
                ThemeMode.system => l.themeSystem,
              },
              accentName,
            ]),
            page: const AppearanceSettingsPage(),
          ),
          _CategoryTile(
            icon: Icons.play_circle_outline,
            title: l.sectionPlayback,
            summary: join([
              l.qualitySummary(switch (height) {
                null => l.qualityOriginal,
                2160 => '4K',
                final h => '${h}p',
              }),
              if (ref.watch(playbackModesProvider).background) l.backgroundPlayback,
            ]),
            page: const PlaybackSettingsPage(),
          ),
          _CategoryTile(
            icon: Icons.motion_photos_on_outlined,
            title: l.sectionPreviewsCards,
            summary: join([
              if (!ref.watch(feedPreviewsProvider))
                l.previewsOffSummary
              else
                switch (ref.watch(previewSourceProvider)) {
                  PreviewSource.animatedImage => l.previewSourceAnimated,
                  PreviewSource.video => l.previewSourceVideo,
                },
              switch (cards.channel) {
                CardChannel.studio => l.cardChannelStudio,
                CardChannel.performers => l.cardChannelPerformers,
              },
            ]),
            page: const PreviewSettingsPage(),
          ),
          _CategoryTile(
            icon: Icons.shield_outlined,
            title: l.sectionPrivacy,
            summary: join([
              ref.watch(appLockSettingsProvider).enabled ? l.appLockOnSummary : l.appLockOffSummary,
              ref.watch(appIconProvider).label(l),
            ]),
            page: const PrivacySettingsPage(),
          ),
          _CategoryTile(
            icon: Icons.info_outline,
            title: l.sectionAbout,
            summary: appInfo == null
                ? l.openSourceLicenses
                : join([l.appVersionValue(appInfo.version, appInfo.buildNumber), l.openSourceLicenses]),
            page: const AboutSettingsPage(),
          ),
        ],
      ),
    );
  }
}

/// A category of the settings; opens [page] inside the settings sheet.
class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.icon, required this.title, required this.summary, required this.page});

  final IconData icon;
  final String title;
  final String summary;
  final Widget page;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon),
    title: Text(title),
    subtitle: Text(summary, maxLines: 1, overflow: TextOverflow.ellipsis),
    trailing: const Icon(Icons.chevron_right),
    onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page)),
  );
}
