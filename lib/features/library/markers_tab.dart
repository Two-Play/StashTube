import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/format.dart';
import '../../data/models/list_queries.dart';
import '../../data/models/marker.dart';
import '../../data/providers.dart';
import '../../widgets/animated_previews.dart';
import '../../widgets/chip_bar.dart';
import '../../widgets/paged_sliver.dart';
import '../../widgets/stash_image.dart';
import '../player/player_providers.dart';
import '../../l10n/l10n.dart';

/// Scene markers of all scenes (the marked moments), like Stash's markers
/// page. Tapping one plays its scene from the marker.
class MarkersTab extends ConsumerStatefulWidget {
  const MarkersTab({super.key});

  @override
  ConsumerState<MarkersTab> createState() => _MarkersTabState();
}

class _MarkersTabState extends ConsumerState<MarkersTab> with AutomaticKeepAliveClientMixin {
  var _query = MarkerQuery();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
            SliverToBoxAdapter(
              child: ChipBar<MarkerSort>(
                values: MarkerSort.values,
                selected: _query.sort,
                labelOf: (s) => s.label(context.l10n),
                onSelected: (s) => setState(() => _query = MarkerQuery(sort: s)),
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
              onLoadMore: () => ref.read(provider.notifier).loadMore(),
              onGoToPage: (page) => ref.read(provider.notifier).goToPage(page),
              itemBuilder: (_, marker) => MarkerTile(marker: marker),
            ),
          ],
        ),
      ),
    );
  }
}

/// The frame at the marker with its time, the marker's title and below it
/// the scene and the marker's tag.
class MarkerTile extends ConsumerWidget {
  const MarkerTile({super.key, required this.marker});

  final Marker marker;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    final still = StashImage(marker.screenshotUrl ?? marker.scene.screenshotUrl, fallbackIcon: Icons.bookmark_outline);
    final preview = previewsPlay(context, ref) ? marker.previewUrl : null;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => ref.read(nowPlayingProvider.notifier).play(marker.scene, at: marker.seconds),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
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
                        color: Colors.black.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.bookmark, color: Colors.white, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              formatDuration(marker.seconds),
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
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
          if (marker.tag.name != marker.title)
            Text('#${marker.tag.name}', maxLines: 1, overflow: TextOverflow.ellipsis, style: muted),
        ],
      ),
    );
  }
}
