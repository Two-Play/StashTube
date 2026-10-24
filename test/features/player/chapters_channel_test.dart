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
import 'package:stash_app_mobile/data/models/scrub_thumbnails.dart';
import 'package:stash_app_mobile/data/models/studio.dart';
import 'package:stash_app_mobile/data/models/tag.dart';
import 'package:stash_app_mobile/data/providers.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/data/repositories/stash_session.dart';
import 'package:stash_app_mobile/features/performers/favorite_button.dart';
import 'package:stash_app_mobile/features/player/player_controls.dart';
import 'package:stash_app_mobile/features/player/player_providers.dart';
import 'package:stash_app_mobile/features/player/player_view.dart';
import 'package:stash_app_mobile/features/player/preview_seek_bar.dart';
import 'package:stash_app_mobile/l10n/gen/app_localizations.dart';
import 'package:stash_app_mobile/widgets/stash_image.dart';

import '../../helpers.dart';
import '../fake_player.dart';

const _scene = Scene(
  id: 's1',
  title: 'A rather long scene title that needs more than one line on a phone',
  height: 1080,
  studio: Studio(id: 'st1', name: 'Some Studio'),
  performers: [Performer(id: 'p1', name: 'First Performer'), Performer(id: 'p2', name: 'Second Performer')],
  tags: [Tag(id: '1', name: 'outdoor')],
);

const _performerScene = Scene(id: 's1', title: 'Solo', performers: [Performer(id: 'p1', name: 'First Performer')]);

const _details = SceneDetails(
  markers: [
    SceneMarker(id: '1', title: 'Intro', seconds: 0, screenshotUrl: 'http://stash/marker/1/screenshot'),
    SceneMarker(id: '2', title: 'The middle part', seconds: 40, screenshotUrl: 'http://stash/marker/2/screenshot'),
    SceneMarker(id: '3', title: 'Ending', seconds: 80, screenshotUrl: 'http://stash/marker/3/screenshot'),
  ],
);

/// "Up next" never finishes loading; favorites are recorded.
class _Repository implements StashRepository {
  bool? studioIsFavorite = false;
  Object? saveError;
  final studioSaves = <(String, bool)>[];
  final performerSaves = <(String, bool)>[];

  @override
  Future<PageResult<Scene>> findScenes(SceneQuery query, {int page = 1, int perPage = 24}) =>
      Completer<PageResult<Scene>>().future;

  @override
  Future<PageResult<Tag>> findTags(TagQuery query, {int page = 1, int perPage = 24}) =>
      Completer<PageResult<Tag>>().future;

  @override
  Future<List<String>?> sceneUrls(String id) async => const [];

  @override
  Future<bool?> studioFavorite(String studioId) async => studioIsFavorite;

  @override
  Future<void> setStudioFavorite(String studioId, bool favorite) async {
    studioSaves.add((studioId, favorite));
    if (saveError case final error?) throw error;
  }

