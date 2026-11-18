import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/widgets/layout_freeze.dart';
import 'package:stash_app_mobile/widgets/sliver_columns.dart';

/// A list like the scene feeds: one column on a phone in portrait, several
/// in landscape (SliverColumns), items of 200 px.
Widget _list(ScrollController controller, ValueListenable<bool> hold) => MaterialApp(
      home: LayoutFreeze(
        hold: hold,
        child: Scaffold(
          body: CustomScrollView(
            controller: controller,
            slivers: [
              SliverColumns(
                itemCount: 40,
                columnWidth: 300,
                itemBuilder: (_, i) => SizedBox(height: 200, child: Text('item $i')),
              ),
            ],
          ),
        ),
      ),
    );

const _portrait = Size(390, 844);
const _landscape = Size(844, 390);

void main() {
  late ScrollController controller;
  late ValueNotifier<bool> hold;

  setUp(() {
    controller = ScrollController();
    hold = ValueNotifier(false);
  });

  tearDown(() {
    controller.dispose();
    hold.dispose();
  });

  Future<void> setWindow(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    await tester.pumpAndSettle();
  }

  testWidgets('without the hold, a turn to landscape loses the place in the list', (tester) async {
    addTearDown(tester.view.reset);
    await setWindow(tester, _portrait);
    await tester.pumpWidget(_list(controller, hold));
    controller.jumpTo(30 * 200);
    await tester.pumpAndSettle();
    expect(find.text('item 30'), findsOneWidget);

    // 2 columns: 20 rows, so the offset is clamped to the shorter list.
    await setWindow(tester, _landscape);
    await setWindow(tester, _portrait);
    expect(controller.offset, lessThan(30 * 200));
    expect(find.text('item 30'), findsNothing);
  });

  testWidgets('held, the list keeps its layout and offset through the turn and back', (tester) async {
    addTearDown(tester.view.reset);
    await setWindow(tester, _portrait);
    await tester.pumpWidget(_list(controller, hold));
    controller.jumpTo(30 * 200);
    await tester.pumpAndSettle();

    // Fullscreen opens: hold, then the window turns.
    hold.value = true;
    await tester.pump();
    await setWindow(tester, _landscape);
    expect(controller.position.viewportDimension, _portrait.height);
    expect(tester.takeException(), isNull);

    // Fullscreen closes while still sideways: stays frozen until it turned.
    hold.value = false;
    await tester.pump();
    expect(controller.position.viewportDimension, _portrait.height);
    await setWindow(tester, _portrait);

    expect(controller.offset, 30 * 200);
    expect(find.text('item 30'), findsOneWidget);
  });

  testWidgets('a window that stays turned gets its new layout after the settle time', (tester) async {
    addTearDown(tester.view.reset);
    await setWindow(tester, _portrait);
    await tester.pumpWidget(_list(controller, hold));

    hold.value = true;
    await tester.pump();
    await setWindow(tester, _landscape);
    hold.value = false;
    await tester.pump();
    expect(controller.position.viewportDimension, _portrait.height);

    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(controller.position.viewportDimension, _landscape.height);
  });
}
