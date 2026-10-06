import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/data/models/page_result.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/models/scene_filter.dart';
import 'package:stash_app_mobile/data/models/tag.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/features/shell/nav_bar_config.dart';
import 'package:stash_app_mobile/features/shell/navigation.dart';
import 'package:stash_app_mobile/features/shorts/shorts_feed.dart';
import 'package:stash_app_mobile/features/shorts/shorts_settings.dart';

import '../helpers.dart';

Scene _scene(String id) => Scene(id: id, title: id, streamUrl: 'http://s/$id');

List<Scene> _scenes(String prefix, int count) => [for (var i = 0; i < count; i++) _scene('$prefix$i')];

/// Tagged scenes are `t<n>`, all others `o<n>`; pages of [perPage].
class _ShortsRepository implements StashRepository {
  _ShortsRepository({this.tagged = 10, this.others = 10});

  final int tagged;
  final int others;
  final queries = <SceneQuery>[];

  @override
  Future<PageResult<Scene>> findScenes(SceneQuery query, {int page = 1, int perPage = 24}) async {
    queries.add(query);
    final isTagged = query.filter.tags.isNotEmpty;
    final all = _scenes(isTagged ? 't' : 'o', isTagged ? tagged : others);
    return PageResult(items: all.skip((page - 1) * perPage).take(perPage).toList(), totalCount: all.length);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<ProviderContainer> _container(_ShortsRepository repo, [ShortsSettings? settings]) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final c = ProviderContainer(overrides: [
    ...testServer,
    sharedPreferencesProvider.overrideWithValue(prefs),
    stashRepositoryProvider.overrideWithValue(repo),
  ]);
  addTearDown(c.dispose);
  if (settings != null) await c.read(shortsSettingsProvider.notifier).set(settings);
  return c;
}

Future<ShortsFeedState> _loaded(ProviderContainer c) async {
  c.listen(shortsFeedProvider, (_, _) {});
  for (var i = 0; i < 20 && c.read(shortsFeedProvider).isLoading; i++) {
    await Future<void>.delayed(Duration.zero);
  }
  return c.read(shortsFeedProvider);
}

void main() {
  const beach = Tag(id: '1', name: 'Beach');

  group('ShortsMixer', () {
    test('shows three tagged videos, then one other', () {
      final mixer = ShortsMixer(hasPreferred: true, hasOthers: true)
        ..addPreferred(_scenes('t', 6))
        ..addOthers(_scenes('o', 6));
      expect(mixer.take(8).map((s) => s.id), ['t0', 't1', 't2', 'o0', 't3', 't4', 't5', 'o1']);
    });

    test('skips videos that were already shown', () {
      final mixer = ShortsMixer(hasPreferred: true, hasOthers: true)
        ..addPreferred([_scene('a'), _scene('b'), _scene('c')])
        ..addOthers([_scene('a'), _scene('d')]);
      expect(mixer.take(4).map((s) => s.id), ['a', 'b', 'c', 'd']);
    });

    test('waits for the next page of the source whose turn it is', () {
      final mixer = ShortsMixer(hasPreferred: true, hasOthers: true)
        ..addPreferred(_scenes('t', 1))
        ..addOthers(_scenes('o', 5));
      expect(mixer.take(5).map((s) => s.id), ['t0']);
      expect(mixer.needsPreferred, isTrue);
    });

    test('continues with the other source when one runs out', () {
      final mixer = ShortsMixer(hasPreferred: true, hasOthers: true)
        ..addPreferred(_scenes('t', 1))
        ..addOthers(_scenes('o', 3))
        ..preferredDone = true
        ..othersDone = true;
      expect(mixer.take(10).map((s) => s.id), ['t0', 'o0', 'o1', 'o2']);
      expect(mixer.isExhausted, isTrue);
    });
  });

  group('SceneFilter for shorts', () {
    test('any of the tags, portrait, at most a length', () {
      const filter = SceneFilter(tags: [beach], anyTag: true, portraitOnly: true, maxSeconds: 180);
      expect(filter.toCriteria(), {
        'tags': {
          'value': ['1'],
          'modifier': 'INCLUDES',
          'depth': 0,
        },
        'duration': {'value': 181, 'modifier': 'LESS_THAN'},
        'orientation': {
          'value': ['PORTRAIT'],
        },
      });
      expect(filter.isEmpty, isFalse);
      expect(filter, isNot(const SceneFilter(tags: [beach], portraitOnly: true, maxSeconds: 180)));
    });
  });

  group('ShortsSettings', () {
    test('are stored per server', () async {
      final c = await _container(_ShortsRepository());
      await c
          .read(shortsSettingsProvider.notifier)
          .set(const ShortsSettings(tags: [beach], onlyTags: true, length: ShortsLength.oneMinute));
      final prefs = c.read(sharedPreferencesProvider);
      expect(prefs.getString('shorts_settings:test-server'), isNotNull);

      final reloaded = ProviderContainer(overrides: [...testServer, sharedPreferencesProvider.overrideWithValue(prefs)]);
      addTearDown(reloaded.dispose);
      final settings = reloaded.read(shortsSettingsProvider);
      expect(settings.tags.single.name, 'Beach');
      expect(settings.onlyTags, isTrue);
      expect(settings.length, ShortsLength.oneMinute);
      expect(settings.portraitOnly, isTrue);
    });

    test('unreadable values fall back to the defaults', () {
      expect(ShortsSettings.fromJson({'length': 'forever', 'tags': 'x'}), const ShortsSettings());
    });
  });

  group('shorts feed', () {
    test('without tags shows short portrait videos', () async {
      final repo = _ShortsRepository();
      final c = await _container(repo);
      final feed = await _loaded(c);
      expect(feed.items.map((s) => s.id), _scenes('o', 10).map((s) => s.id));
      expect(feed.hasMore, isFalse);
      final query = repo.queries.single;
      expect(query.sort, SceneSort.random);
      expect(query.filter.portraitOnly, isTrue);
      expect(query.filter.maxSeconds, 180);
    });

    test('mixes the chosen tags in more often', () async {
      final c = await _container(_ShortsRepository(tagged: 6, others: 4), const ShortsSettings(tags: [beach]));
      final ids = (await _loaded(c)).items.map((s) => s.id).toList();
      expect(ids.take(4), ['t0', 't1', 't2', 'o0']);
      expect(ids, hasLength(10));
    });

    test('with "only these tags" leaves the others out', () async {
      final repo = _ShortsRepository(tagged: 3);
      final c = await _container(repo, const ShortsSettings(tags: [beach], onlyTags: true));
      expect((await _loaded(c)).items.map((s) => s.id), ['t0', 't1', 't2']);
      expect(repo.queries.every((q) => q.filter.tags.isNotEmpty), isTrue);
    });

    test('loads further pages', () async {
      final c = await _container(_ShortsRepository(others: 30));
      expect((await _loaded(c)).items, hasLength(24));
      await c.read(shortsFeedProvider.notifier).loadMore();
      expect(c.read(shortsFeedProvider).items, hasLength(30));
    });
  });

  test('a tab added in an update starts hidden and keeps the stored bar', () async {
    SharedPreferences.setMockInitialValues({
      'nav_bar_order': ['home', 'performers', 'studios', 'library', 'settings'],
      'nav_bar_hidden': <String>[],
    });
    final prefs = await SharedPreferences.getInstance();
    final c = ProviderContainer(overrides: [sharedPreferencesProvider.overrideWithValue(prefs)]);
    addTearDown(c.dispose);
    final config = c.read(navBarConfigProvider);
    expect(config.visible, [AppTab.home, AppTab.performers, AppTab.studios, AppTab.library, AppTab.stats]);
    expect(config.isVisible(AppTab.shorts), isFalse);
    expect(NavBarConfig.standard.isVisible(AppTab.shorts), isFalse);
  });
}
