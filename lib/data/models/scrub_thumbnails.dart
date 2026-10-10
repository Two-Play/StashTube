/// One preview frame: a region of the sprite image shown for a time range.
class ScrubCue {
  const ScrubCue({
    required this.start,
    required this.end,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  /// Seconds.
  final double start;
  final double end;

  /// Region inside the sprite, in image pixels.
  final double x;
  final double y;
  final double width;
  final double height;
}

/// Seek preview thumbnails parsed from Stash's sprite WebVTT, e.g.
///
/// ```
/// WEBVTT
///
/// 00:00:00.000 --> 00:00:05.000
/// abc_sprite.jpg#xywh=0,0,160,90
/// ```
class ScrubThumbnails {
  const ScrubThumbnails({required this.spriteUrl, required this.cues});

  final String spriteUrl;

  /// Sorted by start time.
  final List<ScrubCue> cues;

  static final _cueLine = RegExp(r'([\d:.]+)\s*-->\s*([\d:.]+)');
  static final _region = RegExp(r'#xywh=(\d+(?:\.\d+)?),(\d+(?:\.\d+)?),(\d+(?:\.\d+)?),(\d+(?:\.\d+)?)');

  /// Parses [vtt]. The sprite file named in the cues is ignored in favor of
  /// [spriteUrl] (Stash uses one sprite per scene); when [spriteUrl] is null,
  /// the name is resolved against [vttUrl].
  static ScrubThumbnails? parse(String vtt, {String? spriteUrl, required String vttUrl}) {
    final lines = vtt.split(RegExp(r'\r?\n'));
    final cues = <ScrubCue>[];
    String? fileName;

    for (var i = 0; i < lines.length - 1; i++) {
      final times = _cueLine.firstMatch(lines[i]);
      if (times == null) continue;
      final target = lines[i + 1].trim();
      final region = _region.firstMatch(target);
      final start = parseTimestamp(times.group(1)!);
      final end = parseTimestamp(times.group(2)!);
      if (region == null || start == null || end == null) continue;
      final width = double.parse(region.group(3)!);
      final height = double.parse(region.group(4)!);
      // An empty region can't be shown (and would divide by zero when scaled).
      if (width <= 0 || height <= 0) continue;

      fileName ??= target.substring(0, target.indexOf('#'));
      cues.add(ScrubCue(
        start: start,
        end: end,
        x: double.parse(region.group(1)!),
        y: double.parse(region.group(2)!),
        width: width,
        height: height,
      ));
    }
    if (cues.isEmpty) return null;

    final url = spriteUrl ?? (fileName == null ? null : Uri.parse(vttUrl).resolve(fileName).toString());
    if (url == null) return null;
    cues.sort((a, b) => a.start.compareTo(b.start));
    return ScrubThumbnails(spriteUrl: url, cues: cues);
  }

  /// `HH:MM:SS.mmm` or `MM:SS.mmm` to seconds.
  static double? parseTimestamp(String value) {
    final parts = value.split(':');
    if (parts.length < 2 || parts.length > 3) return null;
    var seconds = 0.0;
    for (final part in parts) {
      final n = double.tryParse(part);
      if (n == null) return null;
      seconds = seconds * 60 + n;
    }
    return seconds;
  }

  /// The frame to show at [seconds] (the last cue starting at or before it).
  ScrubCue cueAt(double seconds) {
    var low = 0;
    var high = cues.length - 1;
    while (low < high) {
      final mid = (low + high + 1) ~/ 2;
      if (cues[mid].start <= seconds) {
        low = mid;
      } else {
        high = mid - 1;
      }
    }
    return cues[low];
  }
}
