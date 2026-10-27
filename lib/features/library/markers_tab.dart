import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../settings/scene_card_config.dart';
import '../../core/config/haptics.dart';
import '../../core/config/theme.dart';
import '../../core/pagination/paging_mode.dart';
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
import '../player/scene_actions.dart' show showMarkerMenu;
import '../shell/navigation.dart';
import '../shorts/shorts_feed.dart';
import '../shorts/shorts_page.dart';
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
/// "Play as loops" (and a tile's "Play as loop") plays exactly these
/// markers, in this order, in [ShortsPage].
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

  /// Opens the grid's markers as shorts, at [marker] or the first one.
  void _playAsShorts(PagedState<Marker> state, [Marker? marker]) {
    Haptics.light();
    final index = marker == null ? -1 : state.items.indexOf(marker);
    final numbered = ref.read(pagingModeProvider) == PagingMode.pages;
    final start = index < 0
        ? (startPage: numbered ? state.page : 1, initialIndex: 0)
        : markerShortsStart(state.items, index, page: numbered ? state.page : null, perPage: state.perPage);
    openPage(
      ref,
      ShortsPage(
        source: ShortsSource.markers(_query, startPage: start.startPage, title: context.l10n.channelTabMarkers),
        initialIndex: start.initialIndex,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = markerListProvider(_query);
    final value = ref.watch(provider);
    final theme = Theme.of(context);
    final state = value.current;
    final playAsShort = state == null ? null : (Marker marker) => _playAsShorts(state, marker);

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
            if (state != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 8, 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          context.l10n.markersCount(state.totalCount),
                          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ),
                      if (state.items.any((m) => m.scene.streamUrl != null))
                        TextButton.icon(
                          onPressed: () => _playAsShorts(state),
                          icon: const Icon(Icons.slow_motion_video),
                          label: Text(context.l10n.markersPlayAsShorts),
                        ),
                    ],
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
              itemBuilder: (_, marker) => MarkerTile(
                marker: marker,
                onPlayAsShort: playAsShort == null || marker.scene.streamUrl == null ? null : () => playAsShort(marker),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The frame at the marker with its time (a ranged marker's range and
/// length), the marker's title and below it the scene and the marker's tag.
///
/// A ⋮ next to the title (and a long press) offers to play it, with
/// [onPlayAsShort] to play it as a short, and to edit or delete it.
class MarkerTile extends ConsumerWidget {
  const MarkerTile({super.key, required this.marker, this.onPlayAsShort});

  final Marker marker;

  /// Plays the marker (and the grid's further markers) as shorts.
  final VoidCallback? onPlayAsShort;

  void _play(WidgetRef ref) => ref.read(nowPlayingProvider.notifier).play(marker.scene, at: marker.seconds);

  /// Play, play as loop, edit, delete.
  void _showMenu(BuildContext context, WidgetRef ref) => showMarkerMenu(
        context,
        scene: marker.scene,
        marker: marker.asSceneMarker,
        leading: (sheetContext, go) {
          final l = sheetContext.l10n;
          return [
            ListTile(
              leading: const Icon(Icons.play_arrow),
              title: Text(l.sceneMenuPlay),
              onTap: () => go(() => _play(ref)),
            ),
            if (onPlayAsShort case final playAsShort?)
              ListTile(
                leading: const Icon(Icons.slow_motion_video),
                title: Text(l.markerPlayAsShort),
                onTap: () => go(playAsShort),
              ),
          ];
        },
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    // A portrait scene's marker shows whole instead of zoomed to the width.
    final fit = thumbnailFit(ref, marker.scene.aspect, 16 / 9);
    final still = StashImage(
      marker.screenshotUrl ?? marker.scene.screenshotUrl,
      fit: fit,
      fallbackIcon: Icons.bookmark_outline,
    );
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
        onTap: () => _play(ref),
        // A shortcut for the ⋮ next to the title.
        onLongPress: () => _showMenu(context, ref),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(
              child: ClipRRect(
                borderRadius: AppRadius.thumbnailBorder,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      const ColoredBox(color: Colors.black),
                      if (preview != null)
                        // Loops by itself (animated WebP); the still frame shows
                        // until it loaded, and if Stash has none.
                        StashImage(preview, fit: fit, standIn: still)
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
            ),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ExcludeSemantics(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          marker.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall,
                        ),
                        Text(marker.scene.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: muted),
                        if (showTag)
                          Text('#${marker.tag.name}', maxLines: 1, overflow: TextOverflow.ellipsis, style: muted),
                      ],
                    ),
                  ),
                ),
                IconButton(
                    tooltip: l.markerMoreOptions,
                    icon: const Icon(Icons.more_vert, size: 18),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(width: 36, height: 48),
                    onPressed: () => _showMenu(context, ref),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
