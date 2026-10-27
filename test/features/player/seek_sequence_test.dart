import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/models/scene_details.dart';
import 'package:stash_app_mobile/data/providers.dart';
import 'package:stash_app_mobile/data/repositories/stash_session.dart';
import 'package:stash_app_mobile/features/cast/cast_media.dart';
import 'package:stash_app_mobile/features/cast/cast_providers.dart';
import 'package:stash_app_mobile/features/cast/cast_service.dart';
import 'package:stash_app_mobile/features/player/player_providers.dart';
import 'package:stash_app_mobile/features/player/seek_settings.dart';
import 'package:stash_app_mobile/features/player/video_controls.dart';

import '../../helpers.dart';
import '../fake_player.dart';

/// Records the seeks sent to the TV.
class _FakeCast implements CastService {
  final seeks = <Duration>[];

  @override
  bool get isSupported => true;
  @override
  bool get supportsAirPlay => false;
  @override
  Future<void> showAirPlayPicker() async {}
  @override
  Stream<List<CastTarget>> get devices => Stream.value(const []);
  @override
  Stream<CastConnection?> get connection => const Stream.empty();
  @override
  Stream<CastPlayback> get playback => const Stream.empty();
  @override
  Future<void> connect(CastTarget target) async {}
  @override
  Future<void> disconnect() async {}
  @override
  Future<void> load(CastMedia media) async {}
  @override
  Future<void> play() async {}
  @override
  Future<void> pause() async {}
  @override
  Future<void> seek(Duration position) async => seeks.add(position);
}

/// Fixed double-tap settings.
class _Seek extends SeekSettingsNotifier {
  _Seek(this.settings);

  final SeekSettings settings;

  @override
  SeekSettings build() => settings;
}

