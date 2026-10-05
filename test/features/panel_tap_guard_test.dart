import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:stash_app_mobile/features/player/player_controls.dart';

void main() {
  /// An expanded miniplayer whose content behaves like media_kit's controls:
  /// a raw Listener for single taps plus a double-tap recognizer.
  Future<ValueNotifier<double>> pumpExpanded(WidgetTester tester,
      {required bool guarded, VoidCallback? onDoubleTap}) async {
    final height = ValueNotifier<double>(600);
    Widget content = Listener(
      onPointerDown: (_) {},
      child: GestureDetector(
        onDoubleTap: onDoubleTap ?? () {},
        child: const ColoredBox(
            key: Key('video'), color: Colors.black, child: SizedBox.expand()),
      ),
    );
    if (guarded) content = PanelTapGuard(child: content);

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Miniplayer(
          minHeight: 64,
          maxHeight: 600,
          valueNotifier: height,
          builder: (_, __) => content,
        ),
      ),
    ));
    return height;
  }

  testWidgets('without the guard a single tap collapses the expanded player',
      (tester) async {
    final height = await pumpExpanded(tester, guarded: false);
    await tester.tap(find.byKey(const Key('video')));
    // The double-tap recognizer holds the arena until its timeout.
    await tester.pump(kDoubleTapTimeout + const Duration(milliseconds: 50));
    await tester.pumpAndSettle();
    expect(height.value, 64);
  });

  testWidgets('with the guard a single tap keeps the player expanded',
      (tester) async {
    final height = await pumpExpanded(tester, guarded: true);
    await tester.tap(find.byKey(const Key('video')));
    // The double-tap recognizer holds the arena until its timeout.
    await tester.pump(kDoubleTapTimeout + const Duration(milliseconds: 50));
    await tester.pumpAndSettle();
    expect(height.value, 600);
  });

  testWidgets('double tap still reaches the video controls', (tester) async {
    var doubleTaps = 0;
    final height = await pumpExpanded(tester,
        guarded: true, onDoubleTap: () => doubleTaps++);
    final video = find.byKey(const Key('video'));
    await tester.tap(video);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(video);
    await tester.pumpAndSettle();
    expect(doubleTaps, 1);
    expect(height.value, 600);
  });
}
