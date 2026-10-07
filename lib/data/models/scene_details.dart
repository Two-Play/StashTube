import '../../core/api/documents/scenes.graphql.dart';
import 'json.dart';

/// One playable endpoint from `sceneStreams` (direct file or a transcode).
class SceneStream {
  const SceneStream({required this.url, required this.label, this.mimeType});

  final String url;

  /// As named by Stash, e.g. "Direct stream", "HLS 720p".
  final String label;
  final String? mimeType;

  factory SceneStream.fromGraphql(Query$FindSceneDetails$findScene$sceneStreams s) =>
      SceneStream(url: s.url, label: nonEmpty(s.label) ?? 'Stream', mimeType: nonEmpty(s.mime_type));

  bool get isHls => mimeType?.contains('mpegurl') ?? label.toUpperCase().startsWith('HLS');
  bool get isDirect => label.toLowerCase().startsWith('direct');

  /// The transcode's format as the label names it: "HLS", "MP4", ...
  String get format => streamFormatOf(label);

  /// The transcode's height, from Stash's `resolution` URL parameter or
  /// else the label; null for the original file or when unknown.
  int? get height {
    if (isDirect) return null;
    final resolution = Uri.tryParse(url)?.queryParameters['resolution'];
    return _resolutionHeights[resolution] ?? streamHeightOf(label);
  }

  static const _resolutionHeights = {
    'LOW': 240,
    'STANDARD': 480,
    'STANDARD_HD': 720,
    'FULL_HD': 1080,
    'FOUR_K': 2160,
  };
}

String streamFormatOf(String label) => label.trim().split(' ').first.toUpperCase();

/// "HLS Standard HD (720p)" → 720, "MP4 4k" → 2160; null without a height.
int? streamHeightOf(String label) {
  if (RegExp(r'\b4k\b', caseSensitive: false).hasMatch(label)) return 2160;
  final match = RegExp(r'(\d{3,4})p\b').firstMatch(label);
  return match == null ? null : int.parse(match.group(1)!);
}

/// The stream to play for the preferred stream label (the player's ⚙ or the
/// settings): that exact stream, else the same format at the preferred
/// height, else the next lower one. Null means the original file: also when
/// every transcode is smaller than preferred, as the original is then no
/// larger than wanted.
SceneStream? pickPreferredStream(List<SceneStream> streams, String preferred) {
  final exact = streams.where((s) => s.label == preferred).firstOrNull;
  if (exact != null) return exact;
  final want = streamHeightOf(preferred);
  if (want == null) return null;
  final format = streamFormatOf(preferred);
  final candidates = [
    for (final s in streams)
      if (!s.isDirect && s.format == format && s.height != null) s,
  ]..sort((a, b) => b.height!.compareTo(a.height!));
  if (candidates.isEmpty || candidates.first.height! < want) return null;
  return candidates.where((s) => s.height! <= want).firstOrNull;
}

/// A scene marker, shown as a chapter.
class SceneMarker {
  const SceneMarker({required this.id, required this.title, required this.seconds});

  final String id;
  final String title;
  final double seconds;

  factory SceneMarker.fromFields(Fragment$MarkerFields m) => SceneMarker(
        id: m.id,
        title: nonEmpty(m.title) ?? nonEmpty(m.primary_tag.name) ?? 'Marker',
        seconds: m.seconds,
      );
}

/// A video file of a scene, as Stash's scan reports it.
class SceneFile {
  const SceneFile({
    required this.path,
    this.size,
    this.format,
    this.width,
    this.height,
    this.duration,
    this.videoCodec,
    this.audioCodec,
    this.frameRate,
    this.bitRate,
    this.modified,
  });

  final String path;

  /// Bytes.
  final double? size;

  /// Container, e.g. "mp4".
  final String? format;
  final int? width;
  final int? height;

  /// Seconds.
  final double? duration;
  final String? videoCodec;
  final String? audioCodec;
  final double? frameRate;

  /// Bits per second.
  final int? bitRate;
  final DateTime? modified;

  /// Unknown values (Stash reports 0 or "") become null.
  factory SceneFile.fromGraphql(Query$FindSceneDetails$findScene$files f) {
    T? positive<T extends num>(T v) => v > 0 ? v : null;
    return SceneFile(
      path: f.path,
      size: positive(f.size)?.toDouble(),
      format: nonEmpty(f.format)?.trim(),
      width: positive(f.width),
      height: positive(f.height),
      duration: positive(f.duration),
      videoCodec: nonEmpty(f.video_codec)?.trim(),
      audioCodec: nonEmpty(f.audio_codec)?.trim(),
      frameRate: positive(f.frame_rate),
      bitRate: positive(f.bit_rate),
      modified: parseDate(f.mod_time),
    );
  }

  /// File name without the folders (Stash paths may use either separator).
  String get name => path.split(RegExp(r'[/\\]')).last;
}

/// Per-scene data that is only needed while the scene is playing.
class SceneDetails {
  const SceneDetails({
    this.streams = const [],
    this.markers = const [],
    this.files = const [],
    this.spriteUrl,
    this.vttUrl,
  });

  final List<SceneStream> streams;

  /// The scene's files; the first is the one that plays.
  final List<SceneFile> files;

  /// Sorted by position.
  final List<SceneMarker> markers;

  /// Seek preview thumbnails: one sprite image plus a WebVTT file mapping
  /// time ranges to regions of it. Null when Stash hasn't generated them.
  final String? spriteUrl;
  final String? vttUrl;

  factory SceneDetails.fromGraphql(Query$FindSceneDetails$findScene s) => SceneDetails(
        spriteUrl: nonEmpty(s.paths.sprite),
        vttUrl: nonEmpty(s.paths.vtt),
        streams: [
          for (final stream in s.sceneStreams)
            if (stream.url.isNotEmpty) SceneStream.fromGraphql(stream),
        ],
        markers: [for (final m in s.scene_markers) SceneMarker.fromFields(m)]
          ..sort((a, b) => a.seconds.compareTo(b.seconds)),
        files: [
          for (final f in s.files)
            if (f.path.isNotEmpty) SceneFile.fromGraphql(f),
        ],
      );

  /// The chapter that contains [seconds], if any.
  SceneMarker? markerAt(double seconds) {
    SceneMarker? current;
    for (final m in markers) {
      if (m.seconds > seconds) break;
      current = m;
    }
    return current;
  }
}
