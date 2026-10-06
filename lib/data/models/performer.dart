import 'json.dart';

class Performer {
  const Performer({
    required this.id,
    required this.name,
    this.disambiguation,
    this.imageUrl,
    this.country,
    this.birthdate,
    this.gender,
    this.details,
    this.favorite = false,
    this.rating100,
    this.sceneCount = 0,
  });

  final String id;
  final String name;
  final String? disambiguation;
  final String? imageUrl;

  /// ISO 3166-1 alpha-2 code, as stored by Stash.
  final String? country;
  final DateTime? birthdate;
  final String? gender;
  final String? details;
  final bool favorite;
  final int? rating100;
  final int sceneCount;

  factory Performer.fromJson(Json json) => Performer(
        id: readString(json, 'id'),
        name: readString(json, 'name', 'Unknown'),
        disambiguation: readNullableString(json, 'disambiguation'),
        imageUrl: readNullableString(json, 'image_path'),
        country: readNullableString(json, 'country'),
        birthdate: readDate(json, 'birthdate'),
        gender: readNullableString(json, 'gender'),
        details: readNullableString(json, 'details'),
        favorite: readBool(json, 'favorite'),
        rating100: readNullableInt(json, 'rating100'),
        sceneCount: readInt(json, 'scene_count'),
      );

  int? ageAt(DateTime now) {
    final b = birthdate;
    if (b == null) return null;
    var age = now.year - b.year;
    if (now.month < b.month || (now.month == b.month && now.day < b.day)) age--;
    return age;
  }
}
