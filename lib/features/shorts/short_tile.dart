import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/theme.dart';
import '../../core/utils/format.dart';
import '../../l10n/l10n.dart';
import '../../widgets/scene_card.dart';
import '../../widgets/stash_image.dart';
import '../settings/scene_card_config.dart';
import 'short.dart';

/// A short's 9:16 tile (the home shelf, a channel's shorts): still, title
/// and length. A marker short shows its marker's still and title with a
/// bookmark badge.
class ShortTile extends ConsumerWidget {
  const ShortTile({super.key, required this.short, required this.onTap});

  final Short short;
  final VoidCallback onTap;

  /// What a screen reader says: the title and the spoken length; for a
  /// marker "Marker: Kiss, Scene title, 20 seconds".
  static String semanticsLabel(AppLocalizations l, Short short) => [
        if (short.isMarker) ...[l.shortMarkerSemantics(short.title), short.scene.title] else short.title,
        if (short.duration > 0) spokenDuration(l, short.duration),
      ].join(', ');

  @override
  // Sized by its parent (9:16); the still fills it when that crops little,
  // else it shows whole on black (a landscape scene).
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    return SizedBox.expand(
      child: ClipRRect(
        borderRadius: AppRadius.thumbnailBorder,
        child: Material(
          color: Colors.black,
          child: TileSemantics(
            label: semanticsLabel(context.l10n, short),
            child: InkWell(
              onTap: onTap,
              child: ExcludeSemantics(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Cropped only as far as the video page would crop it.
                    LayoutBuilder(
                      builder: (context, box) => StashImage(
                        short.marker?.screenshotUrl ?? short.scene.screenshotUrl,
                        fit: thumbnailFit(
                          ref,
                          short.aspect,
                          box.maxHeight > 0 && box.maxHeight.isFinite ? box.maxWidth / box.maxHeight : 9 / 16,
                        ),
                        fallbackIcon: short.isMarker ? Icons.bookmark_outline : Icons.slow_motion_video,
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.center,
                          colors: [colors.videoScrim, Colors.transparent],
                        ),
                      ),
                    ),
                    if (short.isMarker)
                      Positioned(
                        left: 6,
                        top: 6,
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: colors.badgeBackground, borderRadius: AppRadius.badgeBorder),
                          child: Padding(
                            padding: const EdgeInsets.all(3),
                            child: Icon(Icons.bookmark, color: colors.onBadge, size: 14),
                          ),
                        ),
                      ),
                    Positioned(
                      left: 6,
                      right: 6,
                      bottom: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            short.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: AppTextSize.overlayLabel,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (short.duration > 0)
                            Text(
                              formatDuration(short.duration),
                              style: const TextStyle(color: Colors.white70, fontSize: AppTextSize.overlayCaption),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
