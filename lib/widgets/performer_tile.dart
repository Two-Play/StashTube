import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/utils/format.dart';
import '../data/models/performer.dart';
import '../features/performers/favorite_button.dart';
import '../features/shell/navigation.dart';
import 'stash_image.dart';

/// Portrait card for the performers grid.
class PerformerTile extends ConsumerWidget {
  const PerformerTile({super.key, required this.performer});

  final Performer performer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => openPerformer(ref, performer.id),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  StashImage(performer.imageUrl, fallbackIcon: Icons.person),
                  Positioned(top: 4, left: 4, child: FavoriteIconButton(performer: performer)),
                  if (performer.country != null)
                    Positioned(top: 8, right: 8, child: CountryFlagIcon(code: performer.country!)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(performer.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleSmall),
          Text(
            formatCount(performer.sceneCount, 'scene'),
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

/// Circle avatar with name, for horizontal "channel" rows.
class PerformerBubble extends ConsumerWidget {
  const PerformerBubble({super.key, required this.performer});

  final Performer performer;

  @override
  Widget build(BuildContext context, WidgetRef ref) => InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => openPerformer(ref, performer.id),
        child: SizedBox(
          width: 76,
          child: Column(
            children: [
              ChannelAvatar(name: performer.name, imageUrl: performer.imageUrl, radius: 30),
              const SizedBox(height: 6),
              Text(
                performer.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      );
}

class CountryFlagIcon extends StatelessWidget {
  const CountryFlagIcon({super.key, required this.code, this.width = 28});

  final String code;
  final double width;

  @override
  Widget build(BuildContext context) {
    try {
      return ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: CountryFlag.fromCountryCode(code, theme: ImageTheme(width: width, height: width * 0.7)),
      );
    } catch (_) {
      // Stash allows free-text countries; ignore anything that isn't a code.
      return const SizedBox.shrink();
    }
  }
}
