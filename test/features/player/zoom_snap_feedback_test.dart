import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/features/player/video_zoom.dart';
import 'package:stash_app_mobile/l10n/gen/app_localizations.dart';

void main() {
  group('guide lines', () {
    test('at the center, at an edge, or none', () {
      expect(const VideoZoom(scale: 2, snaps: VideoZoom.snapPanX).guideX, 0.5);
      expect(const VideoZoom(scale: 2, panX: 0.1, snaps: VideoZoom.snapPanX).guideX, 0, reason: 'moved right');
      expect(const VideoZoom(scale: 2, panX: -0.1, snaps: VideoZoom.snapPanX).guideX, 1);
      expect(const VideoZoom(scale: 2, panY: 0.1, snaps: VideoZoom.snapPanY).guideY, 0);
      expect(const VideoZoom(scale: 2, panX: 0.1).guideX, isNull, reason: 'not sticking');
      expect(const VideoZoom(scale: 2, snaps: VideoZoom.snapScale).guideY, isNull);
    });
  });

  late ProviderContainer container;
  setUp(() => container = ProviderContainer());
  tearDown(() => container.dispose());

  Future<void> pump(WidgetTester tester, {required bool pinching, bool reducedMotion = false}) =>
      tester.pumpWidget(UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MediaQuery(
            data: MediaQueryData(size: const Size(400, 225), disableAnimations: reducedMotion),
            child: SizedBox(width: 400, height: 225, child: ZoomSnapFeedback(pinching: pinching)),
          ),
        ),
      ));

  double opacityAbove(WidgetTester tester, Finder finder) =>
      tester.widget<AnimatedOpacity>(find.ancestor(of: finder, matching: find.byType(AnimatedOpacity)).first).opacity;

  Color pillColor(WidgetTester tester) =>
      (tester.widget<AnimatedContainer>(find.byKey(ZoomSnapFeedback.labelKey)).decoration! as BoxDecoration).color!;

  SnapGuidesPainter guides(WidgetTester tester) =>
      tester.widget<CustomPaint>(find.byKey(ZoomSnapFeedback.guidesKey)).painter! as SnapGuidesPainter;

  double popScale(WidgetTester tester) => tester
      .widget<Transform>(find.ancestor(of: find.byKey(ZoomSnapFeedback.labelKey), matching: find.byType(Transform)).first)
      .transform
      .getMaxScaleOnAxis();

  testWidgets('hidden without a pinch, always in the tree', (tester) async {
    await pump(tester, pinching: false);
    expect(find.byKey(ZoomSnapFeedback.labelKey), findsOneWidget);
    expect(opacityAbove(tester, find.byKey(ZoomSnapFeedback.labelKey)), 0);
    expect(opacityAbove(tester, find.byKey(ZoomSnapFeedback.guidesKey)), 0);
  });

  testWidgets('the pill names the sizes it sticks to, in the accent', (tester) async {
    await pump(tester, pinching: true);
    final primary = Theme.of(tester.element(find.byType(ZoomSnapFeedback))).colorScheme.primary;
    expect(find.text('Original'), findsOneWidget);
    expect(pillColor(tester), primary);

    container.read(videoZoomProvider.notifier).set(const VideoZoom(scale: 1.5));
    await tester.pumpAndSettle();
    expect(find.text('1.5×'), findsOneWidget);
    expect(pillColor(tester), isNot(primary));

    container.read(videoZoomProvider.notifier).set(const VideoZoom(scale: 1.33, fill: true, snaps: VideoZoom.snapScale));
    await tester.pump();
    expect(find.text('Fill'), findsOneWidget);
    expect(popScale(tester), greaterThan(1), reason: 'pops as it sticks');
    await tester.pumpAndSettle();
    expect(popScale(tester), 1);
    expect(pillColor(tester), primary);
  });

  testWidgets('guide lines show while the pan sticks', (tester) async {
    await pump(tester, pinching: true);
    container.read(videoZoomProvider.notifier).set(const VideoZoom(scale: 2, panY: 0.1, snaps: VideoZoom.snapPanX));
    await tester.pumpAndSettle();
    expect(guides(tester).x, 0.5);
    expect(guides(tester).y, isNull);
    expect(opacityAbove(tester, find.byKey(ZoomSnapFeedback.guidesKey)), 1);

    container.read(videoZoomProvider.notifier).set(const VideoZoom(scale: 2, panX: 0.2, panY: 0.1));
    await tester.pumpAndSettle();
    expect(opacityAbove(tester, find.byKey(ZoomSnapFeedback.guidesKey)), 0);
  });

  testWidgets('with reduced motion nothing pops or fades', (tester) async {
    await pump(tester, pinching: true, reducedMotion: true);
    container.read(videoZoomProvider.notifier).set(const VideoZoom(scale: 1.5));
    await tester.pump();
    container.read(videoZoomProvider.notifier).set(const VideoZoom(scale: 1.33, fill: true, snaps: VideoZoom.snapScale));
    await tester.pump();
    expect(popScale(tester), 1);
    expect(tester.widget<AnimatedContainer>(find.byKey(ZoomSnapFeedback.labelKey)).duration, Duration.zero);
    expect(
      tester.widget<AnimatedOpacity>(
        find.ancestor(of: find.byKey(ZoomSnapFeedback.guidesKey), matching: find.byType(AnimatedOpacity)).first,
      ).duration,
      Duration.zero,
    );
  });
}
