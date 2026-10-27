import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/models/scene_details.dart';
import 'package:stash_app_mobile/data/providers.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/features/cast/cast_media.dart';
import 'package:stash_app_mobile/features/cast/cast_providers.dart';
import 'package:stash_app_mobile/features/cast/cast_service.dart';
import 'package:stash_app_mobile/features/player/playback_tracker.dart';
import 'package:stash_app_mobile/features/player/player_providers.dart';

import '../fake_player.dart';

class _NoopActivity implements PlaybackActivityApi {
  @override
  Future<void> addPlay(String sceneId) async {}
  @override
  Future<void> saveActivity(String sceneId, {required double resumeTime, required double playDuration}) async {}
}

/// A cast device whose `load` fails.
class _FailingCast implements CastService {
  final connections = StreamController<CastConnection?>.broadcast();

  @override
  Stream<CastConnection?> get connection => connections.stream;
  @override
  Stream<CastPlayback> get playback => const Stream.empty();
  @override
  Future<void> load(CastMedia media) async => throw const StashApiException('no route');
  @override
  Future<void> pause() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _scene = Scene(id: '1', title: 'A', streamUrl: 'http://s/scene/1/stream', resumeTime: 30);

void main() {
  late FakePlayer player;
  late ProviderContainer container;
  late _FailingCast cast;

  Future<void> setUpContainer(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    player = FakePlayer();
    cast = _FailingCast();
    container = ProviderContainer(overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      playerProvider.overrideWithValue(player),
      castServiceProvider.overrideWithValue(cast),
      playbackTrackerProvider.overrideWithValue(PlaybackTracker(api: _NoopActivity())),
      sceneDetailsProvider.overrideWith((ref, id) async => const SceneDetails()),
    ]);
    addTearDown(container.dispose);
    container.listen(playbackErrorProvider, (_, _) {});
    container.read(nowPlayingProvider.notifier).play(_scene);
    await tester.pump();
    container.read(playbackErrorProvider); // rebuilt for the scene: listens to the player
    await tester.pump();
  }

  /// Lets the stream events and the confirmation timer run.
  Future<void> wait(WidgetTester tester, [Duration d = Duration.zero]) => tester.pump(d);

  testWidgets('an error that stops playback is reported after a moment', (tester) async {
    await setUpContainer(tester);
    player.position.add(const Duration(seconds: 42));
    await wait(tester);
    player.error.add('tcp: connection reset');
    await wait(tester);
    expect(container.read(playbackErrorProvider), isNull, reason: 'not confirmed yet');

    await wait(tester, PlaybackErrorNotifier.confirmDelay);
    final error = container.read(playbackErrorProvider);
    expect(error?.message, 'tcp: connection reset');
    expect(error?.position, const Duration(seconds: 42));
  });

  testWidgets('an error that playback recovers from is not reported', (tester) async {
    await setUpContainer(tester);
    player.position.add(const Duration(seconds: 10));
    await wait(tester);
    player.error.add('vd: broken frame');
    player.position.add(const Duration(seconds: 12));
    await wait(tester, PlaybackErrorNotifier.confirmDelay * 2);
    expect(container.read(playbackErrorProvider), isNull);
  });

  testWidgets('retry reopens the scene where it stopped and clears the error', (tester) async {
    await setUpContainer(tester);
    expect(player.opened, hasLength(1));
    player.position.add(const Duration(seconds: 42));
    await wait(tester);
    player.error.add('tcp: connection reset');
    await wait(tester, PlaybackErrorNotifier.confirmDelay);
    expect(container.read(playbackErrorProvider), isNotNull);

    container.read(playbackErrorProvider.notifier).retry();
    expect(container.read(playbackErrorProvider), isNull);
    expect(player.opened, hasLength(2));
    expect(player.openedStarts.last, const Duration(seconds: 42));
    expect(player.opened.last.uri, _scene.streamUrl);
    expect(player.opened.last.play, isTrue);
  });

  testWidgets('a file that never played is retried from where it was opened', (tester) async {
    await setUpContainer(tester);
    player.error.add('stream: 404');
    await wait(tester, PlaybackErrorNotifier.confirmDelay);
    expect(container.read(playbackErrorProvider)?.position, isNull);
    container.read(playbackErrorProvider.notifier).retry();
    expect(player.opened, hasLength(2));
    expect(player.openedStarts.last, const Duration(seconds: 30), reason: 'the resume position');
  });

  testWidgets('playback moving on clears a reported error', (tester) async {
    await setUpContainer(tester);
    player.error.add('stream: timeout');
    await wait(tester, PlaybackErrorNotifier.confirmDelay);
    expect(container.read(playbackErrorProvider), isNotNull);
    player.position.add(const Duration(seconds: 33));
    await wait(tester);
    expect(container.read(playbackErrorProvider), isNull);
  });

  testWidgets('closing the player drops the error', (tester) async {
    await setUpContainer(tester);
    player.error.add('stream: timeout');
    await wait(tester, PlaybackErrorNotifier.confirmDelay);
    container.read(nowPlayingProvider.notifier).close();
    expect(container.read(playbackErrorProvider), isNull);
    await wait(tester);
  });

  testWidgets('errors of the waiting local player are ignored while casting', (tester) async {
    await setUpContainer(tester);
    cast.connections.add(const CastConnection(deviceName: 'TV', kind: CastKind.googleCast));
    await wait(tester);
    player.error.add('stream: timeout');
    await wait(tester, PlaybackErrorNotifier.confirmDelay);
    expect(container.read(playbackErrorProvider), isNull);
  });

  testWidgets('a scene the cast device cannot play is reported', (tester) async {
    await setUpContainer(tester);
    container.listen(castFailureProvider, (_, _) {});
    cast.connections.add(const CastConnection(deviceName: 'TV', kind: CastKind.googleCast));
    await wait(tester);
    await wait(tester);
    final failure = container.read(castFailureProvider);
    expect(failure?.deviceName, 'TV');
    expect(failure?.error, isA<StashApiException>());
  });
}
