import 'json.dart';
import '../../core/api/documents/refs.graphql.dart';

class Tag {
  const Tag({required this.id, required this.name, this.imageUrl, this.description, this.sceneCount = 0});

  final String id;
  final String name;
  final String? imageUrl;
  final String? description;
  final int sceneCount;

  factory Tag.fromRef(Fragment$TagRef t) => Tag(id: t.id, name: t.name);

  factory Tag.fromFields(Fragment$TagFields t, {String? description}) => Tag(
        id: t.id,
        name: t.name,
        imageUrl: nonEmpty(t.image_path),
        description: nonEmpty(description),
        sceneCount: t.scene_count,
      );
}
