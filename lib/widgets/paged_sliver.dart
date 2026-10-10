import '../core/config/haptics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Refreshable;

import '../core/pagination/paged_notifier.dart';
import '../core/pagination/paging_mode.dart';
import 'sliver_columns.dart';
import 'status_views.dart';
import '../l10n/l10n.dart';

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
  Haptics.medium();
}

/// Renders a [PagedState] as slivers: loading / error / empty / items + footer.
/// In [PagingMode.pages] the footer is a page bar driving [onGoToPage].
class PagedSliver<T> extends ConsumerWidget {
  const PagedSliver({
    super.key,
    required this.value,
    required this.itemBuilder,
    required this.onRetry,
    required this.onLoadMore,
    this.onGoToPage,
    this.emptyMessage,
    this.emptyIcon = Icons.inbox_outlined,
    this.emptyHint,
    this.gridDelegate,
    this.columnWidth,
    this.padding = EdgeInsets.zero,
  });

  final AsyncValue<PagedState<T>> value;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final VoidCallback onRetry;
  final VoidCallback onLoadMore;

  /// Shows a page (`PagedNotifier.goToPage`); without it the list scrolls
  /// endlessly in either mode.
  final Future<void> Function(int page)? onGoToPage;
  final String? emptyMessage;
  final IconData emptyIcon;
  final String? emptyHint;

  /// Renders a grid instead of a list when set.
  final SliverGridDelegate? gridDelegate;

  /// Without [gridDelegate]: on wide screens the list gets columns of about
  /// this width ([SliverColumns]).
  final double? columnWidth;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = value.current;
    if (state == null) {
      if (value.hasError) {
        return SliverToBoxAdapter(child: ErrorView(error: value.error!, onRetry: onRetry));
      }
      return const SliverToBoxAdapter(child: LoadingView());
    }
    if (state.items.isEmpty) {
      return SliverToBoxAdapter(child: EmptyView(message: emptyMessage ?? context.l10n.emptyDefault, icon: emptyIcon, hint: emptyHint));
    }

    final delegate = SliverChildBuilderDelegate(
      (context, i) => itemBuilder(context, state.items[i]),
      childCount: state.items.length,
    );
    final grid = gridDelegate;
    final columnWidth = this.columnWidth;
    return SliverMainAxisGroup(slivers: [
      SliverPadding(
        padding: padding,
        sliver: grid != null
            ? SliverGrid(delegate: delegate, gridDelegate: grid)
            : columnWidth != null
                ? SliverColumns(
                    itemCount: state.items.length,
                    itemBuilder: (context, i) => itemBuilder(context, state.items[i]),
                    columnWidth: columnWidth,
                  )
                : SliverList(delegate: delegate),
      ),
      SliverToBoxAdapter(
        child: onGoToPage != null && ref.watch(pagingModeProvider) == PagingMode.pages
            ? PageBar(state: state, onGoToPage: onGoToPage!)
            : _Footer(state: state, onLoadMore: onLoadMore),
      ),
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
            label: Text(context.l10n.loadMoreFailed),
          ),
        ),
      );
    }
    return const SizedBox(height: 24);
  }
}

/// First / previous / "Page 3 of 12" / next / last; tapping the page
/// number asks for a page to jump to. Scrolls back to the top once the new
/// page is there.
class PageBar extends StatelessWidget {
  const PageBar({super.key, required this.state, required this.onGoToPage});

  final PagedState<Object?> state;
  final Future<void> Function(int page) onGoToPage;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final page = state.page;
    final count = state.pageCount;
    final busy = state.isLoadingMore;

    Future<void> go(int target) async {
      await onGoToPage(target);
      if (!context.mounted) return;
      final position = Scrollable.maybeOf(context)?.position;
      if (position != null && position.hasPixels) position.jumpTo(position.minScrollExtent);
    }

    Widget button(IconData icon, String tooltip, int target, bool enabled) => IconButton(
          tooltip: tooltip,
          icon: Icon(icon),
          onPressed: enabled && !busy ? () => go(target) : null,
        );

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
        child: Column(
          children: [
            if (state.loadMoreError != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(l.pageLoadFailed, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                button(Icons.first_page, l.firstPage, 1, page > 1),
                button(Icons.chevron_left, l.previousPage, page - 1, page > 1),
                SizedBox(
                  width: 140,
                  child: Center(
                    child: busy
                        ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : TextButton(
                            onPressed: count > 1
                                ? () async {
                                    final target = await _askPage(context, page, count);
                                    if (target != null && target != page) await go(target);
                                  }
                                : null,
                            child: Text(l.pageOf(page, count)),
                          ),
                  ),
                ),
                button(Icons.chevron_right, l.nextPage, page + 1, page < count),
                button(Icons.last_page, l.lastPage, count, page < count),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Asks for a page between 1 and [count]; null if cancelled.
Future<int?> _askPage(BuildContext context, int current, int count) => showDialog<int>(
      context: context,
      builder: (_) => _PageDialog(current: current, count: count),
    );

class _PageDialog extends StatefulWidget {
  const _PageDialog({required this.current, required this.count});

  final int current;
  final int count;

  @override
  State<_PageDialog> createState() => _PageDialogState();
}

class _PageDialogState extends State<_PageDialog> {
  late final _controller = TextEditingController(text: '${widget.current}')
    ..selection = TextSelection(baseOffset: 0, extentOffset: '${widget.current}'.length);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int? get _page {
    final page = int.tryParse(_controller.text.trim());
    return page != null && page >= 1 && page <= widget.count ? page : null;
  }

  void _submit() {
    final page = _page;
    if (page != null) Navigator.pop(context, page);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      title: Text(l.goToPage),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        textInputAction: TextInputAction.go,
        decoration: InputDecoration(helperText: l.pageRange(widget.count)),
        onChanged: (_) => setState(() {}),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
        FilledButton(onPressed: _page == null ? null : _submit, child: Text(l.go)),
      ],
    );
  }
}
