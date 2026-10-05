import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/list_queries.dart';
import '../../data/providers.dart';
import '../../widgets/scene_feed.dart';
import '../../widgets/scene_shelf.dart';
import '../cast/cast_ui.dart';
import '../player/player_providers.dart';
import '../shell/navigation.dart';
import '../../l10n/l10n.dart';

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

  void _refreshShelves() {
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
        child: SceneFeedView(
          initialQuery: _query,
          filterable: true,
          showSavedFilters: true,
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
                    child: Icon(Icons.play_arrow, color: colors.onPrimary, size: 20),
                  ),
                  const SizedBox(width: 6),
                  const Text('Stash', style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: -0.5)),
                ],
              ),
              actions: [
                const CastButton(),
                IconButton(
                  tooltip: context.l10n.search,
                  icon: const Icon(Icons.search),
                  onPressed: () => openSearch(ref),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: SceneShelf(
                title: context.l10n.continueWatching,
                icon: Icons.history,
                query: _continueWatching,
                hideFinished: true,
              ),
            ),
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
    );
  }
}
