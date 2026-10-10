import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/core/pagination/paging_mode.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/data/models/page_result.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/providers.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';

import '../helpers.dart';

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
    container = ProviderContainer(overrides: [stashRepositoryProvider.overrideWithValue(repo), ...testServer]);
    // Keep the auto-dispose provider alive for the test.
    container.listen(sceneListProvider(query), (_, _) {});
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

    // Scrolling on doesn't retry by itself; the "try again" button does.
    await notifier.loadMore();
    expect(repo.requestedPages, [1, 2], reason: 'no automatic retry after a failed page');

    await notifier.loadMore(retry: true);
    state = container.read(sceneListProvider(query)).requireValue;
    expect(state.items, hasLength(48));
    expect(state.loadMoreError, isNull);
  });

  group('pages mode', () {
    late ProviderContainer pages;

    setUp(() async {
      SharedPreferences.setMockInitialValues({'paging_mode': 'pages'});
      final prefs = await SharedPreferences.getInstance();
      repo.requestedPages.clear(); // the outer container loaded page 1 too
      pages = ProviderContainer(overrides: [
        stashRepositoryProvider.overrideWithValue(repo),
        sharedPreferencesProvider.overrideWithValue(prefs),
        ...testServer,
      ]);
      pages.listen(sceneListProvider(query), (_, _) {});
    });

    tearDown(() => pages.dispose());

    test('shows one page at a time and ignores scrolling to the end', () async {
      expect(pages.read(pagingModeProvider), PagingMode.pages);
      final notifier = pages.read(sceneListProvider(query).notifier);
      var state = await pages.read(sceneListProvider(query).future);
      expect(state.pageCount, 3);

      await notifier.loadMore();
      expect(pages.read(sceneListProvider(query)).requireValue.items, hasLength(24));

      await notifier.goToPage(3);
      state = pages.read(sceneListProvider(query)).requireValue;
      expect(state.page, 3);
      expect(state.items.map((s) => s.id), ['48', '49']);

      await notifier.goToPage(4); // past the end
      expect(pages.read(sceneListProvider(query)).requireValue.page, 3);
      expect(repo.requestedPages, [1, 3]);
    });

    test('switching back to infinite scrolling starts over on page 1', () async {
      final notifier = pages.read(sceneListProvider(query).notifier);
      await pages.read(sceneListProvider(query).future);
      await notifier.goToPage(2);

      await pages.read(pagingModeProvider.notifier).set(PagingMode.infinite);
      final state = await pages.read(sceneListProvider(query).future);
      expect(state.page, 1);
      expect(state.items.first.id, '0');
    });
  });
}
