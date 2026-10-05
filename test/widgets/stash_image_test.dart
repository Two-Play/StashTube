import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/widgets/stash_image.dart';

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
      await tester.pumpWidget(MediaQuery(
        data: MediaQueryData(disableAnimations: reduceMotion),
        child: const MaterialApp(home: ShimmerBox(width: 100, height: 50)),
      ));
      final before = (tester.widget<Container>(find.byType(Container)).decoration as BoxDecoration).gradient;
      await tester.pump(d);
      final after = (tester.widget<Container>(find.byType(Container)).decoration as BoxDecoration).gradient;
      return before == after ? null : after;
    }

    expect(await gradientAfter(const Duration(milliseconds: 300), reduceMotion: false), isNotNull);
    await tester.pumpWidget(const SizedBox());
    expect(await gradientAfter(const Duration(milliseconds: 300), reduceMotion: true), isNull);
  });
}
