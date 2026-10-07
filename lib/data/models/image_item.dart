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

  factory ImageItem.fromGraphql(Query$FindImages$findImages$images i) {
    final studio = i.studio;
    return ImageItem(
      id: i.id,
      title: nonEmpty(i.title) ?? 'Image',
      date: parseDate(i.date),
      rating100: i.rating100,
      thumbnailUrl: nonEmpty(i.paths.thumbnail),
      imageUrl: nonEmpty(i.paths.image),
      studio: studio == null ? null : Studio.fromRef(studio),
      performers: [for (final p in i.performers) Performer.fromRef(p)],
    );
  }
}
