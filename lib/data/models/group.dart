import 'json.dart';
import 'studio.dart';

/// A Stash group (called "movie" before Stash v0.27): an ordered set of
/// scenes, used as a playlist.
class Group {
  const Group({
    required this.id,
    required this.name,
    this.date,
    this.duration = 0,
    this.frontImageUrl,
    this.synopsis,
    this.sceneCount = 0,
    this.studio,
  });

  final String id;
  final String name;
  final DateTime? date;

  /// Seconds.
  final double duration;
  final String? frontImageUrl;
  final String? synopsis;
  final int sceneCount;
  final Studio? studio;

  factory Group.fromJson(Json json) {
    final studio = readObject(json, 'studio');
    return Group(
      id: readString(json, 'id'),
      name: readString(json, 'name', 'Group'),
      date: readDate(json, 'date'),
      duration: readDouble(json, 'duration'),
      frontImageUrl: readNullableString(json, 'front_image_path'),
      synopsis: readNullableString(json, 'synopsis'),
      sceneCount: readInt(json, 'scene_count'),
      studio: studio == null ? null : Studio.fromJson(studio),
    );
  }
}
