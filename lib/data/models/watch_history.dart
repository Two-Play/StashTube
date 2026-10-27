/// The span the stats' watch chart shows (16.3).
enum WatchPeriod {
  /// The last 12 weeks, one bar per week.
  weeks(12),

  /// The last 30 days, one bar per day.
  days(30);

  const WatchPeriod(this.bucketCount);

  final int bucketCount;
}

/// One bar of the watch chart: the plays in the week or day from [start].
class WatchBucket {
  const WatchBucket(this.start, this.plays);

  /// Local midnight of the bucket's first day.
  final DateTime start;
  final int plays;

  @override
  bool operator ==(Object other) => other is WatchBucket && other.start == start && other.plays == plays;

  @override
  int get hashCode => Object.hash(start, plays);

  @override
  String toString() => 'WatchBucket($start, $plays)';
}

/// The plays per week or day, oldest first; the last bucket is the current
/// week or today.
class WatchSeries {
  const WatchSeries(this.period, this.buckets);

  final WatchPeriod period;
  final List<WatchBucket> buckets;

  int get total => buckets.fold(0, (sum, b) => sum + b.plays);

  /// Plays per bucket over the whole span, the empty ones included.
  double get average => buckets.isEmpty ? 0 : total / buckets.length;

  WatchBucket get current => buckets.last;
}

/// When the played scenes were played, from Stash's `play_history`
/// (newer Stash versions only). Stash keeps the watch time per scene, not
/// per play, so the chart counts plays.
class PlayHistory {
  const PlayHistory(this.plays, {this.truncated = false});

  /// How many days back the history is loaded; covers both periods.
  static const windowDays = 90;

  /// At most this many played scenes are read (most recently played first).
  static const maxScenes = 1000;

  /// Local times of the plays within [windowDays].
  final List<DateTime> plays;

  /// Whether more played scenes had plays in the window than were read.
  final bool truncated;

  /// The plays bucketed by [period], ending with the week or day of [now].
  /// Weeks start on [firstWeekday] (`DateTime.monday` ... `DateTime.sunday`).
  /// Plays after [now] or before the first bucket are left out.
  WatchSeries series(WatchPeriod period, {required DateTime now, int firstWeekday = DateTime.monday}) {
    final today = _day(now);
    final n = period.bucketCount;
    final DateTime currentStart;
    final int bucketDays;
    switch (period) {
      case WatchPeriod.weeks:
        currentStart = _weekStart(today, firstWeekday);
        bucketDays = 7;
      case WatchPeriod.days:
        currentStart = today;
        bucketDays = 1;
    }
    final counts = List.filled(n, 0);
    for (final play in plays) {
      final day = _day(play);
      if (day.isAfter(today)) continue;
      final start = period == WatchPeriod.weeks ? _weekStart(day, firstWeekday) : day;
      final index = n - 1 - _daysBetween(start, currentStart) ~/ bucketDays;
      if (index >= 0 && index < n) counts[index]++;
    }
    return WatchSeries(period, [
      for (var i = 0; i < n; i++)
        WatchBucket(
          DateTime(currentStart.year, currentStart.month, currentStart.day - (n - 1 - i) * bucketDays),
          counts[i],
        ),
    ]);
  }

  static DateTime _day(DateTime t) {
    final local = t.toLocal();
    return DateTime(local.year, local.month, local.day);
  }

  static DateTime _weekStart(DateTime day, int firstWeekday) =>
      DateTime(day.year, day.month, day.day - (day.weekday - firstWeekday) % 7);

  /// Calendar days from [a] to [b], unaffected by daylight saving changes.
  static int _daysBetween(DateTime a, DateTime b) =>
      DateTime.utc(b.year, b.month, b.day).difference(DateTime.utc(a.year, a.month, a.day)).inDays;
}
