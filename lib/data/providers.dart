import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/pagination/paged_notifier.dart';
import 'models/gallery.dart';
import 'models/image_item.dart';
import 'models/list_queries.dart';
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

/// Streams and markers of a scene; loaded when the scene is played.
final sceneDetailsProvider = FutureProvider.autoDispose.family<SceneDetails, String>(
  (ref, id) => ref.watch(stashRepositoryProvider).findSceneDetails(id),
);

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

/// Seek preview thumbnails of a scene, or null when there are none.
final scrubThumbnailsProvider = FutureProvider.autoDispose.family<ScrubThumbnails?, String>((ref, id) async {
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
