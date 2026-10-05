import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/format.dart';
import '../../data/models/gallery.dart';
import '../../data/models/list_queries.dart';
import '../../data/providers.dart';
import '../../widgets/chip_bar.dart';
import '../../widgets/paged_sliver.dart';
import '../../widgets/stash_image.dart';
import '../shell/navigation.dart';
import 'gallery_page.dart';

/// All galleries as a grid of covers.
class GalleriesTab extends ConsumerStatefulWidget {
  const GalleriesTab({super.key});

  @override
  ConsumerState<GalleriesTab> createState() => _GalleriesTabState();
}

class _GalleriesTabState extends ConsumerState<GalleriesTab> with AutomaticKeepAliveClientMixin {
  var _query = GalleryQuery();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final provider = galleryListProvider(_query);
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
              child: ChipBar<GallerySort>(
                values: GallerySort.values,
                selected: _query.sort,
                labelOf: (s) => s.label,
                onSelected: (s) => setState(() => _query = GalleryQuery(sort: s)),
              ),
            ),
            if (value.value case final state?)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                  child: Text(
                    '${formatNumber(state.totalCount)} galleries',
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ),
              ),
            PagedSliver<Gallery>(
              value: value,
              emptyMessage: 'No galleries found',
              padding: const EdgeInsets.symmetric(horizontal: 12),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 220,
                childAspectRatio: 0.72,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              onRetry: () => ref.invalidate(provider),
              onLoadMore: () => ref.read(provider.notifier).loadMore(),
              itemBuilder: (_, gallery) => GalleryTile(gallery: gallery),
            ),
          ],
        ),
      ),
    );
  }
}

class GalleryTile extends ConsumerWidget {
  const GalleryTile({super.key, required this.gallery});

  final Gallery gallery;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => openPage(ref, GalleryPage(galleryId: gallery.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  StashImage(gallery.coverUrl, fallbackIcon: Icons.photo_library_outlined),
                  Positioned(
                    right: 6,
                    bottom: 6,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.75), borderRadius: BorderRadius.circular(4)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.photo_library_outlined, color: Colors.white, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              formatNumber(gallery.imageCount),
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
          Text(gallery.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleSmall),
          Text(
            [
              if (gallery.studio != null) gallery.studio!.name,
              if (gallery.date != null) formatDate(gallery.date!),
            ].join(' • '),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
