import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/models/scene_details.dart';
import 'package:stash_app_mobile/data/providers.dart';
import 'package:stash_app_mobile/features/cast/cast_media.dart';
import 'package:stash_app_mobile/features/cast/cast_providers.dart';
import 'package:stash_app_mobile/features/cast/cast_service.dart';
import 'package:stash_app_mobile/features/player/playback_tracker.dart';
import 'package:stash_app_mobile/features/player/player_providers.dart';

import 'fake_player.dart';

class FakeCastService implements CastService {
  final connectionController = StreamController<CastConnection?>.broadcast();
  final playbackController = StreamController<CastPlayback>.broadcast();
  final loaded = <CastMedia>[];

  @override
  bool get isSupported => true;
  @override
  Stream<List<CastTarget>> get devices => Stream.value(const [CastTarget(id: 'tv', name: 'Living room')]);
  @override
  Stream<CastConnection?> get connection => connectionController.stream;
  @override
  Stream<CastPlayback> get playback => playbackController.stream;
  @override
  Future<void> connect(CastTarget target) async => connectionController.add(CastConnection(deviceName: target.name));
  @override
  Future<void> disconnect() async => connectionController.add(null);
  @override
  Future<void> load(CastMedia media) async => loaded.add(media);
  @override
  Future<void> play() async {}
  @override
  Future<void> pause() async {}
  @override
  Future<void> seek(Duration position) async {}
}

class _NoopActivity implements PlaybackActivityApi {
  @override
  Future<void> addPlay(String sceneId) async {}
  @override
  Future<void> saveActivity(String sceneId, {required double resumeTime, required double playDuration}) async {}
}

const _details = SceneDetails(streams: [
  SceneStream(url: 'http://s/scene/1/stream.mkv', label: 'Direct stream', mimeType: 'video/x-matroska'),
  SceneStream(url: 'http://s/scene/1/stream.m3u8?resolution=STANDARD_HD', label: 'HLS 720p', mimeType: 'application/vnd.apple.mpegurl'),
  SceneStream(url: 'http://s/scene/1/stream.mp4?resolution=STANDARD', label: 'MP4 480p', mimeType: 'video/mp4'),
]);

void main() {
  group('cast media', () {
    test('adds the API key as URL parameter, keeping existing ones', () {
      expect(withApiKey('http://s/stream.mp4?resolution=HD', 'k'), 'http://s/stream.mp4?resolution=HD&apikey=k');
      expect(withApiKey('http://s/stream', null), 'http://s/stream');
    });

    test('prefers a castable original file, then HLS, then MP4', () {
      const scene = Scene(id: '1', title: 'A', streamUrl: 'http://s/scene/1/stream');
      expect(pickCastStream(scene, _details).contentType, 'application/x-mpegURL', reason: 'mkv is not castable');

      const mp4Direct = SceneDetails(streams: [SceneStream(url: 'http://s/direct', label: 'Direct stream', mimeType: 'video/mp4')]);
      expect(pickCastStream(scene, mp4Direct).url, 'http://s/direct');

      const noHls = SceneDetails(streams: [
        SceneStream(url: 'http://s/direct', label: 'Direct stream', mimeType: 'video/x-matroska'),
        SceneStream(url: 'http://s/t.mp4', label: 'MP4 480p', mimeType: 'video/mp4'),
      ]);
      expect(pickCastStream(scene, noHls).url, 'http://s/t.mp4');
      expect(pickCastStream(scene, null).url, 'http://s/scene/1/stream');
    });

    test('castMediaFor fills metadata and authenticates image and stream', () {
      final media = castMediaFor(
        const Scene(id: '1', title: 'Sunset', screenshotUrl: 'http://s/shot', streamUrl: 'http://s/stream'),
        _details,
        apiKey: 'k',
        start: const Duration(seconds: 42),
      );
      expect(media.title, 'Sunset');
      expect(media.url, contains('apikey=k'));
      expect(media.imageUrl, 'http://s/shot?apikey=k');
      expect(media.start, const Duration(seconds: 42));
    });
  });

  group('player ↔ cast', () {
    late FakePlayer player;
    late FakeCastService cast;
    late ProviderContainer container;

    // Built inside each test so streams and timers run in the test's fake
    // async zone.
    Future<void> setUpCast(WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({'url': 'http://s', 'api_key': 'k'});
      final prefs = await SharedPreferences.getInstance();
      player = FakePlayer(position: const Duration(seconds: 30));
      cast = FakeCastService();
      container = ProviderContainer(overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        playerProvider.overrideWithValue(player),
        castServiceProvider.overrideWithValue(cast),
        playbackTrackerProvider.overrideWithValue(PlaybackTracker(api: _NoopActivity())),
        sceneDetailsProvider.overrideWith((ref, id) async => _details),
      ]);
      addTearDown(() async {
        await tester.pump(); // let the post-frame expand() run first
        container.dispose();
      });
      container.listen(nowPlayingProvider, (_, __) {});
      container.listen(isCastingProvider, (_, __) {});
      container.listen(castPlaybackProvider, (_, __) {});
      await tester.pump();
    }

    const scene = Scene(id: '1', title: 'A', streamUrl: 'http://s/scene/1/stream');
    const next = Scene(id: '2', title: 'B', streamUrl: 'http://s/scene/2/stream');

    testWidgets('connecting hands the playing scene over at the current position', (tester) async {
      await setUpCast(tester);
      container.read(nowPlayingProvider.notifier).play(scene);
      await tester.pump();
      expect(player.opened.single.play, isTrue);

      await cast.connect(const CastTarget(id: 'tv', name: 'TV'));
      await tester.pumpAndSettle();
      expect(player.pauseCalls, 1);
      expect(cast.loaded.single.title, 'A');
      expect(cast.loaded.single.url, contains('apikey=k'));
    });

    testWidgets('a scene picked while casting plays on the TV, not locally', (tester) async {
      await setUpCast(tester);
      await cast.connect(const CastTarget(id: 'tv', name: 'TV'));
      await tester.pumpAndSettle();

      container.read(nowPlayingProvider.notifier).play(next);
      await tester.pumpAndSettle();
      expect(cast.loaded.single.title, 'B');
      expect(player.opened.single.play, isFalse, reason: 'prepared locally but paused');
    });

    testWidgets('disconnecting continues locally where the TV was', (tester) async {
      await setUpCast(tester);
      container.read(nowPlayingProvider.notifier).play(scene);
      await cast.connect(const CastTarget(id: 'tv', name: 'TV'));
      await tester.pumpAndSettle();
      cast.playbackController.add(const CastPlayback(playing: true, position: Duration(seconds: 95)));
      await tester.pump();

      await cast.disconnect();
      await tester.pumpAndSettle();
      expect(player.seeks.last, const Duration(seconds: 95));
    });
  });
}
