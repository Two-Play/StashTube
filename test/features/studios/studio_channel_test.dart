import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/models/gallery.dart';
import 'package:stash_app_mobile/data/models/image_item.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/data/models/marker.dart';
import 'package:stash_app_mobile/data/models/page_result.dart';
import 'package:stash_app_mobile/data/models/performer_profile.dart';
import 'package:stash_app_mobile/data/models/saved_filter.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/models/studio.dart';
import 'package:stash_app_mobile/data/models/tag.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/features/channel/channel_tabs.dart';
import 'package:stash_app_mobile/features/library/markers_tab.dart';
import 'package:stash_app_mobile/features/shell/navigation.dart';
import 'package:stash_app_mobile/features/shorts/shorts_feed.dart';
import 'package:stash_app_mobile/features/shorts/shorts_page.dart';
import 'package:stash_app_mobile/features/studios/studio_page.dart';

import '../../helpers.dart';

class _Repo implements StashRepository {
  _Repo({required this.studio, this.counts = const ChannelMediaCounts(), this.shorts = 0, this.markers = 0});

  final Studio studio;
  final ChannelMediaCounts counts;
  final int shorts;
  final int markers;

  final sceneQueries = <SceneQuery>[];
  final imageQueries = <ImageQuery>[];
  final galleryQueries = <GalleryQuery>[];
  final markerQueries = <MarkerQuery>[];
  final markerCountQueries = <MarkerQuery>[];

  @override
  Future<Studio> findStudio(String id) async => studio;

  @override
  Future<ChannelMediaCounts> studioMediaCounts(String id) async => counts;

  @override
  Future<PageResult<Scene>> findScenes(SceneQuery query, {int page = 1, int perPage = 24}) async {
    sceneQueries.add(query);
    final total = query.filter.portraitOnly ? shorts : 30;
    if (page > 1) return PageResult(items: const [], totalCount: total);
    final prefix = query.filter.portraitOnly ? 'Short' : 'Video';
    return PageResult(
      items: [for (var i = 0; i < total; i++) Scene(id: '$prefix$i', title: '$prefix $i', streamUrl: 'http://s/$i')],
      totalCount: total,
    );
  }

  @override
  Future<PageResult<ImageItem>> findImages(ImageQuery query, {int page = 1, int perPage = 24}) async {
    imageQueries.add(query);
    return PageResult(
      items: page > 1 ? const [] : [for (var i = 0; i < 3; i++) ImageItem(id: 'i$i', title: 'Image $i')],
      totalCount: 3,
    );
  }

  @override
  Future<PageResult<Gallery>> findGalleries(GalleryQuery query, {int page = 1, int perPage = 24}) async {
    galleryQueries.add(query);
    return PageResult(items: page > 1 ? const [] : const [Gallery(id: 'g1', title: 'Backstage')], totalCount: 1);
  }

  @override
  Future<int> countMarkers(MarkerQuery query) async {
    markerCountQueries.add(query);
    return markers;
  }

  @override
  Future<PageResult<Marker>> findMarkers(MarkerQuery query, {int page = 1, int perPage = 24}) async {
    markerQueries.add(query);
    return PageResult(
      items: [
        if (page == 1)
          for (var i = 0; i < markers; i++)
            Marker(
              id: 'm$i',
              title: 'Moment $i',
              seconds: 30.0 + i,
              tag: const Tag(id: 't1', name: 'Outdoor'),
              scene: Scene(id: 'v$i', title: 'Video $i', streamUrl: 'http://s/v$i'),
            ),
      ],
      totalCount: markers,
    );
  }

  @override
  Future<List<SavedFilter>> savedSceneFilters() async => const [];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Pushes extends NavigatorObserver {
  final routes = <Route<dynamic>>[];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) => routes.add(route);
}

const _network = Studio(
  id: 's1',
  name: 'Network',
  url: 'https://network.example',
  details: 'A big network.',
  parent: Studio(id: 's0', name: 'Holding'),
  children: [Studio(id: 's2', name: 'Label', sceneCount: 4)],
);

