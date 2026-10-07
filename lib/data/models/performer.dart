import 'json.dart';
import '../../core/api/documents/performers.graphql.dart';
import '../../core/api/documents/refs.graphql.dart';
import '../../core/api/stash_schema.graphql.dart';

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

  factory Performer.fromRef(Fragment$PerformerRef p, {String? country, bool favorite = false}) => Performer(
        id: p.id,
        name: p.name,
        imageUrl: nonEmpty(p.image_path),
        country: nonEmpty(country),
        favorite: favorite,
      );

  factory Performer.fromFields(Fragment$PerformerFields p, {String? details}) => Performer(
        id: p.id,
        name: p.name,
        disambiguation: nonEmpty(p.disambiguation),
        imageUrl: nonEmpty(p.image_path),
        country: nonEmpty(p.country),
        birthdate: parseDate(p.birthdate),
        gender: p.gender == null ? null : toJson$Enum$GenderEnum(p.gender!),
        details: nonEmpty(details),
        favorite: p.favorite,
        rating100: p.rating100,
        sceneCount: p.scene_count,
      );

  int? ageAt(DateTime now) {
    final b = birthdate;
    if (b == null) return null;
    var age = now.year - b.year;
    if (now.month < b.month || (now.month == b.month && now.day < b.day)) age--;
    return age;
  }
}
