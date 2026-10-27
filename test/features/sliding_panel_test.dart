import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/features/player/sliding_panel.dart';

const _min = 64.0;
const _max = 600.0;

/// Counts how often it is mounted, to tell whether the panel kept it.
class _Content extends StatefulWidget {
  const _Content({required this.onDoubleTap});

  final VoidCallback onDoubleTap;
  static int mounts = 0;

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  @override
  void initState() {
    super.initState();
    _Content.mounts++;
  }

  // Like media_kit's controls: a raw Listener plus a double-tap recognizer.
  @override
  Widget build(BuildContext context) => Listener(
        onPointerDown: (_) {},
        child: GestureDetector(
          onDoubleTap: widget.onDoubleTap,
          child: const ColoredBox(key: Key('content'), color: Colors.black, child: SizedBox.expand()),
        ),
      );
}

void main() {
  late SlidingPanelController controller;
  late ValueNotifier<double> height;
  late int dismissed;
  late int doubleTaps;

  setUp(() {
    controller = SlidingPanelController();
    height = ValueNotifier(_min);
    dismissed = 0;
    doubleTaps = 0;
    _Content.mounts = 0;
  });
  tearDown(() => height.dispose());

  Future<void> pump(WidgetTester tester, {double maxHeight = _max, bool dismissible = true, bool reduceMotion = false}) {
    tester.view
      ..physicalSize = const Size(400, _max)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    return tester.pumpWidget(MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: const Size(400, _max), disableAnimations: reduceMotion),
          child: Scaffold(
            body: SlidingPanel(
              controller: controller,
              height: height,
              minHeight: _min,
              maxHeight: maxHeight,
              onDismissed: dismissible ? () => dismissed++ : null,
              builder: (_, _) => _Content(onDoubleTap: () => doubleTaps++),
            ),
          ),
        ),
      ));
  }

  Finder content() => find.byKey(const Key('content'));

  Future<void> expand(WidgetTester tester) async {
    controller.expand();
    await tester.pumpAndSettle();
    expect(height.value, _max);
  }

  testWidgets('starts as the mini bar at the bottom', (tester) async {
    await pump(tester);
    expect(tester.getRect(content()), const Rect.fromLTRB(0, _max - _min, 400, _max));
    expect(controller.isAttached, isTrue);
  });

  testWidgets('the controller animates between bar and full height', (tester) async {
    await pump(tester);
    controller.expand();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    expect(height.value, inExclusiveRange(_min, _max), reason: 'animates, does not jump');
    await tester.pumpAndSettle();
    expect(height.value, _max);
    expect(tester.getRect(content()), const Rect.fromLTRB(0, 0, 400, _max));

    controller.collapse();
    await tester.pumpAndSettle();
    expect(height.value, _min);
  });

  testWidgets('jumpTo follows right away and stays in range', (tester) async {
    await pump(tester);
    controller.jumpTo(300);
    expect(height.value, 300);
    controller.jumpTo(5000);
    expect(height.value, _max);
    controller.jumpTo(0);
    expect(height.value, _min, reason: 'only a drag on the bar goes below it');
    expect(dismissed, 0);
  });

  testWidgets('reduced motion expands without an animation', (tester) async {
    await pump(tester, reduceMotion: true);
    controller.expand();
    expect(height.value, _max);
  });

  testWidgets('a tap on the bar expands it', (tester) async {
    await pump(tester);
    await tester.tap(content());
    // The content's double-tap recognizer holds the arena until its timeout.
    await tester.pump(kDoubleTapTimeout + const Duration(milliseconds: 50));
    await tester.pumpAndSettle();
    expect(height.value, _max);
  });

  testWidgets('expanded, a single tap stays with the content', (tester) async {
    await pump(tester);
    await expand(tester);
    await tester.tap(content());
    await tester.pump(kDoubleTapTimeout + const Duration(milliseconds: 50));
    await tester.pumpAndSettle();
    expect(height.value, _max);
  });

  testWidgets('expanded, a double tap reaches the content', (tester) async {
    await pump(tester);
    await expand(tester);
    await tester.tap(content());
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(content());
    await tester.pumpAndSettle();
    expect(doubleTaps, 1);
    expect(height.value, _max);
  });

  testWidgets('expanded, the panel ignores vertical drags (DragToMinimize has them)', (tester) async {
    await pump(tester);
    await expand(tester);
    await tester.drag(content(), const Offset(0, 300));
    await tester.pumpAndSettle();
    expect(height.value, _max);
  });

  testWidgets('dragging the bar up follows the finger and expands on release', (tester) async {
    await pump(tester);
    final gesture = await tester.startGesture(tester.getCenter(content()));
    await gesture.moveBy(const Offset(0, -30));
    await gesture.moveBy(const Offset(0, -100));
    await tester.pump();
    // The first move goes partly into the drag slop.
    expect(height.value, inInclusiveRange(_min + 100, _min + 130));
    await gesture.moveBy(const Offset(0, -100));
    await tester.pump(const Duration(milliseconds: 500)); // slow release
    await gesture.up();
    await tester.pumpAndSettle();
    expect(height.value, _max);
  });

  testWidgets('a short, slow drag up snaps back to the bar', (tester) async {
    await pump(tester);
    final gesture = await tester.startGesture(tester.getCenter(content()));
    for (var i = 0; i < 6; i++) {
      await gesture.moveBy(const Offset(0, -8));
      await tester.pump(const Duration(milliseconds: 100));
    }
    await gesture.up();
    await tester.pumpAndSettle();
    expect(height.value, _min);
  });

  testWidgets('dragging up to the top and back down in one go still snaps', (tester) async {
    await pump(tester);
    final gesture = await tester.startGesture(tester.getCenter(content()));
    await gesture.moveBy(const Offset(0, -20));
    await gesture.moveBy(const Offset(0, -_max));
    await tester.pump();
    expect(height.value, _max);
    await gesture.moveBy(const Offset(0, 500));
    await tester.pump(const Duration(milliseconds: 500));
    await gesture.up();
    await tester.pumpAndSettle();
    expect(height.value, _min);
  });

  testWidgets('dragging the bar down out of the window dismisses it', (tester) async {
    await pump(tester);
    await tester.drag(content(), const Offset(0, 60));
    await tester.pumpAndSettle();
    expect(dismissed, 1);
    expect(height.value, _min, reason: 'the height never goes below the bar');
  });

  testWidgets('a small, slow drag down slides the bar back', (tester) async {
    await pump(tester);
    final gesture = await tester.startGesture(tester.getCenter(content()));
    await gesture.moveBy(const Offset(0, 20));
    await gesture.moveBy(const Offset(0, 10));
    await tester.pump();
    final opacity = tester.widget<Opacity>(find.ancestor(of: content(), matching: find.byType(Opacity)).first);
    expect(opacity.opacity, lessThan(1), reason: 'fades while dragged out');
    await tester.pump(const Duration(milliseconds: 500));
    await gesture.up();
    await tester.pumpAndSettle();
    expect(dismissed, 0);
    expect(tester.getRect(content()), const Rect.fromLTRB(0, _max - _min, 400, _max));
  });

  testWidgets('without onDismissed the bar cannot be dragged out', (tester) async {
    await pump(tester, dismissible: false);
    await tester.drag(content(), const Offset(0, 60));
    await tester.pumpAndSettle();
    expect(tester.getRect(content()), const Rect.fromLTRB(0, _max - _min, 400, _max));
  });

  testWidgets('a tap on the dimmed page above the panel collapses it', (tester) async {
    await pump(tester);
    controller.jumpTo(300);
    await tester.pump();
    await tester.tapAt(const Offset(200, 100));
    await tester.pumpAndSettle();
    expect(height.value, _min);
  });

  testWidgets('the content is never remounted while the panel moves', (tester) async {
    await pump(tester);
    await expand(tester);
    controller.collapse();
    await tester.pumpAndSettle();
    final gesture = await tester.startGesture(tester.getCenter(content()));
    await gesture.moveBy(const Offset(0, 20));
    await gesture.moveBy(const Offset(0, 20));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();
    expect(_Content.mounts, 1);
  });

  testWidgets('an expanded panel stays expanded when the window changes', (tester) async {
    await pump(tester);
    await expand(tester);
    await pump(tester, maxHeight: 400);
    await tester.pump();
    expect(height.value, 400);
    await pump(tester, maxHeight: _max);
    await tester.pump();
    expect(height.value, _max);
  });

  testWidgets('the controller detaches with the panel', (tester) async {
    await pump(tester);
    await tester.pumpWidget(const SizedBox());
    expect(controller.isAttached, isFalse);
    controller.expand(); // nothing plays: ignored
    expect(height.value, _min);
  });

  test('release decision', () {
    PanelSnap snap(double progress, double velocity, {double dismissed = 0}) =>
        SlidingPanel.snapAfterDrag(progress: progress, dismissed: dismissed, velocity: velocity, canDismiss: true);
    expect(snap(0.5, 0), PanelSnap.expand, reason: 'far up');
    expect(snap(0.1, 0), PanelSnap.collapse);
    expect(snap(0.1, -800), PanelSnap.expand, reason: 'flung up');
    expect(snap(0.8, 800), PanelSnap.collapse, reason: 'flung down');
    expect(snap(0, 0, dismissed: 0.5), PanelSnap.dismiss);
    expect(snap(0, 0, dismissed: 0.1), PanelSnap.collapse);
    expect(snap(0, 800, dismissed: 0.1), PanelSnap.dismiss, reason: 'flung down');
    expect(snap(0, -800, dismissed: 0.5), PanelSnap.collapse, reason: 'flung back up');
    expect(
      SlidingPanel.snapAfterDrag(progress: 0, dismissed: 0.5, velocity: 0, canDismiss: false),
      PanelSnap.collapse,
    );
  });
}
