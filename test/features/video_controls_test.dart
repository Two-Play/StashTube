import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/providers.dart';
import 'package:stash_app_mobile/features/player/player_providers.dart';
import 'package:stash_app_mobile/features/player/preview_seek_bar.dart';
import 'package:stash_app_mobile/features/player/video_controls.dart';
import 'package:stash_app_mobile/widgets/hold_detector.dart';

import 'fake_player.dart';

void main() {
  late FakePlayer player;
  var fullscreenToggles = 0;

  Future<void> pump(WidgetTester tester, {bool playing = true}) async {
    player = FakePlayer(playing: playing, position: const Duration(seconds: 30));
    fullscreenToggles = 0;
    await tester.pumpWidget(ProviderScope(
      overrides: [
        playerProvider.overrideWithValue(player),
        scrubThumbnailsProvider('1').overrideWith((ref) async => null),
        authHeadersProvider.overrideWithValue(const {}),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 400,
              height: 225,
              child: StashVideoControls(
                fullscreen: false,
                onToggleFullscreen: () => fullscreenToggles++,
                scene: const Scene(id: '1', title: 'A'),
                onQuality: () {},
              ),
            ),
          ),
        ),
      ),
    ));
  }

  bool controlsVisible(WidgetTester tester) =>
      tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity).last).opacity == 1;

  Future<void> tapVideo(WidgetTester tester) async {
    // Empty space: middle row, between the left edge and the play button.
    final rect = tester.getRect(find.byType(StashVideoControls));
    await tester.tapAt(Offset(rect.left + 100, rect.center.dy));
    await tester.pump(kDoubleTapTimeout + const Duration(milliseconds: 10));
  }

  testWidgets('tap shows the controls, they hide again after a while when playing', (tester) async {
    await pump(tester);
    expect(controlsVisible(tester), isFalse);
    await tapVideo(tester);
    expect(controlsVisible(tester), isTrue);
    await tester.pump(const Duration(seconds: 4));
    expect(controlsVisible(tester), isFalse);
  });

  testWidgets('controls stay visible while paused', (tester) async {
    await pump(tester, playing: false);
    await tapVideo(tester);
    await tester.pump(const Duration(seconds: 10));
    expect(controlsVisible(tester), isTrue);
  });

  testWidgets('controls stay visible during a long scrub (regression)', (tester) async {
    await pump(tester);
    await tapVideo(tester);
    final bar = tester.getRect(find.byType(PreviewSeekBar));
    final gesture = await tester.startGesture(Offset(bar.left + bar.width * 0.2, bar.center.dy));
    await tester.pump(const Duration(milliseconds: 150));
    await gesture.moveBy(const Offset(60, 0));
    await tester.pump(const Duration(seconds: 2));
    await gesture.moveBy(const Offset(60, 0));
    await tester.pump(const Duration(seconds: 3)); // longer than hideAfter in total
    expect(controlsVisible(tester), isTrue);
    expect(find.byType(PreviewSeekBar), findsOneWidget);

    await gesture.up();
    await tester.pump();
    expect(player.seeks, hasLength(1));
    await tester.pump(const Duration(seconds: 4));
    expect(controlsVisible(tester), isFalse, reason: 'hides again after the scrub');
  });

  testWidgets('double tap right/left seeks ±10 s', (tester) async {
    await pump(tester);
    final rect = tester.getRect(find.byType(StashVideoControls));
    final right = Offset(rect.right - 30, rect.center.dy);
    await tester.tapAt(right);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tapAt(right);
    await tester.pump();
    expect(player.seeks, [const Duration(seconds: 40)]);

    final left = Offset(rect.left + 30, rect.center.dy);
    await tester.tapAt(left);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tapAt(left);
    await tester.pump(const Duration(seconds: 1));
    expect(player.seeks.last, const Duration(seconds: 30));
  });

  testWidgets('tapping empty space hides visible controls', (tester) async {
    await pump(tester, playing: false);
    await tapVideo(tester);
    expect(controlsVisible(tester), isTrue);
    await tapVideo(tester);
    expect(controlsVisible(tester), isFalse);
  });

  testWidgets('play/pause and fullscreen buttons work', (tester) async {
    await pump(tester);
    await tapVideo(tester);
    await tester.tap(find.byTooltip('Pause'));
    expect(player.playOrPauseCalls, 1, reason: 'immediately, without waiting for a double tap');
    await tester.tap(find.byTooltip('Fullscreen'));
    expect(fullscreenToggles, 1);
  });

  testWidgets('holding the video plays at double speed until released', (tester) async {
    await pump(tester);
    final rect = tester.getRect(find.byType(StashVideoControls));
    final gesture = await tester.startGesture(Offset(rect.left + 100, rect.center.dy));
    await tester.pump(kHoldDelay + const Duration(milliseconds: 50));
    expect(player.rates, [2.0]);
    expect(find.text('2× speed'), findsOneWidget);
    await gesture.up();
    await tester.pump();
    expect(player.rates, [2.0, 1.0]);
    expect(find.text('2× speed'), findsNothing);
  });

  testWidgets('the speed button picks a playback speed', (tester) async {
    await pump(tester);
    await tapVideo(tester);
    await tester.tap(find.text('1×'));
    await tester.pumpAndSettle();
    expect(find.text('Normal'), findsOneWidget);
    await tester.tap(find.text('1.5×'));
    await tester.pumpAndSettle();
    expect(player.rates, [1.5]);
  });
}
