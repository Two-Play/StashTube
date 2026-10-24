import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/data/models/page_result.dart';
import 'package:stash_app_mobile/data/models/performer.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/models/scene_details.dart';
import 'package:stash_app_mobile/data/models/studio.dart';
import 'package:stash_app_mobile/data/models/tag.dart';
import 'package:stash_app_mobile/data/providers.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/data/repositories/stash_session.dart';
import 'package:stash_app_mobile/features/player/player_providers.dart';
import 'package:stash_app_mobile/features/edit/edit_pages.dart';
import 'package:stash_app_mobile/features/player/player_view.dart';
import 'package:stash_app_mobile/features/player/scene_description.dart';
import 'package:stash_app_mobile/features/player/scene_tags_row.dart';
import 'package:stash_app_mobile/features/shell/navigation.dart';
import 'package:stash_app_mobile/features/tags/tag_page.dart';
import 'package:stash_app_mobile/features/tags/tag_editor.dart';
import 'package:stash_app_mobile/l10n/gen/app_localizations.dart';
import 'package:stash_app_mobile/widgets/skeleton.dart';

import '../../helpers.dart';
import '../fake_player.dart';

const _scene = Scene(
  id: 's1',
  title: 'A rather long scene title that needs more than one line on a phone',
  details: 'Some description of the scene.',
  rating100: 80,
  playCount: 3,
  height: 1080,
  studio: Studio(id: '1', name: 'Some Studio'),
  performers: [
    Performer(id: '1', name: 'First Performer'),
    Performer(id: '2', name: 'Second Performer'),
  ],
  tags: [Tag(id: '1', name: 'outdoor'), Tag(id: '2', name: 'summer'), Tag(id: '3', name: 'beach')],
);

/// "Up next" (and tag searches) that never finish loading.
class _LoadingRepository implements StashRepository {
  @override
  Future<PageResult<Scene>> findScenes(SceneQuery query, {int page = 1, int perPage = 24}) =>
      Completer<PageResult<Scene>>().future;

  @override
  Future<PageResult<Tag>> findTags(TagQuery query, {int page = 1, int perPage = 24}) =>
      Completer<PageResult<Tag>>().future;

