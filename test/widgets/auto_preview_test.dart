import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/widgets/animated_previews.dart';
import 'package:stash_app_mobile/widgets/auto_preview.dart';
import 'package:stash_app_mobile/widgets/stash_image.dart';

import '../helpers.dart';

void main() {
  Future<void> pumpList(WidgetTester tester, {bool previews = true, bool firstHasPreview = true}) =>
      tester.pumpWidget(ProviderScope(
        overrides: [...testServer, animatedPreviewsProvider.overrideWithBuild((ref, notifier) => previews)],
        child: MaterialApp(
          home: Scaffold(
            body: AutoPreviewScope(
              child: ListView(
                children: [
                  for (var i = 0; i < 20; i++)
                    SizedBox(
                      height: 200,
                      child: AutoPreview(
                        url: i == 0 && !firstHasPreview ? null : 'http://s/$i.webp',
                        child: Text('still $i'),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ));

  List<String?> playing(WidgetTester tester) =>
      [for (final image in tester.widgetList<StashImage>(find.byType(StashImage))) image.url];

  testWidgets('the first fully shown video plays after a few seconds', (tester) async {
    await pumpList(tester);
    await tester.pump(const Duration(seconds: 1));
    expect(playing(tester), isEmpty, reason: 'not right away');
    await tester.pump(const Duration(seconds: 2));
    expect(playing(tester), ['http://s/0.webp']);
  });

  testWidgets('scrolling stops it; the new first one plays once it rests', (tester) async {
    await pumpList(tester);
    await tester.pump(const Duration(seconds: 3));
    expect(playing(tester), ['http://s/0.webp']);

    // Half of tile 1 scrolls out: tile 2 is the first fully shown one.
    final gesture = await tester.startGesture(tester.getCenter(find.byType(ListView)));
    await gesture.moveBy(const Offset(0, -300));
    await tester.pump();
    expect(playing(tester), isEmpty);
    await gesture.up();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 3));
    expect(playing(tester), ['http://s/2.webp']);
  });

  testWidgets('videos without a preview are skipped', (tester) async {
    await pumpList(tester, firstHasPreview: false);
    await tester.pump(const Duration(seconds: 3));
    expect(playing(tester), ['http://s/1.webp']);
  });

  testWidgets('nothing plays with previews switched off', (tester) async {
    await pumpList(tester, previews: false);
    await tester.pump(const Duration(seconds: 3));
    expect(playing(tester), isEmpty);
    expect(find.text('still 0'), findsOneWidget);
  });
}
