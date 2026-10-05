import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/scene.dart';
import '../../data/models/tag.dart';
import '../../data/repositories/stash_repository.dart';

/// Rating, O-count and tags changed in this session; override the loaded scene.
@immutable
class SceneEdit {
  const SceneEdit({this.rating100, this.ratingChanged = false, this.oCounter, this.tags});

  /// Only meaningful when [ratingChanged] (null = rating removed).
  final int? rating100;
  final bool ratingChanged;
  final int? oCounter;
  final List<Tag>? tags;

  SceneEdit withRating(int? rating100) =>
      SceneEdit(rating100: rating100, ratingChanged: true, oCounter: oCounter, tags: tags);
  SceneEdit withOCounter(int count) =>
      SceneEdit(rating100: rating100, ratingChanged: ratingChanged, oCounter: count, tags: tags);
  SceneEdit withTags(List<Tag> tags) =>
      SceneEdit(rating100: rating100, ratingChanged: ratingChanged, oCounter: oCounter, tags: tags);
}

/// Rating (10.1), O-counter (10.2) and tag edits, applied optimistically and
/// reverted when the server rejects them.
class SceneEditsNotifier extends Notifier<Map<String, SceneEdit>> {
  @override
  Map<String, SceneEdit> build() => const {};

  SceneEdit _editOf(String id) => state[id] ?? const SceneEdit();

  void _put(String id, SceneEdit edit) => state = {...state, id: edit};

  /// Sets 1–5 stars; [stars] 0 removes the rating.
  Future<void> rate(Scene scene, int stars) async {
    final previous = _editOf(scene.id);
    final rating100 = stars == 0 ? null : stars * 20;
    _put(scene.id, previous.withRating(rating100));
    try {
      await ref.read(stashRepositoryProvider).setSceneRating(scene.id, rating100);
    } catch (_) {
      if (ref.mounted) _put(scene.id, previous);
      rethrow;
    }
  }

  /// Replaces the scene's tags (optimistic; reverted on failure).
  Future<void> setTags(Scene scene, List<Tag> tags) async {
    final previous = _editOf(scene.id);
    _put(scene.id, previous.withTags(tags));
    try {
      final saved = await ref.read(stashRepositoryProvider).setSceneTags(scene.id, [for (final t in tags) t.id]);
      if (ref.mounted) _put(scene.id, _editOf(scene.id).withTags(saved));
    } catch (_) {
      if (ref.mounted) _put(scene.id, previous);
      rethrow;
    }
  }

  /// Adds one O; returns the new count.
  Future<int> addO(Scene scene) async {
    final previous = _editOf(scene.id);
    final before = previous.oCounter ?? scene.oCounter;
    _put(scene.id, previous.withOCounter(before + 1));
    try {
      final count = await ref.read(stashRepositoryProvider).addSceneO(scene.id);
      if (ref.mounted) _put(scene.id, _editOf(scene.id).withOCounter(count));
      return count;
    } catch (_) {
      if (ref.mounted) _put(scene.id, previous);
      rethrow;
    }
  }

  /// Undoes the last O (e.g. from the snackbar).
  Future<void> removeO(Scene scene) async {
    final previous = _editOf(scene.id);
    final before = previous.oCounter ?? scene.oCounter;
    if (before <= 0) return;
    _put(scene.id, previous.withOCounter(before - 1));
    try {
      final count = await ref.read(stashRepositoryProvider).removeSceneO(scene.id);
      if (ref.mounted) _put(scene.id, _editOf(scene.id).withOCounter(count));
    } catch (_) {
      if (ref.mounted) _put(scene.id, previous);
      rethrow;
    }
  }
}

final sceneEditsProvider = NotifierProvider<SceneEditsNotifier, Map<String, SceneEdit>>(SceneEditsNotifier.new);

/// Rating of [scene] in stars (0 = none), including edits from this session.
int effectiveStars(WidgetRef ref, Scene scene) {
  final edit = ref.watch(sceneEditsProvider.select((m) => m[scene.id]));
  final rating100 = (edit?.ratingChanged ?? false) ? edit!.rating100 : scene.rating100;
  return rating100 == null ? 0 : (rating100 / 20).round().clamp(0, 5);
}

int effectiveOCounter(WidgetRef ref, Scene scene) =>
    ref.watch(sceneEditsProvider.select((m) => m[scene.id]?.oCounter)) ?? scene.oCounter;

/// Tags of [scene], including edits from this session.
List<Tag> effectiveTags(WidgetRef ref, Scene scene) =>
    ref.watch(sceneEditsProvider.select((m) => m[scene.id]?.tags)) ?? scene.tags;
