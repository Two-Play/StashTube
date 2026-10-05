import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/core/config/theme.dart';

Color _labelColor(WidgetTester tester, String text) =>
    DefaultTextStyle.of(tester.element(find.text(text))).style.color ??
    tester.widget<Text>(find.text(text)).style!.color!;

void main() {
  for (final brightness in Brightness.values) {
    testWidgets('selected chip labels are readable ($brightness)', (tester) async {
      final theme = brightness == Brightness.light ? AppTheme.light(accentColors['Red']!) : AppTheme.dark(accentColors['Red']!);
      await tester.pumpWidget(MaterialApp(
        theme: theme,
        home: Scaffold(
          body: Wrap(children: [
            ChoiceChip(label: const Text('picked'), selected: true, onSelected: (_) {}),
            ChoiceChip(label: const Text('other'), selected: false, onSelected: (_) {}),
            FilterChip(label: const Text('filter on'), selected: true, onSelected: (_) {}),
          ]),
        ),
      ));
      final scheme = theme.colorScheme;
      // Selected chips have the inverted (onSurface) background, so the label
      // must use the surface color, and unselected chips the normal one.
      expect(_labelColor(tester, 'picked'), scheme.surface);
      expect(_labelColor(tester, 'filter on'), scheme.surface);
      expect(_labelColor(tester, 'other'), scheme.onSurface);
    });
  }
}
