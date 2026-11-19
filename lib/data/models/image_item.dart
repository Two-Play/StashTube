import 'json.dart';
import 'performer.dart';
import 'studio.dart';
import '../../core/api/documents/images.graphql.dart';

/// A Stash image (named `ImageItem` to avoid clashing with Flutter's `Image`).
class ImageItem {
  const ImageItem({
    required this.id,
    required this.title,
    this.date,
    this.rating100,
    this.thumbnailUrl,
    this.imageUrl,
    this.studio,
    this.performers = const [],
    this.videoDuration,
    this.width,
    this.height,
  });

  final String id;
  final String title;
  final DateTime? date;
  final int? rating100;
  final String? thumbnailUrl;

  /// Full-resolution image.
  final String? imageUrl;
  final Studio? studio;
  final List<Performer> performers;

  /// Set for a video file shown as an image (a gallery's clip, #64): its
  /// length in seconds. [imageUrl] then serves the video.
  final double? videoDuration;

  bool get isVideo => videoDuration != null;

  /// The video's size, when [isVideo].
  final int? width;
  final int? height;

  /// The video's width / height; null when unknown or not a video.
  double? get aspect {
    final w = width, h = height;
    return w == null || h == null || w <= 0 || h <= 0 ? null : w / h;
  }

  factory ImageItem.fromGraphql(Query$FindImages$findImages$images i) {
    final studio = i.studio;
    final video = i.visual_files.whereType<Query$FindImages$findImages$images$visual_files$$VideoFile>().firstOrNull;
    return ImageItem(
      id: i.id,
      title: nonEmpty(i.title) ?? 'Image',
      date: parseDate(i.date),
      rating100: i.rating100,
      thumbnailUrl: nonEmpty(i.paths.thumbnail),
      imageUrl: nonEmpty(i.paths.image),
      studio: studio == null ? null : Studio.fromRef(studio),
      performers: [for (final p in i.performers) Performer.fromRef(p)],
      videoDuration: video?.duration,
      width: video?.width,
      height: video?.height,
    );
  }
}
