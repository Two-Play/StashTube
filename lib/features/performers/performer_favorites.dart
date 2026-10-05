import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/server_config.dart';

import '../../data/models/list_queries.dart';
import '../../data/models/performer.dart';
import '../../data/providers.dart';
import '../../data/repositories/stash_repository.dart';

/// Favorite flags changed in this app session, by performer id. They take
/// precedence over the (possibly stale) `favorite` field of loaded performers.
class PerformerFavoritesNotifier extends Notifier<Map<String, bool>> {
  final _pending = <String>{};

  @override
  Map<String, bool> build() {
    ref.watch(activeServerIdProvider); // performer ids are per server
    return const {};
  }

  /// Flips the favorite flag optimistically and saves it via `performerUpdate`.
  /// Reverts and rethrows when the server rejects the change.
  Future<void> toggle(Performer performer) async {
    if (!_pending.add(performer.id)) return; // ignore taps while saving
    final previous = state[performer.id] ?? performer.favorite;
    final next = !previous;
    state = {...state, performer.id: next};

    try {
      await ref.read(stashRepositoryProvider).setPerformerFavorite(performer.id, next);
      // Lists filtered by favorites are now out of date.
      ref.invalidate(performerListProvider(PerformerQuery(sort: PerformerSort.favorites)));
      ref.invalidate(sceneListProvider(SceneQuery.newFromFavorites()));
    } catch (_) {
      state = {...state, performer.id: previous};
      rethrow;
    } finally {
      _pending.remove(performer.id);
    }
  }
}

final performerFavoritesProvider =
    NotifierProvider<PerformerFavoritesNotifier, Map<String, bool>>(PerformerFavoritesNotifier.new);

/// Favorite state of [performer], including changes made in this session.
bool effectiveFavorite(WidgetRef ref, Performer performer) =>
    ref.watch(performerFavoritesProvider.select((m) => m[performer.id])) ?? performer.favorite;
