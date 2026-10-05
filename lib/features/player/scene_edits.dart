import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/scene.dart';
import '../../data/repositories/stash_repository.dart';

/// Rating and O-count changed in this session; override the loaded scene.
@immutable
class SceneEdit {
  const SceneEdit({this.rating100, this.ratingChanged = false, this.oCounter});

  /// Only meaningful when [ratingChanged] (null = rating removed).
  final int? rating100;
  final bool ratingChanged;
  final int? oCounter;

  SceneEdit withRating(int? rating100) => SceneEdit(rating100: rating100, ratingChanged: true, oCounter: oCounter);
  SceneEdit withOCounter(int count) =>
      SceneEdit(rating100: rating100, ratingChanged: ratingChanged, oCounter: count);
}

/// Rating (10.1) and O-counter (10.2) edits, applied optimistically and
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
