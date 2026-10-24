import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/providers.dart';
import 'package:stash_app_mobile/data/repositories/stash_session.dart';
import 'package:stash_app_mobile/features/player/player_providers.dart';
import 'package:stash_app_mobile/features/player/touch_lock.dart';
import 'package:stash_app_mobile/features/player/video_controls.dart';
import 'package:stash_app_mobile/features/player/video_zoom.dart';

import '../../helpers.dart';
import '../fake_player.dart';

void main() {
  late FakePlayer player;
  late ValueNotifier<bool> fullscreen;

  Future<void> pump(WidgetTester tester) async {
    player = FakePlayer(playing: true, position: const Duration(seconds: 30));
    fullscreen = ValueNotifier(true);
    await tester.pumpWidget(ProviderScope(
      overrides: [
        ...testServer,
        playerProvider.overrideWithValue(player),
        scrubThumbnailsProvider('1').overrideWith((ref) async => null),
        authHeadersProvider.overrideWithValue(const {}),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 400,
              height: 300,
              child: ValueListenableBuilder<bool>(
                valueListenable: fullscreen,
                builder: (_, isFullscreen, _) => StashVideoControls(
                  fullscreen: isFullscreen,
                  onToggleFullscreen: () => fullscreen.value = !fullscreen.value,
                  scene: const Scene(id: '1', title: 'A'),
                  onQuality: () {},
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }

  bool controlsVisible(WidgetTester tester) => tester
      .widgetList<AnimatedOpacity>(
          find.descendant(of: find.byType(StashVideoControls), matching: find.byType(AnimatedOpacity)))
      .any((o) => o.opacity == 1 && o.child is SafeArea);

  Rect videoRect(WidgetTester tester) => tester.getRect(find.byType(StashVideoControls));

  Future<void> tapVideo(WidgetTester tester) async {
    final rect = videoRect(tester);
    await tester.tapAt(Offset(rect.left + 100, rect.center.dy + 40));
    await tester.pump(kDoubleTapTimeout + const Duration(milliseconds: 10));
  }

  Future<void> lock(WidgetTester tester) async {
    await tapVideo(tester);
    await tester.tap(find.byTooltip('Lock screen'));
    await tester.pump();
    // The lock icon shows briefly to confirm, then goes.
    expect(find.text('Hold to unlock'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
  }

  bool lockIconVisible(WidgetTester tester) => tester
      .widget<AnimatedOpacity>(
          find.ancestor(of: find.text('Hold to unlock'), matching: find.byType(AnimatedOpacity)).first)
      .opacity == 1;

  testWidgets('the lock button is only in fullscreen', (tester) async {
    await pump(tester);
    await tapVideo(tester);
    expect(find.byTooltip('Lock screen'), findsOneWidget);
    fullscreen.value = false;
    await tester.pump();
    expect(find.byTooltip('Lock screen'), findsNothing);
  });

  testWidgets('locked: taps, double taps, holds and pinches do nothing', (tester) async {
    await pump(tester);
    await lock(tester);
    expect(controlsVisible(tester), isFalse);
    expect(lockIconVisible(tester), isFalse);

    // Double tap on the right: no seek.
    final rect = videoRect(tester);
    final right = Offset(rect.right - 30, rect.center.dy + 60);
    await tester.tapAt(right);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tapAt(right);
    await tester.pump(const Duration(milliseconds: 400));
    expect(player.seeks, isEmpty);
    expect(controlsVisible(tester), isFalse);
    // A tap only shows the lock icon, for about 2 s.
    expect(lockIconVisible(tester), isTrue);
    await tester.pump(const Duration(seconds: 3));
    expect(lockIconVisible(tester), isFalse);

    // Holding the video: no 2×.
    final hold = await tester.startGesture(Offset(rect.left + 60, rect.bottom - 30));
    await tester.pump(const Duration(seconds: 2));
    await hold.up();
    await tester.pump();
    expect(player.rates, isEmpty);

    // Pinching: no zoom.
    final container = ProviderScope.containerOf(tester.element(find.byType(StashVideoControls)));
    final center = rect.center + const Offset(0, 60);
    final a = await tester.startGesture(center - const Offset(40, 0));
    final b = await tester.startGesture(center + const Offset(40, 0));
    await tester.pump();
    await a.moveTo(center - const Offset(80, 0));
    await b.moveTo(center + const Offset(80, 0));
    await tester.pump();
    await a.up();
    await b.up();
    await tester.pump(const Duration(seconds: 3));
    expect(container.read(videoZoomProvider).isZoomed, isFalse);
    expect(controlsVisible(tester), isFalse);
  });

  testWidgets('holding the lock icon for a second unlocks', (tester) async {
    await pump(tester);
    await lock(tester);
    await tapVideo(tester);
    expect(lockIconVisible(tester), isTrue);

    // A short press doesn't unlock.
    await tester.tap(find.text('Hold to unlock'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Hold to unlock'), findsOneWidget);

    final gesture = await tester.startGesture(tester.getCenter(find.text('Hold to unlock')));
    // Longer than the icon would show by itself: it stays while held.
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 600));
    await gesture.up();
    await tester.pump();
    expect(find.text('Hold to unlock'), findsNothing);
    expect(controlsVisible(tester), isTrue);

    // Gestures work again.
    await tester.pump(const Duration(seconds: 4));
    final rect = videoRect(tester);
    final right = Offset(rect.right - 30, rect.center.dy + 60);
    await tester.tapAt(right);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tapAt(right);
    await tester.pump(const Duration(seconds: 1));
    expect(player.seeks, [const Duration(seconds: 40)]);
  });

  testWidgets('leaving fullscreen unlocks', (tester) async {
    await pump(tester);
    await lock(tester);
    fullscreen.value = false;
    await tester.pump();
    expect(find.text('Hold to unlock'), findsNothing);
    await tapVideo(tester);
    expect(controlsVisible(tester), isTrue);
    // Back in fullscreen it isn't locked either.
    await tester.pump(const Duration(seconds: 4));
    fullscreen.value = true;
    await tester.pump();
    await tapVideo(tester);
    expect(controlsVisible(tester), isTrue);
  });

  testWidgets('screen readers get an unlock action', (tester) async {
    final semantics = tester.ensureSemantics();
    await pump(tester);
    await lock(tester);
    final node = tester.getSemantics(find.byType(TouchLockLayer));
    expect(node.label, 'Screen locked');
    expect(node.getSemanticsData().hasAction(SemanticsAction.longPress), isTrue);
    tester.semantics.longPress(find.semantics.byLabel('Screen locked'));
    await tester.pump();
    expect(find.text('Hold to unlock'), findsNothing);
    expect(controlsVisible(tester), isTrue);
    semantics.dispose();
  });
}
