import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/features/library/watch_later.dart';
import 'package:stash_app_mobile/features/library/watch_later_tab.dart';

import '../../helpers.dart';

void main() {
  Future<void> pump(WidgetTester tester, List<Scene> scenes) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        ...testServer,
        watchLaterScenesProvider.overrideWith((ref) async => scenes),
      ],
      child: const MaterialApp(home: Scaffold(body: WatchLaterTab())),
    ));
    await tester.pumpAndSettle();
  }

  const note = 'Saved on this device only, not on the server.';

  testWidgets('the empty state says the list is kept on this device (PL-2)', (tester) async {
    await pump(tester, const []);
    expect(find.text('Nothing saved yet'), findsOneWidget);
    expect(find.text(note), findsOneWidget);
  });

  testWidgets('the list ends with the on-this-device note (PL-2)', (tester) async {
    await pump(tester, const [Scene(id: '1', title: 'Saved scene', streamUrl: 'http://s/1')]);
    expect(find.text('Saved scene'), findsOneWidget);
    expect(find.text(note), findsOneWidget);
  });
}
