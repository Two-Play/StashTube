import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_kit/media_kit.dart';
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
  final autoEnterAspects = <double>[];
  final entered = <double>[];
  final enteredFrom = <Rect?>[];
  final started = <({String url, Map<String, String> headers, Duration start, double? aspect})>[];
  var stops = 0;

  @override
  bool get isSupported => true;

  @override
  Stream<PipEvent> get events => events$.stream;

  @override
  Future<void> setAutoEnter({required bool enabled, required double aspect}) async {
    autoEnter.add(enabled);
    autoEnterAspects.add(aspect);
  }

  @override
  Future<bool> enter({required double aspect, Rect? from}) async {
    entered.add(aspect);
    enteredFrom.add(from);
    return true;
  }

  @override
  Future<bool> startNative({
    required String url,
    required Map<String, String> headers,
    required Duration start,
    required Rect from,
    double? aspect,
  }) async {
    started.add((url: url, headers: headers, start: start, aspect: aspect));
    return startResult;
  }

  @override
  Future<void> stopNative() async => stops++;
}

/// A [FakePlayer] that reports the decoded video size once [decode] is
/// called, like media_kit after opening a file.
class _SizedPlayer extends FakePlayer {
  _SizedPlayer() : super(playing: true);

  final _width = StreamController<int?>.broadcast();
  final _height = StreamController<int?>.broadcast();
  PlayerState? _sized;

  @override
  PlayerState get state => _sized ?? super.state;

  void decode(int width, int height) {
    _sized = super.state.copyWith(width: width, height: height);
    _width.add(width);
    _height.add(height);
  }

  @override
  PlayerStream get stream {
    final s = super.stream;
    return PlayerStream(
      s.playlist,
      s.playing,
      s.completed,
      s.position,
      s.duration,
      s.volume,
      s.rate,
      s.pitch,
      s.buffering,
      s.bufferingPercentage,
      s.buffer,
      s.playlistMode,
      s.shuffle,
      s.audioParams,
      s.videoParams,
      s.audioBitrate,
      s.audioDevice,
      s.audioDevices,
      s.track,
      s.tracks,
      _width.stream,
      _height.stream,
      s.subtitle,
      s.log,
      s.error,
    );
  }
}

class _Playing extends NowPlayingNotifier {
  _Playing(this.scene);

  final Scene? scene;

  @override
  Scene? build() => scene;
}

const _scene = Scene(id: '1', title: 'A', streamUrl: 'http://s/scene/1/stream');
const _portrait = Scene(id: '1', title: 'A', streamUrl: 'http://s/scene/1/stream', width: 1080, height: 1920);

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

  ProviderContainer container(FakePipService pip, FakePlayer player, {bool playing = true, Scene scene = _scene}) {
    final c = ProviderContainer(overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      serverConfigProvider.overrideWithValue(const ServerConfig(baseUrl: 'http://s', apiKey: 'k')),
      authHeadersProvider.overrideWithValue(const {'ApiKey': 'k'}),
      pipServiceProvider.overrideWithValue(pip),
      playerProvider.overrideWithValue(player),
      playerPlayingProvider.overrideWith((ref) => Stream.value(playing)),
      nowPlayingProvider.overrideWith(() => _Playing(scene)),
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

  group('picture-in-picture shape', () {
    test('follows the video: Stash\'s size first, then the decoded one, within Android\'s range', () {
      const state = PlayerState(width: 1920, height: 1080);
      expect(pipAspect(state, _portrait), closeTo(9 / 16, 0.001));
      expect(pipAspect(state, _scene), closeTo(16 / 9, 0.001));
      expect(pipAspect(const PlayerState(width: 720, height: 1280), _scene), closeTo(9 / 16, 0.001));
      // Unknown: 16:9; extreme: clamped to 1:2.39 – 2.39:1.
      expect(pipAspect(const PlayerState(), _scene), closeTo(16 / 9, 0.001));
      expect(pipAspect(const PlayerState(), null), closeTo(16 / 9, 0.001));
      expect(pipAspect(const PlayerState(width: 100, height: 1000), _scene), pipMinAspect);
      expect(pipAspect(const PlayerState(width: 4000, height: 1000), _scene), pipMaxAspect);
    });

    test('the source rect hint covers just the video, in physical pixels', () {
      // A portrait video in a 16:9 box: the middle part.
      expect(pipSourceRect(const Rect.fromLTWH(0, 100, 640, 360), 9 / 16, 2), const Rect.fromLTRB(438, 200, 843, 920));
      expect(pipSourceRect(const Rect.fromLTWH(0, 0, 360, 640), 9 / 16, 3), const Rect.fromLTWH(0, 0, 1080, 1920));
      expect(pipSourceRect(Rect.zero, 1, 2), isNull);
    });

    test('a portrait scene enters as portrait, by itself and from the button', () async {
      final pip = FakePipService(canAutoEnter: true);
      final c = container(pip, FakePlayer(), scene: _portrait);
      await pumpEventQueue();
      expect(pip.autoEnter.last, isTrue);
      expect(pip.autoEnterAspects.last, closeTo(9 / 16, 0.001));

      const from = Rect.fromLTWH(0, 0, 400, 500);
      expect(await c.read(pipProvider.notifier).enter(from: from), isTrue);
      expect(pip.entered.single, closeTo(9 / 16, 0.001));
      expect(pip.enteredFrom.single, from);
    });

    test('auto-enter gets the decoded size once the player knows it', () async {
      final pip = FakePipService(canAutoEnter: true);
      final player = _SizedPlayer();
      container(pip, player);
      await pumpEventQueue();
      expect(pip.autoEnterAspects.last, closeTo(16 / 9, 0.001));

      player.decode(720, 1280);
      await pumpEventQueue();
      expect(pip.autoEnter.last, isTrue);
      expect(pip.autoEnterAspects.last, closeTo(9 / 16, 0.001));
    });

    test('the channel sends the aspect and the video\'s place', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      const channel = MethodChannel('stash/pip_test');
      final calls = <MethodCall>[];
      final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
      messenger.setMockMethodCallHandler(channel, (call) async {
        calls.add(call);
        return call.method == 'setAutoEnter' ? null : true;
      });
      addTearDown(() => messenger.setMockMethodCallHandler(channel, null));

      final android = ChannelPipService(native: false, channel: channel, pixelRatio: 2);
      await android.setAutoEnter(enabled: true, aspect: 9 / 16);
      expect(await android.enter(aspect: 9 / 16, from: const Rect.fromLTWH(0, 0, 360, 640)), isTrue);
      expect(calls[0].method, 'setAutoEnter');
      expect(calls[0].arguments, {'enabled': true, 'aspect': 9 / 16});
      expect(calls[1].method, 'enter');
      expect(calls[1].arguments, {
        'aspect': 9 / 16,
        'rect': [0.0, 0.0, 720.0, 1280.0],
      });

      calls.clear();
      final ios = ChannelPipService(native: true, channel: channel);
      expect(
          await ios.startNative(
            url: 'http://s/v.m3u8',
            headers: const {},
            start: const Duration(seconds: 3),
            from: const Rect.fromLTWH(0, 50, 390, 300),
            aspect: 9 / 16,
          ),
          isTrue);
      expect(calls.single.method, 'start');
      expect((calls.single.arguments as Map)['aspect'], 9 / 16);
      expect((calls.single.arguments as Map)['rect'], [0.0, 50.0, 390.0, 300.0]);
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
      // Unknown size: iOS waits for the item's own.
      expect(pip.started.single.aspect, isNull);
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
