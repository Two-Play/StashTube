import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/pagination/paged_notifier.dart';

// List widgets read paged lists through `current` (drops a previous
// server's items while reloading).
export '../core/pagination/paged_notifier.dart' show PagedState, PagedValue;
import 'models/gallery.dart';
import 'models/group.dart';
import 'models/image_item.dart';
import 'models/list_queries.dart';
import 'models/marker.dart';
import 'models/page_result.dart';
import 'models/performer.dart';
import 'models/saved_filter.dart';
import 'models/scene.dart';
import 'models/scene_details.dart';
import 'models/scrub_thumbnails.dart';
import 'models/stats.dart';
import 'models/studio.dart';
import 'models/tag.dart';
import 'repositories/stash_repository.dart';

class SceneListNotifier extends PagedNotifier<Scene, SceneQuery> {
  SceneListNotifier(super.arg);

  @override
  Future<PageResult<Scene>> fetchPage(SceneQuery arg, int page, int perPage) =>
      ref.read(stashRepositoryProvider).findScenes(arg, page: page, perPage: perPage);
}

final sceneListProvider =
    AsyncNotifierProvider.autoDispose.family<SceneListNotifier, PagedState<Scene>, SceneQuery>(
  SceneListNotifier.new,
);

class PerformerListNotifier extends PagedNotifier<Performer, PerformerQuery> {
  PerformerListNotifier(super.arg);

  @override
  Future<PageResult<Performer>> fetchPage(PerformerQuery arg, int page, int perPage) =>
      ref.read(stashRepositoryProvider).findPerformers(arg, page: page, perPage: perPage);
}

final performerListProvider = AsyncNotifierProvider.autoDispose
    .family<PerformerListNotifier, PagedState<Performer>, PerformerQuery>(
  PerformerListNotifier.new,
);

class StudioListNotifier extends PagedNotifier<Studio, StudioQuery> {
  StudioListNotifier(super.arg);

  @override
  Future<PageResult<Studio>> fetchPage(StudioQuery arg, int page, int perPage) =>
      ref.read(stashRepositoryProvider).findStudios(arg, page: page, perPage: perPage);
}

final studioListProvider =
    AsyncNotifierProvider.autoDispose.family<StudioListNotifier, PagedState<Studio>, StudioQuery>(
  StudioListNotifier.new,
);

final performerProvider = FutureProvider.autoDispose.family<Performer, String>(
  (ref, id) => ref.watch(stashRepositoryProvider).findPerformer(id),
);

final studioProvider = FutureProvider.autoDispose.family<Studio, String>(
  (ref, id) => ref.watch(stashRepositoryProvider).findStudio(id),
);

final serverVersionProvider = FutureProvider.autoDispose<String?>(
  (ref) => ref.watch(stashRepositoryProvider).serverVersion(),
);

/// Keeps an auto-dispose provider's value for [duration] after its last
/// listener is gone, e.g. while the player is collapsed and expanded again.
extension CacheFor on Ref {
  void cacheFor(Duration duration) {
    final link = keepAlive();
    Timer? timer;
    onCancel(() => timer = Timer(duration, link.close));
    onResume(() => timer?.cancel());
    onDispose(() => timer?.cancel());
  }
}

/// How long per-scene player data stays cached without listeners.
const _sceneCacheDuration = Duration(minutes: 5);

/// Streams, markers, files and sprite paths of a scene; loaded when the
/// scene is played.
final sceneDetailsProvider = FutureProvider.autoDispose.family<SceneDetails, String>((ref, id) {
  ref.cacheFor(_sceneCacheDuration);
  return ref.watch(stashRepositoryProvider).findSceneDetails(id);
});

class ImageListNotifier extends PagedNotifier<ImageItem, ImageQuery> {
  ImageListNotifier(super.arg);

