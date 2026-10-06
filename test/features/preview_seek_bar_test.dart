import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/models/scene_details.dart';
import 'package:stash_app_mobile/data/providers.dart';
import 'package:stash_app_mobile/features/player/player_providers.dart';
import 'package:stash_app_mobile/features/player/preview_seek_bar.dart';

import 'fake_player.dart';

void main() {
  late FakePlayer player;
  late int thumbnailLoads;

  Future<void> pump(WidgetTester tester, {bool visible = true}) async {
    player = FakePlayer();
    thumbnailLoads = 0;
    await tester.pumpWidget(ProviderScope(
      overrides: [
        playerProvider.overrideWithValue(player),
        scrubThumbnailsProvider('1').overrideWith((ref) async {
          thumbnailLoads++;
          return null;
        }),
        authHeadersProvider.overrideWithValue(const {}),
        sceneDetailsProvider('1').overrideWith(
          (ref) async => const SceneDetails(markers: [SceneMarker(id: 'm', title: 'Intro', seconds: 30)]),
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          // Loose width like in the controls' Column (regression: the bar
          // used to collapse to zero width there).
          body: Center(
            child: SizedBox(width: 400, child: Column(children: [PreviewSeekBar(sceneId: '1', visible: visible)])),
          ),
        ),
      ),
    ));
  }

  Offset at(WidgetTester tester, double fraction) {
    final rect = tester.getRect(find.byType(PreviewSeekBar));
    return Offset(rect.left + rect.width * fraction, rect.center.dy);
  }

  testWidgets('takes the full available width', (tester) async {
    await pump(tester);
    expect(tester.getSize(find.byType(PreviewSeekBar)).width, 400);
  });

  testWidgets('tapping seeks to that position', (tester) async {
    await pump(tester);
    await tester.tapAt(at(tester, 0.5));
    await tester.pumpAndSettle();
    expect(player.seeks, [const Duration(seconds: 50)]);
  });

  testWidgets('dragging shows the target time and seeks once on release', (tester) async {
    await pump(tester);
    final gesture = await tester.startGesture(at(tester, 0.1));
    await tester.pump(const Duration(milliseconds: 150)); // a finger rests briefly before moving
    await gesture.moveTo(at(tester, 0.4));
    await tester.pump();
    await gesture.moveTo(at(tester, 0.8));
    await tester.pump();
    expect(find.text('1:20 • Intro'), findsOneWidget, reason: 'preview shows the target time and chapter');
    expect(player.seeks, isEmpty, reason: 'no seek while dragging');

    await gesture.up();
    await tester.pumpAndSettle();
    expect(player.seeks, [const Duration(seconds: 80)]);
  });

  testWidgets('a hidden bar loads the thumbnails only when touched', (tester) async {
    await pump(tester, visible: false);
    await tester.pump();
    expect(thumbnailLoads, 0);
    await tester.tapAt(at(tester, 0.5));
    await tester.pumpAndSettle();
    expect(thumbnailLoads, 1);
  });

  testWidgets('a visible bar loads the thumbnails before the first scrub', (tester) async {
    await pump(tester);
    await tester.pump();
    expect(thumbnailLoads, 1);
  });

  testWidgets('tapping near a marker jumps exactly to it', (tester) async {
    await pump(tester);
    await tester.pump();
    await tester.tapAt(at(tester, 0.32)); // 8 px from the marker at 30 %
    await tester.pumpAndSettle();
    expect(player.seeks, [const Duration(seconds: 30)]);

    await tester.tapAt(at(tester, 0.4)); // too far away
    await tester.pumpAndSettle();
    expect(player.seeks.last, const Duration(seconds: 40));
  });
}
