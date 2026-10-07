import 'json.dart';
import '../../core/api/documents/refs.graphql.dart';
import '../../core/api/documents/studios.graphql.dart';

class Studio {
  const Studio({
    required this.id,
    required this.name,
    this.imageUrl,
    this.url,
    this.details,
    this.sceneCount = 0,
    this.parent,
    this.children = const [],
  });

  final String id;
  final String name;
  final String? imageUrl;
  final String? url;
  final String? details;
  final int sceneCount;

  /// Network/label hierarchy: the studio this one belongs to, and its
  /// sub-studios (only loaded on the studio page).
  final Studio? parent;
  final List<Studio> children;

  factory Studio.fromRef(Fragment$StudioRef s, {int sceneCount = 0}) =>
      Studio(id: s.id, name: s.name, imageUrl: nonEmpty(s.image_path), sceneCount: sceneCount);

  factory Studio.fromFields(Fragment$StudioFields s) {
    final parent = s.parent_studio;
    final details = s is Fragment$StudioDetails ? s : null;
    return Studio(
      id: s.id,
      name: s.name,
      imageUrl: nonEmpty(s.image_path),
      url: nonEmpty(s.url),
      details: nonEmpty(details?.details),
      sceneCount: s.scene_count,
      parent: parent == null ? null : Studio.fromRef(parent),
      children: [for (final c in details?.child_studios ?? const []) Studio.fromRef(c, sceneCount: c.scene_count)],
    );
  }
}