void main() {
  Future<void> pump(WidgetTester tester, _Repo repo, {_Pushes? observer}) async {
    final prefs = (await tester.runAsync(() async {
      SharedPreferences.setMockInitialValues({});
      return SharedPreferences.getInstance();
    }))!;
    final container = ProviderContainer(overrides: [
      ...testServer,
      sharedPreferencesProvider.overrideWithValue(prefs),
      stashRepositoryProvider.overrideWithValue(repo),
    ]);
    addTearDown(container.dispose);
    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        navigatorKey: container.read(tabNavigatorKeysProvider)[container.read(currentTabProvider)],
        navigatorObservers: [?observer],
        home: const StudioPage(studioId: 's1'),
      ),
    ));
    await tester.pumpAndSettle();
  }

  Finder tab(String label) => find.descendant(of: find.byType(TabBar), matching: find.text(label));

  List<String?> tabLabels(WidgetTester tester) =>
      [for (final t in tester.widget<TabBar>(find.byType(TabBar)).tabs) (t as Tab).text];

  testWidgets('a studio without media shows videos and about only', (tester) async {
    await pump(tester, _Repo(studio: const Studio(id: 's1', name: 'Solo')));
    expect(tabLabels(tester), ['Videos', 'About']);
    expect(find.text('Video 0'), findsOneWidget);
  });

  testWidgets('images, galleries and shorts follow the studio and its sub-studios', (tester) async {
    final repo = _Repo(studio: _network, counts: const ChannelMediaCounts(images: 3, galleries: 1), shorts: 2);
    await pump(tester, repo);
    expect(tabLabels(tester), ['Videos', 'Shorts', 'Images', 'Galleries', 'About']);
    expect(find.text('Part of Holding'), findsOneWidget, reason: 'the parent chip in the header');
    expect(repo.sceneQueries.where((q) => !q.filter.portraitOnly).last.includeSubStudios, isTrue);

    await tester.tap(tab('Images'));
    await tester.pumpAndSettle();
    expect(repo.imageQueries.last.studioId, 's1');
    expect(repo.imageQueries.last.includeSubStudios, isTrue);
    expect(find.text('3 images'), findsOneWidget);

    // Without the sub-studios: the images reload for the studio alone.
    await tester.tap(find.text('Include sub-studios'));
    await tester.pumpAndSettle();
    expect(repo.imageQueries.last.includeSubStudios, isFalse);

    await tester.tap(tab('Galleries'));
    await tester.pumpAndSettle();
    expect(repo.galleryQueries.last.studioId, 's1');
    expect(repo.galleryQueries.last.includeSubStudios, isFalse);
    expect(find.text('Backstage'), findsOneWidget);

    await tester.tap(tab('Shorts'));
    await tester.pumpAndSettle();
    expect(find.byType(ChannelShortTile), findsNWidgets(2));
    final shortsQuery = repo.sceneQueries.where((q) => q.filter.portraitOnly).last;
    expect(shortsQuery.studioId, 's1');
    expect(shortsQuery.includeSubStudios, isTrue);
  });

  testWidgets('markers show with the sub-studios\' unless switched off', (tester) async {
    final repo = _Repo(studio: _network, markers: 2);
    await pump(tester, repo);
    expect(tabLabels(tester), ['Videos', 'Markers', 'About']);
    // Whether the tab shows counts the sub-studios', like the media counts.
    expect(repo.markerCountQueries.single.toMarkerFilter(), {
      'scene_filter': {
        'studios': {'value': ['s1'], 'modifier': 'INCLUDES', 'depth': -1},
      },
    });

    await tester.tap(tab('Markers'));
    await tester.pumpAndSettle();
    expect(repo.markerQueries.last.studioId, 's1');
    expect(repo.markerQueries.last.includeSubStudios, isTrue);
    expect(find.byType(MarkerTile), findsNWidgets(2));

    await tester.tap(find.text('A–Z'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Include sub-studios'));
    await tester.pumpAndSettle();
    expect(repo.markerQueries.last.includeSubStudios, isFalse);
    expect(repo.markerQueries.last.sort, MarkerSort.title, reason: 'the toggle keeps the sort');
  });

  testWidgets('a studio without markers has no markers tab', (tester) async {
    final repo = _Repo(studio: _network);
    await pump(tester, repo);
    expect(tab('Markers'), findsNothing);
    expect(repo.markerQueries, isEmpty);
  });

  testWidgets('a short opens the studio\'s shorts at that short', (tester) async {
    final observer = _Pushes();
    await pump(tester, _Repo(studio: _network, shorts: 2), observer: observer);
    await tester.tap(tab('Shorts'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Short 1'));
    await tester.pumpAndSettle();
    observer.routes.clear();

    await tester.tap(find.text('Short 1'));
    final route = observer.routes.single as MaterialPageRoute<dynamic>;
    final page = route.builder(tester.element(find.byType(StudioPage))) as ShortsPage;
    expect(page.source, const ShortsSource.studio('s1'));
    expect(page.source.title, 'Network');
    expect(page.initialIndex, 1);
    route.navigator!.removeRoute(route);
    await tester.pump();
  });

  testWidgets('about shows the website, parent studio and description', (tester) async {
    await pump(tester, _Repo(studio: _network));
    await tester.tap(tab('About'));
    await tester.pumpAndSettle();
    expect(find.text('https://network.example'), findsOneWidget);
    expect(find.text('Parent studio'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('A big network.'), 100, scrollable: find.byType(Scrollable).first);
    expect(find.text('A big network.'), findsOneWidget);
  });

  testWidgets('about of a studio without details says so', (tester) async {
    await pump(tester, _Repo(studio: const Studio(id: 's1', name: 'Solo')));
    await tester.tap(tab('About'));
    await tester.pumpAndSettle();
    expect(find.text('Nothing here yet'), findsOneWidget);
  });
}
