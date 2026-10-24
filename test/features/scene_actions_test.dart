import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/data/models/page_result.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/models/scene_details.dart';
import 'package:stash_app_mobile/data/models/tag.dart';
import 'package:stash_app_mobile/data/providers.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/features/edit/edit_pages.dart';
import 'package:stash_app_mobile/features/library/watch_later.dart';
import 'package:stash_app_mobile/features/player/player_providers.dart';
import 'package:stash_app_mobile/features/player/scene_actions.dart';
import 'package:stash_app_mobile/features/player/scene_edits.dart';

import '../helpers.dart';
import 'fake_player.dart';

class FakeRepository implements StashRepository {
  final ratings = <int?>[];
  int oCount = 3;
  bool fail = false;
  Completer<void>? gate;
  final markers = <Map<String, Object>>[];

  @override
  Future<void> setSceneRating(String sceneId, int? rating100) async {
    await gate?.future;
    if (fail) throw const StashApiException('denied');
    ratings.add(rating100);
  }

  @override
  Future<int> addSceneO(String sceneId) async {
    if (fail) throw const StashApiException('denied');
    return ++oCount;
  }

  @override
  Future<int> removeSceneO(String sceneId) async {
    if (fail) throw const StashApiException('denied');
    return --oCount;
  }

  @override
  Future<PageResult<Tag>> findTags(TagQuery query, {int page = 1, int perPage = 24}) async => const PageResult(
        items: [Tag(id: '7', name: 'Intro', sceneCount: 3)],
        totalCount: 1,
      );

  @override
  Future<SceneMarker> createMarker({
    required String sceneId,
    required double seconds,
    required String primaryTagId,
    String title = '',
  }) async {
    markers.add({'scene': sceneId, 'seconds': seconds, 'tag': primaryTagId, 'title': title});
    return SceneMarker(id: '1', title: title, seconds: seconds);
  }

