import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/features/player/closing_slide.dart';
import 'package:stash_app_mobile/features/player/player_providers.dart';

import 'fake_player.dart';

void main() {
  testWidgets('slides the child down step by step, then reports closed', (tester) async {
    var closed = 0;
    Widget build(bool closing) => MaterialApp(
          home: Align(
            alignment: Alignment.bottomCenter,
            child: ClosingSlide(
              closing: closing,
              distance: 64,
              onClosed: () => closed++,
              child: const SizedBox(key: Key('bar'), height: 64, width: 300),
            ),
          ),
        );

    await tester.pumpWidget(build(false));
    final start = tester.getTopLeft(find.byKey(const Key('bar'))).dy;

    await tester.pumpWidget(build(true));
    await tester.pump(const Duration(milliseconds: 125));
    final middle = tester.getTopLeft(find.byKey(const Key('bar'))).dy;
    expect(middle, greaterThan(start), reason: 'moving down');
    expect(middle, lessThan(start + 64), reason: 'not jumping');
    expect(closed, 0);

    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.byKey(const Key('bar'))).dy, start + 64);
    expect(closed, 1);
  });

  test('dismiss pauses and marks closing; close clears the player', () {
    final player = FakePlayer(playing: true);
    final container = ProviderContainer(overrides: [playerProvider.overrideWithValue(player)]);
    addTearDown(container.dispose);
    container.listen(nowPlayingProvider, (_, _) {});

    // Put a scene into the player without opening media.
    container.read(nowPlayingProvider.notifier).state = const Scene(id: '1', title: 'A');
    container.read(nowPlayingProvider.notifier).dismiss();
    expect(player.pauseCalls, 1);
    expect(container.read(playerClosingProvider), isTrue);
    expect(container.read(nowPlayingProvider), isNotNull, reason: 'stays until the animation ends');
  });
}
