import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/data/models/marker.dart';
import 'package:stash_app_mobile/data/models/page_result.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/models/scene_details.dart';
import 'package:stash_app_mobile/data/models/tag.dart';
import 'package:stash_app_mobile/data/providers.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/data/repositories/stash_session.dart';
import 'package:stash_app_mobile/features/player/player_providers.dart';
import 'package:stash_app_mobile/features/player/preview_seek_bar.dart';
import 'package:stash_app_mobile/features/shorts/short.dart';
import 'package:stash_app_mobile/features/shorts/short_tile.dart';
import 'package:stash_app_mobile/features/shorts/shorts_page.dart';
import 'package:stash_app_mobile/features/shorts/shorts_settings_sheet.dart';
import 'package:stash_app_mobile/widgets/stash_image.dart';

import '../helpers.dart';
import 'fake_player.dart';

const _scene = Scene(id: 's1', title: 'Sunset', streamUrl: 'http://s/s1', duration: 100, resumeTime: 70);

Marker _marker({double seconds = 30, double? end}) => Marker(
      id: 'm1',
      title: 'Kiss',
      seconds: seconds,
      endSeconds: end,
      tag: const Tag(id: '1', name: 'Beach'),
      scene: _scene,
    );

class _Playing extends NowPlayingNotifier {
  final played = <(String, double?)>[];

  @override
  Scene? build() => null;

  @override
  void play(Scene scene, {double? at, bool remember = true}) => played.add((scene.id, at));
}