  @override
  Future<List<String>> sceneUrls(String sceneId) async => const [];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const scene = Scene(id: 's1', title: 'A', rating100: 60, oCounter: 3, tags: [Tag(id: '1', name: 'outdoor')]);

const _details = SceneDetails(files: [SceneFile(path: '/data/a.mp4', size: 1000000)]);

void main() {
  late FakeRepository repo;
  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    repo = FakeRepository();
    container = ProviderContainer(overrides: [
      ...testServer,
      sceneDetailsProvider('s1').overrideWith((ref) async => _details),
      sharedPreferencesProvider.overrideWithValue(prefs),
      stashRepositoryProvider.overrideWithValue(repo),
      playerProvider.overrideWithValue(FakePlayer(position: const Duration(seconds: 75))),
    ]);
  });
  tearDown(() => container.dispose());

  group('SceneEditsNotifier', () {
    test('rating is optimistic and reverted on failure', () async {
      repo.gate = Completer();
      final future = container.read(sceneEditsProvider.notifier).rate(scene, 5);
      expect(container.read(sceneEditsProvider)['s1']?.rating100, 100, reason: 'visible immediately');
      repo.gate!.complete();
      await future;
      expect(repo.ratings, [100]);

      repo.gate = null;
      repo.fail = true;
      await expectLater(container.read(sceneEditsProvider.notifier).rate(scene, 2), throwsA(isA<StashApiException>()));
      expect(container.read(sceneEditsProvider)['s1']?.rating100, 100, reason: 'reverted');
    });

    test('removing the rating sends null', () async {
      await container.read(sceneEditsProvider.notifier).rate(scene, 0);
      expect(repo.ratings, [null]);
      expect(container.read(sceneEditsProvider)['s1']?.ratingChanged, isTrue);
    });

    test('O-counter uses the count from the server and can be undone', () async {
      expect(await container.read(sceneEditsProvider.notifier).addO(scene), 4);
      expect(container.read(sceneEditsProvider)['s1']?.oCounter, 4);
      await container.read(sceneEditsProvider.notifier).removeO(scene);
      expect(container.read(sceneEditsProvider)['s1']?.oCounter, 3);
    });
  });

  Future<void> pumpActions(WidgetTester tester) => tester.pumpWidget(UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: Scaffold(body: SceneActions(scene: scene))),
      ));

  Finder inSheet(Finder finder) => find.descendant(of: find.byType(BottomSheet), matching: finder);

  Future<void> openRating(WidgetTester tester, String label) async {
    await tester.tap(find.text(label));
    await tester.pumpAndSettle();
    expect(find.text('Rate this scene'), findsOneWidget);
  }

  testWidgets('the action bar has rating, O, watch later, marker and "More" (WATCH-2)', (tester) async {
    await pumpActions(tester);
    for (final label in ['3', 'O · 3', 'Later', 'Marker']) {
      final button = find.ancestor(of: find.text(label), matching: find.byWidgetPredicate((w) => w is ButtonStyleButton));
      expect(button, findsOneWidget, reason: '$label is a button');
      expect(tester.getSize(button).height, greaterThanOrEqualTo(48), reason: '$label keeps a 48 dp target');
    }
    expect(find.byTooltip('More'), findsOneWidget);
  });

  testWidgets('the rating button opens a star picker; a tap rates and closes it, tapping the rating removes it',
      (tester) async {
    await pumpActions(tester);
    expect(find.text('3'), findsOneWidget, reason: 'rating100 60 = 3 stars');
    await openRating(tester, '3');
    expect(inSheet(find.byIcon(Icons.star_rounded)), findsNWidgets(3));

    await tester.tap(find.byTooltip('Rate 4 stars'));
    await tester.pumpAndSettle();
    expect(find.text('Rate this scene'), findsNothing, reason: 'closed after picking');
    expect(find.text('4'), findsOneWidget);
    expect(repo.ratings, [80]);

    await openRating(tester, '4');
    await tester.tap(find.byTooltip('Remove rating'));
    await tester.pumpAndSettle();
    expect(find.text('Rate'), findsOneWidget);
    expect(repo.ratings, [80, null]);
  });

  testWidgets('screen readers get the rating as one adjustable element (A11Y-2)', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpActions(tester);
    expect(find.bySemanticsLabel('Rating: 3 of 5 stars'), findsOneWidget, reason: 'the button says the rating');
    await openRating(tester, '3');
    final rating = find.bySemanticsLabel('Rating');
    expect(rating, findsOneWidget);
    expect(
      tester.getSemantics(rating),
      matchesSemantics(
        label: 'Rating',
        value: '3 of 5 stars',
        increasedValue: '4 of 5 stars',
        decreasedValue: '2 of 5 stars',
        isSlider: true,
        hasIncreaseAction: true,
        hasDecreaseAction: true,
      ),
    );
    expect(find.bySemanticsLabel('Rate 4 stars'), findsNothing, reason: 'the single stars are hidden from screen readers');

    tester.semantics.increase(find.semantics.byLabel('Rating'));
    await tester.pumpAndSettle();
    expect(repo.ratings, [80]);
    expect(tester.getSemantics(rating).value, '4 of 5 stars', reason: 'the picker stays open while adjusting');

    tester.semantics.decrease(find.semantics.byLabel('Rating'));
    await tester.pumpAndSettle();
    expect(repo.ratings, [80, 60]);
    semantics.dispose();
  });

  testWidgets('the stars spread over the sheet as large tap targets, with the value and "Remove rating"',
      (tester) async {
    tester.view.physicalSize = const Size(360, 780);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await pumpActions(tester);
    await openRating(tester, '3');
    expect(inSheet(find.text('3 of 5 stars')), findsOneWidget, reason: 'the current value');

    final stars = find.descendant(of: find.byType(BottomSheet), matching: find.byType(IconButton));
    expect(stars, findsNWidgets(5));
    for (final star in stars.evaluate()) {
      final size = (star.renderObject! as RenderBox).size;
      expect(size.width, greaterThanOrEqualTo(48));
      expect(size.height, greaterThanOrEqualTo(48));
    }
    final span = tester.getTopRight(stars.last).dx - tester.getTopLeft(stars.first).dx;
    expect(span, greaterThanOrEqualTo(0.8 * 360), reason: 'the stars use the full width');

    await tester.tap(inSheet(find.text('Remove rating')));
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsNothing, reason: 'closed');
    expect(repo.ratings, [null]);
    expect(find.text('Rate'), findsOneWidget);

    await openRating(tester, 'Rate');
    expect(inSheet(find.text('No rating')), findsOneWidget);
    final remove = find.ancestor(of: inSheet(find.text('Remove rating')), matching: find.byType(TextButton));
    expect(tester.widget<TextButton>(remove).onPressed, isNull, reason: 'nothing to remove');
  });

  testWidgets('on a tablet the rating sheet keeps a sensible width', (tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await pumpActions(tester);
    await openRating(tester, '3');
    final stars = find.descendant(of: find.byType(BottomSheet), matching: find.byType(IconButton));
    final span = Rect.fromPoints(tester.getTopLeft(stars.first), tester.getBottomRight(stars.last));
    expect(span.width, lessThanOrEqualTo(640));
    expect(span.width, greaterThan(400), reason: 'still spread out');
    expect(span.center.dx, closeTo(600, 1), reason: 'centered');
  });

  testWidgets('watch later toggles', (tester) async {
    await pumpActions(tester);
    await tester.tap(find.text('Later'));
    await tester.pump();
    expect(container.read(watchLaterProvider), ['s1']);
    expect(find.text('Saved'), findsOneWidget);
    await tester.tap(find.text('Saved'));
    await tester.pump();
    expect(container.read(watchLaterProvider), isEmpty);
    expect(find.text('Later'), findsOneWidget);
  });

  testWidgets('"More" lists the rarer actions and opens the file info', (tester) async {
    await pumpActions(tester);
    await tester.tap(find.byTooltip('More'));
    await tester.pumpAndSettle();
    for (final label in ['Description', 'Edit scene', 'Edit tags', 'File info']) {
      expect(inSheet(find.text(label)), findsOneWidget, reason: label);
    }

    await tester.tap(find.text('File info'));
    await tester.pumpAndSettle();
    expect(find.text('Edit scene'), findsNothing, reason: 'the menu closed');
    expect(find.text('/data/a.mp4'), findsOneWidget, reason: 'the file info is open and expanded');
  });

  testWidgets('"More" opens the scene editor', (tester) async {
    await pumpActions(tester);
    await tester.tap(find.byTooltip('More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit scene'));
    await tester.pumpAndSettle();
    expect(find.byType(SceneEditPage), findsOneWidget);
  });

  Future<void> openO(WidgetTester tester, String label) async {
    await tester.tap(find.text(label));
    await tester.pumpAndSettle();
    expect(inSheet(find.text('O-counter')), findsOneWidget);
  }

  testWidgets('the O button opens a counter with − and +; each saves right away', (tester) async {
    await pumpActions(tester);
    expect(find.bySemanticsLabel('O-counter: 3'), findsOneWidget, reason: 'the button says the count');
    await openO(tester, 'O · 3');
    expect(repo.oCount, 3, reason: 'opening it changes nothing');
    expect(inSheet(find.text('3')), findsOneWidget);

    final add = find.byTooltip('Add O');
    final remove = find.byTooltip('Remove one O');
    for (final button in [add, remove]) {
      expect(tester.getSize(button).width, greaterThanOrEqualTo(48));
      expect(tester.getSize(button).height, greaterThanOrEqualTo(48));
    }

    await tester.tap(add);
    await tester.pumpAndSettle();
    expect(repo.oCount, 4);
    expect(inSheet(find.text('4')), findsOneWidget);
    expect(find.text('O · 4'), findsOneWidget, reason: 'the pill follows');
    expect(find.text('Undo'), findsNothing, reason: 'no undo snack bar anymore');

    await tester.tap(remove);
    await tester.pumpAndSettle();
    await tester.tap(remove);
    await tester.pumpAndSettle();
    await tester.tap(remove);
    await tester.pumpAndSettle();
    expect(repo.oCount, 1);
    await tester.tap(remove);
    await tester.pumpAndSettle();
    expect(repo.oCount, 0);
    expect(inSheet(find.text('0')), findsOneWidget);
    final minus = find.ancestor(of: find.byIcon(Icons.remove), matching: find.byType(IconButton));
    expect(tester.widget<IconButton>(minus).onPressed, isNull, reason: '− is disabled at 0');
  });

  testWidgets('the O-counter is one adjustable element for screen readers', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpActions(tester);
    await openO(tester, 'O · 3');
    final counter = find.bySemanticsLabel('O-counter').last;
    expect(
      tester.getSemantics(counter),
      matchesSemantics(
        label: 'O-counter',
        value: '3',
        increasedValue: '4',
        decreasedValue: '2',
        hasIncreaseAction: true,
        hasDecreaseAction: true,
      ),
    );
    expect(find.bySemanticsLabel('Add O'), findsNothing, reason: 'the buttons are hidden from screen readers');

    tester.semantics.increase(find.semantics.byLabel('O-counter').last);
    await tester.pumpAndSettle();
    expect(repo.oCount, 4);
    expect(tester.getSemantics(counter).value, '4');
    tester.semantics.decrease(find.semantics.byLabel('O-counter').last);
    await tester.pumpAndSettle();
    expect(repo.oCount, 3);
    semantics.dispose();
  });

  testWidgets('a failed O save is reverted and shown as a snack bar', (tester) async {
    await pumpActions(tester);
    await openO(tester, 'O · 3');
    repo.fail = true;
    await tester.tap(find.byTooltip('Add O'));
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsNothing, reason: 'closed, so the snack bar shows');
    expect(find.textContaining("Couldn't save"), findsOneWidget);
    expect(find.text('O · 3'), findsOneWidget, reason: 'reverted');
  });

  testWidgets('adding a marker requires a tag and uses the player position', (tester) async {
    await pumpActions(tester);
    await tester.tap(find.text('Marker'));
    await tester.pumpAndSettle();
    expect(find.text('Add marker at 1:15'), findsOneWidget);

    final addButton = find.widgetWithText(FilledButton, 'Add marker');
    expect(tester.widget<FilledButton>(addButton).onPressed, isNull, reason: 'primary tag required');

    await tester.enterText(find.widgetWithText(TextField, 'Title (optional)'), 'Kiss');
    await tester.tap(find.text('#Intro'));
    await tester.pump();
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    expect(repo.markers.single, {'scene': 's1', 'seconds': 75.0, 'tag': '7', 'title': 'Kiss'});
    expect(find.text('Marker added at 1:15'), findsOneWidget);
  });
}
