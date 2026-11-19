import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/widgets/scroll_to_top.dart';

void main() {
  Future<ScrollController> pump(WidgetTester tester, {Map<String, Object> stored = const {}}) async {
    final prefs = (await tester.runAsync(() async {
      SharedPreferences.setMockInitialValues(stored);
      return SharedPreferences.getInstance();
    }))!;
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: MaterialApp(
        home: Scaffold(
          body: ScrollToTop(
            child: ListView.builder(
              controller: controller,
              itemCount: 500,
              itemBuilder: (_, i) => SizedBox(
                height: 100,
                // A row that scrolls sideways doesn't count.
                child: i == 0
                    ? ListView(scrollDirection: Axis.horizontal, children: const [SizedBox(width: 2000)])
                    : Text('Item $i'),
              ),
            ),
          ),
        ),
      ),
    ));
    return controller;
  }

  bool shown(WidgetTester tester) =>
      tester.widget<IgnorePointer>(
        find.ancestor(of: find.byKey(const ValueKey('scroll-to-top')), matching: find.byType(IgnorePointer)).first,
      ).ignoring ==
      false;

  testWidgets('shows once scrolled down and scrolls back to the top', (tester) async {
    final controller = await pump(tester);
    expect(shown(tester), isFalse);

    await tester.drag(find.text('Item 3'), const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(shown(tester), isFalse, reason: 'not yet 1.5 screens down');

    controller.jumpTo(20000);
    await tester.pumpAndSettle();
    expect(shown(tester), isTrue);

    await tester.tap(find.byKey(const ValueKey('scroll-to-top')));
    await tester.pumpAndSettle();
    expect(controller.offset, 0);
    expect(shown(tester), isFalse);
  });

  testWidgets('can be switched off in the settings', (tester) async {
    final controller = await pump(tester, stored: {'scroll_to_top_button': false});
    controller.jumpTo(20000);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('scroll-to-top')), findsNothing);
  });
}
