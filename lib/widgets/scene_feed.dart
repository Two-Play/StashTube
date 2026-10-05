import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/list_queries.dart';
import '../data/models/scene.dart';
import '../data/providers.dart';
import 'chip_bar.dart';
import 'paged_sliver.dart';
import 'scene_card.dart';

/// A scrollable, refreshable, infinitely loading scene feed with sort chips.
///
/// [headerSlivers] are placed above the chips (app bar, channel header, ...).
class SceneFeedView extends ConsumerStatefulWidget {
  const SceneFeedView({
    super.key,
    required this.initialQuery,
    this.headerSlivers = const [],
    this.sorts = SceneSort.values,
    this.compact = false,
    this.emptyMessage = 'No scenes found',
  });

  final SceneQuery initialQuery;
  final List<Widget> headerSlivers;
  final List<SceneSort> sorts;

  /// Use [SceneListTile] rows instead of full-width cards.
  final bool compact;
  final String emptyMessage;

  @override
  ConsumerState<SceneFeedView> createState() => _SceneFeedViewState();
}

class _SceneFeedViewState extends ConsumerState<SceneFeedView> {
  late SceneQuery _query = widget.initialQuery;

  @override
  void didUpdateWidget(SceneFeedView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialQuery != widget.initialQuery) _query = widget.initialQuery;
  }

  @override
  Widget build(BuildContext context) {
    final provider = sceneListProvider(_query);
    final value = ref.watch(provider);

    return RefreshIndicator(
      edgeOffset: 80,
      onRefresh: () => refreshFuture(ref, provider.future),
      child: LoadMoreListener(
        onLoadMore: () => ref.read(provider.notifier).loadMore(),
        child: CustomScrollView(
          // Pull-to-refresh must work even when the list is shorter than the screen.
          physics: const AlwaysScrollableScrollPhysics(),
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
            PagedSliver<Scene>(
              value: value,
              emptyMessage: widget.emptyMessage,
              onRetry: () => ref.invalidate(provider),
              onLoadMore: () => ref.read(provider.notifier).loadMore(),
              itemBuilder: (_, scene) =>
                  widget.compact ? SceneListTile(scene: scene) : SceneCard(scene: scene),
            ),
          ],
        ),
      ),
    );
  }
}
