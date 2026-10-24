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
import 'package:stash_app_mobile/features/player/player_view.dart';
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

/// "Up next" that never finishes loading.
class _LoadingRepository implements StashRepository {
  @override
  Future<PageResult<Scene>> findScenes(SceneQuery query, {int page = 1, int perPage = 24}) =>
      Completer<PageResult<Scene>>().future;

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

  Future<void> pumpDetails(WidgetTester tester, {double textScale = 1}) async {
    tester.view.physicalSize = const Size(320, 640);
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
        home: const Scaffold(body: PlayerDetails(scene: _scene)),
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
    for (final text in ['First Performer', '#outdoor', 'The middle part', 'Some Studio']) {
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

    // The rating's stars keep 48 dp targets.
    final star = find.byIcon(Icons.star_rounded).first;
    final button = find.ancestor(of: star, matching: find.byType(IconButton));
    expect(tester.getSize(button).height, greaterThanOrEqualTo(48));
    expect(tester.getSize(button).width, greaterThanOrEqualTo(48));
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
