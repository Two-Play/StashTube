import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/providers.dart';
import 'package:stash_app_mobile/data/repositories/stash_session.dart';
import 'package:stash_app_mobile/features/player/player_providers.dart';
import 'package:stash_app_mobile/features/player/video_controls.dart';

import '../../helpers.dart';
import '../fake_player.dart';

/// Records the queue commands instead of playing.
class _RecordingNowPlaying extends NowPlayingNotifier {
  final calls = <String>[];

  @override
  Scene? build() => null;

  @override
  void playNext() => calls.add('next');

  @override
  void playPrevious() => calls.add('previous');

  @override
  bool goBack() {
    calls.add('back');
    return true;
  }

  @override
  bool goForward() {
    calls.add('forward');
    return true;
  }
}

const _scenes = [Scene(id: '1', title: 'A'), Scene(id: '2', title: 'B'), Scene(id: '3', title: 'C')];

void main() {
  late ProviderContainer container;
  late _RecordingNowPlaying nowPlaying;

  Future<void> pump(WidgetTester tester, {PlayQueue? queue, bool fullscreen = false}) async {
    nowPlaying = _RecordingNowPlaying();
    await tester.pumpWidget(ProviderScope(
      overrides: [
        ...testServer,
        playerProvider.overrideWithValue(FakePlayer(position: const Duration(seconds: 30))),
        scrubThumbnailsProvider('1').overrideWith((ref) async => null),
        authHeadersProvider.overrideWithValue(const {}),
        nowPlayingProvider.overrideWith(() => nowPlaying),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 400,
              height: 225,
              child: StashVideoControls(
                fullscreen: fullscreen,
                onToggleFullscreen: () {},
                scene: _scenes.first,
                onQuality: () {},
              ),
            ),
          ),
        ),
      ),
    ));
    container = ProviderScope.containerOf(tester.element(find.byType(StashVideoControls)));
    container.read(playQueueProvider.notifier).set(queue);
    await tester.pump();
    // Show the controls.
    final rect = tester.getRect(find.byType(StashVideoControls));
    await tester.tapAt(Offset(rect.left + 20, rect.center.dy));
    await tester.pump(kDoubleTapTimeout + const Duration(milliseconds: 10));
  }

  IconButton button(WidgetTester tester, String tooltip) =>
      tester.widget<IconButton>(find.ancestor(of: find.byTooltip(tooltip), matching: find.byType(IconButton)).first);

  testWidgets('no previous/next without a queue', (tester) async {
    await pump(tester);
    expect(find.byTooltip('Previous scene'), findsNothing);
    expect(find.byTooltip('Next scene'), findsNothing);
    expect(find.byTooltip('Play'), findsOneWidget);
  });

  testWidgets('without a queue: back/forward through the videos picked in the player (4.25)', (tester) async {
    await pump(tester);
    expect(find.byTooltip('Back to the previous video'), findsNothing, reason: 'nothing to go back to');

    container.read(playerHistoryProvider.notifier).push((scene: _scenes[1], at: 12));
    await tester.pump();
    expect(button(tester, 'Back to the previous video').onPressed, isNotNull);
    expect(button(tester, 'Forward to the next video').onPressed, isNull, reason: 'shown, but nothing ahead');
    await tester.tap(find.byTooltip('Back to the previous video'));
    await tester.pump();
    expect(nowPlaying.calls, ['back']);

    container.read(playerHistoryProvider.notifier).back((scene: _scenes.first, at: 3));
    await tester.pump();
    expect(button(tester, 'Back to the previous video').onPressed, isNull);
    await tester.tap(find.byTooltip('Forward to the next video'));
    await tester.pump();
    expect(nowPlaying.calls, ['back', 'forward']);
  });

  testWidgets('in the middle of a queue both work (CTRL-4)', (tester) async {
    await pump(tester, queue: const PlayQueue(title: 'Group', scenes: _scenes, index: 1));
    await tester.tap(find.byTooltip('Next scene'));
    await tester.tap(find.byTooltip('Previous scene'));
    expect(nowPlaying.calls, ['next', 'previous']);
  });

  testWidgets('disabled at the ends of the queue, also in fullscreen', (tester) async {
    await pump(tester, queue: const PlayQueue(title: 'Group', scenes: _scenes), fullscreen: true);
    expect(button(tester, 'Previous scene').onPressed, isNull);
    expect(button(tester, 'Next scene').onPressed, isNotNull);

    container.read(playQueueProvider.notifier).set(const PlayQueue(title: 'Group', scenes: _scenes, index: 2));
    await tester.pump();
    expect(button(tester, 'Previous scene').onPressed, isNotNull);
    expect(button(tester, 'Next scene').onPressed, isNull);
  });
}
