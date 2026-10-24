import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/config/theme.dart';

import '../../data/models/list_queries.dart';
import '../../data/models/marker.dart';
import '../../data/providers.dart';
import '../../widgets/animated_previews.dart';
import '../../widgets/chip_bar.dart';
import '../../widgets/paged_sliver.dart';
import '../../widgets/scene_card.dart';
import '../../widgets/stash_image.dart';
import '../player/player_controls.dart';
import '../player/player_providers.dart';
import '../../l10n/l10n.dart';

/// Scene markers of all scenes (the marked moments), like Stash's markers
/// page. Tapping one plays its scene from the marker.
class MarkersTab extends StatefulWidget {
  const MarkersTab({super.key});

  @override
  State<MarkersTab> createState() => _MarkersTabState();
}

class _MarkersTabState extends State<MarkersTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MarkerGridView(initialQuery: MarkerQuery());
  }
}

/// Markers as a grid of [MarkerTile]s with sort chips, paging and
/// pull-to-refresh: the library's markers and a channel's markers tab.
class MarkerGridView extends ConsumerStatefulWidget {
  const MarkerGridView({super.key, required this.initialQuery, this.headerSlivers = const []});

  final MarkerQuery initialQuery;

  /// Slivers above the sort chips, e.g. a channel's header and tab bar.
  final List<Widget> headerSlivers;

  @override
  ConsumerState<MarkerGridView> createState() => _MarkerGridViewState();
}

class _MarkerGridViewState extends ConsumerState<MarkerGridView> {
  late MarkerQuery _query = widget.initialQuery;

  @override
  void didUpdateWidget(MarkerGridView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // E.g. sub-studios switched on or off: keeps the chosen sort.
    if (oldWidget.initialQuery != widget.initialQuery) _query = widget.initialQuery.withSort(_query.sort);
  }

  @override
  Widget build(BuildContext context) {
    final provider = markerListProvider(_query);
    final value = ref.watch(provider);
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () => refreshFuture(ref, provider.future),
      child: LoadMoreListener(
        onLoadMore: () => ref.read(provider.notifier).loadMore(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            ...widget.headerSlivers,
            SliverToBoxAdapter(
              child: ChipBar<MarkerSort>(
                values: MarkerSort.values,
                selected: _query.sort,
                labelOf: (s) => s.label(context.l10n),
                onSelected: (s) => setState(() => _query = _query.withSort(s)),
              ),
            ),
            if (value.current case final state?)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                  child: Text(
                    context.l10n.markersCount(state.totalCount),
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ),
              ),
            PagedSliver<Marker>(
              value: value,
              emptyMessage: context.l10n.markersEmpty,
              emptyIcon: Icons.bookmarks_outlined,
              emptyHint: context.l10n.markersEmptyHint,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 240,
                childAspectRatio: 0.95,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              onRetry: () => ref.invalidate(provider),
              onLoadMore: () => ref.read(provider.notifier).loadMore(retry: true),
              onGoToPage: (page) => ref.read(provider.notifier).goToPage(page),
              itemBuilder: (_, marker) => MarkerTile(marker: marker),
            ),
          ],
        ),
      ),
    );
  }
}

/// The frame at the marker with its time (a ranged marker's range and
/// length), the marker's title and below it the scene and the marker's tag.
class MarkerTile extends ConsumerWidget {
  const MarkerTile({super.key, required this.marker});

  final Marker marker;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    final still = StashImage(marker.screenshotUrl ?? marker.scene.screenshotUrl, fallbackIcon: Icons.bookmark_outline);
    final preview = previewsPlay(context, ref, markerPreviewsProvider) ? marker.previewUrl : null;
    final l = context.l10n;
    final showTag = marker.tag.name != marker.title;
    final badge = AppColors.of(context);
    return TileSemantics(
      label: [
        marker.title,
        marker.scene.title,
        spokenMarkerTime(l, marker.seconds, marker.endSeconds),
        if (showTag) marker.tag.name,
      ].join(', '),
      child: InkWell(
        borderRadius: AppRadius.thumbnailBorder,
        onTap: () => ref.read(nowPlayingProvider.notifier).play(marker.scene, at: marker.seconds),
        child: ExcludeSemantics(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: AppRadius.thumbnailBorder,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (preview != null)
                        // Loops by itself (animated WebP); the still frame shows
                        // until it loaded, and if Stash has none.
                        StashImage(preview, standIn: still)
                      else
                        still,
                      Positioned(
                        right: 6,
                        bottom: 6,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: badge.badgeBackground,
                            borderRadius: AppRadius.badgeBorder,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.bookmark, color: badge.onBadge, size: 12),
                                const SizedBox(width: AppSpacing.xs),
                                Text(
                                  markerTimeLabel(l, marker.seconds, marker.endSeconds, withLength: true),
                                  style: TextStyle(
                                    color: badge.onBadge,
                                    fontSize: AppTextSize.overlayLabel,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(marker.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleSmall),
              Text(marker.scene.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: muted),
              if (showTag) Text('#${marker.tag.name}', maxLines: 1, overflow: TextOverflow.ellipsis, style: muted),
            ],
          ),
        ),
      ),
    );
  }
}
