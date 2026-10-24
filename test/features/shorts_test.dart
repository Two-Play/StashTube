import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/data/models/marker.dart';
import 'package:stash_app_mobile/data/models/page_result.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/models/scene_filter.dart';
import 'package:stash_app_mobile/data/models/tag.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/features/shell/nav_bar_config.dart';
import 'package:stash_app_mobile/features/shell/navigation.dart';
import 'package:stash_app_mobile/features/shorts/short.dart';
import 'package:stash_app_mobile/features/shorts/shorts_feed.dart';
import 'package:stash_app_mobile/features/shorts/shorts_settings.dart';

import '../helpers.dart';

Scene _scene(String id) => Scene(id: id, title: id, streamUrl: 'http://s/$id');

List<Scene> _scenes(String prefix, int count) => [for (var i = 0; i < count; i++) _scene('$prefix$i')];

List<Short> _shorts(String prefix, int count) => [for (final s in _scenes(prefix, count)) Short.video(s)];

Marker _marker(String id, {double seconds = 30, double? end, double duration = 600}) => Marker(
  id: id,
  title: 'Marker $id',
  seconds: seconds,
  endSeconds: end,
  tag: const Tag(id: '1', name: 'Beach'),
  scene: Scene(id: 's$id', title: 'Scene $id', streamUrl: 'http://s/s$id', duration: duration),
);

/// Tagged scenes are `t<n>`, all others `o<n>`, markers `marker:m<n>`;
/// pages of [perPage].
class _ShortsRepository implements StashRepository {
  _ShortsRepository({this.tagged = 10, this.others = 10, this.markers = 0});

  final int tagged;
  final int others;
  final int markers;
  final queries = <SceneQuery>[];
  final markerQueries = <MarkerQuery>[];
  final pages = <int>[];
  final markerPages = <int>[];
  bool failNext = false;

  /// Thrown by every marker query.
  Object? markerError;

  @override
  Future<PageResult<Scene>> findScenes(SceneQuery query, {int page = 1, int perPage = 24}) async {
    queries.add(query);
    pages.add(page);
    if (failNext) {
      failNext = false;
      throw const StashApiException('offline', isNetworkError: true);
    }
    final isTagged = query.filter.tags.isNotEmpty;
    final all = _scenes(isTagged ? 't' : 'o', isTagged ? tagged : others);
    return PageResult(items: all.skip((page - 1) * perPage).take(perPage).toList(), totalCount: all.length);
  }

