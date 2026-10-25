import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/core/utils/external_links.dart';
import 'package:stash_app_mobile/data/models/gallery.dart';
import 'package:stash_app_mobile/data/models/image_item.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/data/models/marker.dart';
import 'package:stash_app_mobile/data/models/page_result.dart';
import 'package:stash_app_mobile/data/models/performer.dart';
import 'package:stash_app_mobile/data/models/performer_profile.dart';
import 'package:stash_app_mobile/data/models/saved_filter.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/models/tag.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/features/library/galleries_tab.dart';
import 'package:stash_app_mobile/features/library/markers_tab.dart';
import 'package:stash_app_mobile/features/performers/performer_page.dart';
import 'package:stash_app_mobile/features/player/player_providers.dart';
import 'package:stash_app_mobile/features/shell/navigation.dart';
import 'package:stash_app_mobile/features/shorts/short_tile.dart';
import 'package:stash_app_mobile/features/shorts/shorts_feed.dart';
import 'package:stash_app_mobile/features/shorts/shorts_page.dart';
import 'package:stash_app_mobile/widgets/scene_card.dart';

import '../../helpers.dart';

class _Repo implements StashRepository {
  _Repo({
    this.performer = const Performer(id: '1', name: 'Alice'),
    this.profile = const PerformerProfile(),
    this.urls = const [],
    this.shorts = 0,
    this.markers = 0,
  });

  final Performer performer;
  final PerformerProfile profile;
  final List<String> urls;
  final int shorts;
  final int markers;

  final sceneQueries = <SceneQuery>[];
  final imageQueries = <ImageQuery>[];
  final galleryQueries = <GalleryQuery>[];
  final markerQueries = <MarkerQuery>[];
  final markerCountQueries = <MarkerQuery>[];

  @override
  Future<Performer> findPerformer(String id) async => performer;

  @override
  Future<PerformerProfile> performerProfile(String id) async => profile;

  @override
  Future<List<String>?> performerUrls(String id) async => urls;

  @override
  Future<PageResult<Scene>> findScenes(SceneQuery query, {int page = 1, int perPage = 24}) async {
    sceneQueries.add(query);
    if (page > 1) return PageResult(items: const [], totalCount: query.filter.portraitOnly ? shorts : 30);
    // The shorts settings' filter (portrait videos) marks the shorts' queries.
    if (query.filter.portraitOnly) {
      return PageResult(
        items: [for (var i = 0; i < shorts; i++) Scene(id: 's$i', title: 'Short $i', streamUrl: 'http://s/s$i')],
        totalCount: shorts,
      );
    }
    return PageResult(
      items: [for (var i = 0; i < 30; i++) Scene(id: '$i', title: 'Video $i', streamUrl: 'http://s/$i')],
      totalCount: 30,
    );
  }

  @override
  Future<PageResult<ImageItem>> findImages(ImageQuery query, {int page = 1, int perPage = 24}) async {
    imageQueries.add(query);
    if (page > 1) return const PageResult(items: [], totalCount: 40);
    return PageResult(
      items: [for (var i = 0; i < 40; i++) ImageItem(id: 'i$i', title: 'Image $i')],
      totalCount: 40,
    );
  }

