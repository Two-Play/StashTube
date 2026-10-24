import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
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
import 'package:stash_app_mobile/features/library/markers_tab.dart';
import 'package:stash_app_mobile/features/player/player_controls.dart';
import 'package:stash_app_mobile/features/player/player_providers.dart';
import 'package:stash_app_mobile/features/player/preview_seek_bar.dart';
import 'package:stash_app_mobile/features/player/scene_actions.dart';

import '../../fixtures.dart';
import '../../helpers.dart';
import '../fake_player.dart';

/// Ranged scene markers (an end time, newer Stash): loaded by an optional
/// query, drawn as ranges, labeled with their range and created with an end.
void main() {
  const point = SceneMarker(id: 'p', title: 'Intro', seconds: 10);
  const range = SceneMarker(id: 'r', title: 'Chase', seconds: 40, endSeconds: 70);
  const details = SceneDetails(markers: [point, range], markerRanges: true);

  group('model', () {
    test('a ranged marker is current only inside its range; a moment until the next marker', () {
      expect(details.markerAt(5), isNull);
      expect(details.markerAt(20), point);
      expect(details.markerAt(40), range);
      expect(details.markerAt(69.9), range);
      expect(details.markerAt(70), isNull, reason: 'after the range, and the moment ended at the next marker');
      // A moment inside a range: the later start wins, and a moment lasts
      // until the next marker starts (here the end of the scene).
      const nested = SceneDetails(markers: [
        SceneMarker(id: 'a', title: 'Long', seconds: 0, endSeconds: 100),
        SceneMarker(id: 'b', title: 'Kiss', seconds: 30),
      ]);
      expect(nested.markerAt(10)?.id, 'a');
      expect(nested.markerAt(50)?.id, 'b');
    });

    test('end times merge by id; an end not after the start marks no range', () {
      const plain = SceneDetails(markers: [
        SceneMarker(id: '1', title: 'A', seconds: 10),
        SceneMarker(id: '2', title: 'B', seconds: 20),
      ]);
      expect(plain.withMarkerEnds(null).markerRanges, isFalse);
      final merged = plain.withMarkerEnds({'1': 15, '2': 20});
      expect(merged.markerRanges, isTrue);
      expect([for (final m in merged.markers) m.endSeconds], [15, null]);
      expect(merged.markers.first.rangeSeconds, 5);
    });
  });

  group('repository', () {
    late List<Request> sent;

    StashRepository repo(Stream<Response> Function(Request request) answer) {
      sent = [];
      return StashRepository(GraphQLClient(
        cache: GraphQLCache(),
        defaultPolicies: DefaultPolicies(
          query: Policies(fetch: FetchPolicy.networkOnly),
          mutate: Policies(fetch: FetchPolicy.networkOnly),
        ),
        link: Link.function((request, [forward]) {
          sent.add(request);
          return answer(request);
        }),
      ));
    }

    Stream<Response> data(Map<String, dynamic> data, {String type = 'Query'}) =>
        Stream.value(Response(data: {'__typename': type, ...data}, response: const {}));

    final detailsData = {
      'findScene': sceneDetailsJson({
        'id': '1',
        'scene_markers': [
          markerJson({'id': 'm1', 'title': 'Intro', 'seconds': 10}),
          markerJson({'id': 'm2', 'title': 'Chase', 'seconds': 40}),
        ],
      }),
    };

    Stream<Response> unsupported() => Stream.value(Response(
          errors: const [GraphQLError(message: 'Cannot query field "end_seconds" on type "SceneMarker".')],
          response: const {},
        ));

    test('details get the end times from the optional query', () async {
      final r = repo((request) => switch (request.operation.operationName) {
            'FindSceneDetails' => data(detailsData),
            _ => data({
                'findScene': {
                  '__typename': 'Scene',
                  'id': '1',
                  'scene_markers': [
                    {'__typename': 'SceneMarker', 'id': 'm1', 'end_seconds': null},
                    {'__typename': 'SceneMarker', 'id': 'm2', 'end_seconds': 70.5},
                  ],
                },
              }),
          });
      final result = await r.findSceneDetails('1');
      expect(result.markerRanges, isTrue);
      expect([for (final m in result.markers) m.endSeconds], [null, 70.5]);
      expect(sent.map((r) => r.operation.operationName), containsAll(['FindSceneDetails', 'SceneMarkerEnds']));
    });

    test('a server without end times keeps its markers, without ranges, and isn\'t asked again', () async {
      final r = repo((request) => request.operation.operationName == 'FindSceneDetails' ? data(detailsData) : unsupported());
      final result = await r.findSceneDetails('1');
      expect(result.markerRanges, isFalse);
      expect(result.markers.map((m) => m.title), ['Intro', 'Chase']);
      expect(result.markers.any((m) => m.isRange), isFalse);

      sent.clear();
      await r.findSceneDetails('1');
      expect(sent.map((r) => r.operation.operationName), ['FindSceneDetails']);
    });

    test('a network error of the optional query is not taken for an old server', () async {
      final r = repo((request) => request.operation.operationName == 'FindSceneDetails'
          ? data(detailsData)
          : Stream.error(Exception('offline')));
      await expectLater(
        r.findSceneDetails('1'),
        throwsA(isA<StashApiException>().having((e) => e.isNetworkError, 'isNetworkError', isTrue)),
      );
    });

    test('the markers page merges the end times; old servers list theirs without', () async {
      final page = {
        'findSceneMarkers': {
          '__typename': 'FindSceneMarkersResultType',
          'count': 1,
          'scene_markers': [
            {
              '__typename': 'SceneMarker',
              'id': 'm1',
              'title': 'Chase',
              'seconds': 40,
              'screenshot': '',
              'preview': '',
              'primary_tag': {'__typename': 'Tag', 'id': '3', 'name': 'Action'},
              'scene': sceneJson({'id': '1', 'title': 'Sunset'}),
            },
          ],
        },
      };
      final ends = {
        'findSceneMarkers': {
          '__typename': 'FindSceneMarkersResultType',
          'scene_markers': [
            {'__typename': 'SceneMarker', 'id': 'm1', 'end_seconds': 70},
          ],
        },
      };
      var r = repo((request) => data(request.operation.operationName == 'FindSceneMarkers' ? page : ends));
      expect((await r.findMarkers(MarkerQuery())).items.single.endSeconds, 70);
      expect(sent.last.variables['ids'], ['m1']);

      r = repo((request) => request.operation.operationName == 'FindSceneMarkers' ? data(page) : unsupported());
      final old = (await r.findMarkers(MarkerQuery())).items.single;
      expect([old.title, old.endSeconds], ['Chase', null]);
    });

    test('a marker is created with its end; without one the field isn\'t sent', () async {
      final r = repo((request) => data({'sceneMarkerCreate': markerJson({'id': 'm9', 'seconds': 10})}, type: 'Mutation'));
      final created = await r.createMarker(sceneId: '1', seconds: 10, primaryTagId: '3', endSeconds: 25);
      expect(sent.single.variables['input'], containsPair('end_seconds', 25.0));
      expect(created.endSeconds, 25);

      await r.createMarker(sceneId: '1', seconds: 10, primaryTagId: '3');
      expect((sent.last.variables['input'] as Map).containsKey('end_seconds'), isFalse, reason: 'older servers reject it');
    });
  });

  group('seek bar', () {
    Future<SeekBarPainter> pumpBar(WidgetTester tester, SceneDetails details) async {
      await tester.pumpWidget(ProviderScope(
        overrides: [
          playerProvider.overrideWithValue(FakePlayer()),
          scrubThumbnailsProvider('1').overrideWith((ref) async => null),
          authHeadersProvider.overrideWithValue(const {}),
          sceneDetailsProvider('1').overrideWith((ref) async => details),
        ],
        child: const MaterialApp(
          home: Scaffold(body: Center(child: SizedBox(width: 400, child: PreviewSeekBar(sceneId: '1')))),
        ),
      ));
      await tester.pump();
      final paint = tester.widget<CustomPaint>(
        find.descendant(of: find.byType(PreviewSeekBar), matching: find.byType(CustomPaint)),
      );
      return paint.painter! as SeekBarPainter;
    }

    testWidgets('ranged markers are drawn as ranges, moments as before', (tester) async {
      final painter = await pumpBar(tester, details);
      // The fake player's scene is 100 s long.
      expect(painter.chapters, [0.1]);
      expect(painter.ranges, [(0.4, 0.7)]);
      expect(painter.markers, [0.1, 0.4], reason: 'a dot at every start');
    });

    testWidgets('scrubbing inside a range names its marker', (tester) async {
      await pumpBar(tester, details);
      final rect = tester.getRect(find.byType(PreviewSeekBar));
      final gesture = await tester.startGesture(Offset(rect.left + rect.width * 0.2, rect.center.dy));
      await tester.pump(const Duration(milliseconds: 150));
      await gesture.moveTo(Offset(rect.left + rect.width * 0.55, rect.center.dy));
      await tester.pump();
      expect(find.text('0:55 • Chase'), findsOneWidget);
      await gesture.moveTo(Offset(rect.left + rect.width * 0.85, rect.center.dy));
      await tester.pump();
      expect(find.text('1:25'), findsOneWidget, reason: 'after the range, no marker');
      await gesture.up();
      await tester.pumpAndSettle();
    });
  });

  group('chapters', () {
    late FakePlayer player;

    Future<void> pumpChapters(WidgetTester tester, {required Duration position}) async {
      player = FakePlayer(position: position);
      await tester.pumpWidget(ProviderScope(
        overrides: [
          playerProvider.overrideWithValue(player),
          authHeadersProvider.overrideWithValue(const {}),
          ...testServer,
        ],
        child: const MaterialApp(home: Scaffold(body: ChapterList(sceneId: '1', details: details))),
      ));
      await tester.pump();
    }

    testWidgets('a ranged marker shows its range and length', (tester) async {
      await pumpChapters(tester, position: Duration.zero);
      expect(find.text('0:10'), findsOneWidget);
      expect(find.text('0:40–1:10 · 0:30'), findsOneWidget);
    });

    testWidgets('the current marker follows the range', (tester) async {
      Color? tileColor(WidgetTester tester, String title) => tester
          .widget<Material>(find.ancestor(of: find.text(title), matching: find.byType(Material)).first)
          .color;
      await pumpChapters(tester, position: const Duration(seconds: 50));
      final theme = Theme.of(tester.element(find.byType(ChapterList)));
      expect(tileColor(tester, 'Chase'), theme.colorScheme.primaryContainer);
      expect(tileColor(tester, 'Intro'), isNot(theme.colorScheme.primaryContainer));

      player.position.add(const Duration(seconds: 80));
      await tester.pump(); // delivers the position
      await tester.pump();
      expect(tileColor(tester, 'Chase'), isNot(theme.colorScheme.primaryContainer), reason: 'past its end');
    });
  });

  group('add marker', () {
    late _Repo repo;
    late ProviderContainer container;

    Future<void> pumpSheet(WidgetTester tester, {required bool ranges}) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      repo = _Repo();
      container = ProviderContainer(overrides: [
        ...testServer,
        sharedPreferencesProvider.overrideWithValue(prefs),
        stashRepositoryProvider.overrideWithValue(repo),
        sceneDetailsProvider('s1').overrideWith((ref) async => SceneDetails(markerRanges: ranges)),
        playerProvider.overrideWithValue(FakePlayer(position: const Duration(seconds: 30))),
      ]);
      addTearDown(container.dispose);
      await tester.pumpWidget(UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: Scaffold(body: AddMarkerSheet(scene: _scene, seconds: 30))),
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.text('#Action'));
      await tester.pump();
    }

    testWidgets('older servers get no end field', (tester) async {
      await pumpSheet(tester, ranges: false);
      expect(find.text('Set end to current position'), findsNothing);
      await tester.tap(find.widgetWithText(FilledButton, 'Add marker'));
      await tester.pumpAndSettle();
      expect(repo.created.single, (30.0, null));
    });

    testWidgets('an end can be set, moved, must be after the start and is sent', (tester) async {
      await pumpSheet(tester, ranges: true);
      await tester.tap(find.text('Set end to current position'));
      await tester.pump();
      // The player still stands at the start: a little after it.
      expect(find.text('0:30–0:40'), findsOneWidget);

      await tester.tap(find.byTooltip('End 5 seconds earlier'));
      await tester.tap(find.byTooltip('End 5 seconds earlier'));
      await tester.pump();
      expect(find.text('The end must be after the start.'), findsOneWidget);
      final add = find.widgetWithText(FilledButton, 'Add marker');
      expect(tester.widget<FilledButton>(add).onPressed, isNull);

      await tester.tap(find.byTooltip('End 5 seconds later'));
      await tester.tap(find.byTooltip('End 5 seconds later'));
      await tester.tap(find.byTooltip('End 5 seconds later'));
      await tester.pump();
      expect(find.text('0:30–0:45'), findsOneWidget);
      await tester.tap(add);
      await tester.pumpAndSettle();
      expect(repo.created.single, (30.0, 45.0));
    });

    testWidgets('a removed end creates a moment', (tester) async {
      await pumpSheet(tester, ranges: true);
      await tester.tap(find.text('Set end to current position'));
      await tester.pump();
      await tester.tap(find.byTooltip('Remove end'));
      await tester.pump();
      await tester.tap(find.widgetWithText(FilledButton, 'Add marker'));
      await tester.pumpAndSettle();
      expect(repo.created.single, (30.0, null));
    });
  });

  testWidgets('a ranged marker tile shows its range and length', (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [...testServer, authHeadersProvider.overrideWithValue(const {})],
      child: const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 240,
            child: MarkerTile(
              marker: Marker(
                id: 'm1',
                title: 'Chase',
                seconds: 40,
                endSeconds: 70,
                tag: Tag(id: 't', name: 'Action'),
                scene: _scene,
              ),
            ),
          ),
        ),
      ),
    ));
    await tester.pump();
    expect(find.text('0:40–1:10 · 0:30'), findsOneWidget);
  });
}

const _scene = Scene(id: 's1', title: 'Sunset');

class _Repo implements StashRepository {
  final created = <(double, double?)>[];

  @override
  Future<PageResult<Tag>> findTags(TagQuery query, {int page = 1, int perPage = 24}) async =>
      const PageResult(items: [Tag(id: '3', name: 'Action')], totalCount: 1);

  @override
  Future<SceneMarker> createMarker({
    required String sceneId,
    required double seconds,
    required String primaryTagId,
    String title = '',
    double? endSeconds,
  }) async {
    created.add((seconds, endSeconds));
    return SceneMarker(id: 'n', title: title, seconds: seconds, endSeconds: endSeconds);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
