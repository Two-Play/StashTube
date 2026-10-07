import 'json.dart';
import 'performer.dart';
import 'studio.dart';
import 'tag.dart';
import '../../core/api/documents/scenes.graphql.dart';

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

  factory Scene.fromFields(Fragment$SceneFields s) {
    final file = s.files.firstOrNull;
    final studio = s.studio;
    return Scene(
      id: s.id,
      title: nonEmpty(s.title) ?? nonEmpty(file?.basename) ?? 'Untitled scene',
      details: nonEmpty(s.details),
      date: parseDate(s.date),
      createdAt: parseDate(s.created_at),
      rating100: s.rating100,
      playCount: s.play_count ?? 0,
      oCounter: s.o_counter ?? 0,
      resumeTime: s.resume_time ?? 0,
      organized: s.organized,
      duration: file?.duration ?? 0,
      width: file?.width,
      height: file?.height,
      screenshotUrl: nonEmpty(s.paths.screenshot),
      previewUrl: nonEmpty(s.paths.preview),
      streamUrl: nonEmpty(s.paths.stream),
      studio: studio == null ? null : Studio.fromRef(studio),
      performers: [for (final p in s.performers) Performer.fromRef(p, country: p.country, favorite: p.favorite)],
      tags: [for (final t in s.tags) Tag.fromRef(t)],
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