  @override
  Future<void> setPerformerFavorite(String performerId, bool favorite) async {
    performerSaves.add((performerId, favorite));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late ProviderContainer container;
  late FakePlayer player;
  late _Repository repository;

  Future<void> setUpContainer({SceneDetails details = _details, ScrubThumbnails? thumbs}) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    player = FakePlayer(position: const Duration(seconds: 45));
    repository = _Repository();
    container = ProviderContainer(overrides: [
      ...testServer,
      sharedPreferencesProvider.overrideWithValue(prefs),
      playerProvider.overrideWithValue(player),
      authHeadersProvider.overrideWithValue(const {}),
      sceneDetailsProvider('s1').overrideWith((ref) async => details),
      scrubThumbnailsProvider('s1').overrideWith((ref) async => thumbs),
      stashRepositoryProvider.overrideWithValue(repository),
    ]);
    addTearDown(container.dispose);
  }

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
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        ),
        home: Scaffold(
          body: Column(
            children: [
              SizedBox(height: videoHeight),
              Expanded(child: PlayerDetails(scene: scene)),
            ],
          ),
        ),
      ),
    ));
    await tester.pump();
    await tester.pump();
  }

  Finder inChapters(Finder finder) => find.descendant(of: find.byType(ChapterList), matching: finder);

  group('chapters', () {
    testWidgets('show the marker screenshots with the time as a badge; a tap seeks', (tester) async {
      await setUpContainer();
      await pumpDetails(tester);

      final images = tester.widgetList<StashImage>(inChapters(find.byType(StashImage))).toList();
      expect(images.map((i) => i.url), [for (final m in _details.markers) m.screenshotUrl]);
      for (final time in ['0:00', '0:40', '1:20']) {
        expect(inChapters(find.text(time)), findsOneWidget);
      }
      // 16:9 at the compact width.
      expect(tester.getSize(inChapters(find.byType(StashImage)).first), const Size(120, 120 * 9 / 16));

      await tester.tap(inChapters(find.text('Ending')));
      expect(player.seeks, [const Duration(seconds: 80)]);
    });

    testWidgets('the chapter playing is highlighted', (tester) async {
      final semantics = tester.ensureSemantics();
      await setUpContainer();
      await pumpDetails(tester);
      // The player is at 0:45, in "The middle part".
      expect(
        tester.getSemantics(inChapters(find.text('The middle part'))),
        isSemantics(isSelected: true, isButton: true),
      );
      expect(tester.getSemantics(inChapters(find.text('Intro'))), isSemantics(isSelected: false));
      semantics.dispose();
    });

    testWidgets('without screenshots, the sprite frame at the chapter stands in', (tester) async {
      await setUpContainer(
        details: const SceneDetails(
          vttUrl: 'http://stash/s1_thumbs.vtt',
          markers: [SceneMarker(id: '1', title: 'Intro', seconds: 0), SceneMarker(id: '2', title: 'Later', seconds: 40)],
        ),
        thumbs: const ScrubThumbnails(spriteUrl: 'http://stash/s1_sprite.jpg', cues: [
          ScrubCue(start: 0, end: 30, x: 0, y: 0, width: 160, height: 90),
          ScrubCue(start: 30, end: 60, x: 160, y: 0, width: 160, height: 90),
        ]),
      );
      await pumpDetails(tester);
      final frames = tester.widgetList<SpriteFrame>(inChapters(find.byType(SpriteFrame))).toList();
      expect(frames.map((f) => f.cue.x), [0, 160]);
      expect(inChapters(find.text('0:40')), findsOneWidget);
    });

    testWidgets('without any pictures, chapters stay text tiles', (tester) async {
      await setUpContainer(
        details: const SceneDetails(markers: [SceneMarker(id: '1', title: 'Intro', seconds: 0)]),
      );
      await pumpDetails(tester);
      expect(inChapters(find.text('Intro')), findsOneWidget);
      expect(inChapters(find.byType(StashImage)), findsNothing);
      expect(inChapters(find.byType(SpriteFrame)), findsNothing);
    });

    testWidgets('thumbnail chapters fit with 2× text', (tester) async {
      await setUpContainer();
      await pumpDetails(tester, textScale: 2);
      expect(tester.takeException(), isNull, reason: 'no overflow');
      final title = inChapters(find.text('The middle part'));
      expect(tester.getSize(title).height, greaterThan(30), reason: 'drawn at the larger size');
      // The title sits below the thumbnail, inside the tile.
      final image = inChapters(find.byType(StashImage)).at(1);
      expect(tester.getTopLeft(title).dy, greaterThanOrEqualTo(tester.getBottomLeft(image).dy));
    });

    testWidgets('"Up next" still starts within the first screen on a 360×780 phone', (tester) async {
      await setUpContainer();
      await pumpDetails(tester, size: const Size(360, 780), videoHeight: 24 + 360 * 9 / 16);
      final header = find.text('More from Some Studio');
      expect(header, findsOneWidget);
      expect(tester.getBottomLeft(header).dy, lessThan(780));
      expect(inChapters(find.byType(StashImage)), findsNWidgets(3));
    });
  });

  group('channel favorite', () {
    testWidgets('a studio becomes a favorite optimistically', (tester) async {
      await setUpContainer();
      await pumpDetails(tester);
      final toggle = find.byType(StudioChannelFavorite);
      expect(toggle, findsOneWidget);
      expect(find.byTooltip('Add to favorites'), findsOneWidget);
      expect(tester.getSize(find.descendant(of: toggle, matching: find.byType(IconButton))).height,
          greaterThanOrEqualTo(48));

      await tester.tap(find.byTooltip('Add to favorites'));
      await tester.pump();
      expect(repository.studioSaves, [('st1', true)]);
      expect(find.byTooltip('Remove from favorites'), findsOneWidget);
      expect(find.descendant(of: toggle, matching: find.byIcon(Icons.favorite)), findsOneWidget);
      await tester.pump(const Duration(seconds: 2)); // confetti
    });

    testWidgets('a failed save reverts the studio and says so', (tester) async {
      await setUpContainer();
      repository.saveError = const StashApiException('nope', kind: StashErrorKind.notSaved);
      await pumpDetails(tester);
      await tester.tap(find.byTooltip('Add to favorites'));
      await tester.pump();
      await tester.pump();
      expect(find.byTooltip('Add to favorites'), findsOneWidget);
      expect(find.textContaining("Couldn't update favorite"), findsOneWidget);
      await tester.pump(const Duration(seconds: 10));
    });

    testWidgets('servers without studio favorites show no toggle', (tester) async {
      await setUpContainer();
      repository.studioIsFavorite = null;
      await pumpDetails(tester);
      expect(find.byType(StudioChannelFavorite), findsOneWidget);
      expect(find.byTooltip('Add to favorites'), findsNothing);
    });

    testWidgets('a performer channel toggles the performer', (tester) async {
      await setUpContainer();
      await pumpDetails(tester, scene: _performerScene);
      expect(find.byType(PerformerChannelFavorite), findsOneWidget);
      await tester.tap(find.byTooltip('Add to favorites'));
      await tester.pump();
      expect(repository.performerSaves, [('p1', true)]);
      expect(find.byTooltip('Remove from favorites'), findsOneWidget);
      await tester.pump(const Duration(seconds: 2));
    });
  });
}
