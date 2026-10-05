import 'json.dart';

class Tag {
  const Tag({required this.id, required this.name, this.imageUrl, this.description, this.sceneCount = 0});

  final String id;
  final String name;
  final String? imageUrl;
  final String? description;
  final int sceneCount;

  factory Tag.fromJson(Json json) => Tag(
        id: readString(json, 'id'),
        name: readString(json, 'name'),
        imageUrl: readNullableString(json, 'image_path'),
        description: readNullableString(json, 'description'),
        sceneCount: readInt(json, 'scene_count'),
      );
}
