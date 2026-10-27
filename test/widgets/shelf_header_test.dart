import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/widgets/scene_shelf.dart';

void main() {
  Future<void> pump(WidgetTester tester, {double scale = 1}) async {
    tester.view.physicalSize = const Size(360, 200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(size: const Size(360, 200), textScaler: TextScaler.linear(scale)),
        child: Scaffold(body: ShelfHeader(title: 'History', onSeeAll: () {})),
      ),
    ));
  }

  testWidgets('"See all" sits at the end of the row', (tester) async {
    await pump(tester);
    final button = tester.getRect(find.byType(TextButton));
    expect(button.right, greaterThan(340));
    expect(button.left, greaterThan(180), reason: 'not in the middle');
  });

  testWidgets('with large text it takes at most half the row and stays at the end', (tester) async {
    await pump(tester, scale: 2);
    final button = tester.getRect(find.byType(TextButton));
    expect(button.right, greaterThan(340));
    expect(button.width, lessThanOrEqualTo(180));
    expect(tester.takeException(), isNull);
  });
}
