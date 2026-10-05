import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/format.dart';
import '../../data/models/image_item.dart';
import '../../data/models/list_queries.dart';
import '../../data/providers.dart';
import '../../widgets/chip_bar.dart';
import '../../widgets/paged_sliver.dart';
import '../../widgets/stash_image.dart';
import 'image_viewer_page.dart';

/// All images as an endless thumbnail grid; tapping opens the viewer.
class ImagesTab extends ConsumerStatefulWidget {
  const ImagesTab({super.key});

  @override
  ConsumerState<ImagesTab> createState() => _ImagesTabState();
}

class _ImagesTabState extends ConsumerState<ImagesTab> with AutomaticKeepAliveClientMixin {
  var _query = ImageQuery();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
            SliverToBoxAdapter(
              child: ChipBar<ImageSort>(
                values: ImageSort.values,
                selected: _query.sort,
                labelOf: (s) => s.label,
                onSelected: (s) => setState(() => _query = ImageQuery(sort: s)),
              ),
            ),
            if (value.valueOrNull case final state?)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                  child: Text(
                    '${formatNumber(state.totalCount)} images',
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ),
              ),
            PagedSliver<ImageItem>(
              value: value,
              emptyMessage: 'No images found',
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
                  final items = ref.read(provider).valueOrNull?.items ?? const [];
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
