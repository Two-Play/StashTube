import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/core/utils/external_links.dart';
import 'package:stash_app_mobile/features/settings/about.dart';
import 'package:stash_app_mobile/features/settings/settings_categories.dart';

void main() {
  testWidgets('feedback opens GitHub\'s issue forms', (tester) async {
    final opened = <Uri>[];
    urlOpener = (uri) async {
      opened.add(uri);
      return true;
    };
    addTearDown(() => urlOpener = (uri) async => false);
    await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: Scaffold(body: AboutSettingsPage()))));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Feedback and bugs'));
    await tester.pumpAndSettle();
    expect(opened, [Uri.parse(githubIssuesUrl)]);
    expect(opened.single.toString(), startsWith('https://github.com/Two-Play/StashTube/'));
  });

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
