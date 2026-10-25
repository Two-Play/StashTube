import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/server_config.dart';
import '../../core/config/theme.dart';
import '../../data/models/performer.dart';
import '../../data/repositories/stash_repository.dart';
import '../../l10n/l10n.dart';
import '../player/scene_actions.dart';

/// What has a channel page with stars.
enum ChannelKind { performer, studio }

/// Stash's 0–100 rating as 0–5 stars (0 = none).
int starsOf(int? rating100) => rating100 == null ? 0 : (rating100 / 20).round().clamp(0, 5);

/// A studio's rating as the server reports it; null when the server has no
/// studio ratings. Loaded on its own, so older servers only lose the stars.
final studioRatingProvider = FutureProvider.autoDispose.family<({int? rating100})?, String>(
  (ref, id) => ref.watch(stashRepositoryProvider).studioRating(id),
);

/// Stars given in this app session, by `<kind>:<id>`. They take precedence
/// over the loaded values, so every page shows a new rating right away.
class ChannelRatingsNotifier extends Notifier<Map<String, int>> {
  @override
  Map<String, int> build() {
    ref.watch(activeServerIdProvider); // ids are per server
    return const {};
  }

  static String key(ChannelKind kind, String id) => '${kind.name}:$id';

  /// Shows [stars] (0 removes the rating) right away and saves them.
  /// Reverts and rethrows when the server rejects the change.
  Future<void> rate(ChannelKind kind, String id, int stars, {required int current}) async {
    final k = key(kind, id);
    final previous = state[k] ?? current;
    state = {...state, k: stars};
    final rating100 = stars == 0 ? null : stars * 20;
    final repository = ref.read(stashRepositoryProvider);
    try {
      await switch (kind) {
        ChannelKind.performer => repository.setPerformerRating(id, rating100),
        ChannelKind.studio => repository.setStudioRating(id, rating100),
      };
    } catch (_) {
      if (ref.mounted) state = {...state, k: previous};
      rethrow;
    }
  }
}

final channelRatingsProvider =
    NotifierProvider<ChannelRatingsNotifier, Map<String, int>>(ChannelRatingsNotifier.new);

/// The performer's stars including this session's changes.
int effectivePerformerStars(WidgetRef ref, Performer performer) =>
    ref.watch(channelRatingsProvider.select((m) => m[ChannelRatingsNotifier.key(ChannelKind.performer, performer.id)])) ??
    starsOf(performer.rating100);

/// The studio's stars including this session's changes; null while loading
/// or when the server has no studio ratings.
int? effectiveStudioStars(WidgetRef ref, String studioId) {
  final changed =
      ref.watch(channelRatingsProvider.select((m) => m[ChannelRatingsNotifier.key(ChannelKind.studio, studioId)]));
  if (changed != null) return changed;
  final loaded = ref.watch(studioRatingProvider(studioId)).value;
  return loaded == null ? null : starsOf(loaded.rating100);
}

/// "★ 4" or "Rate" next to a channel's favorite button; the stars are in
/// the same sheet as a scene's.
class ChannelRatingButton extends ConsumerWidget {
  const ChannelRatingButton({super.key, required this.kind, required this.id, required this.stars});

  final ChannelKind kind;
  final String id;

  /// The current stars, read the same way inside the sheet.
  final int Function(WidgetRef ref) stars;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final current = stars(ref);
    final messenger = ScaffoldMessenger.of(context);
    return FilledButton.tonalIcon(
      style: FilledButton.styleFrom(visualDensity: VisualDensity.compact),
      icon: Icon(
        current > 0 ? Icons.star_rounded : Icons.star_outline_rounded,
        color: current > 0 ? AppColors.of(context).rating : null,
      ),
      label: Semantics(
        label: l.ratingButtonSemantics(l.ratingValue(current)),
        excludeSemantics: true,
        child: Text(current > 0 ? '$current' : l.rateScene),
      ),
      onPressed: () => showStarsSheet(
        context,
        title: switch (kind) {
          ChannelKind.performer => l.rateThisPerformer,
          ChannelKind.studio => l.rateThisStudio,
        },
        stars: stars,
        onRate: (ref, value) => ref
            .read(channelRatingsProvider.notifier)
            .rate(kind, id, value, current: current)
            .catchError((Object e) {
          messenger.showSnackBar(SnackBar(content: Text(l.saveFailed(errorText(l, e)))));
        }),
      ),
    );
  }
}
