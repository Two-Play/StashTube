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

/// The short a shelf tile shows: the first of its lane's queue that no
/// earlier tile shows, and where it is in that queue.
typedef ShelfPick = ({Scene scene, int index});

/// One pick per lane (null while a lane has none to offer), so the four
/// tiles never show the same short.
List<ShelfPick?> shelfPicks(List<List<Scene>> lanes) {
  final shown = <String>{};
  return [
    for (final items in lanes)
      () {
        final index = items.indexWhere((s) => !shown.contains(s.id));
        if (index < 0) return null;
        shown.add(items[index].id);
        return (scene: items[index], index: index);
      }(),
  ];
}

/// Four portrait shorts as a 2×2 grid on the home page (4.23). Every tile
/// has a queue of its own ([ShortsSource.lane]): tapping it opens the
/// shorts at that short, continuing with that queue. The heading opens the
/// shorts tab (or the feed on top of the home page). Hidden when there are
/// no shorts.
class ShortsShelf extends ConsumerWidget {
  const ShortsShelf({super.key});

  static const count = 4;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watched here so the queues stay loaded while their shorts are open.
    final picks = shelfPicks([
      for (var lane = 0; lane < count; lane++) ref.watch(shortsFeedFamily(ShortsSource.lane(lane))).items,
    ]);
    if (picks.every((p) => p == null)) return const SizedBox.shrink();
    final theme = Theme.of(context);

    void openFeed() {
      if (ref.read(navBarConfigProvider).isVisible(AppTab.shorts)) {
        ref.read(currentTabProvider.notifier).select(AppTab.shorts);
      } else {
        openPage(ref, const ShortsPage());
      }
    }

    Widget tile(int lane) {
      final pick = picks[lane];
      return Expanded(
        child: pick == null
            ? const SizedBox.shrink()
            : _ShortTile(
                scene: pick.scene,
                onTap: () => openPage(ref, ShortsPage(source: ShortsSource.lane(lane), initialIndex: pick.index)),
              ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: openFeed,
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
