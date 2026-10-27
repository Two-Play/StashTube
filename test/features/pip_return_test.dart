import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/secret_store.dart';
import 'package:stash_app_mobile/core/config/server_config.dart' show sharedPreferencesProvider;
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/models/scene_details.dart';
import 'package:stash_app_mobile/data/providers.dart';
import 'package:stash_app_mobile/data/repositories/stash_session.dart';
import 'package:stash_app_mobile/features/cast/cast_providers.dart';
import 'package:stash_app_mobile/features/pip/pip.dart';
import 'package:stash_app_mobile/features/pip/pip_service.dart';
import 'package:stash_app_mobile/features/player/fullscreen_morph.dart';
import 'package:stash_app_mobile/features/player/held_orientation.dart';
import 'package:stash_app_mobile/features/player/player_controls.dart';
import 'package:stash_app_mobile/features/player/player_providers.dart';
import 'package:stash_app_mobile/features/player/video_controls.dart';
import 'package:stash_app_mobile/features/security/app_lock_gate.dart';

import '../helpers.dart';
import 'fake_player.dart';
import 'pip_test.dart' show FakePipService;

/// media_kit's controller without a native texture.
class _FakeVideoController implements VideoController {
  _FakeVideoController(this.player);

  @override
  final Player player;

  @override
  final notifier = ValueNotifier<PlatformVideoController?>(null);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Playing extends NowPlayingNotifier {
  @override
  Scene? build() => _scene;
}

const _scene = Scene(id: '1', title: 'A', streamUrl: 'http://s/scene/1/stream', width: 1920, height: 1080);

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    fullscreenByRotation.value = false;
  });

  /// The phone (portrait), and Android's picture-in-picture window (16:9).
  void setWindow(WidgetTester tester, {required bool pip}) {
    tester.view.devicePixelRatio = 3;
    tester.view.physicalSize = pip ? const Size(720, 405) : const Size(1080, 2340);
  }

  Future<FakePipService> pump(WidgetTester tester, {Stream<HeldOrientation> turns = const Stream.empty()}) async {
    addTearDown(tester.view.reset);
    // media_kit's native fullscreen on desktop (the tests' platform); it
    // holds media_kit's fullscreen lock until it answers.
    const fullscreenChannel = MethodChannel('com.alexmercerind/media_kit_video');
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(fullscreenChannel, (_) async => null);
    addTearDown(() => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(fullscreenChannel, null));
    setWindow(tester, pip: false);
    final pip = FakePipService(canAutoEnter: true);
    final player = FakePlayer(playing: true);
    await tester.pumpWidget(ProviderScope(
      overrides: [
        ...testServer,
        sharedPreferencesProvider.overrideWithValue(prefs),
        secretStoreProvider.overrideWithValue(MemorySecretStore()),
        authHeadersProvider.overrideWithValue(const {}),
        pipServiceProvider.overrideWithValue(pip),
        heldOrientationProvider.overrideWithValue(turns),
        playerProvider.overrideWithValue(player),
        videoControllerProvider.overrideWithValue(_FakeVideoController(player)),
        playerPlayingProvider.overrideWith((ref) => Stream.value(true)),
        nowPlayingProvider.overrideWith(_Playing.new),
        isCastingProvider.overrideWithValue(false),
        sceneDetailsProvider.overrideWith((ref, id) async => const SceneDetails()),
        scrubThumbnailsProvider('1').overrideWith((ref) async => null),
      ],
      child: MaterialApp(
        builder: (context, child) => FullscreenMorph(
          key: fullscreenMorphKey,
          child: AppLockGate(child: PipScope(child: child!)),
        ),
        // Like PlayerPanel, rebuilt whenever the window's size changes.
        home: Scaffold(
          body: Builder(
            builder: (context) => Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).width * 9 / 16,
                // ignore: prefer_const_constructors
                child: PlayerVideo(scene: _scene, showControls: true),
              ),
            ),
          ),
        ),
      ),
    ));
    await tester.pump();
    return pip;
  }

  /// Back in the full (portrait) window: no exception, no fullscreen left.
  Future<void> leave(WidgetTester tester, FakePipService pip) async {
    pip.events$.add(const PipModeChanged(false));
    setWindow(tester, pip: false);
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.takeException(), isNull);
    }
    expect(find.byType(Video, skipOffstage: false), findsOneWidget, reason: 'only the player, no fullscreen route');
    expect(fullscreenByRotation.value, isFalse);
    expect(playerVideoKey.currentState!.isFullscreen(), isFalse);
  }

  testWidgets('Android: the picture-in-picture window is no turn to landscape', (tester) async {
    final pip = await pump(tester);

    // The app shrinks into the 16:9 window, which reads as landscape, but
    // the phone wasn't turned: no fullscreen.
    pip.events$.add(const PipModeChanged(true));
    await tester.pump();
    setWindow(tester, pip: true);
    for (var i = 0; i < 3; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(tester.takeException(), isNull);
    expect(playerVideoKey.currentState!.isFullscreen(), isFalse);

    await leave(tester, pip);
  });

  // Formerly a landscape window before the mode change entered fullscreen
  // as if the phone was turned. Now only reported turns of the phone do.
  testWidgets('Android: a landscape window before the mode change is no turn either', (tester) async {
    final pip = await pump(tester);

    setWindow(tester, pip: true);
    for (var i = 0; i < 3; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    pip.events$.add(const PipModeChanged(true));
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
    expect(playerVideoKey.currentState!.isFullscreen(), isFalse);

    await leave(tester, pip);
  });

  group('turning the phone (4.19)', () {
    // The moving video, except where a test asks for the plain fade.
    setUp(() => FullscreenMorph.curtainOnlyOverride = false);
    tearDown(() => FullscreenMorph.curtainOnlyOverride = null);

    Future<void> settle(WidgetTester tester) async {
      for (var i = 0; i < 12; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
    }

    bool morphing() => find.byKey(FullscreenMorph.videoKey).evaluate().isNotEmpty;

    /// The moving video's turn: a quarter turn in the portrait test window.
    double angle(WidgetTester tester) => tester
        .widget<Transform>(find.ancestor(of: find.byKey(FullscreenMorph.videoKey), matching: find.byType(Transform)).first)
        .transform
        .getRotation()
        .entry(1, 0);

    testWidgets('sideways morphs the video into fullscreen, upright back out', (tester) async {
      final turns = StreamController<HeldOrientation>.broadcast();
      addTearDown(turns.close);
      await pump(tester, turns: turns.stream);

      turns.add(HeldOrientation.turnedLeft);
      // A turn counts after 250 ms; the morph starts with the next frame.
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump(const Duration(milliseconds: 200));
      expect(morphing(), isTrue, reason: 'the video moves into fullscreen first');
      expect(angle(tester), greaterThan(0), reason: 'turning clockwise, against the phone turned to the left');
      await settle(tester);
      expect(playerVideoKey.currentState!.isFullscreen(), isTrue);
      expect(fullscreenByRotation.value, isTrue);
      expect(morphing(), isFalse);

      turns.add(HeldOrientation.portrait);
      await settle(tester);
      expect(playerVideoKey.currentState!.isFullscreen(), isFalse);
      expect(morphing(), isFalse);
      expect(tester.takeException(), isNull);
    });

    testWidgets('left by its button while sideways: no new fullscreen until upright', (tester) async {
      final turns = StreamController<HeldOrientation>.broadcast();
      addTearDown(turns.close);
      await pump(tester, turns: turns.stream);
      turns.add(HeldOrientation.turnedLeft);
      await settle(tester);
      expect(playerVideoKey.currentState!.isFullscreen(), isTrue);

      // The fullscreen controls' button.
      tester.widget<StashVideoControls>(find.byType(StashVideoControls).last).onToggleFullscreen();
      await settle(tester);
      expect(playerVideoKey.currentState!.isFullscreen(), isFalse);

      turns.add(HeldOrientation.turnedLeft);
      await settle(tester);
      expect(playerVideoKey.currentState!.isFullscreen(), isFalse);

      // Held upright for a moment (a blink doesn't count), then sideways.
      turns.add(HeldOrientation.portrait);
      await tester.pump(const Duration(milliseconds: 400));
      turns.add(HeldOrientation.turnedLeft);
      await settle(tester);
      expect(playerVideoKey.currentState!.isFullscreen(), isTrue);
    });

    testWidgets('the app fades to black around the turn instead of moving the video', (tester) async {
      FullscreenMorph.curtainOnlyOverride = null;
      final turns = StreamController<HeldOrientation>.broadcast();
      addTearDown(turns.close);
      await pump(tester, turns: turns.stream);
      double black() {
        final curtain = find.byKey(FullscreenMorph.curtainKey);
        return curtain.evaluate().isEmpty ? 0 : tester.widget<Opacity>(curtain).opacity;
      }

      turns.add(HeldOrientation.turnedLeft);
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(black(), greaterThan(0));
      expect(morphing(), isFalse);
      await settle(tester);
      expect(playerVideoKey.currentState!.isFullscreen(), isTrue);
      expect(black(), 0);

      turns.add(HeldOrientation.portrait);
      await settle(tester);
      expect(playerVideoKey.currentState!.isFullscreen(), isFalse);
      expect(black(), 0);
      expect(morphing(), isFalse);
    });

    testWidgets('held at an angle, the flipping reports change nothing', (tester) async {
      final turns = StreamController<HeldOrientation>.broadcast();
      addTearDown(turns.close);
      await pump(tester, turns: turns.stream);
      for (var i = 0; i < 6; i++) {
        turns.add(i.isEven ? HeldOrientation.turnedLeft : HeldOrientation.portrait);
        await tester.pump(const Duration(milliseconds: 150));
      }
      await settle(tester);
      expect(playerVideoKey.currentState!.isFullscreen(), isFalse);
      expect(find.byKey(FullscreenMorph.videoKey), findsNothing);
    });

    // Regression: coming back to the app reported several turns while the
    // first fullscreen was still opening, and each opened another one.
    testWidgets('turns while fullscreen opens open no second one', (tester) async {
      final turns = StreamController<HeldOrientation>.broadcast();
      addTearDown(turns.close);
      await pump(tester, turns: turns.stream);
      turns.add(HeldOrientation.turnedLeft);
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump(const Duration(milliseconds: 100));
      turns.add(HeldOrientation.portrait);
      await tester.pump(const Duration(milliseconds: 400));
      turns.add(HeldOrientation.turnedRight);
      await settle(tester);
      await settle(tester);
      expect(playerVideoKey.currentState!.isFullscreen(), isTrue);
      expect(find.byType(StashVideoControls, skipOffstage: false), findsNWidgets(2), reason: 'inline and one fullscreen');

      turns.add(HeldOrientation.portrait);
      await settle(tester);
      expect(playerVideoKey.currentState!.isFullscreen(), isFalse);
    });
  });
}
