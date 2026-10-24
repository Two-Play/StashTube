import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/server_config.dart';
import '../../data/repositories/stash_repository.dart';

/// Whether a studio is a favorite, as the server reports it; null when the
/// server has no studio favorites (Stash before 0.25). Loaded on its own, so
/// older servers only lose the favorite button.
final studioFavoriteProvider = FutureProvider.autoDispose.family<bool?, String>(
  (ref, id) => ref.watch(stashRepositoryProvider).studioFavorite(id),
);

/// Studio favorite flags changed in this app session, by studio id. They take
/// precedence over the loaded `studioFavoriteProvider` values.
class StudioFavoritesNotifier extends Notifier<Map<String, bool>> {
  final _pending = <String>{};

  @override
  Map<String, bool> build() {
    ref.watch(activeServerIdProvider); // studio ids are per server
    return const {};
  }

  /// Sets the favorite flag optimistically and saves it via `studioUpdate`.
  /// Reverts and rethrows when the server rejects the change.
  Future<void> toggle(String studioId, {required bool current}) async {
    if (!_pending.add(studioId)) return; // ignore taps while saving
    final previous = state[studioId] ?? current;
    state = {...state, studioId: !previous};
    try {
      await ref.read(stashRepositoryProvider).setStudioFavorite(studioId, !previous);
    } catch (_) {
      state = {...state, studioId: previous};
      rethrow;
    } finally {
      _pending.remove(studioId);
    }
  }
}

final studioFavoritesProvider =
    NotifierProvider<StudioFavoritesNotifier, Map<String, bool>>(StudioFavoritesNotifier.new);

/// Favorite state of the studio including this session's changes; null while
/// loading or when the server has no studio favorites.
bool? effectiveStudioFavorite(WidgetRef ref, String studioId) =>
    ref.watch(studioFavoritesProvider.select((m) => m[studioId])) ??
    ref.watch(studioFavoriteProvider(studioId)).value;
