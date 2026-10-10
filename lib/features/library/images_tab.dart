import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/image_item.dart';
import '../../data/models/list_queries.dart';
import '../../data/providers.dart';
import '../../widgets/chip_bar.dart';
import '../../widgets/paged_sliver.dart';
import '../../widgets/scene_filter_sheet.dart';
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
      sorts: ImageSort.browse,
      // Searched from the search page (library app bar), not a field of its own.
      searchable: false,
    );
  }
}

/// Endless, refreshable thumbnail grid of images with an optional search
/// field, a filter button (tags, rating, quality; 15.4) and optional sort
/// chips; tapping an image opens [ImageViewerPage] on the same list. Without
/// the field, a changed [initialQuery] search keeps the sort and filters.
class ImageGridView extends ConsumerStatefulWidget {
  const ImageGridView({
    super.key,
    required this.initialQuery,
    this.sorts = const [],
    this.headerSlivers = const [],
    this.searchable = true,
  });

  final ImageQuery initialQuery;
  final List<ImageSort> sorts;
  final List<Widget> headerSlivers;
  final bool searchable;

  @override
  ConsumerState<ImageGridView> createState() => _ImageGridViewState();
}

class _ImageGridViewState extends ConsumerState<ImageGridView> {
  late ImageQuery _query = widget.initialQuery;
  late final _search = TextEditingController(text: widget.initialQuery.search);
  Timer? _debounce;

  @override
  void didUpdateWidget(ImageGridView oldWidget) {
    super.didUpdateWidget(oldWidget);
    final search = widget.initialQuery.search;
    if (oldWidget.initialQuery.search != search) {
      _query = _query.copyWith(search: search, clearSearch: search == null);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _onSearchChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () => _setSearch(text));
    setState(() {}); // Shows or hides the clear button.
  }

  void _setSearch(String text) {
    _debounce?.cancel();
    final search = text.trim();
    if (!mounted || search == (_query.search ?? '')) return;
    setState(() => _query = _query.copyWith(search: search, clearSearch: search.isEmpty));
  }

  Future<void> _openFilters() async {
    final next = await showSceneFilterSheet(context, _query.filter, forImages: true);
    if (next != null && mounted) setState(() => _query = _query.copyWith(filter: next));
  }

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
            if (widget.searchable)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                  child: TextField(
                    controller: _search,
                    textInputAction: TextInputAction.search,
                    onChanged: _onSearchChanged,
                    onSubmitted: _setSearch,
                    decoration: InputDecoration(
                      hintText: context.l10n.searchImages,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _search.text.isEmpty
                          ? null
                          : IconButton(
                              tooltip: context.l10n.clearField,
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                _search.clear();
                                _setSearch('');
                              },
                            ),
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
              ),
            SliverToBoxAdapter(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: IconButton(
                      tooltip: context.l10n.filter,
                      onPressed: _openFilters,
                      icon: Badge(
                        isLabelVisible: _query.filter.activeCount > 0,
                        label: Text('${_query.filter.activeCount}'),
                        child: const Icon(Icons.tune),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ChipBar<ImageSort>(
                      values: widget.sorts.length > 1 ? widget.sorts : const [],
                      selected: _query.sort,
                      labelOf: (s) => s.label(context.l10n),
                      onSelected: (s) => setState(() => _query = _query.copyWith(sort: s)),
                    ),
                  ),
                ],
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
              emptyMessage: _query.search == null && _query.filter.isEmpty
                  ? context.l10n.imagesEmpty
                  : context.l10n.imagesNoMatch,
              emptyIcon: Icons.image_outlined,
              padding: const EdgeInsets.symmetric(horizontal: 2),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 140,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
              ),
              onRetry: () => ref.invalidate(provider),
              onLoadMore: () => ref.read(provider.notifier).loadMore(retry: true),
              onGoToPage: (page) => ref.read(provider.notifier).goToPage(page),
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
