import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/config/theme.dart';

import '../../core/utils/format.dart';
import '../../data/models/gallery.dart';
import '../../data/models/list_queries.dart';
import '../../data/providers.dart';
import '../../widgets/chip_bar.dart';
import '../../widgets/paged_sliver.dart';
import '../../widgets/scene_card.dart';
import '../../widgets/stash_image.dart';
import '../shell/navigation.dart';
import 'gallery_page.dart';
import '../../l10n/l10n.dart';

/// All galleries as a grid of covers.
class GalleriesTab extends StatefulWidget {
  const GalleriesTab({super.key});

  @override
  State<GalleriesTab> createState() => _GalleriesTabState();
}

class _GalleriesTabState extends State<GalleriesTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const GalleryGridView();
  }
}

/// Endless, refreshable grid of gallery covers with sort chips, optionally
/// limited to a [search] term (the search page).
class GalleryGridView extends ConsumerStatefulWidget {
  const GalleryGridView({super.key, this.search});

  final String? search;

  @override
  ConsumerState<GalleryGridView> createState() => _GalleryGridViewState();
}

class _GalleryGridViewState extends ConsumerState<GalleryGridView> {
  late var _query = GalleryQuery(search: widget.search);

  @override
  void didUpdateWidget(GalleryGridView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.search != widget.search) _query = GalleryQuery(sort: _query.sort, search: widget.search);
  }

  @override
  Widget build(BuildContext context) {
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
                labelOf: (s) => s.label(context.l10n),
                onSelected: (s) => setState(() => _query = GalleryQuery(sort: s, search: widget.search)),
              ),
            ),
            if (value.current case final state?)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                  child: Text(
                    context.l10n.galleriesCount(state.totalCount),
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ),
              ),
            PagedSliver<Gallery>(
              value: value,
              emptyMessage: widget.search == null
                  ? context.l10n.galleriesEmpty
                  : context.l10n.searchNoResults(widget.search!),
              emptyIcon: Icons.photo_library_outlined,
              emptyHint: widget.search == null ? context.l10n.galleriesEmptyHint : context.l10n.searchNoScenesHint,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 220,
                childAspectRatio: 0.72,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              onRetry: () => ref.invalidate(provider),
              onLoadMore: () => ref.read(provider.notifier).loadMore(retry: true),
              onGoToPage: (page) => ref.read(provider.notifier).goToPage(page),
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
    final l = context.l10n;
    final meta = [gallery.studio?.name ?? l.unknownStudio, if (gallery.date != null) formatDate(gallery.date!)];
    final badge = AppColors.of(context);
    return TileSemantics(
      label: [gallery.title, l.imagesCount(gallery.imageCount), ...meta].join(', '),
      child: InkWell(
        borderRadius: AppRadius.cardBorder,
        onTap: () => openPage(ref, GalleryPage(galleryId: gallery.id)),
        child: ExcludeSemantics(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: AppRadius.cardBorder,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      StashImage(gallery.coverUrl, fallbackIcon: Icons.photo_library_outlined),
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
                                Icon(Icons.photo_library_outlined, color: badge.onBadge, size: 14),
                                const SizedBox(width: AppSpacing.xs),
                                Text(
                                  formatNumber(gallery.imageCount),
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
              Text(gallery.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleSmall),
              Text(
                meta.join(' • '),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
