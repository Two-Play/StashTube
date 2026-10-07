import 'json.dart';
import 'studio.dart';
import '../../core/api/documents/groups.graphql.dart';

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

  factory Group.fromFields(Fragment$GroupFields g, {String? synopsis}) {
    final studio = g.studio;
    return Group(
      id: g.id,
      name: g.name,
      date: parseDate(g.date),
      duration: (g.duration ?? 0).toDouble(),
      frontImageUrl: nonEmpty(g.front_image_path),
      synopsis: nonEmpty(synopsis),
      sceneCount: g.scene_count,
      studio: studio == null ? null : Studio.fromRef(studio),
    );
  }
}
