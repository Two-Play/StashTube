import '../../core/api/documents/system.graphql.dart';

class LibraryStats {
  const LibraryStats({
    this.sceneCount = 0,
    this.scenesSize = 0,
    this.scenesDuration = 0,
    this.imageCount = 0,
    this.imagesSize = 0,
    this.galleryCount = 0,
    this.performerCount = 0,
    this.studioCount = 0,
    this.tagCount = 0,
  });

  final int sceneCount;

  /// Bytes.
  final double scenesSize;

  /// Seconds.
  final double scenesDuration;
  final int imageCount;
  final double imagesSize;
  final int galleryCount;
  final int performerCount;
  final int studioCount;
  final int tagCount;

  factory LibraryStats.fromGraphql(Query$Stats$stats s) => LibraryStats(
        sceneCount: s.scene_count,
        scenesSize: s.scenes_size,
        scenesDuration: s.scenes_duration,
        imageCount: s.image_count,
        imagesSize: s.images_size,
        galleryCount: s.gallery_count,
        performerCount: s.performer_count,
        studioCount: s.studio_count,
        tagCount: s.tag_count,
      );
}

class ActivityStats {
  const ActivityStats({this.playCount = 0, this.playDuration = 0, this.scenesPlayed = 0, this.oCount = 0});

  final int playCount;

  /// Seconds.
  final double playDuration;
  final int scenesPlayed;
  final int oCount;

  factory ActivityStats.fromGraphql(Query$ActivityStats$stats s) => ActivityStats(
        playCount: s.total_play_count,
        playDuration: s.total_play_duration,
        scenesPlayed: s.scenes_played,
        oCount: s.total_o_count,
      );
}
