/// `12:34` or `1:02:03`, like YouTube duration badges.
String formatDuration(double seconds) {
  final total = seconds.isFinite && seconds > 0 ? seconds.round() : 0;
  final h = total ~/ 3600;
  final m = (total % 3600) ~/ 60;
  final s = (total % 60).toString().padLeft(2, '0');
  return h > 0 ? '$h:${m.toString().padLeft(2, '0')}:$s' : '$m:$s';
}

/// `3 days ago`, `2 years ago`, ... relative to [now].
String formatTimeAgo(DateTime date, DateTime now) {
  final diff = now.difference(date);
  if (diff.isNegative) return 'upcoming';

  String plural(int n, String unit) => '$n $unit${n == 1 ? '' : 's'} ago';

  if (diff.inDays >= 365) return plural(diff.inDays ~/ 365, 'year');
  if (diff.inDays >= 30) return plural(diff.inDays ~/ 30, 'month');
  if (diff.inDays >= 7) return plural(diff.inDays ~/ 7, 'week');
  if (diff.inDays >= 1) return plural(diff.inDays, 'day');
  if (diff.inHours >= 1) return plural(diff.inHours, 'hour');
  if (diff.inMinutes >= 1) return plural(diff.inMinutes, 'minute');
  return 'just now';
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

String formatCount(int n, String unit) => '$n $unit${n == 1 ? '' : 's'}';
