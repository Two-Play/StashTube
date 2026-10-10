import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/features/settings/about.dart';

void main() {
  testWidgets('the licenses include StashTube\'s own and the native video libraries', (tester) async {
    registerAppLicenses();
    // Tall enough for the whole list.
    await tester.binding.setSurfaceSize(const Size(800, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: Scaffold(body: AboutSettings()))));
    await tester.pumpAndSettle();
    expect(find.text('Version'), findsOneWidget);

    await tester.tap(find.text('Open source licenses'));
    // The page reads the license texts from the assets and parses them in an
    // isolate: that needs real time.
    for (var i = 0; i < 20 && find.text('mpv').evaluate().isEmpty; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
      await tester.pump();
    }
    expect(find.byType(LicensePage), findsOneWidget);
    expect(find.text('StashTube'), findsWidgets);
    for (final library in nativeLibraries) {
      expect(find.text(library.name), findsOneWidget, reason: library.name);
    }
  });
}
