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
import 'package:stash_app_mobile/features/shorts/shorts_settings.dart';
import 'package:stash_app_mobile/features/shorts/shorts_settings_sheet.dart';
import 'package:stash_app_mobile/l10n/l10n.dart';

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
  void play(Scene scene, {double? at}) => played.add((scene.id, at));
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

    Future<void> pump(WidgetTester tester, {Duration position = const Duration(seconds: 40)}) async {
      player = FakePlayer(position: position);
      await tester.pumpWidget(ProviderScope(
        overrides: [
          playerProvider.overrideWithValue(player),
          scrubThumbnailsProvider('1').overrideWith((ref) async => null),
          authHeadersProvider.overrideWithValue(const {}),
          sceneDetailsProvider('1').overrideWith((ref) async => details),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: Center(child: SizedBox(width: 400, child: PreviewSeekBar(sceneId: '1', window: window))),
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

  group('marker shorts stay in their clip', () {
    final short = Short.marker(_marker(seconds: 30));

    test('back to the start once the position left the clip', () {
      expect(short.correctionFor(const Duration(seconds: 40)), isNull);
      expect(short.correctionFor(const Duration(milliseconds: 50400)), isNull,
          reason: 'the A-B loop jumps back a moment after the end');
      expect(short.correctionFor(const Duration(seconds: 55)), const Duration(seconds: 30));
      expect(short.correctionFor(Duration.zero), const Duration(seconds: 30),
          reason: 'e.g. the scene ended and looped');
      expect(const Short.video(_scene).correctionFor(Duration.zero), isNull);
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

    testWidgets('a marker: badge, its title and its clip\'s length', (tester) async {
      await pumpTile(tester, Short.marker(_marker(seconds: 30)));
      expect(find.text('Kiss'), findsOneWidget);
      expect(find.text('0:20'), findsOneWidget);
      expect(find.byIcon(Icons.bookmark), findsOneWidget);
      expect(find.bySemanticsLabel('Marker: Kiss, Sunset, 20 seconds'), findsOneWidget);
    });
  });

  group('shorts settings sheet', () {
    testWidgets('the markers are a segmented choice, saved on apply', (tester) async {
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

      final l = lookupAppLocalizations(const Locale('en'));
      final segmented = find.byType(SegmentedButton<ShortsMarkers>);
      await tester.scrollUntilVisible(
        segmented,
        200,
        scrollable: find.descendant(of: find.byType(ListView), matching: find.byType(Scrollable)).first,
      );
      expect(
        tester.widget<SegmentedButton<ShortsMarkers>>(segmented).selected,
        {ShortsMarkers.off},
        reason: 'off by default',
      );
      await tester.tap(find.descendant(of: segmented, matching: find.text(l.shortsMarkersOnly)));
      await tester.pumpAndSettle();
      expect(tester.widget<SegmentedButton<ShortsMarkers>>(segmented).selected, {ShortsMarkers.only});
      expect(container.read(shortsSettingsProvider).markers, ShortsMarkers.off, reason: 'not before applying');

      await tester.tap(find.text(l.apply));
      await tester.pumpAndSettle();
      expect(container.read(shortsSettingsProvider).markers, ShortsMarkers.only);
    });
  });

  group('full video', () {
    Future<_Playing> pumpButton(WidgetTester tester, Short short) async {
      final playing = _Playing();
      await tester.pumpWidget(ProviderScope(
        overrides: [nowPlayingProvider.overrideWith(() => playing)],
        child: MaterialApp(
          home: Consumer(
            builder: (context, ref, _) => TextButton(
              onPressed: () => playFullVideo(ref, short),
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
  });
}
