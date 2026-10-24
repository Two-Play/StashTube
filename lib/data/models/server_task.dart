import '../../core/api/documents/tasks.graphql.dart';
import '../../core/api/stash_schema.graphql.dart';

enum JobState { ready, running, finished, stopping, cancelled, failed }

/// A job in Stash's task queue (scan, generate, ...).
class ServerJob {
  const ServerJob({
    required this.id,
    required this.state,
    required this.description,
    this.subTasks = const [],
    this.progress,
    this.error,
  });

  final String id;
  final JobState state;

  /// Stash's own text, e.g. "Scanning...".
  final String description;

  /// What the job is working on right now (a file, a step).
  final List<String> subTasks;

  /// 0–1; null while Stash can't tell yet.
  final double? progress;
  final String? error;

  bool get isActive => state == JobState.ready || state == JobState.running;

  factory ServerJob.fromFields(Fragment$JobFields j) => ServerJob(
    id: j.id,
    state: switch (j.status) {
      Enum$JobStatus.READY => JobState.ready,
      Enum$JobStatus.RUNNING || Enum$JobStatus.$unknown => JobState.running,
      Enum$JobStatus.FINISHED => JobState.finished,
      Enum$JobStatus.STOPPING => JobState.stopping,
      Enum$JobStatus.CANCELLED => JobState.cancelled,
      Enum$JobStatus.FAILED => JobState.failed,
    },
    description: j.description,
    subTasks: j.subTasks ?? const [],
    progress: j.progress,
    error: j.error,
  );
}

/// What a scan generates for new files besides reading them in; the values
/// are the keys of Stash's `ScanMetadataInput`.
enum ScanOption {
  rescan('rescan'),
  covers('scanGenerateCovers'),
  previews('scanGeneratePreviews'),
  imagePreviews('scanGenerateImagePreviews'),
  sprites('scanGenerateSprites'),
  phashes('scanGeneratePhashes');

  const ScanOption(this.key);

  final String key;

  static const standard = {covers, previews, imagePreviews, sprites, phashes};
}

/// What the generate task creates; the values are the keys of Stash's
/// `GenerateMetadataInput`.
enum GenerateOption {
  covers('covers'),
  previews('previews'),
  imagePreviews('imagePreviews'),
  sprites('sprites'),
  markers('markers'),
  markerImagePreviews('markerImagePreviews'),
  markerScreenshots('markerScreenshots'),
  phashes('phashes');

  const GenerateOption(this.key);

  final String key;

  /// The animated (WebP) previews the lists and markers play.
  static const animatedPreviews = {imagePreviews, markerImagePreviews};

  static const standard = {covers, previews, imagePreviews, sprites, markers, markerImagePreviews, phashes};
}

/// Whether the server has generated the previews the app plays, judged
/// from a random sample.
class PreviewCheck {
  const PreviewCheck({this.scenes = 0, this.animated = 0, this.videos = 0, this.markers = 0, this.markerAnimated = 0});

  /// How many scenes were checked, and how many of them had an animated
  /// (WebP) and a video (MP4) preview.
  final int scenes;
  final int animated;
  final int videos;

  final int markers;
  final int markerAnimated;
}