  @override
  Future<PageResult<ImageItem>> fetchPage(ImageQuery arg, int page, int perPage) =>
      ref.read(stashRepositoryProvider).findImages(arg, page: page, perPage: perPage);
}

final imageListProvider =
    AsyncNotifierProvider.autoDispose.family<ImageListNotifier, PagedState<ImageItem>, ImageQuery>(
  ImageListNotifier.new,
);

final libraryStatsProvider = FutureProvider.autoDispose<LibraryStats>(
  (ref) => ref.watch(stashRepositoryProvider).libraryStats(),
);

final activityStatsProvider = FutureProvider.autoDispose<ActivityStats?>(
  (ref) => ref.watch(stashRepositoryProvider).activityStats(),
);

/// Seek preview thumbnails of a scene, or null when there are none. Only
/// read once the user is about to seek (`PreviewSeekBar`), as the WebVTT
/// can be large for long scenes.
final scrubThumbnailsProvider = FutureProvider.autoDispose.family<ScrubThumbnails?, String>((ref, id) async {
  ref.cacheFor(_sceneCacheDuration);
  final details = await ref.watch(sceneDetailsProvider(id).future);
  return ref.watch(stashRepositoryProvider).scrubThumbnails(details);
});

class GalleryListNotifier extends PagedNotifier<Gallery, GalleryQuery> {
  GalleryListNotifier(super.arg);

  @override
  Future<PageResult<Gallery>> fetchPage(GalleryQuery arg, int page, int perPage) =>
      ref.read(stashRepositoryProvider).findGalleries(arg, page: page, perPage: perPage);
}

final galleryListProvider =
    AsyncNotifierProvider.autoDispose.family<GalleryListNotifier, PagedState<Gallery>, GalleryQuery>(
  GalleryListNotifier.new,
);

final galleryProvider = FutureProvider.autoDispose.family<Gallery, String>(
  (ref, id) => ref.watch(stashRepositoryProvider).findGallery(id),
);

class TagListNotifier extends PagedNotifier<Tag, TagQuery> {
  TagListNotifier(super.arg);

  @override
  Future<PageResult<Tag>> fetchPage(TagQuery arg, int page, int perPage) =>
      ref.read(stashRepositoryProvider).findTags(arg, page: page, perPage: perPage);
}

final tagListProvider =
    AsyncNotifierProvider.autoDispose.family<TagListNotifier, PagedState<Tag>, TagQuery>(TagListNotifier.new);

final tagProvider = FutureProvider.autoDispose.family<Tag, String>(
  (ref, id) => ref.watch(stashRepositoryProvider).findTag(id),
);

final savedSceneFiltersProvider = FutureProvider.autoDispose<List<SavedFilter>>(
  (ref) => ref.watch(stashRepositoryProvider).savedSceneFilters(),
);

class MarkerListNotifier extends PagedNotifier<Marker, MarkerQuery> {
  MarkerListNotifier(super.arg);

  @override
  Future<PageResult<Marker>> fetchPage(MarkerQuery arg, int page, int perPage) =>
      ref.read(stashRepositoryProvider).findMarkers(arg, page: page, perPage: perPage);
}

final markerListProvider =
    AsyncNotifierProvider.autoDispose.family<MarkerListNotifier, PagedState<Marker>, MarkerQuery>(
  MarkerListNotifier.new,
);

class GroupListNotifier extends PagedNotifier<Group, GroupQuery> {
  GroupListNotifier(super.arg);

  @override
  Future<PageResult<Group>> fetchPage(GroupQuery arg, int page, int perPage) =>
      ref.read(stashRepositoryProvider).findGroups(arg, page: page, perPage: perPage);
}

final groupListProvider =
    AsyncNotifierProvider.autoDispose.family<GroupListNotifier, PagedState<Group>, GroupQuery>(GroupListNotifier.new);

final groupProvider = FutureProvider.autoDispose.family<Group, String>(
  (ref, id) => ref.watch(stashRepositoryProvider).findGroup(id),
);
