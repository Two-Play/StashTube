import 'json.dart';

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

  factory Studio.fromJson(Json json) {
    final parent = readObject(json, 'parent_studio');
    return Studio(
      id: readString(json, 'id'),
      name: readString(json, 'name', 'Unknown studio'),
      imageUrl: readNullableString(json, 'image_path'),
      url: readNullableString(json, 'url'),
      details: readNullableString(json, 'details'),
      sceneCount: readInt(json, 'scene_count'),
      parent: parent == null ? null : Studio.fromJson(parent),
      children: readList(json, 'child_studios').map(Studio.fromJson).toList(),
    );
  }
}
