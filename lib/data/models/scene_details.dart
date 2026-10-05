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

/// Per-scene data that is only needed while the scene is playing.
class SceneDetails {
  const SceneDetails({this.streams = const [], this.markers = const []});

  final List<SceneStream> streams;

  /// Sorted by position.
  final List<SceneMarker> markers;

  factory SceneDetails.fromJson(Json json) => SceneDetails(
        streams: readList(json, 'sceneStreams').map(SceneStream.fromJson).where((s) => s.url.isNotEmpty).toList(),
        markers: readList(json, 'scene_markers').map(SceneMarker.fromJson).toList()
          ..sort((a, b) => a.seconds.compareTo(b.seconds)),
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
