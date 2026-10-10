import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/features/settings/about.dart';

void main() {
  testWidgets('the licenses include the Stash logo next to the packages', (tester) async {
    registerAppLicenses();
    await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: Scaffold(body: AboutSettings()))));
    await tester.pumpAndSettle();
    expect(find.text('Version'), findsOneWidget);

    await tester.tap(find.text('Open source licenses'));
    await tester.pumpAndSettle();
    expect(find.byType(LicensePage), findsOneWidget);
    expect(find.text('Stash (logo and colors)'), findsOneWidget);
  });
}
