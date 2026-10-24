import 'dart:math' as math;

import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' show NumberFormat;

import '../../core/config/design_tokens.dart';
import '../../core/config/haptics.dart';
import '../../data/models/watch_history.dart';
import '../../data/providers.dart';
import '../../l10n/l10n.dart';

/// Plays per week (last 12 weeks) or per day (last 30 days) as a bar chart
/// with the total and the average (16.3). Built from Stash's play history;
/// hidden on servers without one (older Stash) and while it loads.
class WatchChartSection extends ConsumerStatefulWidget {
  const WatchChartSection({super.key, this.now});

  /// The current time; tests pin it.
  final DateTime? now;

  @override
  ConsumerState<WatchChartSection> createState() => _WatchChartSectionState();
}

class _WatchChartSectionState extends ConsumerState<WatchChartSection> {
  var _period = WatchPeriod.weeks;

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(playHistoryProvider).value;
    if (history == null) return const SizedBox.shrink();

    final l = context.l10n;
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final locale = l.localeName;
    final material = MaterialLocalizations.of(context);
    final firstDay = material.firstDayOfWeekIndex;
    final series = history.series(
      _period,
      now: widget.now ?? DateTime.now(),
      firstWeekday: firstDay == 0 ? DateTime.sunday : firstDay,
    );
    final weeks = _period == WatchPeriod.weeks;
    final average = NumberFormat('#,##0.#', locale).format(series.average);

