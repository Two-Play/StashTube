import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/page_result.dart';

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

/// Base for infinite lists: loads page 1 in [build], further pages via [loadMore].
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
    final result = await fetchPage(_arg, 1, pageSize);
    return PagedState(items: result.items, totalCount: result.totalCount, page: 1, perPage: pageSize);
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore || state.isLoading) return;

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
}
