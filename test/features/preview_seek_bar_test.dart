import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/providers.dart';
import 'package:stash_app_mobile/features/player/player_providers.dart';
import 'package:stash_app_mobile/features/player/preview_seek_bar.dart';

import 'fake_player.dart';

void main() {
  late FakePlayer player;

  Future<void> pump(WidgetTester tester) async {
    player = FakePlayer();
    await tester.pumpWidget(ProviderScope(
      overrides: [
        playerProvider.overrideWithValue(player),
        scrubThumbnailsProvider('1').overrideWith((ref) async => null),
        authHeadersProvider.overrideWithValue(const {}),
      ],
      child: const MaterialApp(
        home: Scaffold(
          // Loose width like in the controls' Column (regression: the bar
          // used to collapse to zero width there).
          body: Center(child: SizedBox(width: 400, child: Column(children: [PreviewSeekBar(sceneId: '1')]))),
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
    expect(find.text('1:20'), findsOneWidget, reason: 'preview shows the target time');
    expect(player.seeks, isEmpty, reason: 'no seek while dragging');

    await gesture.up();
    await tester.pumpAndSettle();
    expect(player.seeks, [const Duration(seconds: 80)]);
  });
}
