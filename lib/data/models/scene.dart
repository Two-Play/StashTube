import 'json.dart';
import 'performer.dart';
import 'studio.dart';
import 'tag.dart';

class Scene {
  const Scene({
    required this.id,
    required this.title,
    this.details,
    this.date,
    this.createdAt,
    this.rating100,
    this.playCount = 0,
    this.oCounter = 0,
    this.resumeTime = 0,
    this.organized = false,
    this.duration = 0,
    this.width,
    this.height,
    this.screenshotUrl,
    this.previewUrl,
    this.streamUrl,
    this.studio,
    this.performers = const [],
    this.tags = const [],
  });

  final String id;

  /// Display title; falls back to the file name when the scene has no title.
  final String title;
  final String? details;
  final DateTime? date;
  final DateTime? createdAt;
  final int? rating100;
  final int playCount;
  final int oCounter;

  /// Where the user stopped watching, in seconds; 0 if not started or finished.
  final double resumeTime;

  /// Marked as organized (metadata reviewed) in Stash.
  final bool organized;

  /// Duration of the primary file in seconds.
  final double duration;
  final int? width;
  final int? height;
  final String? screenshotUrl;
  final String? previewUrl;
  final String? streamUrl;
  final Studio? studio;
  final List<Performer> performers;
  final List<Tag> tags;

  factory Scene.fromJson(Json json) {
    final files = readList(json, 'files');
    final file = files.isNotEmpty ? files.first : const <String, dynamic>{};
    final paths = readObject(json, 'paths') ?? const <String, dynamic>{};
    final studioJson = readObject(json, 'studio');

    final title = readNullableString(json, 'title') ??
        readNullableString(file, 'basename') ??
        'Untitled scene';

    return Scene(
      id: readString(json, 'id'),
      title: title,
      details: readNullableString(json, 'details'),
      date: readDate(json, 'date'),
      createdAt: readDate(json, 'created_at'),
      rating100: readNullableInt(json, 'rating100'),
      playCount: readInt(json, 'play_count'),
      oCounter: readInt(json, 'o_counter'),
      resumeTime: readDouble(json, 'resume_time'),
      organized: readBool(json, 'organized'),
      duration: readDouble(file, 'duration'),
      width: readNullableInt(file, 'width'),
      height: readNullableInt(file, 'height'),
      screenshotUrl: readNullableString(paths, 'screenshot'),
      previewUrl: readNullableString(paths, 'preview'),
      streamUrl: readNullableString(paths, 'stream'),
      studio: studioJson == null ? null : Studio.fromJson(studioJson),
      performers: readList(json, 'performers').map(Performer.fromJson).toList(),
      tags: readList(json, 'tags').map(Tag.fromJson).toList(),
    );
  }

  Scene copyWith({double? resumeTime}) => Scene(
        id: id,
        title: title,
        details: details,
        date: date,
        createdAt: createdAt,
        rating100: rating100,
        playCount: playCount,
        oCounter: oCounter,
        resumeTime: resumeTime ?? this.resumeTime,
        organized: organized,
        duration: duration,
        width: width,
        height: height,
        screenshotUrl: screenshotUrl,
        previewUrl: previewUrl,
        streamUrl: streamUrl,
        studio: studio,
        performers: performers,
        tags: tags,
      );

  /// The date shown to users: the scene's release date, else when it was added.
  DateTime? get displayDate => date ?? createdAt;
}
