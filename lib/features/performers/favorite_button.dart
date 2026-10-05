import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/performer.dart';
import 'performer_favorites.dart';

Future<void> _toggle(BuildContext context, WidgetRef ref, Performer performer) async {
  HapticFeedback.lightImpact();
  final messenger = ScaffoldMessenger.of(context);
  try {
    await ref.read(performerFavoritesProvider.notifier).toggle(performer);
  } catch (e) {
    messenger.showSnackBar(SnackBar(content: Text('Couldn\'t update favorite: $e')));
  }
}

/// Compact YouTube "Subscribe"-style button under a performer's name.
class FavoriteButton extends ConsumerWidget {
  const FavoriteButton({super.key, required this.performer});

  final Performer performer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorite = effectiveFavorite(ref, performer);
    final colors = Theme.of(context).colorScheme;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: favorite
          ? FilledButton.tonalIcon(
              key: const ValueKey('favorited'),
              style: FilledButton.styleFrom(visualDensity: VisualDensity.compact),
              onPressed: () => _toggle(context, ref, performer),
              icon: const Icon(Icons.favorite, color: Colors.redAccent),
              label: const Text('Favorited'),
            )
          : FilledButton.icon(
              key: const ValueKey('favorite'),
              style: FilledButton.styleFrom(
                backgroundColor: colors.onSurface,
                foregroundColor: colors.surface,
                visualDensity: VisualDensity.compact,
              ),
              onPressed: () => _toggle(context, ref, performer),
              icon: const Icon(Icons.favorite_border),
              label: const Text('Favorite'),
            ),
    );
  }
}

/// Compact heart toggle, e.g. on performer tiles.
class FavoriteIconButton extends ConsumerWidget {
  const FavoriteIconButton({super.key, required this.performer});

  final Performer performer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorite = effectiveFavorite(ref, performer);
    return IconButton(
      tooltip: favorite ? 'Remove from favorites' : 'Add to favorites',
      visualDensity: VisualDensity.compact,
      style: IconButton.styleFrom(backgroundColor: Colors.black38),
      onPressed: () => _toggle(context, ref, performer),
      icon: Icon(
        favorite ? Icons.favorite : Icons.favorite_border,
        color: favorite ? Colors.redAccent : Colors.white,
        size: 20,
      ),
    );
  }
}
