import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/core/pagination/paged_notifier.dart';
import 'package:stash_app_mobile/widgets/paged_sliver.dart';

void main() {
  Future<List<int>> pumpBar(WidgetTester tester, {required int page}) async {
    final requested = <int>[];
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: PageBar(
          state: PagedState<Object?>(items: const [], totalCount: 50, page: page, perPage: 24),
          onGoToPage: (p) async => requested.add(p),
        ),
      ),
    ));
    return requested;
  }

  testWidgets('shows the page and goes to neighbors and ends', (tester) async {
    final requested = await pumpBar(tester, page: 2);
    expect(find.text('Page 2 of 3'), findsOneWidget);

    for (final icon in [Icons.first_page, Icons.chevron_left, Icons.chevron_right, Icons.last_page]) {
      await tester.tap(find.byIcon(icon));
      await tester.pump();
    }
    expect(requested, [1, 1, 3, 3]);
  });

  testWidgets('disables the buttons past the ends', (tester) async {
    final requested = await pumpBar(tester, page: 3);
    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.tap(find.byIcon(Icons.last_page));
    await tester.pump();
    expect(requested, isEmpty);
  });

  testWidgets('tapping the page number jumps to a typed page', (tester) async {
    final requested = await pumpBar(tester, page: 1);
    await tester.tap(find.text('Page 1 of 3'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '9'); // out of range
    await tester.pump();
    expect(tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Go')).onPressed, isNull);

    await tester.enterText(find.byType(TextField), '3');
    await tester.testTextInput.receiveAction(TextInputAction.go);
    await tester.pumpAndSettle();
    expect(requested, [3]);
  });
}
