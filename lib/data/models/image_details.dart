import 'gallery.dart';
import 'json.dart';
import 'performer.dart';
import 'studio.dart';
import 'tag.dart';
import '../../core/api/documents/images.graphql.dart';

/// Everything about one image for the viewer's info sheet; loaded when the
/// sheet opens (`imageDetailsProvider`). Unset values are null or empty.
class ImageDetails {
  const ImageDetails({
    required this.id,
    this.title,
    this.date,
    this.details,
    this.photographer,
    this.rating100,
    this.oCounter = 0,
    this.organized = false,
    this.created,
    this.updated,
    this.file,
    this.studio,
    this.performers = const [],
    this.tags = const [],
    this.galleries = const [],
  });

  final String id;

  /// Null when the image has no title of its own (Stash shows the file name).
  final String? title;
  final DateTime? date;
  final String? details;
  final String? photographer;
  final int? rating100;
  final int oCounter;
  final bool organized;
  final DateTime? created;
  final DateTime? updated;

  /// The primary file, null when Stash reports none.
  final ImageFileInfo? file;
  final Studio? studio;
  final List<Performer> performers;
  final List<Tag> tags;
  final List<Gallery> galleries;

  factory ImageDetails.fromGraphql(Query$FindImageDetails$findImage i) {
    final studio = i.studio;
    return ImageDetails(
      id: i.id,
      title: nonEmpty(i.title),
      date: parseDate(i.date),
      details: nonEmpty(i.details),
      photographer: nonEmpty(i.photographer),
      rating100: i.rating100,
      oCounter: i.o_counter ?? 0,
      organized: i.organized,
      created: parseDate(i.created_at),
      updated: parseDate(i.updated_at),
      file: i.visual_files.map(ImageFileInfo.fromGraphql).nonNulls.firstOrNull,
      studio: studio == null ? null : Studio.fromRef(studio),
      performers: [for (final p in i.performers) Performer.fromRef(p)],
      tags: [for (final t in i.tags) Tag.fromRef(t)],
      galleries: [for (final g in i.galleries) Gallery.fromFields(g)],
    );
  }
}

/// An image's file: an image or, for animated images, a video file.
class ImageFileInfo {
  const ImageFileInfo({required this.path, required this.name, this.size, this.format, this.width, this.height});

  final String path;
  final String name;

  /// In bytes.
  final int? size;
  final String? format;
  final int? width;
  final int? height;

  static ImageFileInfo? fromGraphql(Query$FindImageDetails$findImage$visual_files f) => switch (f) {
    Query$FindImageDetails$findImage$visual_files$$ImageFile() => ImageFileInfo._of(
      f.path,
      f.basename,
      f.size,
      f.format,
      f.width,
      f.height,
    ),
    Query$FindImageDetails$findImage$visual_files$$VideoFile() => ImageFileInfo._of(
      f.path,
      f.basename,
      f.size,
      f.format,
      f.width,
      f.height,
    ),
    _ => null,
  };

  static ImageFileInfo _of(String path, String basename, int size, String format, int width, int height) =>
      ImageFileInfo(
        path: path,
        name: nonEmpty(basename) ?? path.split(RegExp(r'[/\\]')).last,
        size: size > 0 ? size : null,
        format: nonEmpty(format),
        width: width > 0 ? width : null,
        height: height > 0 ? height : null,
      );
}
