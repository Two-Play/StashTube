import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/pagination/paged_notifier.dart';
import 'status_views.dart';

/// Calls [onLoadMore] when the user scrolls near the end of the wrapped scroll view.
class LoadMoreListener extends StatelessWidget {
  const LoadMoreListener({super.key, required this.onLoadMore, required this.child});

  final VoidCallback onLoadMore;
  final Widget child;

  @override
  Widget build(BuildContext context) => NotificationListener<ScrollNotification>(
        onNotification: (n) {
          if (n.metrics.axis == Axis.vertical && n.metrics.extentAfter < 800) onLoadMore();
          return false;
        },
        child: child,
      );
}

/// For `RefreshIndicator.onRefresh`: reloads [future] (e.g. `provider(arg).future`).
Future<void> refreshFuture(WidgetRef ref, Refreshable<Future<Object?>> future) async {
  try {
    final reloaded = ref.refresh(future);
    await reloaded;
  } catch (_) {
    // The error state is rendered by the list itself.
  }
  HapticFeedback.mediumImpact();
}

/// Renders a [PagedState] as slivers: loading / error / empty / items + footer.
class PagedSliver<T> extends StatelessWidget {
  const PagedSliver({
    super.key,
    required this.value,
    required this.itemBuilder,
    required this.onRetry,
    required this.onLoadMore,
    this.emptyMessage = 'Nothing here yet',
    this.gridDelegate,
    this.padding = EdgeInsets.zero,
  });

  final AsyncValue<PagedState<T>> value;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final VoidCallback onRetry;
  final VoidCallback onLoadMore;
  final String emptyMessage;

  /// Renders a grid instead of a list when set.
  final SliverGridDelegate? gridDelegate;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final state = value.valueOrNull;
    if (state == null) {
      if (value.hasError) {
        return SliverToBoxAdapter(child: ErrorView(error: value.error!, onRetry: onRetry));
      }
      return const SliverToBoxAdapter(child: LoadingView());
    }
    if (state.items.isEmpty) {
      return SliverToBoxAdapter(child: EmptyView(message: emptyMessage));
    }

    final delegate = SliverChildBuilderDelegate(
      (context, i) => itemBuilder(context, state.items[i]),
      childCount: state.items.length,
    );
    final grid = gridDelegate;
    return SliverMainAxisGroup(slivers: [
      SliverPadding(
        padding: padding,
        sliver: grid == null
            ? SliverList(delegate: delegate)
            : SliverGrid(delegate: delegate, gridDelegate: grid),
      ),
      SliverToBoxAdapter(child: _Footer(state: state, onLoadMore: onLoadMore)),
    ]);
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.state, required this.onLoadMore});

  final PagedState<Object?> state;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    if (state.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (state.loadMoreError != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: TextButton.icon(
            onPressed: onLoadMore,
            icon: const Icon(Icons.refresh),
            label: const Text('Couldn\'t load more – tap to retry'),
          ),
        ),
      );
    }
    return const SizedBox(height: 24);
  }
}
