import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/providers.dart';
import 'package:stash_app_mobile/data/repositories/stash_session.dart';
import 'package:stash_app_mobile/features/player/gesture_hints.dart';
import 'package:stash_app_mobile/features/player/player_providers.dart';
import 'package:stash_app_mobile/features/player/video_controls.dart';

import '../../helpers.dart';
import '../fake_player.dart';

/// A playback error that can be raised mid-test.
class _Errors extends PlaybackErrorNotifier {
  _Errors(this.initial);

  final PlaybackError? initial;

  @override
  PlaybackError? build() => initial;
}

void main() {
  late SharedPreferences prefs;

  Future<void> pump(WidgetTester tester, {Map<String, Object> stored = const {}, PlaybackError? error}) async {
    SharedPreferences.setMockInitialValues(stored);
    prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(ProviderScope(
      overrides: [
        ...testServer,
        sharedPreferencesProvider.overrideWithValue(prefs),
        playerProvider.overrideWithValue(FakePlayer(position: const Duration(seconds: 30))),
        scrubThumbnailsProvider('1').overrideWith((ref) async => null),
        authHeadersProvider.overrideWithValue(const {}),
        playbackErrorProvider.overrideWith(() => _Errors(error)),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 400,
              height: 225,
              child: StashVideoControls(
                fullscreen: false,
                onToggleFullscreen: _noop,
                scene: Scene(id: '1', title: 'A'),
                onQuality: _noop,
              ),
            ),
          ),
        ),
      ),
    ));
  }

  Future<void> tapVideo(WidgetTester tester) async {
    final rect = tester.getRect(find.byType(StashVideoControls));
    await tester.tapAt(Offset(rect.left + 100, rect.center.dy));
    await tester.pump(kDoubleTapTimeout + const Duration(milliseconds: 10));
    await tester.pump(const Duration(milliseconds: 300));
  }

  testWidgets('the first time the controls show, the gesture tips come instead', (tester) async {
    await pump(tester);
    expect(find.byType(GestureTipsOverlay), findsNothing);
    await tapVideo(tester);
    expect(find.byType(GestureTipsOverlay), findsOneWidget);
    expect(find.text('Player gestures'), findsOneWidget);
    expect(find.text('Hold: 2× speed'), findsOneWidget);
    expect(find.text('Double-tap left or right: ±10 s'), findsOneWidget);
    expect(find.text('Pinch: zoom'), findsOneWidget);
    expect(find.text('Swipe down: minimize'), findsOneWidget);
  });

  testWidgets('"Got it" dismisses them for good and shows the controls', (tester) async {
    await pump(tester);
    await tapVideo(tester);
    await tester.tap(find.text('Got it'));
    await tester.pump();
    expect(find.byType(GestureTipsOverlay), findsNothing);
    expect(prefs.getBool('gesture_tips_seen'), isTrue);
    // The controls are up now.
    expect(find.byTooltip('Fullscreen'), findsOneWidget);
    await tester.pump(const Duration(seconds: 4));

    // Next time, only the controls.
    await tapVideo(tester);
    expect(find.byType(GestureTipsOverlay), findsNothing);
  });

  testWidgets('a tap anywhere skips them too', (tester) async {
    await pump(tester);
    await tapVideo(tester);
    await tester.tapAt(tester.getTopLeft(find.byType(StashVideoControls)) + const Offset(10, 10));
    await tester.pump();
    expect(find.byType(GestureTipsOverlay), findsNothing);
    expect(prefs.getBool('gesture_tips_seen'), isTrue);
  });

  testWidgets('not shown once dismissed in an earlier run', (tester) async {
    await pump(tester, stored: {'gesture_tips_seen': true});
    await tapVideo(tester);
    expect(find.byType(GestureTipsOverlay), findsNothing);
  });

  testWidgets('not shown over a playback error', (tester) async {
    await pump(tester, error: const PlaybackError('boom'));
    await tapVideo(tester);
    expect(find.byType(GestureTipsOverlay), findsNothing);
    expect(prefs.getBool('gesture_tips_seen'), isNull);
  });

  test('"Show gesture tips again" resets the flag', () async {
    SharedPreferences.setMockInitialValues({'gesture_tips_seen': true});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(overrides: [sharedPreferencesProvider.overrideWithValue(prefs)]);
    addTearDown(container.dispose);
    expect(container.read(gestureTipsSeenProvider), isTrue);
    await container.read(gestureTipsSeenProvider.notifier).reset();
    expect(container.read(gestureTipsSeenProvider), isFalse);
    expect(prefs.getBool('gesture_tips_seen'), isFalse);
  });
}

void _noop() {}