  @override
  Future<PageResult<Gallery>> findGalleries(GalleryQuery query, {int page = 1, int perPage = 24}) async {
    galleryQueries.add(query);
    if (page > 1) return const PageResult(items: [], totalCount: 1);
    return const PageResult(items: [Gallery(id: 'g1', title: 'Holiday', imageCount: 5)], totalCount: 1);
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
              seconds: 60.0 + i,
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

/// Records pushed routes without building them (the shorts player needs
/// native players).
class _Playing extends NowPlayingNotifier {
  final played = <(String, double?)>[];

  @override
  Scene? build() => null;

  @override
  void play(Scene scene, {double? at, bool remember = true}) => played.add((scene.id, at));
}

class _Pushes extends NavigatorObserver {
  final routes = <Route<dynamic>>[];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) => routes.add(route);
}

void main() {
  late SharedPreferences prefs;

  Future<ProviderContainer> pump(WidgetTester tester, _Repo repo, {_Pushes? observer, _Playing? playing}) async {
    prefs = (await tester.runAsync(() async {
      SharedPreferences.setMockInitialValues({});
      return SharedPreferences.getInstance();
    }))!;
    final container = ProviderContainer(overrides: [
      ...testServer,
      sharedPreferencesProvider.overrideWithValue(prefs),
      stashRepositoryProvider.overrideWithValue(repo),
      if (playing != null) nowPlayingProvider.overrideWith(() => playing),
    ]);
    addTearDown(container.dispose);
    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        // openPage pushes onto the current tab's navigator.
        navigatorKey: container.read(tabNavigatorKeysProvider)[container.read(currentTabProvider)],
        navigatorObservers: [?observer],
        home: const PerformerPage(performerId: '1'),
      ),
    ));
    await tester.pumpAndSettle();
    return container;
  }

  Finder tab(String label) => find.descendant(of: find.byType(TabBar), matching: find.text(label));

  double titleOpacity(WidgetTester tester) => tester
      .widget<AnimatedOpacity>(find.descendant(of: find.byType(AppBar), matching: find.byType(AnimatedOpacity)))
      .opacity;

  testWidgets('only the tabs with content show; videos first', (tester) async {
    await pump(tester, _Repo());

    expect(tab('Videos'), findsOneWidget);
    expect(tab('About'), findsOneWidget);
    expect(tab('Shorts'), findsNothing);
    expect(tab('Markers'), findsNothing);
    expect(tab('Images'), findsNothing);
    expect(tab('Galleries'), findsNothing);
    expect(find.text('Video 0'), findsOneWidget);
    expect(find.byType(SceneCard), findsWidgets);
  });

  testWidgets('each tab shows the performer\'s content', (tester) async {
    final repo = _Repo(
      profile: const PerformerProfile(counts: ChannelMediaCounts(images: 40, galleries: 1)),
      shorts: 3,
      markers: 2,
    );
    await pump(tester, repo);
    expect([for (final t in tester.widget<TabBar>(find.byType(TabBar)).tabs) (t as Tab).text],
        ['Videos', 'Shorts', 'Markers', 'Images', 'Galleries', 'About']);

    await tester.tap(tab('Images'));
    await tester.pumpAndSettle();
    expect(repo.imageQueries.last.performerId, '1');
    expect(find.text('40 images'), findsOneWidget);
    expect(find.bySemanticsLabel('Image 0'), findsOneWidget);

    await tester.tap(tab('Galleries'));
    await tester.pumpAndSettle();
    expect(repo.galleryQueries.last.performerId, '1');
    expect(find.byType(GalleryTile), findsOneWidget);
    expect(find.text('Holiday'), findsOneWidget);

    await tester.tap(tab('Shorts'));
    await tester.pumpAndSettle();
    expect(find.byType(ShortTile), findsNWidgets(3));
    expect(find.text('Short 2'), findsOneWidget);
  });

  testWidgets('markers lists the markers of the performer\'s scenes and plays from one', (tester) async {
    final repo = _Repo(markers: 2);
    final playing = _Playing();
    await pump(tester, repo, playing: playing);
    expect(repo.markerCountQueries.single.performerId, '1');

    await tester.tap(tab('Markers'));
    await tester.pumpAndSettle();
    final query = repo.markerQueries.single;
    expect(query.performerId, '1');
    expect(query.sort, MarkerSort.recentlyAdded);
    expect(query.toMarkerFilter(), {
      'performers': {'value': ['1'], 'modifier': 'INCLUDES'},
    });
    expect(find.text('2 markers'), findsOneWidget);
    expect(find.byType(MarkerTile), findsNWidgets(2));

    await tester.tap(find.text('Moment 1'));
    expect(playing.played, [('v1', 61.0)]);

    // The sort chips keep the performer.
    await tester.tap(find.text('A–Z'));
    await tester.pumpAndSettle();
    expect(repo.markerQueries.last.sort, MarkerSort.title);
    expect(repo.markerQueries.last.performerId, '1');
  });

  testWidgets('the markers play as shorts, from the first or the chosen one', (tester) async {
    final observer = _Pushes();
    final playing = _Playing();
    final repo = _Repo(markers: 3);
    await pump(tester, repo, observer: observer, playing: playing);
    await tester.tap(tab('Markers'));
    await tester.pumpAndSettle();
    final grid = repo.markerQueries.single;
    observer.routes.clear();

    ShortsPage pushed() {
      final route = observer.routes.single as MaterialPageRoute<dynamic>;
      final page = route.builder(tester.element(find.byType(PerformerPage))) as ShortsPage;
      // Never built: it would start native players.
      route.navigator!.removeRoute(route);
      observer.routes.clear();
      return page;
    }

    await tester.tap(find.text('Play as shorts'));
    var page = pushed();
    expect(page.source, ShortsSource.markers(grid), reason: 'the grid\'s markers, filter and sort');
    expect(page.initialIndex, 0);
    await tester.pump();

    // The tile's menu: play as before, or as a short from that marker on.
    await tester.tap(find.byTooltip('Marker options').at(2));
    await tester.pumpAndSettle();
    expect(find.text('Play'), findsOneWidget);
    observer.routes.clear();
    await tester.tap(find.text('Play as short'));
    page = pushed();
    expect(page.source, ShortsSource.markers(grid));
    expect(page.initialIndex, 2);
    await tester.pumpAndSettle();

    // A long press opens the same menu; a tap still plays the scene.
    await tester.longPress(find.text('Moment 1'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Play'));
    await tester.pumpAndSettle();
    expect(playing.played, [('v1', 61.0)]);
    await tester.tap(find.text('Moment 0'));
    expect(playing.played.last, ('v0', 60.0));
    expect(observer.routes.whereType<MaterialPageRoute<dynamic>>(), isEmpty, reason: 'no shorts');
  });

  testWidgets('a short opens the shorts player on that short of the same feed', (tester) async {
    final observer = _Pushes();
    await pump(tester, _Repo(shorts: 3), observer: observer);
    await tester.tap(tab('Shorts'));
    await tester.pumpAndSettle();
    observer.routes.clear();

    await tester.tap(find.text('Short 2'));
    final route = observer.routes.single as MaterialPageRoute<dynamic>;
    final page = route.builder(tester.element(find.byType(PerformerPage))) as ShortsPage;
    expect(page.source, const ShortsSource.performer('1'));
    expect(page.source.title, 'Alice');
    expect(page.initialIndex, 2);
    // Never built: it would start native players.
    route.navigator!.removeRoute(route);
    await tester.pump();
  });

  testWidgets('about lists the details that are set, with links', (tester) async {
    final repo = _Repo(
      performer: Performer(
        id: '1',
        name: 'Alice',
        gender: 'FEMALE',
        country: 'DE',
        birthdate: DateTime(1990, 5, 3),
        details: 'Loves the sea.',
      ),
      profile: const PerformerProfile(aliases: ['Ally', 'A.'], heightCm: 170, career: '2010 - 2015', tattoos: 'None'),
      urls: ['https://example.com/alice'],
    );
    await pump(tester, repo);
    await tester.tap(tab('About'));
    await tester.pumpAndSettle();

    expect(find.text('Also known as'), findsOneWidget);
    expect(find.text('Ally, A.'), findsOneWidget);
    expect(find.text('Female'), findsOneWidget);
    expect(find.textContaining('1990'), findsOneWidget);
    expect(find.text('170 cm'), findsOneWidget);
    expect(find.text('2010 - 2015'), findsOneWidget);
    expect(find.text('Hair color'), findsNothing, reason: 'unset facts are left out');

    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method == 'Clipboard.setData') copied = (call.arguments as Map)['text'] as String?;
      return null;
    });
    addTearDown(() => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, null));
    final scrollable = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(find.text('https://example.com/alice'), 100, scrollable: scrollable);
    // A tap opens the link in the browser, a long press copies it.
    final opened = <Uri>[];
    urlOpener = (uri) async {
      opened.add(uri);
      return true;
    };
    addTearDown(() => urlOpener = (uri) async => false);
    await tester.tap(find.text('https://example.com/alice'));
    await tester.pump();
    expect(opened, [Uri.parse('https://example.com/alice')]);
    await tester.longPress(find.text('https://example.com/alice'));
    await tester.pump();
    expect(find.text('Link copied'), findsOneWidget);
    expect(copied, 'https://example.com/alice');
    await tester.scrollUntilVisible(find.text('Loves the sea.'), 100, scrollable: scrollable);
  });

  testWidgets('about without any details says so', (tester) async {
    await pump(tester, _Repo());
    await tester.tap(tab('About'));
    await tester.pumpAndSettle();
    expect(find.text('Nothing here yet'), findsOneWidget);
  });

  testWidgets('the title shows once the header is gone, also after switching tabs', (tester) async {
    final repo = _Repo(profile: const PerformerProfile(counts: ChannelMediaCounts(images: 40)));
    await pump(tester, repo);
    expect(titleOpacity(tester), 0);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -1200));
    await tester.pumpAndSettle();
    expect(titleOpacity(tester), 1);
    expect(find.byType(TabBar), findsOneWidget, reason: 'the tab bar stays pinned');

    // The images tab opens with the header collapsed, at the top of its grid.
    await tester.tap(tab('Images'));
    await tester.pumpAndSettle();
    expect(titleOpacity(tester), 1);
    expect(find.text('40 images'), findsOneWidget);

    // Back on the videos, they are where they were.
    await tester.tap(tab('Videos'));
    await tester.pumpAndSettle();
    expect(titleOpacity(tester), 1);
    expect(find.text('Video 0'), findsNothing);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, 3000));
    await tester.pumpAndSettle();
    expect(titleOpacity(tester), 0, reason: 'hidden again back at the top');
  });

  testWidgets('pull-to-refresh reloads a tab', (tester) async {
    final repo = _Repo(profile: const PerformerProfile(counts: ChannelMediaCounts(images: 40)));
    await pump(tester, repo);
    final scenes = repo.sceneQueries.length;
    await tester.fling(find.byType(CustomScrollView), const Offset(0, 400), 1000);
    await tester.pumpAndSettle();
    expect(repo.sceneQueries.length, greaterThan(scenes));

    await tester.tap(tab('Images'));
    await tester.pumpAndSettle();
    final images = repo.imageQueries.length;
    await tester.fling(find.byType(CustomScrollView), const Offset(0, 400), 1000);
    await tester.pumpAndSettle();
    expect(repo.imageQueries.length, greaterThan(images));
  });
}
