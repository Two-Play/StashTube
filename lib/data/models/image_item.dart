import 'json.dart';
import 'performer.dart';
import 'studio.dart';

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

  factory ImageItem.fromJson(Json json) {
    final paths = readObject(json, 'paths') ?? const <String, dynamic>{};
    final studio = readObject(json, 'studio');
    return ImageItem(
      id: readString(json, 'id'),
      title: readNullableString(json, 'title') ?? 'Image',
      date: readDate(json, 'date'),
      rating100: readNullableInt(json, 'rating100'),
      thumbnailUrl: readNullableString(paths, 'thumbnail'),
      imageUrl: readNullableString(paths, 'image'),
      studio: studio == null ? null : Studio.fromJson(studio),
      performers: readList(json, 'performers').map(Performer.fromJson).toList(),
    );
  }
}
