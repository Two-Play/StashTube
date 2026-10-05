import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/data/models/page_result.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/providers.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';

class FakeRepository implements StashRepository {
  FakeRepository(this.total);

  final int total;
  final requestedPages = <int>[];
  bool failNext = false;

  @override
  Future<PageResult<Scene>> findScenes(SceneQuery query, {int page = 1, int perPage = 24}) async {
    requestedPages.add(page);
    if (failNext) {
      failNext = false;
      throw const StashApiException('boom');
    }
    final start = (page - 1) * perPage;
    final end = (start + perPage).clamp(0, total);
    return PageResult(
      items: [for (var i = start; i < end; i++) Scene(id: '$i', title: 'Scene $i')],
      totalCount: total,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late FakeRepository repo;
  late ProviderContainer container;
  final query = SceneQuery();

  setUp(() {
    repo = FakeRepository(50);
    container = ProviderContainer(overrides: [stashRepositoryProvider.overrideWithValue(repo)]);
    // Keep the auto-dispose provider alive for the test.
    container.listen(sceneListProvider(query), (_, __) {});
  });

  tearDown(() => container.dispose());

  test('loads pages until totalCount is reached', () async {
    final notifier = container.read(sceneListProvider(query).notifier);
    var state = await container.read(sceneListProvider(query).future);
    expect(state.items, hasLength(24));
    expect(state.hasMore, isTrue);

    await notifier.loadMore();
    await notifier.loadMore();
    state = container.read(sceneListProvider(query)).requireValue;
    expect(state.items, hasLength(50));
    expect(state.hasMore, isFalse);

    await notifier.loadMore();
    expect(repo.requestedPages, [1, 2, 3], reason: 'no request past the last page');
  });

  test('keeps loaded items and exposes the error when loading more fails', () async {
    final notifier = container.read(sceneListProvider(query).notifier);
    await container.read(sceneListProvider(query).future);

    repo.failNext = true;
    await notifier.loadMore();
    var state = container.read(sceneListProvider(query)).requireValue;
    expect(state.items, hasLength(24));
    expect(state.loadMoreError, isA<StashApiException>());

    await notifier.loadMore();
    state = container.read(sceneListProvider(query)).requireValue;
    expect(state.items, hasLength(48));
    expect(state.loadMoreError, isNull);
  });
}
