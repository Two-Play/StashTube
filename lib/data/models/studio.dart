import 'json.dart';

class Studio {
  const Studio({
    required this.id,
    required this.name,
    this.imageUrl,
    this.url,
    this.details,
    this.sceneCount = 0,
  });

  final String id;
  final String name;
  final String? imageUrl;
  final String? url;
  final String? details;
  final int sceneCount;

  factory Studio.fromJson(Json json) => Studio(
        id: readString(json, 'id'),
        name: readString(json, 'name', 'Unknown studio'),
        imageUrl: readNullableString(json, 'image_path'),
        url: readNullableString(json, 'url'),
        details: readNullableString(json, 'details'),
        sceneCount: readInt(json, 'scene_count'),
      );
}
