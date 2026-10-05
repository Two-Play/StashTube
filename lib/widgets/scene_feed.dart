import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/list_queries.dart';
import '../data/models/scene.dart';
import '../core/utils/format.dart';
import '../data/models/saved_filter.dart';
import '../data/providers.dart';
import 'chip_bar.dart';
import 'paged_sliver.dart';
import 'scene_card.dart';
import 'scene_filter_sheet.dart';

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
    this.sorts = SceneSort.values,
    this.layout = SceneFeedLayout.cards,
    this.showCount = false,
    this.refreshable = true,
    this.filterable = false,
    this.showSavedFilters = false,
    this.physics,
    this.emptyMessage = 'No scenes found',
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
  final String emptyMessage;

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
        content: Text('"${saved.name}": ignored unsupported criteria (${saved.unsupportedCriteria.join(', ')})'),
      ));
    }
  }

  @override
  void didUpdateWidget(SceneFeedView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // A changed filter from the parent (e.g. a toggle) keeps the chosen sort.
    if (oldWidget.initialQuery != widget.initialQuery) _query = widget.initialQuery.copyWith(sort: _query.sort);
  }

  @override
  Widget build(BuildContext context) {
    final provider = sceneListProvider(_query);
    final value = ref.watch(provider);

    final list = LoadMoreListener(
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
                          tooltip: 'Filter',
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
                        labelOf: (s) => s.label,
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
            if (widget.showCount && value.value != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                  child: Text(
                    '${formatNumber(value.requireValue.totalCount)} scenes',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
              ),
            PagedSliver<Scene>(
              value: value,
              emptyMessage: widget.emptyMessage,
              onRetry: () => ref.invalidate(provider),
              onLoadMore: () => ref.read(provider.notifier).loadMore(),
              padding: widget.layout == SceneFeedLayout.grid ? const EdgeInsets.symmetric(horizontal: 12) : EdgeInsets.zero,
              gridDelegate: widget.layout == SceneFeedLayout.grid
                  ? const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 240,
                      childAspectRatio: 0.95,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                    )
                  : null,
              itemBuilder: (_, scene) => switch (widget.layout) {
                SceneFeedLayout.cards => SceneCard(scene: scene),
                SceneFeedLayout.list => SceneListTile(scene: scene),
                SceneFeedLayout.grid => SceneGridTile(scene: scene),
              },
            ),
          ],
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
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final filter = filters[i];
          return FilterChip(
            avatar: const Icon(Icons.bookmark_outline, size: 16),
            label: Text(filter.name),
            selected: filter.id == activeId,
            onSelected: (_) => onSelected(filter),
          );
        },
      ),
    );
  }
}
