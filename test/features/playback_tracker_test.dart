import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/features/player/playback_tracker.dart';

class FakeApi implements PlaybackActivityApi {
  final saves = <({String id, double resume, double watched})>[];
  final plays = <String>[];
  bool fail = false;

  @override
  Future<void> saveActivity(String sceneId, {required double resumeTime, required double playDuration}) async {
    if (fail) throw Exception('offline');
    saves.add((id: sceneId, resume: resumeTime, watched: playDuration));
  }

  @override
  Future<void> addPlay(String sceneId) async => plays.add(sceneId);
}

/// Simulates [seconds] of normal playback in 0.5 s ticks, starting at [from].
void watch(PlaybackTracker t, double from, double seconds) {
  for (var s = from + 0.5; s <= from + seconds + 1e-9; s += 0.5) {
    t.onPosition(Duration(milliseconds: (s * 1000).round()));
  }
}

void main() {
  late FakeApi api;
  late PlaybackTracker tracker;
  final resumed = <String, double>{};

  setUp(() {
    api = FakeApi();
    resumed.clear();
    tracker = PlaybackTracker(api: api, onResumeSaved: (id, t) => resumed[id] = t);
  });

  const scene = Scene(id: 's1', title: 'A', duration: 600);

  test('saves watched time and resume position periodically and on pause', () async {
    await tracker.start(scene);
    tracker.onPlaying(true);
    watch(tracker, 0, 16);
    await pumpEventQueue();

    expect(api.saves, hasLength(1), reason: 'first save after 15 s of watching');
    expect(api.saves.single.watched, closeTo(15, 0.01));
    expect(api.saves.single.resume, closeTo(15, 0.01));

    tracker.onPlaying(false);
    await pumpEventQueue();
    expect(api.saves.last.resume, closeTo(16, 0.01));
    expect(api.saves.last.watched, closeTo(1, 0.01));
    expect(resumed['s1'], closeTo(16, 0.01));
  });

  test('seeking does not count as watched time', () async {
    await tracker.start(scene);
    tracker.onPlaying(true);
    watch(tracker, 0, 5);
    tracker.onPosition(const Duration(seconds: 300)); // seek
    await tracker.stop();

    expect(api.saves.single.watched, closeTo(5, 0.01));
    expect(api.saves.single.resume, 300);
  });

  test('counts one play after 10 % (max 60 s) of watching', () async {
    await tracker.start(const Scene(id: 'short', title: 'B', duration: 100));
    tracker.onPlaying(true);
    watch(tracker, 0, 9.5);
    expect(api.plays, isEmpty);
    watch(tracker, 9.5, 1);
    watch(tracker, 10.5, 50);
    expect(api.plays, ['short']);

    await tracker.start(const Scene(id: 'long', title: 'C', duration: 7200));
    tracker.onPlaying(true);
    watch(tracker, 0, 61);
    expect(api.plays, ['short', 'long'], reason: 'capped at 60 s for long scenes');
  });

  test('resets resume position when (nearly) finished', () async {
    await tracker.start(const Scene(id: 's', title: 'D', duration: 100, resumeTime: 90));
    tracker.onPlaying(true);
    watch(tracker, 90, 6);
    await tracker.stop();
    expect(api.saves.single.resume, 0);
  });

  test('starting a new scene saves the previous one', () async {
    await tracker.start(scene);
    tracker.onPlaying(true);
    watch(tracker, 0, 3);
    await tracker.start(const Scene(id: 's2', title: 'E', duration: 60));
    expect(api.saves.single.id, 's1');
  });

  test('does not save when nothing changed', () async {
    await tracker.start(const Scene(id: 's', title: 'F', duration: 100, resumeTime: 42));
    await tracker.stop();
    expect(api.saves, isEmpty);
  });

  test('keeps unsaved time for the next attempt when saving fails', () async {
    await tracker.start(scene);
    tracker.onPlaying(true);
    watch(tracker, 0, 4);
    api.fail = true;
    await tracker.flush();
    expect(api.saves, isEmpty);

    api.fail = false;
    watch(tracker, 4, 2);
    await tracker.stop();
    expect(api.saves.single.watched, closeTo(6, 0.01));
  });
}
