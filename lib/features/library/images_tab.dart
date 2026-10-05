import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/image_item.dart';
import '../../data/models/list_queries.dart';
import '../../data/providers.dart';
import '../../widgets/chip_bar.dart';
import '../../widgets/paged_sliver.dart';
import '../../widgets/stash_image.dart';
import 'image_viewer_page.dart';
import '../../l10n/l10n.dart';

/// All images, newest first.
class ImagesTab extends StatefulWidget {
  const ImagesTab({super.key});

  @override
  State<ImagesTab> createState() => _ImagesTabState();
}

class _ImagesTabState extends State<ImagesTab> with AutomaticKeepAliveClientMixin {
  final _query = ImageQuery();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ImageGridView(
      initialQuery: _query,
      sorts: const [ImageSort.recentlyAdded, ImageSort.newest, ImageSort.random, ImageSort.topRated, ImageSort.title],
    );
  }
}

/// Endless, refreshable thumbnail grid of images with optional sort chips;
/// tapping an image opens [ImageViewerPage] on the same list.
class ImageGridView extends ConsumerStatefulWidget {
  const ImageGridView({
    super.key,
    required this.initialQuery,
    this.sorts = const [],
    this.headerSlivers = const [],
  });

  final ImageQuery initialQuery;
  final List<ImageSort> sorts;
  final List<Widget> headerSlivers;

  @override
  ConsumerState<ImageGridView> createState() => _ImageGridViewState();
}

class _ImageGridViewState extends ConsumerState<ImageGridView> {
  late ImageQuery _query = widget.initialQuery;

  @override
  Widget build(BuildContext context) {
    final provider = imageListProvider(_query);
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
            if (widget.sorts.length > 1)
              SliverToBoxAdapter(
                child: ChipBar<ImageSort>(
                  values: widget.sorts,
                  selected: _query.sort,
                  labelOf: (s) => s.label(context.l10n),
                  onSelected: (s) => setState(() => _query = ImageQuery(sort: s, galleryId: _query.galleryId)),
                ),
              ),
            if (value.current case final state?)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                  child: Text(
                    context.l10n.imagesCount(state.totalCount),
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ),
              ),
            PagedSliver<ImageItem>(
              value: value,
              emptyMessage: context.l10n.imagesEmpty,
              emptyIcon: Icons.image_outlined,
              padding: const EdgeInsets.symmetric(horizontal: 2),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 140,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
              ),
              onRetry: () => ref.invalidate(provider),
              onLoadMore: () => ref.read(provider.notifier).loadMore(),
              itemBuilder: (context, image) => GestureDetector(
                onTap: () {
                  final items = ref.read(provider).current?.items ?? const [];
                  Navigator.of(context, rootNavigator: true).push(MaterialPageRoute<void>(
                    builder: (_) => ImageViewerPage(query: _query, initialIndex: items.indexOf(image)),
                  ));
                },
                child: Semantics(
                  label: image.title,
                  button: true,
                  child: StashImage(image.thumbnailUrl, fallbackIcon: Icons.image_outlined),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