  @override
  Future<PageResult<Marker>> findMarkers(MarkerQuery query, {int page = 1, int perPage = 24}) async {
    markerQueries.add(query);
    markerPages.add(page);
    if (markerError case final error?) throw error;
    final all = [for (var i = 0; i < markers; i++) _marker('m$i')];
    return PageResult(items: all.skip((page - 1) * perPage).take(perPage).toList(), totalCount: all.length);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<ProviderContainer> _container(_ShortsRepository repo, [ShortsSettings? settings]) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final c = ProviderContainer(
    overrides: [
      ...testServer,
      sharedPreferencesProvider.overrideWithValue(prefs),
      stashRepositoryProvider.overrideWithValue(repo),
    ],
  );
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
        ..addPreferred(_shorts('t', 6))
        ..addOthers(_shorts('o', 6));
      expect(mixer.take(8).map((s) => s.key), ['t0', 't1', 't2', 'o0', 't3', 't4', 't5', 'o1']);
    });

    test('skips videos that were already shown', () {
      final mixer = ShortsMixer(hasPreferred: true, hasOthers: true)
        ..addPreferred([
          for (final id in ['a', 'b', 'c']) Short.video(_scene(id)),
        ])
        ..addOthers([
          for (final id in ['a', 'd']) Short.video(_scene(id)),
        ]);
      expect(mixer.take(4).map((s) => s.key), ['a', 'b', 'c', 'd']);
    });

    test('waits for the next page of the source whose turn it is', () {
      final mixer = ShortsMixer(hasPreferred: true, hasOthers: true)
        ..addPreferred(_shorts('t', 1))
        ..addOthers(_shorts('o', 5));
      expect(mixer.take(5).map((s) => s.key), ['t0']);
      expect(mixer.needsPreferred, isTrue);
    });

    test('continues with the other source when one runs out', () {
      final mixer = ShortsMixer(hasPreferred: true, hasOthers: true)
        ..addPreferred(_shorts('t', 1))
        ..addOthers(_shorts('o', 3))
        ..preferredDone = true
        ..othersDone = true;
      expect(mixer.take(10).map((s) => s.key), ['t0', 'o0', 'o1', 'o2']);
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

      final reloaded = ProviderContainer(
        overrides: [...testServer, sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(reloaded.dispose);
      final settings = reloaded.read(shortsSettingsProvider);
      expect(settings.tags.single.name, 'Beach');
      expect(settings.onlyTags, isTrue);
      expect(settings.length, ShortsLength.oneMinute);
      expect(settings.portraitOnly, isTrue);
    });

    test('unreadable values fall back to the defaults', () {
      expect(ShortsSettings.fromJson({'length': 'forever', 'tags': 'x', 'markers': 'some'}), const ShortsSettings());
    });

    test('keep the marker choice', () {
      const settings = ShortsSettings(markers: ShortsMarkers.only);
      expect(ShortsSettings.fromJson(settings.toJson()), settings);
      expect(settings, isNot(const ShortsSettings()));
    });
  });

  group('markers in the shorts', () {
    test('a marker plays from its start to its end, by default 20 s', () {
      final short = Short.marker(_marker('1', seconds: 30));
      expect(short.key, 'marker:1', reason: 'apart from its scene as a short video');
      expect(short.start, const Duration(seconds: 30));
      expect(short.end, const Duration(seconds: 50));
      expect(short.duration, 20);
      expect(Short.marker(_marker('2', seconds: 30, end: 42)).end, const Duration(seconds: 42));
      expect(Short.marker(_marker('3', seconds: 590)).end, const Duration(seconds: 600), reason: 'not past the scene');
      expect(Short.video(_scene('a')).start, isNull);
    });

    test('marker queries filter by any of the tags', () {
      expect(MarkerQuery().toMarkerFilter(), isNull);
      expect(MarkerQuery(tagIds: ['1', '2']).toMarkerFilter(), {
        'tags': {
          'value': ['1', '2'],
          'modifier': 'INCLUDES',
          'depth': 0,
        },
      });
      expect(MarkerQuery(tagIds: ['1'], seed: 3), MarkerQuery(tagIds: ['1'], seed: 3));
      expect(MarkerQuery(tagIds: ['1'], seed: 3), isNot(MarkerQuery(tagIds: ['2'], seed: 3)));
    });

    test('off by default: no markers are loaded', () async {
      final repo = _ShortsRepository(markers: 5);
      final c = await _container(repo);
      await _loaded(c);
      expect(repo.markerQueries, isEmpty);
    });

    test('"only markers" shows random markers with the chosen tags', () async {
      final repo = _ShortsRepository(markers: 3);
      final c = await _container(repo, const ShortsSettings(tags: [beach], markers: ShortsMarkers.only));
      final feed = await _loaded(c);
      expect(feed.items.map((s) => s.key), ['marker:m0', 'marker:m1', 'marker:m2']);
      expect(feed.hasMore, isFalse);
      expect(repo.queries, isEmpty, reason: 'no whole videos');
      final query = repo.markerQueries.single;
      expect(query.sort, MarkerSort.random);
      expect(query.tagIds, ['1']);
    });

    test('"with videos" takes turns, then continues with what is left', () async {
      final c = await _container(
        _ShortsRepository(others: 4, markers: 2),
        const ShortsSettings(markers: ShortsMarkers.mixed),
      );
      expect((await _loaded(c)).items.map((s) => s.key), ['o0', 'marker:m0', 'o1', 'marker:m1', 'o2', 'o3']);
    });

    test('"portrait videos only" applies to the markers, the length does not', () {
      final query = const ShortsSettings(tags: [beach], markers: ShortsMarkers.mixed, length: ShortsLength.oneMinute)
          .markerQuery!;
      expect(query.portraitOnly, isTrue);
      expect(query.toMarkerFilter(), {
        'scene_filter': {
          'orientation': {
            'value': ['PORTRAIT'],
          },
        },
        'tags': {
          'value': ['1'],
          'modifier': 'INCLUDES',
          'depth': 0,
        },
      });
      expect(
        const ShortsSettings(markers: ShortsMarkers.only, portraitOnly: false).markerQuery!.toMarkerFilter(),
        isNull,
      );
      // A studio's markers in portrait videos: one scene filter.
      expect(MarkerQuery(studioId: '4', includeSubStudios: true, portraitOnly: true).toMarkerFilter(), {
        'scene_filter': {
          'studios': {
            'value': ['4'],
            'modifier': 'INCLUDES',
            'depth': -1,
          },
          'orientation': {
            'value': ['PORTRAIT'],
          },
        },
      });
      expect(MarkerQuery(portraitOnly: true, seed: 1), isNot(MarkerQuery(seed: 1)));
    });

    test('the stored content choice reads as before', () {
      for (final (stored, markers) in [
        ('off', ShortsMarkers.off),
        ('mixed', ShortsMarkers.mixed),
        ('only', ShortsMarkers.only),
      ]) {
        expect(ShortsSettings.fromJson({'markers': stored}).markers, markers);
      }
    });

    test('a server rejecting the marker query leaves the videos', () async {
      final repo = _ShortsRepository(others: 3, markers: 2)
        ..markerError = const StashApiException('Unknown field orientation');
      final c = await _container(repo, const ShortsSettings(markers: ShortsMarkers.mixed));
      final feed = await _loaded(c);
      expect(feed.error, isNull);
      expect(feed.items.map((s) => s.key), ['o0', 'o1', 'o2']);
      expect(feed.hasMore, isFalse);
      expect(repo.markerQueries, hasLength(1), reason: 'not asked again');
    });

    test('only markers show the server error', () async {
      final repo = _ShortsRepository(markers: 2)..markerError = const StashApiException('Unknown field orientation');
      final c = await _container(repo, const ShortsSettings(markers: ShortsMarkers.only));
      final feed = await _loaded(c);
      expect(feed.items, isEmpty);
      expect(feed.error, isA<StashApiException>());
    });

    test('without a connection the mixed feed shows the error', () async {
      final repo = _ShortsRepository(others: 3, markers: 2)
        ..markerError = const StashApiException('offline', isNetworkError: true);
      final c = await _container(repo, const ShortsSettings(markers: ShortsMarkers.mixed));
      expect((await _loaded(c)).error, isA<StashApiException>());
    });

    test('performer shorts leave the markers out', () async {
      final repo = _ShortsRepository(others: 2, markers: 2);
      final c = await _container(repo, const ShortsSettings(markers: ShortsMarkers.only));
      final provider = shortsFeedFamily(const ShortsSource.performer('7'));
      c.listen(provider, (_, _) {});
      for (var i = 0; i < 20 && c.read(provider).isLoading; i++) {
        await Future<void>.delayed(Duration.zero);
      }
      expect(c.read(provider).items.map((s) => s.key), ['o0', 'o1']);
      expect(repo.markerQueries, isEmpty);
    });
  });

  group('shorts feed', () {
    test('without tags shows short portrait videos', () async {
      final repo = _ShortsRepository();
      final c = await _container(repo);
      final feed = await _loaded(c);
      expect(feed.items.map((s) => s.key), _scenes('o', 10).map((s) => s.id));
      expect(feed.hasMore, isFalse);
      final query = repo.queries.single;
      expect(query.sort, SceneSort.random);
      expect(query.filter.portraitOnly, isTrue);
      expect(query.filter.maxSeconds, 180);
    });

    test('mixes the chosen tags in more often', () async {
      final c = await _container(_ShortsRepository(tagged: 6, others: 4), const ShortsSettings(tags: [beach]));
      final ids = (await _loaded(c)).items.map((s) => s.key).toList();
      expect(ids.take(4), ['t0', 't1', 't2', 'o0']);
      expect(ids, hasLength(10));
    });

    test('with "only these tags" leaves the others out', () async {
      final repo = _ShortsRepository(tagged: 3);
      final c = await _container(repo, const ShortsSettings(tags: [beach], onlyTags: true));
      expect((await _loaded(c)).items.map((s) => s.key), ['t0', 't1', 't2']);
      expect(repo.queries.every((q) => q.filter.tags.isNotEmpty), isTrue);
    });

    test('loads further pages', () async {
      final c = await _container(_ShortsRepository(others: 30));
      expect((await _loaded(c)).items, hasLength(24));
      await c.read(shortsFeedProvider.notifier).loadMore();
      expect(c.read(shortsFeedProvider).items, hasLength(30));
    });

    test('loads a failed page again instead of skipping it', () async {
      final repo = _ShortsRepository(others: 30);
      final c = await _container(repo);
      expect((await _loaded(c)).items, hasLength(24));

      repo.failNext = true;
      await c.read(shortsFeedProvider.notifier).loadMore();
      expect(c.read(shortsFeedProvider).error, isNotNull);
      expect(c.read(shortsFeedProvider).items, hasLength(24));

      await c.read(shortsFeedProvider.notifier).loadMore();
      expect(repo.pages, [1, 2, 2]);
      expect(c.read(shortsFeedProvider).items, hasLength(30));
    });
  });

  group('performer shorts', () {
    test('only the performer\'s short videos, without the tag preference', () async {
      final repo = _ShortsRepository(tagged: 0, others: 5);
      final c = await _container(repo, const ShortsSettings(tags: [beach], onlyTags: true));
      final provider = shortsFeedFamily(const ShortsSource.performer('7', title: 'Alice'));
      c.listen(provider, (_, _) {});
      for (var i = 0; i < 20 && c.read(provider).isLoading; i++) {
        await Future<void>.delayed(Duration.zero);
      }
      expect(c.read(provider).items, hasLength(5));
      final query = repo.queries.single;
      expect(query.performerId, '7');
      expect(query.sort, SceneSort.random);
      expect(query.filter.tags, isEmpty);
      expect(query.filter.maxSeconds, ShortsLength.threeMinutes.maxSeconds);
      expect(query.filter.portraitOnly, isTrue);
    });

    test('counts the performer\'s shorts for the channel button', () async {
      final repo = _ShortsRepository(others: 4);
      final c = await _container(repo);
      expect(await c.read(performerShortsCountProvider('7').future), 4);
      expect(repo.queries.single.performerId, '7');
    });

    test('feeds are kept apart by source', () {
      expect(const ShortsSource.performer('7', title: 'A'), const ShortsSource.performer('7'));
      expect(const ShortsSource.feed(), isNot(const ShortsSource.performer('7')));
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
    // Five stored tabs: the last hideable one makes room for "You".
    expect(config.visible, [AppTab.home, AppTab.performers, AppTab.studios, AppTab.library, AppTab.you]);
    expect(config.isVisible(AppTab.shorts), isFalse);
    expect(NavBarConfig.standard.isVisible(AppTab.shorts), isTrue, reason: 'only stored bars start without it');
  });

  group('a markers grid as shorts', () {
    Future<ShortsFeedState> loaded(ProviderContainer c, ShortsSource source) async {
      final provider = shortsFeedFamily(source);
      c.listen(provider, (_, _) {});
      for (var i = 0; i < 20 && c.read(provider).isLoading; i++) {
        await Future<void>.delayed(Duration.zero);
      }
      return c.read(provider);
    }

    test('plays exactly the grid\'s markers, without the shorts settings', () async {
      final repo = _ShortsRepository(others: 5, markers: 30);
      final c = await _container(
        repo,
        const ShortsSettings(tags: [beach], markers: ShortsMarkers.off, length: ShortsLength.oneMinute),
      );
      final grid = MarkerQuery(sort: MarkerSort.title, performerId: '7');
      final feed = await loaded(c, ShortsSource.markers(grid));
      expect(feed.items.map((s) => s.key), [for (var i = 0; i < 24; i++) 'marker:m$i']);
      expect(feed.hasMore, isTrue);
      expect(repo.queries, isEmpty, reason: 'no videos');
      expect(repo.markerQueries.single, same(grid), reason: 'the grid\'s filter and sort, no portrait');
    });

    test('starts at the page of the tapped marker', () async {
      final repo = _ShortsRepository(markers: 30);
      final c = await _container(repo);
      final feed = await loaded(c, ShortsSource.markers(MarkerQuery(), startPage: 2));
      expect(repo.markerPages, [2]);
      expect(feed.items.map((s) => s.key), [for (var i = 24; i < 30; i++) 'marker:m$i']);
      expect(feed.hasMore, isFalse);
    });

    test('sources are equal by their query and page', () {
      final query = MarkerQuery(sort: MarkerSort.random, seed: 5, tagIds: ['1']);
      expect(
        ShortsSource.markers(query, title: 'a'),
        ShortsSource.markers(MarkerQuery(sort: MarkerSort.random, seed: 5, tagIds: ['1'])),
      );
      expect(ShortsSource.markers(query), isNot(ShortsSource.markers(query, startPage: 2)));
      expect(ShortsSource.markers(query), isNot(const ShortsSource.feed()));
      expect(ShortsSource.markers(query).isFeed, isFalse);
    });

    test('the tapped marker\'s place in the shorts', () {
      Marker unplayable(String id) => Marker(
        id: id,
        title: id,
        seconds: 0,
        tag: const Tag(id: '1', name: 'Beach'),
        scene: Scene(id: 's$id', title: id),
      );
      final items = [for (var i = 0; i < 30; i++) i == 25 ? unplayable('x') : _marker('m$i')];
      expect(markerShortsStart(items, 3), (startPage: 1, initialIndex: 3));
      expect(markerShortsStart(items, 27), (startPage: 2, initialIndex: 2), reason: 'm25 cannot play');
      // Numbered pages: the grid shows only its page.
      expect(markerShortsStart(items.sublist(0, 10), 4, page: 3), (startPage: 3, initialIndex: 4));
    });
  });
}
