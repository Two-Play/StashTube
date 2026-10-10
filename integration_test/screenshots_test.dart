// Takes the README screenshots against the demo Stash (tool/screenshots/):
//
//   tool/screenshots/take_screenshots.sh
//
// Not part of `flutter test`; it drives the real app on a simulator.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/main.dart' as app;
import 'package:stash_app_mobile/widgets/performer_tile.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// Lets the app run for [seconds] (loading, previews, playback); the app
  /// never settles, as thumbnails shimmer and videos play.
  Future<void> run(WidgetTester tester, double seconds) async {
    final end = DateTime.now().add(Duration(milliseconds: (seconds * 1000).round()));
    while (DateTime.now().isBefore(end)) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> shot(WidgetTester tester, String name) async {
    await tester.pump();
    await binding.takeScreenshot(name);
  }

  Future<void> tap(WidgetTester tester, Finder finder, {double wait = 1.5}) async {
    if (finder.evaluate().isEmpty) {
      // Shows where the run got stuck (not part of the README).
      await binding.takeScreenshot('failed');
      fail('Not found: $finder');
    }
    await tester.tap(finder.first);
    await run(tester, wait);
  }

  testWidgets('README screenshots', (tester) async {
    // English, whatever the simulator's language (the app's language setting).
    await (await SharedPreferences.getInstance()).setString('locale', 'en');
    await app.main();
    await run(tester, 3);

    // Without a port: the app finds Stash on its default port 9999.
    await tester.enterText(find.widgetWithText(TextFormField, 'Server URL'), 'localhost');
    await tap(tester, find.text('Connect'), wait: 4);

    // The theme picker after the first login.
    await tap(tester, find.text('Dark'), wait: 1);
    await shot(tester, 'theme');
    await tap(tester, find.text('Done'), wait: 5);

    await shot(tester, 'home');

    await tap(tester, find.text('Shorts'), wait: 6);
    await shot(tester, 'shorts');
    await tap(tester, find.byType(BackButton), wait: 2);

    await tap(tester, find.text('The Robots Arrive'), wait: 6);
    // A tap on the video shows the controls (after the double tap timeout).
    await tester.tapAt(Offset(tester.view.physicalSize.width / tester.view.devicePixelRatio / 2, 150));
    await run(tester, 1);
    await shot(tester, 'player');
    await tap(tester, find.byIcon(Icons.keyboard_arrow_down), wait: 2);

    // The collapsed player has the same texts (performers, ...): only
    // look in the bar, the grid and the tabs.
    Finder inBar(String label) => find.descendant(of: find.byType(NavigationBar), matching: find.text(label));

    await tap(tester, inBar('Performers'), wait: 3);
    await tap(tester, find.widgetWithText(PerformerTile, 'Celia'), wait: 4);
    await shot(tester, 'channel');

    await tap(tester, inBar('Library'), wait: 2);
    final markersTab = find.descendant(of: find.byType(TabBar), matching: find.text('Markers'));
    // The tab is past the edge of the scrolling tab bar.
    await tester.ensureVisible(markersTab);
    await run(tester, 1);
    await tap(tester, markersTab, wait: 5);
    await shot(tester, 'markers');
  });
}