  @override
  Future<List<String>?> sceneUrls(String id) async => const [];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _details = SceneDetails(
  markers: [
    SceneMarker(id: '1', title: 'Intro', seconds: 0),
    SceneMarker(id: '2', title: 'The middle part', seconds: 40),
    SceneMarker(id: '3', title: 'Ending', seconds: 80),
  ],
  files: [SceneFile(path: '/data/videos/a.mp4', size: 1000000, videoCodec: 'h264', height: 1080)],
);

void main() {
  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    container = ProviderContainer(overrides: [
      ...testServer,
      sharedPreferencesProvider.overrideWithValue(prefs),
      playerProvider.overrideWithValue(FakePlayer()),
      authHeadersProvider.overrideWithValue(const {}),
      sceneDetailsProvider('s1').overrideWith((ref) async => _details),
      stashRepositoryProvider.overrideWithValue(_LoadingRepository()),
    ]);
    container.read(playQueueProvider.notifier).set(
          const PlayQueue(
            title: 'Watch later',
            scenes: [Scene(id: 's0', title: 'Before'), _scene, Scene(id: 's2', title: 'After')],
            index: 1,
          ),
        );
  });
  tearDown(() => container.dispose());

  Future<void> pumpDetails(
    WidgetTester tester, {
    double textScale = 1,
    Size size = const Size(320, 640),
    double videoHeight = 0,
    Scene scene = _scene,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        // Where openTag & co. push their pages.
        navigatorKey: container.read(tabNavigatorKeysProvider)[container.read(currentTabProvider)],
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        ),
        home: Scaffold(
          body: Column(
            children: [
              // Where the video would be.
              SizedBox(height: videoHeight),
              Expanded(child: PlayerDetails(scene: scene)),
            ],
          ),
        ),
      ),
    ));
    await tester.pump();
  }

  testWidgets('the queue header shows the position', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpDetails(tester);
    expect(find.text('Watch later'), findsOneWidget);
    expect(find.text('2 / 3'), findsOneWidget);
    expect(find.bySemanticsLabel('Scene 2 of 3'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('the details fit with 2× text on a 320 dp wide screen (WATCH-4)', (tester) async {
    await pumpDetails(tester, textScale: 2);
    expect(tester.takeException(), isNull, reason: 'no overflow');

    // Chip rows and chapter tiles grow with the text instead of clipping it.
    for (final text in ['First Performer', 'O · 0', 'The middle part', 'Some Studio']) {
      final label = find.text(text).first;
      final box = tester.renderObject<RenderBox>(label);
      expect(box.size.height, greaterThan(30), reason: '$text is drawn at the larger size');
      final clip = find.ancestor(of: label, matching: find.byType(ClipRect));
      for (final element in clip.evaluate()) {
        final clipBox = element.renderObject! as RenderBox;
        final rect = clipBox.localToGlobal(Offset.zero) & clipBox.size;
        final labelRect = box.localToGlobal(Offset.zero) & box.size;
        expect(rect.top <= labelRect.top && rect.bottom >= labelRect.bottom, isTrue,
            reason: '$text is not cut off vertically');
      }
    }

    // The action bar's pills keep 48 dp targets.
    final button = find.ancestor(of: find.text('4'), matching: find.byWidgetPredicate((w) => w is ButtonStyleButton));
    expect(tester.getSize(button).height, greaterThanOrEqualTo(48));
    expect(tester.getSize(button).width, greaterThanOrEqualTo(48));
  });

  /// "Up next"'s placeholders shimmer forever, so pumpAndSettle can't be used.
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Finder inSheet(Finder finder) => find.descendant(of: find.byType(BottomSheet), matching: finder);

  testWidgets('title, meta, channel and actions come first; the rest is in the description sheet (WATCH-2)',
      (tester) async {
    container.read(playQueueProvider.notifier).set(null);
    await pumpDetails(tester);
    expect(find.text('3 plays · 1080p'), findsNothing, reason: 'the meta line ends with "...more"');
    expect(find.textContaining('3 plays · 1080p', findRichText: true), findsOneWidget);
    expect(find.text('Some Studio'), findsOneWidget);
    expect(find.text('O · 0'), findsOneWidget);
    // Not on the page anymore.
    for (final text in ['Some description of the scene.', 'File info', 'Edit tags']) {
      expect(find.text(text), findsNothing, reason: text);
    }

    await tester.tap(find.text(_scene.title));
    await settle(tester);
    for (final text in [_scene.title, 'Some description of the scene.', '#outdoor', '#summer', '#beach', 'File info', 'Edit scene']) {
      expect(inSheet(find.text(text)), findsOneWidget, reason: text);
    }

    // Tags are edited in a sheet over this one.
    await tester.ensureVisible(inSheet(find.text('Edit tags')));
    await tester.tap(inSheet(find.text('Edit tags')));
    await settle(tester);
    expect(find.byType(SceneTagEditor), findsOneWidget);
    await tester.tapAt(const Offset(160, 20));
    await settle(tester);
    expect(find.byType(SceneTagEditor), findsNothing);

    // "Edit scene" closes the sheet and opens the editor.
    await tester.ensureVisible(inSheet(find.text('Edit scene')));
    await settle(tester);
    await tester.tap(inSheet(find.text('Edit scene')));
    await settle(tester);
    expect(find.text('Some description of the scene.'), findsWidgets, reason: 'in the edit form');
    expect(find.byType(SceneDescriptionSheet), findsNothing);
    expect(find.byType(SceneEditPage), findsOneWidget);
  });

  testWidgets('the title opens the description for screen readers too (WATCH-5)', (tester) async {
    final semantics = tester.ensureSemantics();
    container.read(playQueueProvider.notifier).set(null);
    await pumpDetails(tester);
    expect(
      tester.getSemantics(find.text(_scene.title)),
      isSemantics(isButton: true, hasTapAction: true, onTapHint: 'Show description'),
    );
    semantics.dispose();
  });

  testWidgets('"Up next" starts within the first screen on a 360×780 phone (WATCH-2)', (tester) async {
    container.read(playQueueProvider.notifier).set(null);
    // Status bar plus a 16:9 video, as in the player.
    await pumpDetails(tester, size: const Size(360, 780), videoHeight: 24 + 360 * 9 / 16);
    await tester.pump();
    final header = find.text('More from Some Studio');
    expect(header, findsOneWidget);
    expect(tester.getBottomLeft(header).dy, lessThan(780));
    expect(find.text('Chapters'), findsOneWidget, reason: 'a typical scene, with chapters');
  });

  testWidgets('the first tags show under the actions; a tag opens its page', (tester) async {
    container.read(playQueueProvider.notifier).set(null);
    const scene = Scene(
      id: 's1',
      title: 'Tagged',
      studio: Studio(id: '1', name: 'Some Studio'),
      tags: [Tag(id: '1', name: 'a'), Tag(id: '2', name: 'b'), Tag(id: '3', name: 'c')],
    );
    await pumpDetails(tester, size: const Size(360, 780), scene: scene);
    for (final tag in ['#a', '#b', '#c']) {
      expect(find.text(tag).hitTestable(), findsOneWidget, reason: '$tag fits');
    }
    expect(find.textContaining(RegExp(r'^\+\d')).hitTestable(), findsNothing, reason: 'no "+N" when all fit');

    await tester.tap(find.text('#b'));
    await settle(tester);
    expect(find.byType(TagPage), findsOneWidget);
  });

  testWidgets('more tags than fit in one line end in "+N", which opens the description', (tester) async {
    container.read(playQueueProvider.notifier).set(null);
    final names = ['outdoor', 'summer', 'beach', 'sunset', 'friends', 'vacation', 'travel', 'ocean'];
    final scene = Scene(
      id: 's1',
      title: 'Tagged',
      studio: const Studio(id: '1', name: 'Some Studio'),
      tags: [for (final (i, n) in names.indexed) Tag(id: '$i', name: n)],
    );
    final semantics = tester.ensureSemantics();
    await pumpDetails(tester, size: const Size(360, 780), scene: scene);

    final row = find.byType(SceneTagsRow);
    final shown = [for (final n in names) if (find.descendant(of: row, matching: find.text('#$n')).hitTestable().evaluate().isNotEmpty) n];
    expect(shown, isNotEmpty);
    expect(shown, names.take(shown.length), reason: 'the first tags, in order');
    expect(shown.length, lessThanOrEqualTo(5));
    final more = find.text('+${names.length - shown.length}');
    expect(more.hitTestable(), findsOneWidget);
    expect(find.bySemanticsLabel('${names.length - shown.length} more tags'), findsOneWidget);
    // The tags left out are neither shown nor read out.
    expect(find.bySemanticsLabel('#ocean'), findsNothing);
    // One line, within the screen.
    final rowBox = tester.getRect(row);
    expect(tester.getRect(more).right, lessThanOrEqualTo(rowBox.right));

    await tester.tap(more);
    await settle(tester);
    expect(find.byType(SceneDescriptionSheet), findsOneWidget);
    expect(inSheet(find.text('#ocean')), findsOneWidget, reason: 'the sheet lists all tags');
    semantics.dispose();
  });

  testWidgets('the tags stay in one line with 2× text', (tester) async {
    container.read(playQueueProvider.notifier).set(null);
    await pumpDetails(tester, size: const Size(320, 640), textScale: 2);
    expect(tester.takeException(), isNull, reason: 'no overflow');
    final row = tester.getRect(find.byType(SceneTagsRow));
    final first = tester.getRect(find.text('#outdoor'));
    expect(row.right, lessThanOrEqualTo(320));
    expect(first.height, greaterThan(30), reason: 'drawn at the larger size');
    final more = find.textContaining(RegExp(r'^\+\d'));
    expect(more.hitTestable(), findsOneWidget, reason: 'the rest behind "+N"');
    expect((tester.getCenter(more.hitTestable()).dy - first.center.dy).abs(), lessThan(1), reason: 'same line');
  });

  testWidgets('"Up next" loads with placeholders instead of a spinner (HOME-2)', (tester) async {
    container.dispose();
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    container = ProviderContainer(overrides: [
      ...testServer,
      sharedPreferencesProvider.overrideWithValue(prefs),
      playerProvider.overrideWithValue(FakePlayer()),
      authHeadersProvider.overrideWithValue(const {}),
      sceneDetailsProvider('s1').overrideWith((ref) async => _details),
      stashRepositoryProvider.overrideWithValue(_LoadingRepository()),
    ]);
    await pumpDetails(tester);
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -2000));
    await tester.pump();
    expect(find.text('More from Some Studio'), findsOneWidget);
    expect(find.byType(ListTileSkeleton), findsWidgets);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
