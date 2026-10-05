import '../../l10n/l10n.dart';

/// `12:34` or `1:02:03`, like YouTube duration badges.
String formatDuration(double seconds) {
  final total = seconds.isFinite && seconds > 0 ? seconds.round() : 0;
  final h = total ~/ 3600;
  final m = (total % 3600) ~/ 60;
  final s = (total % 60).toString().padLeft(2, '0');
  return h > 0 ? '$h:${m.toString().padLeft(2, '0')}:$s' : '$m:$s';
}

/// `3 days ago`, `2 years ago`, ... relative to [now].
String formatTimeAgo(AppLocalizations l, DateTime date, DateTime now) {
  final diff = now.difference(date);
  if (diff.isNegative) return l.timeUpcoming;
  if (diff.inDays >= 365) return l.timeYearsAgo(diff.inDays ~/ 365);
  if (diff.inDays >= 30) return l.timeMonthsAgo(diff.inDays ~/ 30);
  if (diff.inDays >= 7) return l.timeWeeksAgo(diff.inDays ~/ 7);
  if (diff.inDays >= 1) return l.timeDaysAgo(diff.inDays);
  if (diff.inHours >= 1) return l.timeHoursAgo(diff.inHours);
  if (diff.inMinutes >= 1) return l.timeMinutesAgo(diff.inMinutes);
  return l.timeJustNow;
}

/// `2024-01-31`
String formatDate(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

/// `4K`, `1080p`, ... from the video height; null when unknown.
String? resolutionLabel(int? height) {
  if (height == null || height <= 0) return null;
  if (height >= 2160) return '4K';
  if (height >= 1440) return '1440p';
  if (height >= 1080) return '1080p';
  if (height >= 720) return '720p';
  if (height >= 480) return '480p';
  return '${height}p';
}

/// `1.2 TB`, `340 MB`, ... (binary units, as Stash shows them).
String formatBytes(double bytes) {
  const units = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];
  var value = bytes < 0 ? 0.0 : bytes;
  var unit = 0;
  while (value >= 1024 && unit < units.length - 1) {
    value /= 1024;
    unit++;
  }
  final digits = unit == 0 || value >= 100 ? 0 : 1;
  return '${value.toStringAsFixed(digits)} ${units[unit]}';
}

/// `3d 4h`, `5h 12m`, `42m` for long totals like library duration.
String formatLongDuration(double seconds) {
  final total = seconds.isFinite && seconds > 0 ? seconds.round() : 0;
  final d = total ~/ 86400;
  final h = (total % 86400) ~/ 3600;
  final m = (total % 3600) ~/ 60;
  if (d > 0) return '${d}d ${h}h';
  if (h > 0) return '${h}h ${m}m';
  return '${m}m';
}

/// `12,345` with thousands separators.
String formatNumber(int n) {
  final s = n.abs().toString();
  final buffer = StringBuffer(n < 0 ? '-' : '');
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buffer.write(',');
    buffer.write(s[i]);
  }
  return buffer.toString();
}
