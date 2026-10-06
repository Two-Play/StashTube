import 'json.dart';
import 'performer.dart';
import 'studio.dart';

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

  factory Gallery.fromJson(Json json) {
    final files = readList(json, 'files');
    final folderPath = readNullableString(readObject(json, 'folder') ?? const {}, 'path');
    final title = readNullableString(json, 'title') ??
        (files.isEmpty ? null : readNullableString(files.first, 'basename')) ??
        folderPath?.split(RegExp(r'[/\\]')).lastWhere((p) => p.isNotEmpty, orElse: () => folderPath) ??
        'Gallery';
    final studio = readObject(json, 'studio');
    return Gallery(
      id: readString(json, 'id'),
      title: title,
      date: readDate(json, 'date'),
      imageCount: readInt(json, 'image_count'),
      coverUrl: readNullableString(readObject(json, 'paths') ?? const {}, 'cover'),
      details: readNullableString(json, 'details'),
      studio: studio == null ? null : Studio.fromJson(studio),
      performers: readList(json, 'performers').map(Performer.fromJson).toList(),
    );
  }
}
