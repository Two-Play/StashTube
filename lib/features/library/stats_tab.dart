import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/format.dart';
import '../../data/models/stats.dart';
import '../../data/providers.dart';
import '../../widgets/status_views.dart';
import '../../l10n/l10n.dart';

/// Library and watch statistics as stat tiles (headline numbers, no charts).
class StatsTab extends ConsumerWidget {
  const StatsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final library = ref.watch(libraryStatsProvider);
    final activity = ref.watch(activityStatsProvider);

    Future<void> refresh() async {
      ref.invalidate(activityStatsProvider);
      try {
        final reloaded = ref.refresh(libraryStatsProvider.future);
        await reloaded;
      } catch (_) {
        // Rendered as error state below.
      }
      HapticFeedback.mediumImpact();
    }

    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
        children: [
          ...switch (library) {
            AsyncData(:final value) => _libraryTiles(context.l10n, value),
            AsyncError(:final error) => [ErrorView(error: error, onRetry: () => ref.invalidate(libraryStatsProvider))],
            _ => [const LoadingView()],
          },
          // Activity stats are optional: hidden on servers that don't support them.
          if (activity.value case final value?) ..._activityTiles(context.l10n, value),
        ],
      ),
    );
  }

  List<Widget> _libraryTiles(AppLocalizations l, LibraryStats s) => [
        _SectionHeader(l.statsLibrary),
        _TileGrid(tiles: [
          _StatTile(
            icon: Icons.movie_outlined,
            label: l.statsScenes,
            value: formatNumber(s.sceneCount),
            detail: '${formatBytes(s.scenesSize)} • ${formatLongDuration(s.scenesDuration)}',
          ),
          _StatTile(
            icon: Icons.image_outlined,
            label: l.statsImages,
            value: formatNumber(s.imageCount),
            detail: formatBytes(s.imagesSize),
          ),
          _StatTile(icon: Icons.photo_library_outlined, label: l.statsGalleries, value: formatNumber(s.galleryCount)),
          _StatTile(icon: Icons.people_outline, label: l.statsPerformers, value: formatNumber(s.performerCount)),
          _StatTile(icon: Icons.subscriptions_outlined, label: l.statsStudios, value: formatNumber(s.studioCount)),
          _StatTile(icon: Icons.sell_outlined, label: l.statsTags, value: formatNumber(s.tagCount)),
        ]),
        _SectionHeader(l.statsStorage),
        _TileGrid(tiles: [
          _StatTile(
            icon: Icons.storage_outlined,
            label: l.statsTotalSize,
            value: formatBytes(s.scenesSize + s.imagesSize),
          ),
          _StatTile(
            icon: Icons.timer_outlined,
            label: l.statsAverageScene,
            value: s.sceneCount == 0 ? '–' : formatLongDuration(s.scenesDuration / s.sceneCount),
            detail: s.sceneCount == 0 ? null : formatBytes(s.scenesSize / s.sceneCount),
          ),
        ]),
      ];

  List<Widget> _activityTiles(AppLocalizations l, ActivityStats a) => [
        _SectionHeader(l.statsWatching),
        _TileGrid(tiles: [
          _StatTile(icon: Icons.play_circle_outline, label: l.statsPlays, value: formatNumber(a.playCount)),
          _StatTile(icon: Icons.schedule, label: l.statsWatchTime, value: formatLongDuration(a.playDuration)),
          _StatTile(icon: Icons.check_circle_outline, label: l.statsScenesWatched, value: formatNumber(a.scenesPlayed)),
          _StatTile(icon: Icons.favorite_border, label: l.statsOCount, value: formatNumber(a.oCount)),
        ]),
      ];
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
        child: Text(text, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
      );
}

class _TileGrid extends StatelessWidget {
  const _TileGrid({required this.tiles});

  final List<Widget> tiles;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 600 ? 3 : 2;
          const spacing = 8.0;
          final width = (constraints.maxWidth - spacing * (columns - 1)) / columns;
          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: [for (final t in tiles) SizedBox(width: width, child: t)],
          );
        },
      );
}

/// Headline number with a label; text uses text colors, the accent only
/// tints the icon.
class _StatTile extends StatelessWidget {
  const _StatTile({required this.icon, required this.label, required this.value, this.detail});

  final IconData icon;
  final String label;
  final String value;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    return Semantics(
      label: '$label: $value${detail == null ? '' : ', $detail'}',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: theme.colorScheme.primary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.labelLarge?.copyWith(color: muted)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(value, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
            ),
            Text(
              detail ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(color: muted),
            ),
          ],
        ),
      ),
    );
  }
}
