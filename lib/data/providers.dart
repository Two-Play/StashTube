import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/pagination/paged_notifier.dart';
import 'models/list_queries.dart';
import 'models/page_result.dart';
import 'models/performer.dart';
import 'models/scene.dart';
import 'models/scene_details.dart';
import 'models/studio.dart';
import 'repositories/stash_repository.dart';

class SceneListNotifier extends PagedNotifier<Scene, SceneQuery> {
  @override
  Future<PageResult<Scene>> fetchPage(SceneQuery arg, int page, int perPage) =>
      ref.read(stashRepositoryProvider).findScenes(arg, page: page, perPage: perPage);
}

final sceneListProvider =
    AsyncNotifierProvider.autoDispose.family<SceneListNotifier, PagedState<Scene>, SceneQuery>(
  SceneListNotifier.new,
);

class PerformerListNotifier extends PagedNotifier<Performer, PerformerQuery> {
  @override
  Future<PageResult<Performer>> fetchPage(PerformerQuery arg, int page, int perPage) =>
      ref.read(stashRepositoryProvider).findPerformers(arg, page: page, perPage: perPage);
}

final performerListProvider = AsyncNotifierProvider.autoDispose
    .family<PerformerListNotifier, PagedState<Performer>, PerformerQuery>(
  PerformerListNotifier.new,
);

class StudioListNotifier extends PagedNotifier<Studio, StudioQuery> {
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