    String periodName(WatchBucket b) => weeks ? l.statsChartWeekOf(material.formatShortMonthDay(b.start)) : material.formatShortMonthDay(b.start);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.xs, AppSpacing.l, AppSpacing.xs, AppSpacing.s),
          child: Text(
            l.statsWatchHistory,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(AppSpacing.m + 2),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: AppRadius.cardBorder,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SegmentedButton<WatchPeriod>(
                segments: [
                  ButtonSegment(value: WatchPeriod.weeks, label: Text(l.statsChartWeeks)),
                  ButtonSegment(value: WatchPeriod.days, label: Text(l.statsChartDays)),
                ],
                selected: {_period},
                showSelectedIcon: false,
                onSelectionChanged: (selection) {
                  Haptics.selection();
                  setState(() => _period = selection.single);
                },
              ),
              const SizedBox(height: AppSpacing.m),
              Wrap(
                spacing: AppSpacing.xl,
                runSpacing: AppSpacing.s,
                children: [
                  _Figure(label: l.statsChartTotal, value: l.playsCount(series.total)),
                  _Figure(
                    label: l.statsChartAverage,
                    value: weeks ? l.statsAveragePerWeek(average) : l.statsAveragePerDay(average),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.m),
              Text(weeks ? l.statsPlaysPerWeek : l.statsPlaysPerDay, style: theme.textTheme.labelLarge?.copyWith(color: muted)),
              const SizedBox(height: AppSpacing.s),
              if (series.total == 0)
                _EmptyChart(message: l.statsChartEmpty)
              else
                WatchChart(
                  key: ValueKey(_period),
                  values: [for (final b in series.buckets) b.plays],
                  axisLabels: [for (final b in series.buckets) material.formatShortMonthDay(b.start)],
                  barLabels: [
                    for (final b in series.buckets) l.statsChartBar(periodName(b), l.playsCount(b.plays)),
                  ],
                  summary: weeks
                      ? l.statsChartSummaryWeek(series.current.plays, average)
                      : l.statsChartSummaryDay(series.current.plays, average),
                ),
              const SizedBox(height: AppSpacing.s),
              Text(
                [l.statsChartPlaysNote, if (history.truncated) l.statsChartTruncated(PlayHistory.maxScenes)].join(' '),
                style: theme.textTheme.bodySmall?.copyWith(color: muted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Figure extends StatelessWidget {
  const _Figure({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: '$label: $value',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          Text(value, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _EmptyChart extends StatelessWidget {
  const _EmptyChart({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Column(
        children: [
          Icon(Icons.bar_chart, size: 40, color: muted),
          const SizedBox(height: AppSpacing.s),
          Text(message, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium?.copyWith(color: muted)),
        ],
      ),
    );
  }
}

/// A bar per value, the last one (this week or today) highlighted. Tapping
/// or long-pressing a bar shows its [barLabels] entry above it; screen
/// readers get [summary] and a node per bar.
class WatchChart extends StatefulWidget {
  const WatchChart({
    super.key,
    required this.values,
    required this.axisLabels,
    required this.barLabels,
    required this.summary,
  });

  final List<int> values;

  /// Short labels under the bars; thinned out where they would overlap.
  final List<String> axisLabels;

  /// A bar's value with its period, for the tooltip and screen readers.
  final List<String> barLabels;
  final String summary;

  @override
  State<WatchChart> createState() => _WatchChartState();
}

class _WatchChartState extends State<WatchChart> {
  int? _selected;

  void _select(int? index) {
    if (index == _selected) return;
    if (index != null) Haptics.selection();
    setState(() => _selected = index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final textScaler = MediaQuery.textScalerOf(context);
    final labelStyle = (theme.textTheme.labelSmall ?? const TextStyle(fontSize: 11)).copyWith(color: scheme.onSurfaceVariant);
    final painter = WatchChartPainter(
      values: widget.values,
      axisLabels: widget.axisLabels,
      barLabels: widget.barLabels,
      selected: _selected,
      barColor: scheme.primary,
      mutedBarColor: scheme.primary.withValues(alpha: 0.55),
      gridColor: scheme.outlineVariant,
      labelStyle: labelStyle,
      currentLabelStyle: labelStyle.copyWith(color: scheme.primary, fontWeight: FontWeight.w700),
      tooltipColor: scheme.inverseSurface,
      tooltipStyle: (theme.textTheme.labelMedium ?? const TextStyle(fontSize: 12)).copyWith(color: scheme.onInverseSurface),
      textScaler: textScaler,
      textDirection: Directionality.of(context),
    );
    final height = 140 + textScaler.scale(labelStyle.fontSize ?? 11) * 4;

    return Semantics(
      container: true,
      label: widget.summary,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapUp: (d) {
          final index = painter.indexAt(d.localPosition, context.size!);
          _select(index == _selected ? null : index);
        },
        onLongPressStart: (d) => _select(painter.indexAt(d.localPosition, context.size!)),
        onLongPressMoveUpdate: (d) => _select(painter.indexAt(d.localPosition, context.size!)),
        child: CustomPaint(
          painter: painter,
          size: Size(double.infinity, height),
        ),
      ),
    );
  }
}

/// Paints [WatchChart]: bars from a zero line, a y axis with zero and a
/// round maximum, x labels and the selected bar's tooltip.
class WatchChartPainter extends CustomPainter {
  WatchChartPainter({
    required this.values,
    required this.axisLabels,
    required this.barLabels,
    required this.selected,
    required this.barColor,
    required this.mutedBarColor,
    required this.gridColor,
    required this.labelStyle,
    required this.currentLabelStyle,
    required this.tooltipColor,
    required this.tooltipStyle,
    required this.textScaler,
    required this.textDirection,
  });

  final List<int> values;
  final List<String> axisLabels;
  final List<String> barLabels;
  final int? selected;
  final Color barColor;
  final Color mutedBarColor;
  final Color gridColor;
  final TextStyle labelStyle;
  final TextStyle currentLabelStyle;
  final Color tooltipColor;
  final TextStyle tooltipStyle;
  final TextScaler textScaler;
  final TextDirection textDirection;

  static const _gap = 4.0;
  static const _maxBarWidth = 28.0;

  /// The y axis' top value: the largest value rounded up to 1, 2 or 5
  /// times a power of ten (at least 1).
  static int niceMax(int max) {
    if (max <= 1) return 1;
    var magnitude = 1;
    while (magnitude * 10 <= max) {
      magnitude *= 10;
    }
    for (final step in [1, 2, 5, 10]) {
      if (step * magnitude >= max) return step * magnitude;
    }
    return 10 * magnitude;
  }

  /// Which labels show under the bars: every [step]th, counted back from
  /// the last, so the current one always shows.
  static int labelStep(double slot, double labelWidth) => math.max(1, ((labelWidth + 6) / slot).ceil());

  int get _top => niceMax(values.fold<int>(0, math.max));

  TextPainter _text(String text, TextStyle style, {double maxWidth = double.infinity}) => TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: textDirection,
    textScaler: textScaler,
  )..layout(maxWidth: maxWidth);

  /// The bars' area within [size].
  Rect _plot(Size size) {
    final axis = _text('$_top', labelStyle).width + _gap * 2;
    final label = _text('0', labelStyle).height;
    return Rect.fromLTRB(axis, label / 2, size.width, size.height - label - _gap);
  }

  double _slot(Rect plot) => plot.width / values.length;

  Rect _bar(Rect plot, int i) {
    final slot = _slot(plot);
    final width = math.min(slot * 0.65, _maxBarWidth);
    final height = plot.height * values[i] / _top;
    final center = plot.left + slot * (i + 0.5);
    return Rect.fromLTRB(center - width / 2, plot.bottom - height, center + width / 2, plot.bottom);
  }

  /// The bar under [position], or null outside the bars' columns.
  int? indexAt(Offset position, Size size) {
    if (values.isEmpty) return null;
    final plot = _plot(size);
    if (position.dx < plot.left || position.dx > plot.right) return null;
    return ((position.dx - plot.left) / _slot(plot)).floor().clamp(0, values.length - 1);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final plot = _plot(size);
    final top = _top;

    // Grid: zero, half (when a whole number) and the top.
    final grid = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    for (final v in {0, if (top.isEven) top ~/ 2, top}) {
      final y = plot.bottom - plot.height * v / top;
      canvas.drawLine(Offset(plot.left, y), Offset(plot.right, y), grid);
      final label = _text('$v', labelStyle);
      label.paint(canvas, Offset(plot.left - _gap - label.width, y - label.height / 2));
    }

    // Bars, the current (last) and the selected one in full color.
    final last = values.length - 1;
    for (var i = 0; i < values.length; i++) {
      if (values[i] == 0) continue;
      final rect = _bar(plot, i);
      final radius = Radius.circular(math.min(4, rect.width / 2));
      canvas.drawRRect(
        RRect.fromRectAndCorners(rect, topLeft: radius, topRight: radius),
        Paint()..color = i == last || i == selected ? barColor : mutedBarColor,
      );
    }

    // X labels, thinned out so they don't overlap.
    final slot = _slot(plot);
    final widest = axisLabels.fold<double>(0, (w, l) => math.max(w, _text(l, currentLabelStyle).width));
    final step = labelStep(slot, widest);
    for (var i = last; i >= 0; i -= step) {
      final label = _text(axisLabels[i], i == last ? currentLabelStyle : labelStyle);
      final x = (plot.left + slot * (i + 0.5) - label.width / 2).clamp(0.0, math.max(0.0, size.width - label.width)).toDouble();
      label.paint(canvas, Offset(x, plot.bottom + _gap));
    }

    // Tooltip above the selected bar, kept inside the chart.
    if (selected case final i? when i >= 0 && i < values.length) {
      final text = _text(barLabels[i], tooltipStyle, maxWidth: size.width - 16);
      final box = Size(text.width + 16, text.height + 8);
      final bar = _bar(plot, i);
      final left = (bar.center.dx - box.width / 2).clamp(0.0, math.max(0.0, size.width - box.width)).toDouble();
      final topY = math.max(0.0, bar.top - box.height - _gap);
      final rect = Offset(left, topY) & box;
      canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(AppRadius.badge)), Paint()..color = tooltipColor);
      text.paint(canvas, rect.topLeft + const Offset(8, 4));
    }
  }

  @override
  SemanticsBuilderCallback get semanticsBuilder => (size) {
    if (values.isEmpty) return const [];
    final plot = _plot(size);
    final slot = _slot(plot);
    return [
      for (var i = 0; i < values.length; i++)
        CustomPainterSemantics(
          key: ValueKey(i),
          rect: Rect.fromLTWH(plot.left + slot * i, 0, slot, size.height),
          properties: SemanticsProperties(
            label: barLabels[i],
            textDirection: textDirection,
            selected: i == selected,
          ),
        ),
    ];
  };

  @override
  bool shouldRebuildSemantics(WatchChartPainter oldDelegate) =>
      !listEquals(oldDelegate.barLabels, barLabels) || oldDelegate.selected != selected || oldDelegate.textScaler != textScaler;

  @override
  bool shouldRepaint(WatchChartPainter oldDelegate) =>
      !listEquals(oldDelegate.values, values) ||
      !listEquals(oldDelegate.axisLabels, axisLabels) ||
      !listEquals(oldDelegate.barLabels, barLabels) ||
      oldDelegate.selected != selected ||
      oldDelegate.barColor != barColor ||
      oldDelegate.mutedBarColor != mutedBarColor ||
      oldDelegate.gridColor != gridColor ||
      oldDelegate.labelStyle != labelStyle ||
      oldDelegate.currentLabelStyle != currentLabelStyle ||
      oldDelegate.tooltipColor != tooltipColor ||
      oldDelegate.tooltipStyle != tooltipStyle ||
      oldDelegate.textScaler != textScaler ||
      oldDelegate.textDirection != textDirection;
}
