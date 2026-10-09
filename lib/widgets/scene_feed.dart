import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/haptics.dart';
import '../data/models/list_queries.dart';
import '../data/models/scene.dart';
import '../data/models/saved_filter.dart';
import '../data/providers.dart';
import 'auto_preview.dart';
import 'chip_bar.dart';
import 'paged_sliver.dart';
import 'scene_card.dart';
import 'scene_filter_sheet.dart';
import '../l10n/l10n.dart';

enum SceneFeedLayout {
  /// Full-width YouTube cards ([SceneCard]).
  cards,

  /// Compact rows ([SceneListTile]).
  list,

  /// Dense thumbnail grid ([SceneGridTile]).
  grid,
}

/// A scrollable, refreshable, infinitely loading scene feed with sort chips.
///
/// [headerSlivers] are placed above the chips (app bar, channel header, ...).
class SceneFeedView extends ConsumerStatefulWidget {
  const SceneFeedView({
    super.key,
    required this.initialQuery,
    this.headerSlivers = const [],
    this.sorts = SceneSort.feed,
    this.layout = SceneFeedLayout.cards,
    this.showCount = false,
    this.refreshable = true,
    this.filterable = false,
    this.showSavedFilters = false,
    this.physics,
    this.emptyMessage,
    this.emptyIcon = Icons.movie_outlined,
    this.emptyHint,
    this.onRefresh,
  });

  final SceneQuery initialQuery;
  final List<Widget> headerSlivers;
  final List<SceneSort> sorts;

  final SceneFeedLayout layout;

  /// Show the total number of matching scenes above the list.
  final bool showCount;

  /// Pull-to-refresh; off where a downward swipe means something else
  /// (e.g. minimizing the player).
  final bool refreshable;

  /// Show a filter button (tags, rating, duration, quality) before the sort chips.
  final bool filterable;

  /// Show the user's saved Stash scene filters as a chip row.
  final bool showSavedFilters;

  /// Scroll physics; defaults to always-scrollable platform physics.
  final ScrollPhysics? physics;
  final String? emptyMessage;
  final IconData emptyIcon;
  final String? emptyHint;

  /// Called on pull-to-refresh in addition to reloading the feed, e.g. to
  /// reload content in [headerSlivers].
  final VoidCallback? onRefresh;

  @override
  ConsumerState<SceneFeedView> createState() => _SceneFeedViewState();
}

class _SceneFeedViewState extends ConsumerState<SceneFeedView> {
  late SceneQuery _query = widget.initialQuery;
  String? _savedFilterId;

  Future<void> _openFilters() async {
    final next = await showSceneFilterSheet(context, _query.filter);
    if (next != null && mounted) setState(() => _query = _query.copyWith(filter: next));
  }

