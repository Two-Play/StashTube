import 'json.dart';
import 'scene.dart';
import 'tag.dart';
import '../../core/api/documents/scenes.graphql.dart';

/// A scene marker on the markers page: a marked moment of a scene, with
/// its scene so it can be played from there.
class Marker {
  const Marker({
    required this.id,
    required this.title,
    required this.seconds,
    required this.tag,
    required this.scene,
    this.endSeconds,
    this.screenshotUrl,
    this.previewUrl,
  });

  final String id;

  /// The marker's title, or its tag's name when it has none.
  final String title;
  final double seconds;
  final double? endSeconds;
  final Tag tag;
  final Scene scene;

  /// The frame at the marker.
  final String? screenshotUrl;

  /// A short looping clip from the marker (animated WebP), if Stash has
  /// generated it.
  final String? previewUrl;

  factory Marker.fromGraphql(Query$FindSceneMarkers$findSceneMarkers$scene_markers m) {
    final tag = Tag.fromRef(m.primary_tag);
    return Marker(
      id: m.id,
      title: nonEmpty(m.title) ?? tag.name,
      seconds: m.seconds,
      endSeconds: m.end_seconds,
      tag: tag,
      scene: Scene.fromFields(m.scene),
      screenshotUrl: nonEmpty(m.screenshot),
      previewUrl: nonEmpty(m.preview),
    );
  }
}
