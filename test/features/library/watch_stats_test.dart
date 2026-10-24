import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/models/stats.dart';
import 'package:stash_app_mobile/data/models/watch_history.dart';
import 'package:stash_app_mobile/data/providers.dart';
import 'package:stash_app_mobile/features/library/stats_tab.dart';
import 'package:stash_app_mobile/features/library/watch_chart.dart';

import '../../helpers.dart';

/// The stats' watch chart (16.3): bucketing, painter and the section.
void main() {
  // A Saturday afternoon.
  final now = DateTime(2026, 10, 24, 15);
  final history = PlayHistory([
    DateTime(2026, 10, 24, 10), // today
    DateTime(2026, 10, 19, 8), // Monday this week
    DateTime(2026, 10, 18, 23), // Sunday
    DateTime(2026, 10, 1, 12),
    DateTime(2026, 7, 1), // before both periods
    DateTime(2026, 10, 25, 9), // after now (clock skew)
  ]);

  group('PlayHistory.series', () {
    test('days: 30 buckets ending today', () {
      final s = history.series(WatchPeriod.days, now: now);
      expect(s.buckets, hasLength(30));
      expect(s.buckets.first.start, DateTime(2026, 9, 25));
      expect(s.current, WatchBucket(DateTime(2026, 10, 24), 1));
      expect(s.buckets[24], WatchBucket(DateTime(2026, 10, 19), 1));
      expect(s.buckets[23], WatchBucket(DateTime(2026, 10, 18), 1));
      expect(s.buckets[6], WatchBucket(DateTime(2026, 10, 1), 1));
      expect(s.total, 4);
      expect(s.average, closeTo(4 / 30, 1e-9));
    });

    test('weeks starting Monday: 12 buckets ending this week', () {
      final s = history.series(WatchPeriod.weeks, now: now);
      expect(s.buckets, hasLength(12));
      expect(s.current, WatchBucket(DateTime(2026, 10, 19), 2));
      expect(s.buckets[10], WatchBucket(DateTime(2026, 10, 12), 1));
      expect(s.buckets.first.start, DateTime(2026, 8, 3));
      expect(s.buckets.where((b) => b.start == DateTime(2026, 9, 28)).single.plays, 1);
      expect(s.total, 4);
    });

    test('weeks starting Sunday put Sunday into the current week', () {
      final s = history.series(WatchPeriod.weeks, now: now, firstWeekday: DateTime.sunday);
      expect(s.current, WatchBucket(DateTime(2026, 10, 18), 3));
      expect(s.total, 4);
    });

    test('no plays: empty buckets', () {
      final s = const PlayHistory([]).series(WatchPeriod.weeks, now: now);
      expect(s.total, 0);
      expect(s.average, 0);
      expect(s.buckets.every((b) => b.plays == 0), isTrue);
    });

    test('UTC timestamps count on their local day', () {
      final play = DateTime(2026, 10, 24, 12).toUtc();
      final s = PlayHistory([play]).series(WatchPeriod.days, now: now);
      expect(s.current.plays, 1);
    });
  });

  group('WatchChartPainter', () {
    test('niceMax rounds up to 1, 2 or 5 times a power of ten', () {
      expect([0, 1, 2, 3, 6, 10, 11, 23, 70, 101].map(WatchChartPainter.niceMax), [1, 1, 2, 5, 10, 10, 20, 50, 100, 200]);
    });

    test('labelStep thins out labels that would overlap', () {
      expect(WatchChartPainter.labelStep(40, 20), 1);
      expect(WatchChartPainter.labelStep(10, 30), 4);
    });

    WatchChartPainter painter({int? selected}) => WatchChartPainter(
      values: const [0, 3, 1],
      axisLabels: const ['Oct 1', 'Oct 2', 'Oct 3'],
      barLabels: const ['Oct 1: No plays', 'Oct 2: 3 plays', 'Oct 3: 1 play'],
      selected: selected,
      barColor: Colors.blue,
      mutedBarColor: Colors.blue.withValues(alpha: 0.5),
      gridColor: Colors.grey,
      labelStyle: const TextStyle(fontSize: 11),
      currentLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
      tooltipColor: Colors.black,
      tooltipStyle: const TextStyle(fontSize: 12, color: Colors.white),
      textScaler: TextScaler.noScaling,
      textDirection: TextDirection.ltr,
    );

    test('paints with a tooltip and gives every bar a semantics label', () {
      const size = Size(300, 180);
      final p = painter(selected: 1);
      final recorder = ui.PictureRecorder();
      p.paint(Canvas(recorder), size);
      recorder.endRecording().dispose();

      final nodes = p.semanticsBuilder(size);
      expect([for (final n in nodes) n.properties.label], ['Oct 1: No plays', 'Oct 2: 3 plays', 'Oct 3: 1 play']);
      expect([for (final n in nodes) n.properties.selected], [false, true, false]);
    });

    test('indexAt finds the bar column under a position', () {
      const size = Size(300, 180);
      final p = painter();
      expect(p.indexAt(const Offset(299, 50), size), 2);
      expect(p.indexAt(const Offset(-5, 50), size), isNull);
      expect(p.shouldRepaint(painter(selected: 2)), isTrue);
      expect(p.shouldRepaint(painter()), isFalse);
    });
  });

  group('WatchChartSection', () {
    Future<void> pump(
      WidgetTester tester,
      PlayHistory? history, {
      ThemeData? theme,
      double textScale = 1,
      Size size = const Size(400, 900),
    }) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(ProviderScope(
        overrides: [
          ...testServer,
          playHistoryProvider.overrideWith((ref) async => history),
        ],
        child: MaterialApp(
          theme: theme,
          home: MediaQuery(
            data: MediaQueryData(size: size, textScaler: TextScaler.linear(textScale)),
            child: Scaffold(body: ListView(children: [WatchChartSection(now: now)])),
          ),
        ),
      ));
      await tester.pumpAndSettle();
    }

    Finder chartPaint() => find.descendant(of: find.byType(WatchChart), matching: find.byType(CustomPaint));
    WatchChartPainter chartPainter(WidgetTester tester) =>
        tester.widget<CustomPaint>(chartPaint()).painter! as WatchChartPainter;

    testWidgets('weeks: total, average and accessible bars; switches to days', (tester) async {
      final semantics = tester.ensureSemantics();
      await pump(tester, history);

      expect(find.text('Watch history'), findsOneWidget);
      expect(find.text('Plays per week'), findsOneWidget);
      expect(find.text('4 plays'), findsOneWidget);
      expect(find.text('0.3 per week'), findsOneWidget);
      // The default (English) Material localizations start weeks on Sunday.
      expect(find.bySemanticsLabel(RegExp('^3 plays this week, 0.3 on average')), findsOneWidget);
      expect(find.semantics.byLabel('Week of Oct 18: 3 plays'), findsOne);
      expect(find.semantics.byLabel('Week of Aug 2: No plays'), findsOne);
      expect(chartPainter(tester).values, hasLength(12));

      await tester.tap(find.text('30 days'));
      await tester.pumpAndSettle();
      expect(find.text('Plays per day'), findsOneWidget);
      expect(find.text('0.1 per day'), findsOneWidget);
      expect(find.bySemanticsLabel(RegExp('^1 play today, 0.1 on average')), findsOneWidget);
      expect(find.semantics.byLabel('Oct 24: 1 play'), findsOne);
      expect(chartPainter(tester).values, hasLength(30));
      semantics.dispose();
    });

    testWidgets('tapping a bar selects it for the tooltip, tapping again hides it', (tester) async {
      await pump(tester, history);
      final rect = tester.getRect(chartPaint());
      await tester.tapAt(Offset(rect.right - 2, rect.center.dy));
      await tester.pump();
      expect(chartPainter(tester).selected, 11);
      await tester.tapAt(Offset(rect.right - 2, rect.center.dy));
      await tester.pump();
      expect(chartPainter(tester).selected, isNull);

      await tester.longPressAt(Offset(rect.right - 2, rect.center.dy));
      await tester.pump();
      expect(chartPainter(tester).selected, 11);
    });

    testWidgets('bars use the accent in dark mode too', (tester) async {
      final dark = ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal, brightness: Brightness.dark));
      await pump(tester, history, theme: dark);
      expect(chartPainter(tester).barColor, dark.colorScheme.primary);
    });

    testWidgets('empty state without plays in the period', (tester) async {
      await pump(tester, const PlayHistory([]));
      expect(find.text('No plays in this period'), findsOneWidget);
      expect(find.byType(WatchChart), findsNothing);
    });

    testWidgets('hidden on servers without play history', (tester) async {
      await pump(tester, null);
      expect(find.text('Watch history'), findsNothing);
    });

    testWidgets('notes when only the most recently played scenes were read', (tester) async {
      await pump(tester, PlayHistory(history.plays, truncated: true));
      expect(find.textContaining('Based on the 1,000 most recently played scenes.'), findsOneWidget);
    });

    testWidgets('lays out at 2x text and on a tablet', (tester) async {
      await pump(tester, history, textScale: 2, size: const Size(360, 1200));
      expect(tester.takeException(), isNull);
      await pump(tester, history, size: const Size(1024, 768));
      expect(tester.takeException(), isNull);
      expect(tester.getSize(chartPaint()).width, greaterThan(900));
    });
  });

  testWidgets('the stats tab hides the chart when the server has no play history', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(ProviderScope(
      overrides: [
        ...testServer,
        sharedPreferencesProvider.overrideWithValue(prefs),
        serverVersionProvider.overrideWith((ref) async => '0.24.0'),
        libraryStatsProvider.overrideWith((ref) async => const LibraryStats(sceneCount: 3)),
        activityStatsProvider.overrideWith((ref) async => null),
        playHistoryProvider.overrideWith((ref) async => null),
      ],
      child: const MaterialApp(home: Scaffold(body: StatsTab())),
    ));
    await tester.pumpAndSettle();
    expect(find.text('Library'), findsWidgets);
    expect(find.byType(WatchChartSection), findsOneWidget);
    expect(find.text('Watch history'), findsNothing);
  });
}
