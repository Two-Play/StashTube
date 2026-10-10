import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/page_result.dart';
import '../config/server_config.dart';
import 'paging_mode.dart';

class PagedState<T> {
  const PagedState({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.perPage,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  final List<T> items;
  final int totalCount;

  /// Last page that was loaded (1-based).
  final int page;
  final int perPage;
  final bool isLoadingMore;
  final Object? loadMoreError;

  // Based on pages, not items.length, because repositories may drop items
  // client-side (e.g. the currently playing scene).
  bool get hasMore => page * perPage < totalCount;

  int get pageCount => totalCount <= 0 ? 1 : (totalCount + perPage - 1) ~/ perPage;

  PagedState<T> copyWith({
    List<T>? items,
    int? totalCount,
    int? page,
    bool? isLoadingMore,
    Object? loadMoreError,
  }) =>
      PagedState(
        items: items ?? this.items,
        totalCount: totalCount ?? this.totalCount,
        page: page ?? this.page,
        perPage: perPage,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        loadMoreError: loadMoreError,
      );
}

extension PagedValue<T> on AsyncValue<PagedState<T>> {
  /// The list to show, or null to show loading/error instead.
  ///
  /// Unlike [AsyncValue.value] this drops the previous list when the
  /// provider rebuilds because a dependency changed ([isReloading]) – for
  /// paged lists that is a server switch, whose old items must not stay on
  /// screen – and when loading failed. A pull-to-refresh ([isRefreshing])
  /// keeps showing the list while it reloads.
  PagedState<T>? get current => isReloading || hasError ? null : value;
}

/// Base for paged lists: loads page 1 in [build], then either appends
/// further pages via [loadMore] (infinite scrolling) or shows one page at a
/// time via [goToPage] ([PagingMode.pages]).
///
/// Used with `AsyncNotifierProvider.autoDispose.family`; the family argument
/// arrives through the constructor (Riverpod 3).
abstract class PagedNotifier<T, A> extends AsyncNotifier<PagedState<T>> {
  PagedNotifier(this._arg);

  final A _arg;

  static const pageSize = 24;

  Future<PageResult<T>> fetchPage(A arg, int page, int perPage);

  @override
  Future<PagedState<T>> build() async {
    // Subclasses read the repository in fetchPage (also used by loadMore,
    // outside build), so watch the server here: switching servers reloads
    // every list, even ones the UI keeps subscribed during the switch.
    ref.watch(serverConfigProvider);
    // Switching the paging mode starts the list over on page 1.
    ref.watch(pagingModeProvider);
    final result = await fetchPage(_arg, 1, pageSize);
    return PagedState(items: result.items, totalCount: result.totalCount, page: 1, perPage: pageSize);
  }

  /// Loads the next page. After a failed page only with [retry] (the "try
  /// again" button), so scrolling doesn't fire a request per scroll event.
  Future<void> loadMore({bool retry = false}) async {
    if (ref.read(pagingModeProvider) == PagingMode.pages) return;
    final current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore || state.isLoading) return;
    if (current.loadMoreError != null && !retry) return;

    final loading = current.copyWith(isLoadingMore: true);
    state = AsyncData(loading);
    try {
      final next = current.page + 1;
      final result = await fetchPage(_arg, next, pageSize);
      // Disposed, or refreshed meanwhile so this page belongs to the old list.
      if (!ref.mounted || !identical(state.value, loading)) return;
      state = AsyncData(current.copyWith(
        items: [...current.items, ...result.items],
        totalCount: result.totalCount,
        page: next,
        isLoadingMore: false,
      ));
    } catch (e) {
      if (!ref.mounted || !identical(state.value, loading)) return;
      state = AsyncData(current.copyWith(isLoadingMore: false, loadMoreError: e));
    }
  }

  /// Replaces the shown page with [page] ([PagingMode.pages]).
  Future<void> goToPage(int page) async {
    final current = state.value;
    if (current == null || current.isLoadingMore || state.isLoading) return;
    if (page < 1 || page > current.pageCount || page == current.page) return;

    final loading = current.copyWith(isLoadingMore: true);
    state = AsyncData(loading);
    try {
      final result = await fetchPage(_arg, page, pageSize);
      if (!ref.mounted || !identical(state.value, loading)) return;
      state = AsyncData(current.copyWith(
        items: result.items,
        totalCount: result.totalCount,
        page: page,
        isLoadingMore: false,
      ));
    } catch (e) {
      if (!ref.mounted || !identical(state.value, loading)) return;
      state = AsyncData(current.copyWith(isLoadingMore: false, loadMoreError: e));
    }
  }
}
