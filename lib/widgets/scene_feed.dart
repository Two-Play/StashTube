import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/list_queries.dart';
import '../data/models/scene.dart';
import '../core/utils/format.dart';
import '../data/providers.dart';
import 'chip_bar.dart';
import 'paged_sliver.dart';
import 'scene_card.dart';

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
            if (widget.sorts.length > 1)
              SliverToBoxAdapter(
                child: ChipBar<SceneSort>(
                  values: widget.sorts,
                  selected: _query.sort,
                  labelOf: (s) => s.label,
                  onSelected: (s) => setState(() => _query = _query.copyWith(sort: s)),
                ),
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
