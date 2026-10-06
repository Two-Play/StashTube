import 'json.dart';

/// One playable endpoint from `sceneStreams` (direct file or a transcode).
class SceneStream {
  const SceneStream({required this.url, required this.label, this.mimeType});

  final String url;

  /// As named by Stash, e.g. "Direct stream", "HLS 720p".
  final String label;
  final String? mimeType;

  factory SceneStream.fromJson(Json json) => SceneStream(
        url: readString(json, 'url'),
        label: readString(json, 'label', 'Stream'),
        mimeType: readNullableString(json, 'mime_type'),
      );

  bool get isHls => mimeType?.contains('mpegurl') ?? label.toUpperCase().startsWith('HLS');
  bool get isDirect => label.toLowerCase().startsWith('direct');
}

/// A scene marker, shown as a chapter.
class SceneMarker {
  const SceneMarker({required this.id, required this.title, required this.seconds});

  final String id;
  final String title;
  final double seconds;

  factory SceneMarker.fromJson(Json json) {
    final title = readNullableString(json, 'title') ??
        readNullableString(readObject(json, 'primary_tag') ?? const {}, 'name') ??
        'Marker';
    return SceneMarker(id: readString(json, 'id'), title: title, seconds: readDouble(json, 'seconds'));
  }
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

  factory SceneFile.fromJson(Json json) {
    double? positive(String key) {
      final v = readDouble(json, key);
      return v > 0 ? v : null;
    }

    int? positiveInt(String key) {
      final v = readNullableInt(json, key);
      return v != null && v > 0 ? v : null;
    }

    String? text(String key) {
      final v = readNullableString(json, key)?.trim();
      return v == null || v.isEmpty ? null : v;
    }

    return SceneFile(
      path: readString(json, 'path'),
      size: positive('size'),
      format: text('format'),
      width: positiveInt('width'),
      height: positiveInt('height'),
      duration: positive('duration'),
      videoCodec: text('video_codec'),
      audioCodec: text('audio_codec'),
      frameRate: positive('frame_rate'),
      bitRate: positiveInt('bit_rate'),
      modified: readDate(json, 'mod_time'),
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

  factory SceneDetails.fromJson(Json json) => SceneDetails(
        spriteUrl: readNullableString(readObject(json, 'paths') ?? const {}, 'sprite'),
        vttUrl: readNullableString(readObject(json, 'paths') ?? const {}, 'vtt'),
        streams: readList(json, 'sceneStreams').map(SceneStream.fromJson).where((s) => s.url.isNotEmpty).toList(),
        markers: readList(json, 'scene_markers').map(SceneMarker.fromJson).toList()
          ..sort((a, b) => a.seconds.compareTo(b.seconds)),
        files: readList(json, 'files').map(SceneFile.fromJson).where((f) => f.path.isNotEmpty).toList(),
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
