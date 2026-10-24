import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/l10n.dart';
import '../../widgets/skeleton.dart';
import '../../widgets/sliver_columns.dart';
import '../shell/nav_bar_config.dart';
import '../shell/navigation.dart';
import 'short.dart';
import 'short_tile.dart';
import 'shorts_feed.dart';
import 'shorts_page.dart';

/// The short a shelf tile shows: the first of its lane's queue that no
/// earlier tile shows, where it is in that queue, and the lane.
typedef ShelfPick = ({Short short, int index, int lane});

/// One pick per tile (null while its lane has none to offer), so the tiles
/// never show the same short. Tile `i` takes from lane `i % lanes.length`,
/// further down the queue each round; [tiles] defaults to one per lane.
List<ShelfPick?> shelfPicks(List<List<Short>> lanes, {int? tiles}) {
  final shown = <String>{};
  final from = List.filled(lanes.length, 0);
  return [
    for (var tile = 0; tile < (tiles ?? lanes.length); tile++)
      () {
        final lane = tile % lanes.length;
        final items = lanes[lane];
        final index = items.indexWhere((s) => !shown.contains(s.key), from[lane]);
        if (index < 0) return null;
        shown.add(items[index].key);
        from[lane] = index + 1;
        return (short: items[index], index: index, lane: lane);
      }(),
  ];
}

/// Portrait shorts as a horizontal row on the home page (4.23, HOME-1):
/// about 2.5 tiles show on a phone, more on wide screens. Every tile takes
/// from one of [count] queues ([ShortsSource.lane]): tapping it opens the
/// shorts at that short, continuing with that queue. The heading opens the
/// shorts tab (or the feed on top of the home page). Placeholders while
/// loading; hidden when there are no shorts.
class ShortsShelf extends ConsumerWidget {
  const ShortsShelf({super.key});

  /// The number of queues (lanes).
  static const count = 4;

  /// The row's height; the tiles are 9:16.
  static const double height = 240;
  static const double tileWidth = height * 9 / 16;
  static const double _spacing = 8;

  /// Tiles for a row [width] wide: one per lane on phones, enough to fill
  /// the row on wide screens.
  static int tilesFor(double width) {
    if (width < kWideLayoutBreakpoint) return count;
    return ((width - 24) / (tileWidth + _spacing)).ceil().clamp(count, 3 * count);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watched here so the queues stay loaded while their shorts are open.
    final lanes = [for (var lane = 0; lane < count; lane++) ref.watch(shortsFeedFamily(ShortsSource.lane(lane)))];
    final loading = lanes.every((l) => l.items.isEmpty) && lanes.any((l) => l.isLoading);
    if (!loading && lanes.every((l) => l.items.isEmpty)) return const SizedBox.shrink();
    final theme = Theme.of(context);

    void openFeed() {
      if (ref.read(navBarConfigProvider).isVisible(AppTab.shorts)) {
        ref.read(currentTabProvider.notifier).select(AppTab.shorts);
      } else {
        openPage(ref, const ShortsPage());
      }
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
        if (loading)
          const ShelfSkeleton(
            height: height,
            itemWidth: tileWidth,
            spacing: _spacing,
            itemBuilder: _tileSkeleton,
          )
        else
          LayoutBuilder(builder: (context, constraints) {
            final picks = shelfPicks(
              [for (final l in lanes) l.items],
              tiles: tilesFor(constraints.maxWidth),
            ).nonNulls.toList();
            return SizedBox(
              height: height,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: picks.length,
                separatorBuilder: (_, _) => const SizedBox(width: _spacing),
                itemBuilder: (_, i) {
                  final pick = picks[i];
                  return SizedBox(
                    width: tileWidth,
                    child: ShortTile(
                      short: pick.short,
                      onTap: () => openPage(
                        ref,
                        ShortsPage(source: ShortsSource.lane(pick.lane), initialIndex: pick.index),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        const Divider(height: 24),
      ],
    );
  }
}

Widget _tileSkeleton(BuildContext context) => const SkeletonBox();
