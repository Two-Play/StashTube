import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/features/settings/about.dart';

void main() {
  testWidgets('the licenses page lists the packages\' licenses for Stashy', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: Scaffold(body: AboutSettings()))));
    await tester.pumpAndSettle();
    expect(find.text('Version'), findsOneWidget);

    await tester.tap(find.text('Open source licenses'));
    await tester.pumpAndSettle();
    expect(find.byType(LicensePage), findsOneWidget);
    expect(find.text('Stashy'), findsWidgets);
  });
}
