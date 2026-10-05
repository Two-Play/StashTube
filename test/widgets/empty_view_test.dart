import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/core/pagination/paged_notifier.dart';
import 'package:stash_app_mobile/widgets/paged_sliver.dart';
import 'package:stash_app_mobile/widgets/status_views.dart';

void main() {
  testWidgets('empty lists show their own symbol, title and hint', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CustomScrollView(slivers: [
          PagedSliver<String>(
            value: const AsyncData(PagedState(items: [], totalCount: 0, page: 1, perPage: 24)),
            emptyMessage: 'No studios yet',
            emptyIcon: Icons.subscriptions_outlined,
            emptyHint: 'Studios appear here once scenes in Stash have one.',
            onRetry: () {},
            onLoadMore: () {},
            itemBuilder: (_, item) => Text(item),
          ),
        ]),
      ),
    ));
    expect(find.byIcon(Icons.subscriptions_outlined), findsOneWidget);
    expect(find.text('No studios yet'), findsOneWidget);
    expect(find.text('Studios appear here once scenes in Stash have one.'), findsOneWidget);
  });

  testWidgets('the symbol uses the theme in light and dark mode', (tester) async {
    for (final brightness in Brightness.values) {
      final theme = ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.red, brightness: brightness));
      await tester.pumpWidget(MaterialApp(theme: theme, home: const Scaffold(body: EmptyView(message: 'Empty'))));
      await tester.pumpAndSettle(); // theme changes are animated
      final icon = tester.widget<Icon>(find.byIcon(Icons.inbox_outlined));
      expect(icon.color, theme.colorScheme.onPrimaryContainer);
    }
  });
}
