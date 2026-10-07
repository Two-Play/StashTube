import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/list_queries.dart';
import '../../data/providers.dart';
import '../../widgets/scene_feed.dart';
import '../../widgets/scene_shelf.dart';
import '../cast/cast_ui.dart';
import '../player/player_providers.dart';
import '../shell/navigation.dart';
import '../shorts/shorts_feed.dart';
import '../shorts/shorts_page.dart';
import '../shorts/shorts_shelf.dart';
import '../../l10n/l10n.dart';
import '../settings/settings_button.dart';

/// YouTube-style home: logo app bar, filter chips and an endless scene feed.
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  // Held in state so the shuffle seed stays stable across rebuilds.
  final _query = SceneQuery(sort: SceneSort.recentlyAdded);
  final _continueWatching = SceneQuery(sort: SceneSort.lastPlayed, inProgressOnly: true);
  final _fromFavorites = SceneQuery.newFromFavorites();

  /// The app bar hides while scrolling down and comes back when scrolling
  /// up or at the top, like YouTube's.
  bool _barVisible = true;

  bool _onScroll(ScrollUpdateNotification n) {
    if (n.depth != 0 || n.metrics.axis != Axis.vertical) return false;
    final delta = n.scrollDelta ?? 0;
    final visible = n.metrics.pixels <= kToolbarHeight || (delta < -2 || (delta <= 2 && _barVisible));
    if (visible != _barVisible) setState(() => _barVisible = visible);
    return false;
  }

  void _refreshShelves() {
    ref.invalidate(shortsFeedProvider);
    ref.invalidate(sceneListProvider(_continueWatching));
    ref.invalidate(sceneListProvider(_fromFavorites));
    ref.invalidate(savedSceneFiltersProvider);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // A scene that isn't in "Continue watching" yet got its first saved
    // position: reload the shelf so it shows up.
    ref.listen(resumeTimesProvider, (previous, next) {
      final shown = ref.read(sceneListProvider(_continueWatching)).current?.items.map((s) => s.id).toSet() ?? {};
      final added = next.entries.any((e) => e.value > 0 && previous?[e.key] == null && !shown.contains(e.key));
      if (added) ref.invalidate(sceneListProvider(_continueWatching));
    });

    return Scaffold(
      body: SafeArea(
        bottom: false,
        // The app bar sits above the list instead of in it: a floating
        // sliver app bar snapped away when tapped mid-animation, so its
        // buttons didn't react.
        child: Stack(
          children: [
            NotificationListener<ScrollUpdateNotification>(
              onNotification: _onScroll,
              child: SceneFeedView(
                initialQuery: _query,
                filterable: true,
                showSavedFilters: true,
                onRefresh: _refreshShelves,
                headerSlivers: [
                  const SliverToBoxAdapter(child: SizedBox(height: kToolbarHeight)),
                  SliverToBoxAdapter(
                    child: SceneShelf(
                      title: context.l10n.continueWatching,
                      icon: Icons.history,
                      query: _continueWatching,
                      hideFinished: true,
                    ),
                  ),
                  const SliverToBoxAdapter(child: ShortsShelf()),
                  SliverToBoxAdapter(
                    child: SceneShelf(
                      title: context.l10n.newFromFavorites,
                      icon: Icons.favorite_border,
                      query: _fromFavorites,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedSlide(
              offset: _barVisible ? Offset.zero : const Offset(0, -1),
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: SizedBox(
                height: kToolbarHeight,
                child: AppBar(
                  primary: false,
                  titleSpacing: 12,
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: colors.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(Icons.play_arrow, color: colors.onPrimary, size: 20),
                      ),
                      const SizedBox(width: 6),
                      const Flexible(
                        child: Text(
                          'Stash',
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: -0.5),
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    const CastButton(),
                    IconButton(
                      tooltip: context.l10n.tabShorts,
                      icon: const Icon(Icons.slow_motion_video),
                      onPressed: () => openPage(ref, const ShortsPage()),
                    ),
                    IconButton(
                      tooltip: context.l10n.search,
                      icon: const Icon(Icons.search),
                      onPressed: () => openSearch(ref),
                    ),
                    const SettingsButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
