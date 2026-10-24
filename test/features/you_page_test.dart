import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/models/gallery.dart';
import 'package:stash_app_mobile/data/models/group.dart';
import 'package:stash_app_mobile/data/models/image_item.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/data/models/marker.dart';
import 'package:stash_app_mobile/data/models/page_result.dart';
import 'package:stash_app_mobile/data/models/performer.dart';
import 'package:stash_app_mobile/data/models/saved_filter.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/models/tag.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/features/library/library_page.dart';
import 'package:stash_app_mobile/features/performers/performers_page.dart';
import 'package:stash_app_mobile/features/shell/navigation.dart';
import 'package:stash_app_mobile/features/you/you_page.dart';
import 'package:stash_app_mobile/widgets/scene_shelf.dart';

import '../helpers.dart';

class _Repo implements StashRepository {
  @override
  Future<PageResult<Scene>> findScenes(SceneQuery query, {int page = 1, int perPage = 24}) async => PageResult(
        items: page > 1 ? const [] : [for (var i = 0; i < 5; i++) Scene(id: 'v$i', title: 'Video $i')],
        totalCount: 5,
      );

  @override
  Future<List<Scene>> findScenesByIds(List<String> ids) async => const [];

  @override
  Future<PageResult<Group>> findGroups(GroupQuery query, {int page = 1, int perPage = 24}) async =>
      const PageResult(items: [Group(id: 'g1', name: 'A group', sceneCount: 3)], totalCount: 1);

  @override
  Future<PageResult<Marker>> findMarkers(MarkerQuery query, {int page = 1, int perPage = 24}) async => const PageResult(
        items: [
          Marker(
            id: 'm1',
            title: 'A marker',
            seconds: 12,
            tag: Tag(id: 't1', name: 'A tag'),
            scene: Scene(id: 'v1', title: 'Video 1'),
          ),
        ],
        totalCount: 1,
      );

  @override
  Future<PageResult<Performer>> findPerformers(PerformerQuery query, {int page = 1, int perPage = 24}) async =>
      const PageResult(items: [Performer(id: 'p1', name: 'Celia')], totalCount: 1);

  @override
  Future<PageResult<ImageItem>> findImages(ImageQuery query, {int page = 1, int perPage = 24}) async =>
      const PageResult(items: [], totalCount: 0);

  @override
  Future<PageResult<Gallery>> findGalleries(GalleryQuery query, {int page = 1, int perPage = 24}) async =>
      const PageResult(items: [], totalCount: 0);

  @override
  Future<List<SavedFilter>> savedSceneFilters() async => const [];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late ProviderContainer container;

  /// The "You" tab as AppShell builds it: its navigator and scroll
  /// controller, selected.
  Future<void> pumpYou(WidgetTester tester, {Widget root = const YouPage()}) async {
    final prefs = (await tester.runAsync(() async {
      SharedPreferences.setMockInitialValues({});
      return SharedPreferences.getInstance();
    }))!;
    container = ProviderContainer(overrides: [
      ...testServer,
      sharedPreferencesProvider.overrideWithValue(prefs),
      stashRepositoryProvider.overrideWithValue(_Repo()),
    ]);
    addTearDown(container.dispose);
    container.read(currentTabProvider.notifier).select(AppTab.you);
    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        home: Navigator(
          key: container.read(tabNavigatorKeysProvider)[AppTab.you],
          onGenerateRoute: (_) => MaterialPageRoute<void>(
            builder: (_) => PrimaryScrollController(
              controller: container.read(tabScrollControllersProvider)[AppTab.you]!,
              child: root,
            ),
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();
  }

  void tallView(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets('shows the shelves, the views and the settings', (tester) async {
    tallView(tester);
    await pumpYou(tester);

    expect(find.widgetWithText(ShelfHeader, 'History'), findsOneWidget);
    expect(find.text('Video 0'), findsWidgets);
    // Watch later is empty: a hint instead of a row.
    expect(find.widgetWithText(ShelfHeader, 'Watch later'), findsOneWidget);
    expect(find.text('Tap "Later" on a scene to watch it afterwards.'), findsOneWidget);
    expect(find.widgetWithText(ShelfHeader, 'Groups'), findsOneWidget);
    expect(find.text('A group'), findsOneWidget);
    expect(find.widgetWithText(ShelfHeader, 'Markers'), findsOneWidget);
    expect(find.text('A marker'), findsOneWidget);

    for (final title in ['Stats', 'Subscriptions', 'Performers', 'Studios', 'Tags', 'Server tasks', 'Settings']) {
      expect(find.widgetWithText(ListTile, title), findsOneWidget, reason: title);
    }
    // Views not in the standard bar, but not those in it.
    expect(find.text('More views'), findsOneWidget);
    expect(find.widgetWithText(ListTile, 'Scenes'), findsOneWidget);
    expect(find.widgetWithText(ListTile, 'Galleries'), findsOneWidget);
    expect(find.widgetWithText(ListTile, 'Home'), findsNothing);
    expect(find.widgetWithText(ListTile, 'Library'), findsNothing);
  });

  testWidgets('a view opens inside the "You" tab', (tester) async {
    tallView(tester);
    await pumpYou(tester);
    final navigator = container.read(tabNavigatorKeysProvider)[AppTab.you]!.currentState!;

    await tester.tap(find.widgetWithText(ListTile, 'Performers'));
    await tester.pumpAndSettle();
    expect(find.byType(PerformersPage), findsOneWidget);
    expect(find.text('Celia'), findsOneWidget);
    expect(navigator.canPop(), isTrue);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(
      of: find.widgetWithText(ShelfHeader, 'History'),
      matching: find.byType(TextButton),
    ));
    await tester.pumpAndSettle();
    expect(find.byWidgetPredicate((w) => w is LibrarySectionPage && w.section == LibrarySection.history),
        findsOneWidget);
  });

  testWidgets('re-selecting "You" scrolls it to the top', (tester) async {
    await pumpYou(tester);
    final controller = container.read(tabScrollControllersProvider)[AppTab.you]!;
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -500));
    await tester.pumpAndSettle();
    expect(controller.offset, greaterThan(0), reason: 'the page follows the tab\'s controller');

    reselectTab(container.read(tabNavigatorKeysProvider)[AppTab.you]!.currentState, controller);
    await tester.pumpAndSettle();
    expect(controller.offset, 0);
  });

  testWidgets('the library has only the media as text tabs', (tester) async {
    await pumpYou(tester, root: const LibraryPage());
    final tabs = find.descendant(of: find.byType(TabBar), matching: find.byType(Tab));
    expect(tabs, findsNWidgets(3));
    for (final label in ['Scenes', 'Images', 'Galleries']) {
      expect(find.descendant(of: find.byType(TabBar), matching: find.text(label)), findsOneWidget);
    }
    for (final label in ['History', 'Watch later', 'Groups', 'Markers', 'Stats']) {
      expect(find.descendant(of: find.byType(TabBar), matching: find.text(label)), findsNothing);
    }
    expect(tester.widget<TabBar>(find.byType(TabBar)).isScrollable, isFalse);
    expect(find.descendant(of: find.byType(TabBar), matching: find.byType(Icon)), findsNothing);
  });
}
