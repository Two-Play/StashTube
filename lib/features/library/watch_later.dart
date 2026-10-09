import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/haptics.dart';
import '../../core/config/server_config.dart';
import '../../data/models/scene.dart';
import '../../data/repositories/stash_repository.dart';

/// "Watch later" (9.4): scene ids stored on the device, oldest first.
class WatchLaterNotifier extends Notifier<List<String>> {
  static const _key = 'watch_later';

  /// Per server: scene ids only make sense on the server they come from.
  String? get _serverKey {
    final server = ref.read(activeServerIdProvider);
    return server == null ? null : '$_key:$server';
  }

  @override
  List<String> build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    ref.watch(activeServerIdProvider);
    final key = _serverKey;
    if (key == null) return const [];
    // Lists saved before servers were separated still show up.
    return prefs.getStringList(key) ?? prefs.getStringList(_key) ?? const [];
  }

  bool contains(String sceneId) => state.contains(sceneId);

  /// Adds or removes; returns whether the scene is now saved.
  Future<bool> toggle(String sceneId) async {
    final saved = !state.contains(sceneId);
    Haptics.light();
    await _save(saved ? [...state, sceneId] : state.where((id) => id != sceneId).toList());
    return saved;
  }

  Future<void> remove(String sceneId) => _save(state.where((id) => id != sceneId).toList());

  Future<void> _save(List<String> ids) async {
    state = ids;
    final key = _serverKey;
    if (key != null) await ref.read(sharedPreferencesProvider).setStringList(key, ids);
  }
}

final watchLaterProvider = NotifierProvider<WatchLaterNotifier, List<String>>(WatchLaterNotifier.new);

/// The saved scenes, in saved order.
final watchLaterScenesProvider = FutureProvider.autoDispose<List<Scene>>((ref) {
  final ids = ref.watch(watchLaterProvider);
  return ref.watch(stashRepositoryProvider).findScenesByIds(ids);
});
