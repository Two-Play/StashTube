import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/models/scene_details.dart';
import 'package:stash_app_mobile/data/providers.dart';
import 'package:stash_app_mobile/data/repositories/stash_session.dart';
import 'package:stash_app_mobile/features/cast/cast_providers.dart';
import 'package:stash_app_mobile/features/pip/pip.dart';
import 'package:stash_app_mobile/features/pip/pip_service.dart';
import 'package:stash_app_mobile/features/player/player_providers.dart';
import 'package:stash_app_mobile/widgets/sliver_columns.dart';

import 'fake_player.dart';

/// Android's picture-in-picture with [canAutoEnter], iOS's native one without.
class FakePipService implements PipService {
  FakePipService({required this.canAutoEnter, this.startResult = true});

  @override
  final bool canAutoEnter;
  final bool startResult;
  final events$ = StreamController<PipEvent>.broadcast();
  final autoEnter = <bool>[];
  final entered = <double>[];
  final started = <({String url, Map<String, String> headers, Duration start})>[];
  var stops = 0;

  @override
  bool get isSupported => true;

  @override
  Stream<PipEvent> get events => events$.stream;

  @override
  Future<void> setAutoEnter({required bool enabled, required double aspect}) async => autoEnter.add(enabled);

  @override
  Future<bool> enter({required double aspect}) async {
    entered.add(aspect);
    return true;
  }

  @override
  Future<bool> startNative({
    required String url,
    required Map<String, String> headers,
    required Duration start,
    required Rect from,
  }) async {
    started.add((url: url, headers: headers, start: start));
    return startResult;
  }

  @override
  Future<void> stopNative() async => stops++;
}

class _Playing extends NowPlayingNotifier {
  _Playing(this.scene);

  final Scene? scene;

  @override
  Scene? build() => scene;
}

const _scene = Scene(id: '1', title: 'A', streamUrl: 'http://s/scene/1/stream');

