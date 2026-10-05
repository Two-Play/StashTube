/// One page of a paginated Stash `find*` query.
class PageResult<T> {
  const PageResult({required this.items, required this.totalCount});

  final List<T> items;

  /// Total number of matching items on the server (not just this page).
  final int totalCount;
}
