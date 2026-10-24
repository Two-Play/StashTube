import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/models/image_item.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/data/models/page_result.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/features/library/image_viewer_page.dart';

import '../../fixtures.dart';
import '../../helpers.dart';

class _Repo implements StashRepository {
  @override
  Future<PageResult<ImageItem>> findImages(ImageQuery query, {int page = 1, int perPage = 24}) async => PageResult(
        items: [
          imageFrom({'id': '1', 'title': 'First'}),
          imageFrom({'id': '2', 'title': 'Second'}),
        ],
        totalCount: 2,
      );

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError('${invocation.memberName}');
}

/// Swiping the image viewer down closes it (LIB, image viewer).
void main() {
  Future<void> pumpViewer(WidgetTester tester, {bool reducedMotion = false}) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(ProviderScope(
      retry: (_, _) => null,
      overrides: [
        ...testServer,
        sharedPreferencesProvider.overrideWithValue(prefs),
        stashRepositoryProvider.overrideWithValue(_Repo()),
      ],
      child: MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(disableAnimations: reducedMotion),
          child: child!,
        ),
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => Navigator.of(context).push(ImageViewerPage.route(query: ImageQuery(), initialIndex: 0)),
              child: const Text('grid'),
            ),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('grid'));
    await tester.pumpAndSettle();
    expect(find.byType(ImageViewerPage), findsOneWidget);
  }

  Offset imageOffset(WidgetTester tester) => tester.getTopLeft(find.byType(PageView));

  testWidgets('the grid shows through while the image follows the finger; far enough closes', (tester) async {
    await pumpViewer(tester);
    final start = imageOffset(tester);

    final gesture = await tester.startGesture(const Offset(200, 400));
    await gesture.moveBy(const Offset(0, 20));
    await gesture.moveBy(const Offset(0, 180));
    await tester.pump();
    expect(imageOffset(tester).dy, greaterThan(start.dy + 100), reason: 'follows the finger');
    expect(find.text('grid'), findsOneWidget, reason: 'the page below is still painted');
    final background = tester.widget<ColoredBox>(
      find.descendant(of: find.byType(ImageViewerPage), matching: find.byType(ColoredBox)).first,
    );
    expect(background.color.a, lessThan(1));

    await tester.pump(const Duration(seconds: 1)); // slow: no fling
    await gesture.up();
    await tester.pumpAndSettle();
    expect(find.byType(ImageViewerPage), findsNothing);
  });

  testWidgets('a short drag springs back', (tester) async {
    await pumpViewer(tester);
    final start = imageOffset(tester);
    await tester.timedDrag(find.byType(PageView), const Offset(0, 60), const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.byType(ImageViewerPage), findsOneWidget);
    expect(imageOffset(tester), start);
  });

  testWidgets('a fast fling closes even when short', (tester) async {
    await pumpViewer(tester);
    await tester.fling(find.byType(PageView), const Offset(0, 80), 1500);
    await tester.pumpAndSettle();
    expect(find.byType(ImageViewerPage), findsNothing);
  });

  testWidgets('swiping up does not close', (tester) async {
    await pumpViewer(tester);
    await tester.fling(find.byType(PageView), const Offset(0, -300), 1500);
    await tester.pumpAndSettle();
    expect(find.byType(ImageViewerPage), findsOneWidget);
  });

  testWidgets('horizontal swipes still page between the images', (tester) async {
    await pumpViewer(tester);
    expect(find.text('First'), findsOneWidget);
    await tester.fling(find.byType(PageView), const Offset(-300, 0), 1500);
    await tester.pumpAndSettle();
    expect(find.text('Second'), findsOneWidget);
    expect(find.byType(ImageViewerPage), findsOneWidget);
  });

  testWidgets('zoomed in, a vertical drag pans instead of closing', (tester) async {
    await pumpViewer(tester);
    final center = tester.getCenter(find.byType(PageView));
    await tester.tapAt(center);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tapAt(center);
    await tester.pumpAndSettle();
    final viewer = tester.widget<InteractiveViewer>(find.byType(InteractiveViewer).first);
    expect(viewer.transformationController!.value.getMaxScaleOnAxis(), greaterThan(1));

    await tester.fling(find.byType(PageView), const Offset(0, 300), 1500);
    await tester.pumpAndSettle();
    expect(find.byType(ImageViewerPage), findsOneWidget);
  });

  testWidgets('with reduced motion it closes without animating', (tester) async {
    await pumpViewer(tester, reducedMotion: true);
    await tester.fling(find.byType(PageView), const Offset(0, 300), 1500);
    await tester.pump();
    await tester.pump();
    expect(find.byType(ImageViewerPage), findsNothing);
  });
}
