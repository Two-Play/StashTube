import 'json.dart';

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

  factory LibraryStats.fromJson(Json json) => LibraryStats(
        sceneCount: readInt(json, 'scene_count'),
        scenesSize: readDouble(json, 'scenes_size'),
        scenesDuration: readDouble(json, 'scenes_duration'),
        imageCount: readInt(json, 'image_count'),
        imagesSize: readDouble(json, 'images_size'),
        galleryCount: readInt(json, 'gallery_count'),
        performerCount: readInt(json, 'performer_count'),
        studioCount: readInt(json, 'studio_count'),
        tagCount: readInt(json, 'tag_count'),
      );
}

class ActivityStats {
  const ActivityStats({this.playCount = 0, this.playDuration = 0, this.scenesPlayed = 0, this.oCount = 0});

  final int playCount;

  /// Seconds.
  final double playDuration;
  final int scenesPlayed;
  final int oCount;

  factory ActivityStats.fromJson(Json json) => ActivityStats(
        playCount: readInt(json, 'total_play_count'),
        playDuration: readDouble(json, 'total_play_duration'),
        scenesPlayed: readInt(json, 'scenes_played'),
        oCount: readInt(json, 'total_o_count'),
      );
}