const _details = SceneDetails(streams: [
  SceneStream(url: 'http://s/scene/1/stream.mkv', label: 'Direct stream', mimeType: 'video/x-matroska'),
  SceneStream(url: 'http://s/scene/1/stream.m3u8', label: 'HLS', mimeType: 'application/vnd.apple.mpegurl'),
]);

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  ProviderContainer container(FakePipService pip, FakePlayer player, {bool playing = true}) {
    final c = ProviderContainer(overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      serverConfigProvider.overrideWithValue(const ServerConfig(baseUrl: 'http://s', apiKey: 'k')),
      authHeadersProvider.overrideWithValue(const {'ApiKey': 'k'}),
      pipServiceProvider.overrideWithValue(pip),
      playerProvider.overrideWithValue(player),
      playerPlayingProvider.overrideWith((ref) => Stream.value(playing)),
      nowPlayingProvider.overrideWith(() => _Playing(_scene)),
      isCastingProvider.overrideWithValue(false),
      sceneDetailsProvider.overrideWith((ref, id) async => _details),
    ]);
    addTearDown(c.dispose);
    c.listen(pipProvider, (_, _) {});
    return c;
  }

  group('Android picture-in-picture', () {
    test('enters by itself only while a video plays and the setting is on', () async {
      final pip = FakePipService(canAutoEnter: true);
      final c = container(pip, FakePlayer());
      await pumpEventQueue();
      expect(pip.autoEnter.last, isTrue);

      await c.read(playbackModesProvider.notifier).setAutoPip(false);
      await pumpEventQueue();
      expect(pip.autoEnter.last, isFalse);
      expect(prefs.getBool('auto_pip'), isFalse);
    });

    test('the button enters it, and the platform reports the mode', () async {
      final pip = FakePipService(canAutoEnter: true);
      final c = container(pip, FakePlayer());
      expect(await c.read(pipProvider.notifier).enter(), isTrue);
      expect(pip.entered.single, closeTo(16 / 9, 0.001));

      pip.events$.add(const PipModeChanged(true));
      await pumpEventQueue();
      expect(c.read(pipProvider), isTrue);
      pip.events$.add(const PipModeChanged(false));
      await pumpEventQueue();
      expect(c.read(pipProvider), isFalse);
    });
  });

  group('iOS picture-in-picture', () {
    test('hands the scene to the native player and continues where it stopped', () async {
      final pip = FakePipService(canAutoEnter: false);
      final player = FakePlayer(playing: true, position: const Duration(seconds: 12));
      // Playing in the app again would end it.
      final c = container(pip, player, playing: false);

      expect(await c.read(pipProvider.notifier).enter(), isTrue);
      // AVPlayer can't play MKV: Stash's HLS, with the key for its segments.
      expect(pip.started.single.url, 'http://s/scene/1/stream.m3u8?apikey=k');
      expect(pip.started.single.headers, {'ApiKey': 'k'});
      expect(pip.started.single.start, const Duration(seconds: 12));
      expect(player.pauseCalls, 1);
      expect(c.read(pipProvider), isTrue);

      pip.events$.add(const PipStopped(position: Duration(seconds: 42), playing: true));
      await pumpEventQueue();
      expect(c.read(pipProvider), isFalse);
      expect(player.seeks.last, const Duration(seconds: 42));
      expect(player.playCalls, 1);
    });

    test('keeps playing in the app when it can\'t start', () async {
      final pip = FakePipService(canAutoEnter: false, startResult: false);
      final player = FakePlayer(playing: true);
      final c = container(pip, player);

      expect(await c.read(pipProvider.notifier).enter(), isFalse);
      expect(player.playCalls, 1);
      expect(c.read(pipProvider), isFalse);
    });
  });

  group('background playback', () {
    Future<void> leaveApp(WidgetTester tester) async {
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      await tester.pump();
    }

    void comeBack(WidgetTester tester) {
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    }

    testWidgets('pauses when the app is hidden', (tester) async {
      final player = FakePlayer(playing: true);
      final c = container(FakePipService(canAutoEnter: true), player);
      c.read(backgroundPlaybackProvider);
      await leaveApp(tester);
      expect(player.pauseCalls, 1);
      comeBack(tester);
      c.dispose();
      await tester.pump();
    });

    testWidgets('keeps playing with background playback', (tester) async {
      final player = FakePlayer(playing: true);
      final c = container(FakePipService(canAutoEnter: true), player);
      await c.read(playbackModesProvider.notifier).setBackground(true);
      c.read(backgroundPlaybackProvider);
      await leaveApp(tester);
      expect(player.pauseCalls, 0);
      comeBack(tester);
      c.dispose();
      await tester.pump();
    });

    testWidgets('keeps playing in picture-in-picture', (tester) async {
      final player = FakePlayer(playing: true);
      final pip = FakePipService(canAutoEnter: true);
      final c = container(pip, player);
      c.read(backgroundPlaybackProvider);
      pip.events$.add(const PipModeChanged(true));
      await tester.pump();
      await leaveApp(tester);
      expect(player.pauseCalls, 0);
      comeBack(tester);
      c.dispose();
      await tester.pump();
    });
  });

  group('columns (13.5)', () {
    test('one column on phones, several from 600 dp', () {
      expect(listColumns(390, 420), 1);
      expect(listColumns(600, 420), 2);
      expect(listColumns(1366, 420), 3);
    });

    testWidgets('lays items out in rows on wide screens', (tester) async {
      Future<void> pumpAt(double width) async {
        await tester.pumpWidget(Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: SizedBox(
              width: width,
              child: CustomScrollView(slivers: [
                SliverColumns(
                  itemCount: 5,
                  columnWidth: 300,
                  itemBuilder: (_, i) => SizedBox(height: 50, child: Text('item $i')),
                ),
              ]),
            ),
          ),
        ));
      }

      await pumpAt(400);
      expect(tester.getTopLeft(find.text('item 1')).dy, greaterThan(tester.getTopLeft(find.text('item 0')).dy));

      await pumpAt(780);
      // Two columns: items 0 and 1 side by side, 2 below 0.
      expect(tester.getTopLeft(find.text('item 1')).dy, tester.getTopLeft(find.text('item 0')).dy);
      expect(tester.getTopLeft(find.text('item 1')).dx, greaterThan(tester.getTopLeft(find.text('item 0')).dx));
      expect(tester.getTopLeft(find.text('item 2')).dy, greaterThan(tester.getTopLeft(find.text('item 0')).dy));
    });
  });
}
