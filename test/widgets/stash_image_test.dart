import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/widgets/stash_image.dart';

import '../helpers.dart';

void main() {
  group('decodeSize', () {
    test('constrains only the larger side, in physical pixels', () {
      expect(StashImage.decodeSize(180, 101, 3), (width: 540, height: null));
      expect(StashImage.decodeSize(120, 200, 2), (width: null, height: 400));
    });

    test('ignores unbounded or missing sizes', () {
      expect(StashImage.decodeSize(double.infinity, 200, 2), (width: null, height: 400));
      expect(StashImage.decodeSize(null, null, 2), (width: null, height: null));
      expect(StashImage.decodeSize(0, 0, 2), (width: null, height: null));
    });
  });

  testWidgets('shimmer animates, but stays still with reduced motion', (tester) async {
    Future<Gradient?> gradientAfter(Duration d, {required bool reduceMotion}) async {
      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(disableAnimations: reduceMotion),
          child: const MaterialApp(home: ShimmerBox(width: 100, height: 50)),
        ),
      );
      final before = (tester.widget<Container>(find.byType(Container)).decoration as BoxDecoration).gradient;
      await tester.pump(d);
      final after = (tester.widget<Container>(find.byType(Container)).decoration as BoxDecoration).gradient;
      return before == after ? null : after;
    }

    expect(await gradientAfter(const Duration(milliseconds: 300), reduceMotion: false), isNotNull);
    await tester.pumpWidget(const SizedBox());
    expect(await gradientAfter(const Duration(milliseconds: 300), reduceMotion: true), isNull);
  });

  group('ChannelAvatar', () {
    Future<void> pump(WidgetTester tester, String? imageUrl) => tester.pumpWidget(
      ProviderScope(
        overrides: [...testServer],
        child: MaterialApp(
          home: Scaffold(
            body: ChannelAvatar(name: 'studio x', imageUrl: imageUrl),
          ),
        ),
      ),
    );

    testWidgets('shows the initial without an image', (tester) async {
      await pump(tester, null);
      expect(find.text('S'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsNothing);
    });

    testWidgets('keeps the initial, not a person icon, until the image shows', (tester) async {
      // Stash's SVG placeholder for a missing studio image can't be decoded;
      // the avatar falls back to the same stand-in as while loading.
      await pump(tester, 'http://test/studio/1/image');
      expect(find.text('S'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsNothing);
      expect(tester.widget<StashImage>(find.byType(StashImage)).standIn, isNotNull);
    });

    testWidgets('is skipped by screen readers (the name is shown next to it)', (tester) async {
      final handle = tester.ensureSemantics();
      await pump(tester, null);
      expect(find.bySemanticsLabel('S'), findsNothing);
      handle.dispose();
    });
  });

  testWidgets('StashImage without a url shows its stand-in', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: StashImage(null, standIn: Text('stand-in'))),
      ),
    );
    expect(find.text('stand-in'), findsOneWidget);
    expect(find.byIcon(Icons.image_not_supported_outlined), findsNothing);
  });
}
