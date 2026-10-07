import 'json.dart';
import 'performer.dart';
import 'studio.dart';
import '../../core/api/documents/galleries.graphql.dart';

class Gallery {
  const Gallery({
    required this.id,
    required this.title,
    this.date,
    this.imageCount = 0,
    this.coverUrl,
    this.details,
    this.studio,
    this.performers = const [],
  });

  final String id;

  /// Falls back to the zip/folder name for galleries without a title.
  final String title;
  final DateTime? date;
  final int imageCount;
  final String? coverUrl;
  final String? details;
  final Studio? studio;
  final List<Performer> performers;

  factory Gallery.fromFields(Fragment$GalleryFields g) {
    final folderPath = nonEmpty(g.folder?.path);
    final title = nonEmpty(g.title) ??
        nonEmpty(g.files.firstOrNull?.basename) ??
        folderPath?.split(RegExp(r'[/\\]')).lastWhere((p) => p.isNotEmpty, orElse: () => folderPath) ??
        'Gallery';
    final studio = g.studio;
    return Gallery(
      id: g.id,
      title: title,
      date: parseDate(g.date),
      imageCount: g.image_count,
      coverUrl: nonEmpty(g.paths.cover),
      details: nonEmpty(g.details),
      studio: studio == null ? null : Studio.fromRef(studio),
      performers: [for (final p in g.performers) Performer.fromRef(p)],
    );
  }
}