class _TagRepository implements StashRepository {
  @override
  Future<PageResult<Tag>> findTags(TagQuery query, {int page = 1, int perPage = 24}) async =>
      const PageResult(items: [Tag(id: '1', name: 'Beach')], totalCount: 1);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('seek bar with a window (marker shorts)', () {
    late FakePlayer player;

    // The clip runs from 0:30 to 0:50 of a 100 s scene.
    const window = (start: Duration(seconds: 30), end: Duration(seconds: 50));
    const details = SceneDetails(markers: [
      SceneMarker(id: 'a', title: 'Before', seconds: 10),
      SceneMarker(id: 'm1', title: 'Kiss', seconds: 30),
      SceneMarker(id: 'b', title: 'Inside', seconds: 35),
      SceneMarker(id: 'c', title: 'Overlapping', seconds: 45, endSeconds: 70),
      SceneMarker(id: 'd', title: 'After', seconds: 80),
    ]);

    /// [relative]: the player plays only the clip (a loop's EDL), so its
    /// times run from the clip's start.
    Future<void> pump(WidgetTester tester, {Duration position = const Duration(seconds: 40), bool relative = false}) async {
      player = relative
          ? FakePlayer(position: position - window.start, duration: window.end - window.start)
          : FakePlayer(position: position);
      await tester.pumpWidget(ProviderScope(
        overrides: [
          playerProvider.overrideWithValue(player),
          scrubThumbnailsProvider('1').overrideWith((ref) async => null),
          authHeadersProvider.overrideWithValue(const {}),
          sceneDetailsProvider('1').overrideWith((ref) async => details),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 400,
                child: PreviewSeekBar(sceneId: '1', window: window, windowRelative: relative),
              ),
            ),
          ),
        ),
      ));
      await tester.pump();
    }

    Offset at(WidgetTester tester, double fraction) {
      final rect = tester.getRect(find.byType(PreviewSeekBar));
      return Offset(rect.left + rect.width * fraction, rect.center.dy);
    }

    SeekBarPainter painter(WidgetTester tester) => tester
        .widget<CustomPaint>(find.descendant(of: find.byType(PreviewSeekBar), matching: find.byType(CustomPaint)))
        .painter! as SeekBarPainter;

    testWidgets('maps the bar to the clip and draws only the markers inside it', (tester) async {
      await pump(tester);
      final bar = painter(tester);
      expect(bar.played, 0.5, reason: '0:40 is the middle of 0:30–0:50');
      expect(bar.chapters, [0.25], reason: 'the clip\'s own marker and those outside are left out');
      expect(bar.ranges, [(0.75, 1.0)], reason: 'a range reaching past the end is cut to the clip');
    });

    testWidgets('a player that plays only the clip: same bar, seeks from the clip\'s start', (tester) async {
      await pump(tester, relative: true);
      final bar = painter(tester);
      expect(bar.played, 0.5, reason: '0:10 into the clip is 0:40 of the scene');
      expect(bar.chapters, [0.25], reason: 'markers at their absolute times');
      await tester.tapAt(at(tester, 0.25));
      await tester.pumpAndSettle();
      expect(player.seeks, [const Duration(seconds: 5)], reason: 'the player only knows the clip');
    });

    testWidgets('tapping seeks inside the clip', (tester) async {
      await pump(tester);
      await tester.tapAt(at(tester, 0.5));
      await tester.pumpAndSettle();
      expect(player.seeks, [const Duration(seconds: 40)]);
      await tester.tapAt(at(tester, 0.0));
      await tester.pumpAndSettle();
      expect(player.seeks.last, const Duration(seconds: 30));
    });

    testWidgets('dragging past the end seeks at most to the clip\'s end; the label is relative', (tester) async {
      await pump(tester);
      final gesture = await tester.startGesture(at(tester, 0.1));
      await tester.pump(const Duration(milliseconds: 150));
      await gesture.moveTo(at(tester, 0.3));
      await tester.pump();
      // 0:06 into the clip is 0:36 of the scene: the chapter there is found
      // at the absolute time.
      expect(find.text('0:06 • Inside'), findsOneWidget);
      await gesture.moveTo(at(tester, 1.5));
      await tester.pump();
      expect(find.text('0:20 • Overlapping'), findsOneWidget);
      await gesture.up();
      await tester.pumpAndSettle();
      expect(player.seeks, [const Duration(seconds: 50)]);
    });

    testWidgets('screen readers hear the clip\'s time and step inside it', (tester) async {
      final handle = tester.ensureSemantics();
      await pump(tester, position: const Duration(seconds: 45));
      final node = tester.getSemantics(find.bySemanticsLabel('Seek bar'));
      expect(node.value, '15 seconds of 20 seconds');
      node.owner!.performAction(node.id, SemanticsAction.increase);
      await tester.pump();
      expect(player.seeks.last, const Duration(seconds: 50), reason: 'not past the clip');
      handle.dispose();
    });

    testWidgets('without a window the bar covers the whole video', (tester) async {
      player = FakePlayer(position: const Duration(seconds: 40));
      await tester.pumpWidget(ProviderScope(
        overrides: [
          playerProvider.overrideWithValue(player),
          scrubThumbnailsProvider('1').overrideWith((ref) async => null),
          authHeadersProvider.overrideWithValue(const {}),
          sceneDetailsProvider('1').overrideWith((ref) async => details),
        ],
        child: const MaterialApp(
          home: Scaffold(body: Center(child: SizedBox(width: 400, child: PreviewSeekBar(sceneId: '1')))),
        ),
      ));
      await tester.pump();
      final bar = painter(tester);
      expect(bar.played, 0.4);
      expect(bar.chapters, [0.1, 0.3, 0.35, 0.8]);
      expect(bar.ranges, [(0.45, 0.7)]);
    });
  });

  group('zoom', () {
    test('cover only when it crops little, else the whole picture', () {
      const phone = 390 / 844;
      const landscapeTablet = 1280 / 800;
      const portraitTablet = 800 / 1280;
      expect(Short.fitFor(9 / 16, phone), BoxFit.cover, reason: 'a portrait video fills a phone');
      expect(Short.fitFor(9 / 16, landscapeTablet), BoxFit.contain, reason: 'no zoom to the tablet\'s width');
      expect(Short.fitFor(9 / 16, portraitTablet), BoxFit.cover);
      expect(Short.fitFor(16 / 9, phone), BoxFit.contain);
      expect(Short.fitFor(16 / 9, landscapeTablet), BoxFit.cover);
      expect(Short.fitFor(null, phone), BoxFit.contain);
    });
  });

  group('short tile', () {
    Future<void> pumpTile(WidgetTester tester, Short short) => tester.pumpWidget(ProviderScope(
          overrides: [...testServer, authHeadersProvider.overrideWithValue(const {})],
          child: MaterialApp(
            home: Scaffold(
              body: Center(child: SizedBox(width: 135, height: 240, child: ShortTile(short: short, onTap: () {}))),
            ),
          ),
        ));

    testWidgets('a whole video: title and length', (tester) async {
      await pumpTile(tester, const Short.video(_scene));
      expect(find.text('Sunset'), findsOneWidget);
      expect(find.text('1:40'), findsOneWidget);
      expect(find.byIcon(Icons.bookmark), findsNothing);
      expect(find.bySemanticsLabel('Sunset, 1 minute 40 seconds'), findsOneWidget);
    });

    testWidgets('a landscape scene shows whole in the 9:16 tile, a portrait one fills it', (tester) async {
      BoxFit fit() => tester.widget<StashImage>(find.byType(StashImage)).fit;
      await pumpTile(tester, const Short.video(Scene(id: 'w', title: 'Wide', width: 1920, height: 1080)));
      expect(fit(), BoxFit.contain);
      await pumpTile(tester, const Short.video(Scene(id: 'p', title: 'Tall', width: 1080, height: 1920)));
      expect(fit(), BoxFit.cover);
    });

    testWidgets('a marker: badge, its title and its clip\'s length', (tester) async {
      await pumpTile(tester, Short.marker(_marker(seconds: 30)));
      expect(find.text('Kiss'), findsOneWidget);
      expect(find.text('0:20'), findsOneWidget);
      expect(find.byIcon(Icons.bookmark), findsOneWidget);
      expect(find.bySemanticsLabel('Marker: Kiss, Sunset, 20 seconds'), findsOneWidget);
    });
  });

  group('shorts settings sheet', () {
    testWidgets('no content choice any more: the loops have their own switch', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(overrides: [
        ...testServer,
        sharedPreferencesProvider.overrideWithValue(prefs),
        stashRepositoryProvider.overrideWithValue(_TagRepository()),
      ]);
      addTearDown(container.dispose);
      await tester.pumpWidget(UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(onPressed: () => showShortsSettingsSheet(context), child: const Text('open')),
            ),
          ),
        ),
      ));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      final hint = find.textContaining('Loops play scene markers');
      await tester.scrollUntilVisible(
        hint,
        200,
        scrollable: find.descendant(of: find.byType(ListView), matching: find.byType(Scrollable)).first,
      );
      expect(hint, findsOneWidget);
      expect(find.text('Content'), findsNothing);
    });
  });

  group('full video', () {
    Future<_Playing> pumpButton(WidgetTester tester, Short short, {Duration? position}) async {
      final playing = _Playing();
      await tester.pumpWidget(ProviderScope(
        overrides: [nowPlayingProvider.overrideWith(() => playing)],
        child: MaterialApp(
          home: Consumer(
            builder: (context, ref, _) => TextButton(
              onPressed: () => playFullVideo(ref, short, position: position),
              child: const Text('full'),
            ),
          ),
        ),
      ));
      await tester.tap(find.text('full'));
      return playing;
    }

    testWidgets('a marker opens its scene at the marker', (tester) async {
      expect((await pumpButton(tester, Short.marker(_marker(seconds: 30)))).played, [('s1', 30.0)]);
    });

    testWidgets('a ranged marker opens at its start, like its chapter', (tester) async {
      expect((await pumpButton(tester, Short.marker(_marker(seconds: 40, end: 60)))).played, [('s1', 40.0)]);
    });

    testWidgets('a whole video resumes where it was left', (tester) async {
      expect((await pumpButton(tester, const Short.video(_scene))).played, [('s1', null)]);
    });

    testWidgets('the player continues where the short is', (tester) async {
      final video = await pumpButton(tester, const Short.video(_scene), position: const Duration(seconds: 12));
      expect(video.played, [('s1', 12.0)]);
    });

    testWidgets('a loop continues at the clip\'s spot in the scene', (tester) async {
      final loop = await pumpButton(tester, Short.marker(_marker(seconds: 30)), position: const Duration(seconds: 7));
      expect(loop.played, [('s1', 37.0)], reason: 'the clip counts from the marker\'s start');
    });
  });
}
