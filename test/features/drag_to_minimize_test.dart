import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/features/player/drag_to_minimize.dart';
import 'package:stash_app_mobile/features/player/sliding_panel.dart';

const _max = 800.0;
const _videoBottom = 220.0;

/// Records what [DragToMinimize] asks the panel for: a height, or
/// 'collapse'/'expand'.
class _RecordingController extends SlidingPanelController {
  Object? last;

  @override
  void expand({Duration? duration}) => last = 'expand';

  @override
  void collapse({Duration? duration}) => last = 'collapse';

  @override
  void jumpTo(double height) => last = height;
}

void main() {
  late _RecordingController controller;
  late ScrollController scroll;

  setUp(() {
    controller = _RecordingController();
    scroll = ScrollController();
  });
  tearDown(() => scroll.dispose());

  /// Video area that claims vertical drags (like media_kit's controls) above
  /// a details list (like "Up next").
  Future<void> pump(WidgetTester tester, {bool enabled = true}) => tester.pumpWidget(MaterialApp(
        home: DragToMinimize(
          enabled: enabled,
          controller: controller,
          minHeight: 64,
          maxHeight: _max,
          videoBottom: _videoBottom,
          child: Column(
            children: [
              GestureDetector(
                onVerticalDragUpdate: (_) {},
                child: const SizedBox(
                  key: Key('video'),
                  height: _videoBottom,
                  width: double.infinity,
                  child: ColoredBox(color: Colors.black),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  key: const Key('details'),
                  controller: scroll,
                  physics: const ClampingScrollPhysics(),
                  itemCount: 50,
                  itemBuilder: (_, i) => SizedBox(height: 80, child: Text('item $i')),
                ),
              ),
            ],
          ),
        ),
      ));

  Object? panelTarget() => controller.last;

  testWidgets('swiping down on the video collapses, even though the video claims the drag', (tester) async {
    await pump(tester);
    await tester.drag(find.byKey(const Key('video')), const Offset(0, 300));
    await tester.pump();
    expect(panelTarget(), 'collapse');
  });

  testWidgets('the panel follows the finger during the swipe', (tester) async {
    await pump(tester);
    final gesture = await tester.startGesture(tester.getCenter(find.byKey(const Key('video'))));
    await gesture.moveBy(const Offset(0, 20));
    await gesture.moveBy(const Offset(0, 100));
    expect(panelTarget(), _max - 120);
    await gesture.up();
  });

  testWidgets('a short, slow swipe snaps back open', (tester) async {
    await pump(tester);
    final gesture = await tester.startGesture(tester.getCenter(find.byKey(const Key('video'))));
    for (var i = 0; i < 10; i++) {
      await gesture.moveBy(const Offset(0, 5));
      await tester.pump(const Duration(milliseconds: 50));
    }
    await gesture.up();
    expect(panelTarget(), 'expand');
  });

  testWidgets('swiping down in the details at the top collapses', (tester) async {
    await pump(tester);
    await tester.drag(find.byKey(const Key('details')), const Offset(0, 300));
    expect(panelTarget(), 'collapse');
  });

  testWidgets('in scrolled details a downward swipe scrolls the list instead', (tester) async {
    await pump(tester);
    scroll.jumpTo(1000);
    await tester.pump();
    await tester.drag(find.byKey(const Key('details')), const Offset(0, 300));
    expect(panelTarget(), isNull);
    expect(scroll.offset, lessThan(1000));
  });

  testWidgets('does nothing while the panel is not expanded', (tester) async {
    await pump(tester, enabled: false);
    await tester.drag(find.byKey(const Key('video')), const Offset(0, 300));
    expect(panelTarget(), isNull);
  });

  test('release decision', () {
    expect(DragToMinimize.shouldCollapse(dragDistance: 50, velocity: 1000, maxHeight: _max), isTrue, reason: 'fling');
    expect(DragToMinimize.shouldCollapse(dragDistance: 200, velocity: 0, maxHeight: _max), isTrue, reason: 'far');
    expect(DragToMinimize.shouldCollapse(dragDistance: 50, velocity: 0, maxHeight: _max), isFalse);
    expect(DragToMinimize.shouldCollapse(dragDistance: 300, velocity: -800, maxHeight: _max), isFalse, reason: 'flung back up');
  });
}
