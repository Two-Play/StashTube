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
import 'package:stash_app_mobile/features/player/player_controls.dart';
import 'package:stash_app_mobile/features/player/player_providers.dart';
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

  Future<FakePipService> pump(WidgetTester tester) async {
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
        playerProvider.overrideWithValue(player),
        videoControllerProvider.overrideWithValue(_FakeVideoController(player)),
        playerPlayingProvider.overrideWith((ref) => Stream.value(true)),
        nowPlayingProvider.overrideWith(_Playing.new),
        isCastingProvider.overrideWithValue(false),
        sceneDetailsProvider.overrideWith((ref, id) async => const SceneDetails()),
        scrubThumbnailsProvider('1').overrideWith((ref) async => null),
      ],
      child: MaterialApp(
        builder: (context, child) => AppLockGate(child: PipScope(child: child!)),
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

  // Regression: when the landscape window comes before the mode change, the
  // wide video enters fullscreen as if the phone was turned; back in the
  // portrait window, the fullscreen route went while the player rebuilt for
  // the new size, and its controls builder asked media_kit's
  // VideoState.isFullscreen(), which looks up the remembered (fullscreen
  // route's, now deactivated) context.
  testWidgets('Android: leaving picture-in-picture throws nothing', (tester) async {
    final pip = await pump(tester);

    setWindow(tester, pip: true);
    for (var i = 0; i < 3; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    pip.events$.add(const PipModeChanged(true));
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
    expect(playerVideoKey.currentState!.isFullscreen(), isTrue);

    await leave(tester, pip);
  });
}