  /// Applies a saved filter's criteria, search and sort; tapping the active
  /// one again turns it off.
  void _toggleSavedFilter(SavedFilter saved) {
    Haptics.selection();
    if (_savedFilterId == saved.id) {
      setState(() {
        _savedFilterId = null;
        _query = _query.copyWith(filter: _query.filter.copyWith(clearSavedFilter: true), clearSearch: true);
      });
      return;
    }
    final sortField = saved.sort ?? '';
    final sort = sortField.startsWith('random')
        ? SceneSort.random
        : SceneSort.values.where((s) => s.field == sortField).firstOrNull;
    setState(() {
      _savedFilterId = saved.id;
      _query = _query.copyWith(
        sort: sort,
        filter: _query.filter.copyWith(savedFilter: saved.sceneFilter),
        search: saved.search,
        clearSearch: saved.search == null,
      );
    });
    if (saved.unsupportedCriteria.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(context.l10n.savedFilterUnsupported(saved.name, saved.unsupportedCriteria.join(', '))),
      ));
    }
  }

  @override
  void didUpdateWidget(SceneFeedView oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = widget.initialQuery;
    if (oldWidget.initialQuery == next) return;
    if (oldWidget.initialQuery.copyWith(search: next.search, clearSearch: next.search == null) == next) {
      // A new search term (the search page) keeps the chosen sort and filters.
      _query = _query.copyWith(search: next.search, clearSearch: next.search == null);
    } else {
      // A changed filter from the parent (e.g. a toggle) keeps the chosen sort.
      _query = next.copyWith(sort: _query.sort);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = sceneListProvider(_query);
    final value = ref.watch(provider);

    // The first fully shown video plays its preview once scrolling stops.
    final list = AutoPreviewScope(
      child: LoadMoreListener(
      onLoadMore: () => ref.read(provider.notifier).loadMore(),
      child: CustomScrollView(
          // Pull-to-refresh must work even when the list is shorter than the screen.
          physics: widget.physics ?? const AlwaysScrollableScrollPhysics(),
          slivers: [
            ...widget.headerSlivers,
            if (widget.sorts.length > 1 || widget.filterable)
              SliverToBoxAdapter(
                child: Row(
                  children: [
                    if (widget.filterable)
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
                      child: ChipBar<SceneSort>(
                        values: widget.sorts,
                        selected: _query.sort,
                        labelOf: (s) => s.label(context.l10n),
                        onSelected: (s) => setState(() => _query = _query.copyWith(sort: s)),
                      ),
                    ),
                  ],
                ),
              ),
            if (widget.showSavedFilters)
              SliverToBoxAdapter(
                child: _SavedFilterChips(activeId: _savedFilterId, onSelected: _toggleSavedFilter),
              ),
            if (widget.showCount && value.current != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                  child: Text(
                    context.l10n.scenesCount(value.current!.totalCount),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
              ),
            PagedSliver<Scene>(
              value: value,
              emptyMessage: widget.emptyMessage ?? context.l10n.scenesEmpty,
              emptyIcon: widget.emptyIcon,
              emptyHint: widget.emptyHint,
              onRetry: () => ref.invalidate(provider),
              onLoadMore: () => ref.read(provider.notifier).loadMore(),
              onGoToPage: (page) => ref.read(provider.notifier).goToPage(page),
              padding: widget.layout == SceneFeedLayout.grid ? const EdgeInsets.symmetric(horizontal: 12) : EdgeInsets.zero,
              gridDelegate: widget.layout == SceneFeedLayout.grid
                  ? const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 240,
                      childAspectRatio: 0.88,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                    )
                  : null,
              // Cards and rows get columns on tablets and in landscape (13.5).
              columnWidth: widget.layout == SceneFeedLayout.list ? 480 : 420,
              itemBuilder: (_, scene) => switch (widget.layout) {
                SceneFeedLayout.cards => SceneCard(scene: scene),
                SceneFeedLayout.list => SceneListTile(scene: scene),
                SceneFeedLayout.grid => SceneGridTile(scene: scene),
              },
            ),
          ],
        ),
    ),
    );
    if (!widget.refreshable) return list;
    return RefreshIndicator(
      edgeOffset: 80,
      onRefresh: () {
        widget.onRefresh?.call();
        return refreshFuture(ref, provider.future);
      },
      child: list,
    );
  }
}

/// Saved Stash scene filters (5.5) as a chip row; hidden when there are none.
class _SavedFilterChips extends ConsumerWidget {
  const _SavedFilterChips({required this.activeId, required this.onSelected});

  final String? activeId;
  final ValueChanged<SavedFilter> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(savedSceneFiltersProvider).value ?? const <SavedFilter>[];
    if (filters.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final filter = filters[i];
          final selected = filter.id == activeId;
          final colors = Theme.of(context).colorScheme;
          return FilterChip(
            avatar: Icon(Icons.bookmark_outline, size: 16, color: selected ? colors.surface : colors.onSurface),
            label: Text(filter.name),
            selected: selected,
            onSelected: (_) => onSelected(filter),
          );
        },
      ),
    );
  }
}
