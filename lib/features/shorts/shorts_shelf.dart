import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/format.dart';
import '../../data/models/scene.dart';
import '../../l10n/l10n.dart';
import '../../widgets/stash_image.dart';
import '../shell/nav_bar_config.dart';
import '../shell/navigation.dart';
import 'shorts_feed.dart';
import 'shorts_page.dart';

/// Four portrait shorts as a 2×2 grid on the home page (4.23). Tapping one
/// opens the shorts feed at that short: in the shorts tab if the bar has
/// it, else on top of the home page. Hidden when there are no shorts.
class ShortsShelf extends ConsumerWidget {
  const ShortsShelf({super.key});

  static const count = 4;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shorts = ref.watch(shortsFeedProvider).items.take(count).toList();
    if (shorts.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);

    void open(int index) {
      if (ref.read(navBarConfigProvider).isVisible(AppTab.shorts)) {
        ref.read(shortsJumpProvider.notifier).jumpTo(index);
        ref.read(currentTabProvider.notifier).select(AppTab.shorts);
      } else {
        openPage(ref, ShortsPage(initialIndex: index));
      }
    }

    Widget tile(int i) => Expanded(
          child: i < shorts.length ? _ShortTile(scene: shorts[i], onTap: () => open(i)) : const SizedBox.shrink(),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => open(0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            child: Row(
              children: [
                const Icon(Icons.slow_motion_video, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    context.l10n.tabShorts,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              Row(children: [tile(0), const SizedBox(width: 8), tile(1)]),
              const SizedBox(height: 8),
              Row(children: [tile(2), const SizedBox(width: 8), tile(3)]),
            ],
          ),
        ),
        const Divider(height: 24),
      ],
    );
  }
}

class _ShortTile extends StatelessWidget {
  const _ShortTile({required this.scene, required this.onTap});

  final Scene scene;
  final VoidCallback onTap;

  @override
  // Portrait, but shorter than 9:16 so the 2×2 grid fits on screen; the
  // screenshot is cropped to fill it.
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 3 / 4,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.black,
            child: InkWell(
              onTap: onTap,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  StashImage(scene.screenshotUrl, fallbackIcon: Icons.slow_motion_video),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                        colors: [Colors.black87, Colors.transparent],
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
                          scene.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        if (scene.duration > 0)
                          Text(
                            formatDuration(scene.duration),
                            style: const TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
