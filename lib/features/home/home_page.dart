import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/list_queries.dart';
import '../../data/providers.dart';
import '../../widgets/scene_feed.dart';
import '../../widgets/scene_shelf.dart';
import '../player/player_providers.dart';
import '../shell/navigation.dart';

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
  final _fromFavorites = SceneQuery(sort: SceneSort.recentlyAdded, favoritePerformersOnly: true);

  void _refreshShelves() {
    ref.invalidate(sceneListProvider(_continueWatching));
    ref.invalidate(sceneListProvider(_fromFavorites));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // A scene that isn't in "Continue watching" yet got its first saved
    // position: reload the shelf so it shows up.
    ref.listen(resumeTimesProvider, (previous, next) {
      final shown = ref.read(sceneListProvider(_continueWatching)).valueOrNull?.items.map((s) => s.id).toSet() ?? {};
      final added = next.entries.any((e) => e.value > 0 && previous?[e.key] == null && !shown.contains(e.key));
      if (added) ref.invalidate(sceneListProvider(_continueWatching));
    });

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SceneFeedView(
          initialQuery: _query,
          onRefresh: _refreshShelves,
          headerSlivers: [
            SliverAppBar(
              floating: true,
              snap: true,
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
                    child: const Icon(Icons.play_arrow, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 6),
                  const Text('Stash', style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: -0.5)),
                ],
              ),
              actions: [
                IconButton(
                  tooltip: 'Search',
                  icon: const Icon(Icons.search),
                  onPressed: () => openSearch(ref),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: SceneShelf(
                title: 'Continue watching',
                icon: Icons.history,
                query: _continueWatching,
                hideFinished: true,
              ),
            ),
            SliverToBoxAdapter(
              child: SceneShelf(
                title: 'New from favorites',
                icon: Icons.favorite_border,
                query: _fromFavorites,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
