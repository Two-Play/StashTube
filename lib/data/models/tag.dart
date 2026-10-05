import 'json.dart';

class Tag {
  const Tag({required this.id, required this.name});

  final String id;
  final String name;

  factory Tag.fromJson(Json json) =>
      Tag(id: readString(json, 'id'), name: readString(json, 'name'));
}