void main() {
  late FakePlayer player;
  late _FakeCast cast;

  Future<void> pump(
    WidgetTester tester, {
    Duration position = const Duration(seconds: 30),
    bool fullscreen = false,
    bool casting = false,
    bool reduceMotion = false,
    SeekSettings seek = const SeekSettings(),
  }) async {
    player = FakePlayer(playing: true, position: position);
    cast = _FakeCast();
    await tester.pumpWidget(ProviderScope(
      overrides: [
        ...testServer,
        playerProvider.overrideWithValue(player),
        scrubThumbnailsProvider('1').overrideWith((ref) async => null),
        authHeadersProvider.overrideWithValue(const {}),
        sceneDetailsProvider('1').overrideWith((ref) async => const SceneDetails(streams: [])),
        castServiceProvider.overrideWithValue(cast),
        seekSettingsProvider.overrideWith(() => _Seek(seek)),
        if (casting) ...[
          castConnectionProvider.overrideWith((ref) => Stream.value(const CastConnection(deviceName: 'TV'))),
          castPlaybackProvider.overrideWith((ref) => Stream.value(CastPlayback(playing: true, position: position))),
        ],
      ],
      child: MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: reduceMotion),
          child: Scaffold(
            body: Center(
              child: SizedBox(
                width: 400,
                height: 225,
                child: StashVideoControls(
                  fullscreen: fullscreen,
                  onToggleFullscreen: () {},
                  scene: const Scene(id: '1', title: 'A', duration: 100),
                  onQuality: () {},
                ),
              ),
            ),
          ),
        ),
      ),
    ));
    if (casting) await tester.pump(); // the stream overrides deliver
  }

  bool controlsVisible(WidgetTester tester) =>
      tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity).last).opacity == 1;

  // The bubble and, while it animates, the ripple behind it.
  Finder circles() => find.byWidgetPredicate(
        (w) => w is DecoratedBox && w.decoration is BoxDecoration && (w.decoration as BoxDecoration).shape == BoxShape.circle,
      );

  Rect area(WidgetTester tester) => tester.getRect(find.byType(StashVideoControls));
  Offset right(WidgetTester tester) => Offset(area(tester).right - 20, area(tester).center.dy);
  Offset left(WidgetTester tester) => Offset(area(tester).left + 20, area(tester).center.dy);
  Offset middle(WidgetTester tester) => Offset(area(tester).center.dx + 60, area(tester).center.dy);

  Future<void> tap(WidgetTester tester, Offset at) async {
    await tester.tapAt(at);
    await tester.pump(const Duration(milliseconds: 100));
  }

  List<int> seconds(List<Duration> seeks) => [for (final s in seeks) s.inSeconds];

  testWidgets('fingers still down when the controls go away cause no errors', (tester) async {
    // A swipe down collapses the player and removes the controls while the
    // fingers are still on the screen; their events keep arriving.
    await pump(tester);
    final one = await tester.startGesture(left(tester));
    final two = await tester.startGesture(right(tester), pointer: 2);
    await one.moveBy(const Offset(10, 0));
    await tester.pumpWidget(const SizedBox());
    await one.moveBy(const Offset(0, 40));
    await two.moveBy(const Offset(0, 40));
    await one.up();
    await two.up();
    await tester.pump(const Duration(seconds: 1)); // gesture timers run out
    expect(tester.takeException(), isNull);
  });

  testWidgets('every further tap skips further: 5, 10, 20, 30, 40 s', (tester) async {
    await pump(tester);
    await tap(tester, right(tester));
    expect(player.seeks, isEmpty, reason: 'a single tap does not seek');
    await tap(tester, right(tester));
    expect(find.text('5 seconds'), findsOneWidget);
    expect(circles(), findsNWidgets(2), reason: 'the bubble and its ripple');
    for (var i = 0; i < 4; i++) {
      await tap(tester, right(tester));
    }
    expect(seconds(player.seeks), [35, 40, 50, 60, 70], reason: 'from the start position, right away');
    expect(find.text('40 seconds'), findsOneWidget);
    expect(controlsVisible(tester), isFalse, reason: 'the taps of a sequence do not toggle the controls');

    await tester.pump(StashVideoControls.seekSequenceWindow);
    expect(find.text('40 seconds'), findsNothing, reason: 'the bubble goes after the last tap');
    expect(controlsVisible(tester), isFalse);
  });

  testWidgets('back works the same way', (tester) async {
    await pump(tester, position: const Duration(seconds: 60));
    for (var i = 0; i < 4; i++) {
      await tap(tester, left(tester));
    }
    expect(seconds(player.seeks), [55, 50, 40]);
    expect(find.text('20 seconds'), findsOneWidget);
  });

  testWidgets('after the timeout a single tap is a normal tap again', (tester) async {
    await pump(tester);
    await tap(tester, right(tester));
    await tap(tester, right(tester));
    await tester.pump(StashVideoControls.seekSequenceWindow);
    await tap(tester, right(tester));
    await tester.pump(kDoubleTapTimeout);
    expect(seconds(player.seeks), [35]);
    expect(controlsVisible(tester), isTrue, reason: 'it toggled the controls');

    await tester.pump(const Duration(seconds: 4)); // they hide again
    await tap(tester, right(tester));
    await tap(tester, right(tester));
    expect(seconds(player.seeks), [35, 40], reason: 'a new sequence starts at 5 s');
    expect(find.text('5 seconds'), findsOneWidget);
  });

  testWidgets('a tap on the other side starts a new sequence there', (tester) async {
    await pump(tester);
    await tap(tester, right(tester));
    await tap(tester, right(tester));
    await tap(tester, right(tester));
    expect(seconds(player.seeks), [35, 40]);
    await tap(tester, left(tester));
    expect(seconds(player.seeks), [35, 40, 35], reason: '5 s back from where it is');
    expect(find.text('5 seconds'), findsOneWidget);
    expect(find.text('10 seconds'), findsNothing);
    await tap(tester, left(tester));
    expect(seconds(player.seeks).last, 30);
  });

  testWidgets('the other side counts from where the last seek went, though mpv lags', (tester) async {
    await pump(tester);
    // mpv reports the old position for a moment after a seek.
    player.lagging = true;
    await tap(tester, left(tester));
    await tap(tester, left(tester));
    await tap(tester, left(tester));
    expect(seconds(player.seeks), [25, 20]);
    await tap(tester, right(tester));
    expect(seconds(player.seeks).last, 25, reason: '5 s on from 0:20, not from the stale 0:30');
    expect(find.text('5 seconds'), findsOneWidget);
    await tap(tester, right(tester));
    expect(seconds(player.seeks).last, 30);
    expect(find.text('10 seconds'), findsOneWidget, reason: 'counts up from the start again');
  });

  testWidgets('a tap in the middle ends the sequence and toggles the controls', (tester) async {
    await pump(tester);
    await tap(tester, right(tester));
    await tap(tester, right(tester));
    await tap(tester, middle(tester));
    expect(find.text('5 seconds'), findsNothing);
    await tester.pump(kDoubleTapTimeout);
    expect(controlsVisible(tester), isTrue);

    await tester.pump(const Duration(seconds: 4));
    await tap(tester, right(tester));
    await tester.pump(kDoubleTapTimeout);
    expect(seconds(player.seeks), [35], reason: 'a single tap does not continue the old sequence');
  });

  testWidgets('clamps at the start', (tester) async {
    await pump(tester, position: const Duration(seconds: 3));
    for (var i = 0; i < 3; i++) {
      await tap(tester, left(tester));
    }
    expect(seconds(player.seeks), [0], reason: 'once to the start, not again for every tap');
    await tester.pump(StashVideoControls.seekSequenceWindow);
  });

  testWidgets('clamps at the end', (tester) async {
    await pump(tester, position: const Duration(seconds: 97));
    await tap(tester, right(tester));
    await tap(tester, right(tester));
    await tap(tester, right(tester));
    expect(seconds(player.seeks), [100]);
    await tester.pump(StashVideoControls.seekSequenceWindow);
  });

  testWidgets('screen readers hear the total', (tester) async {
    await pump(tester);
    await tap(tester, right(tester));
    await tap(tester, right(tester));
    await tap(tester, right(tester));
    expect(tester.takeAnnouncements().map((a) => a.message), ['Forward 5 seconds', 'Forward 10 seconds']);
    await tester.pump(StashVideoControls.seekSequenceWindow);
  });

  testWidgets('with reduced motion the bubble shows without the ripple', (tester) async {
    await pump(tester, reduceMotion: true);
    await tap(tester, right(tester));
    await tap(tester, right(tester));
    expect(find.text('5 seconds'), findsOneWidget);
    expect(circles(), findsOneWidget, reason: 'the bubble, no ripple');
    await tester.pump(StashVideoControls.seekSequenceWindow);
  });

  testWidgets('while casting, the TV seeks', (tester) async {
    await pump(tester, casting: true, position: const Duration(seconds: 20));
    for (var i = 0; i < 3; i++) {
      await tap(tester, right(tester));
    }
    expect(seconds(cast.seeks), [25, 30]);
    expect(player.seeks, isEmpty);
    expect(find.text('10 seconds'), findsOneWidget);
    await tester.pump(StashVideoControls.seekSequenceWindow);
    expect(find.text('10 seconds'), findsNothing);

    await tap(tester, left(tester));
    await tap(tester, left(tester));
    expect(seconds(cast.seeks).last, 25, reason: 'back from where the last seek went, not the TV\'s late report');
    await tester.pump(StashVideoControls.seekSequenceWindow);
  });

  group('settings', () {
    test('cumulative totals: step, then 2 × step × (taps − 1)', () {
      List<int> totals(SeekSettings s) => [for (var t = 1; t <= 5; t++) s.total(t).inSeconds];
      expect(totals(const SeekSettings()), [5, 10, 20, 30, 40], reason: 'the default is the old sequence');
      expect(totals(const SeekSettings(step: Duration(seconds: 10))), [10, 20, 40, 60, 80]);
      expect(totals(const SeekSettings(step: Duration(seconds: 15))), [15, 30, 60, 90, 120]);
      expect(totals(const SeekSettings(step: Duration(seconds: 30))), [30, 60, 120, 180, 240]);
    });

    test('without cumulative every tap adds one step', () {
      List<int> totals(SeekSettings s) => [for (var t = 1; t <= 5; t++) s.total(t).inSeconds];
      expect(totals(const SeekSettings(cumulative: false)), [5, 10, 15, 20, 25]);
      expect(totals(const SeekSettings(step: Duration(seconds: 10), cumulative: false)), [10, 20, 30, 40, 50]);
    });

    testWidgets('a 10 s step seeks 10, 20, 40 s', (tester) async {
      await pump(tester, seek: const SeekSettings(step: Duration(seconds: 10)), position: const Duration(seconds: 10));
      for (var i = 0; i < 4; i++) {
        await tap(tester, right(tester));
      }
      expect(seconds(player.seeks), [20, 30, 50]);
      expect(find.text('40 seconds'), findsOneWidget);
      expect(tester.takeAnnouncements().map((a) => a.message).first, 'Forward 10 seconds');
      await tester.pump(StashVideoControls.seekSequenceWindow);
    });

    testWidgets('without cumulative, further taps add one step each', (tester) async {
      await pump(tester, seek: const SeekSettings(cumulative: false));
      for (var i = 0; i < 4; i++) {
        await tap(tester, right(tester));
      }
      expect(seconds(player.seeks), [35, 40, 45]);
      expect(find.text('15 seconds'), findsOneWidget);
      await tester.pump(StashVideoControls.seekSequenceWindow);
    });

    testWidgets('with double-tap seeking off, taps only toggle the controls, right away', (tester) async {
      await pump(tester, seek: const SeekSettings(enabled: false));
      await tester.tapAt(right(tester));
      await tester.pump();
      expect(controlsVisible(tester), isTrue, reason: 'no wait for a second tap');
      await tester.tapAt(right(tester));
      await tester.pump();
      expect(controlsVisible(tester), isFalse);
      await tester.tapAt(right(tester));
      await tester.pump();
      expect(player.seeks, isEmpty);
      expect(circles(), findsNothing);
      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets('with double-tap seeking off, casting has no seek zones', (tester) async {
      await pump(tester, casting: true, seek: const SeekSettings(enabled: false));
      for (var i = 0; i < 3; i++) {
        await tap(tester, right(tester));
      }
      expect(cast.seeks, isEmpty);
    });
  });

  testWidgets('no seeking while the touch lock is on', (tester) async {
    await pump(tester, fullscreen: true);
    await tap(tester, middle(tester));
    await tester.pump(kDoubleTapTimeout);
    await tester.tap(find.byTooltip('Lock screen'));
    await tester.pump();
    for (var i = 0; i < 3; i++) {
      await tap(tester, right(tester));
    }
    expect(player.seeks, isEmpty);
    expect(find.text('5 seconds'), findsNothing);
    await tester.pump(const Duration(seconds: 3));
  });
}
