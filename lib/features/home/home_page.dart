import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/haptics.dart';
import '../../data/models/list_queries.dart';
import '../../data/providers.dart';
import '../../data/repositories/stash_repository.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/scene_feed.dart';
import '../../widgets/scene_shelf.dart';
import '../../widgets/status_views.dart';
import '../cast/cast_ui.dart';
import '../player/player_providers.dart';
import '../shell/navigation.dart';
import '../shorts/shorts_feed.dart';
import '../shorts/shorts_shelf.dart';
import '../subscriptions/last_visit.dart';
import '../subscriptions/new_scenes.dart';
import '../subscriptions/subscriptions_page.dart';
import '../../l10n/l10n.dart';
import '../server_tasks/server_tasks_page.dart';
import '../auth/server_avatar.dart';
import '../settings/settings_button.dart';

/// YouTube-style home: logo app bar, sticky filter chips, shelves and an
/// endless scene feed.
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

  /// The dice: plays one scene from the whole library, picked by Stash
  /// (a single page of one, sorted `random_<seed>`).
  Future<void> _playRandom() async {
    Haptics.medium();
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    try {
      final page = await ref
          .read(stashRepositoryProvider)
          .findScenes(SceneQuery(sort: SceneSort.random), perPage: 1);
      if (!mounted) return;
      final scene = page.items.firstOrNull;
      if (scene == null) {
        messenger.showSnackBar(SnackBar(content: Text(l.randomSceneNone)));
      } else {
        ref.read(nowPlayingProvider.notifier).play(scene);
      }
    } catch (e) {
      if (!mounted) return;
      Haptics.error();
      messenger.showSnackBar(SnackBar(content: Text(errorText(l, e))));
    }
  }

  void _refreshShelves() {
    ref.invalidate(newScenesSinceLastVisitProvider);
    ref.invalidate(shortsFeedFamily); // the shelf's queues
    ref.invalidate(sceneListProvider(_continueWatching));
    ref.invalidate(sceneListProvider(_fromFavorites));
    ref.invalidate(savedSceneFiltersProvider);
  }

  @override
  Widget build(BuildContext context) {

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
                // The chips stay under the app bar, or at the top while it
                // is hidden (HOME-1).
                pinChips: true,
                chipsTopSpace: kToolbarHeight,
                keepChipsTopSpace: _barVisible,
                unfilteredEmptyView: EmptyView(
                  message: context.l10n.homeEmptyTitle,
                  hint: context.l10n.homeEmptyHint,
                  icon: Icons.video_library_outlined,
                  actionLabel: context.l10n.openServerTasks,
                  actionIcon: Icons.manage_search,
                  onAction: () => openSettings(context, ref, initialPage: const ServerTasksPage()),
                ),
                belowChipsSlivers: [
                  // "N new videos since your last visit" (NOTIF-1).
                  const SliverToBoxAdapter(child: NewSinceLastVisitBanner()),
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
                      onSeeAll: () {
                        Haptics.selection();
                        openPage(ref, const SubscriptionsPage());
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Clipped and faded: the slide alone only moves the painting, so
            // the bar showed over the status bar.
            ClipRect(
              child: AnimatedSlide(
                offset: _barVisible ? Offset.zero : const Offset(0, -1),
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                child: AnimatedOpacity(
                  opacity: _barVisible ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: IgnorePointer(
                    ignoring: !_barVisible,
                    child: SizedBox(
                      height: kToolbarHeight,
                      child: AppBar(
                        primary: false,
                        titleSpacing: 12,
                        title: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const AppLogo(size: 30, background: AppLogo.tile),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                context.l10n.appTitle,
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: -0.5),
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          const CastButton(),
                          IconButton(
                            tooltip: context.l10n.randomScene,
                            icon: const Icon(Icons.casino_outlined),
                            onPressed: _playRandom,
                          ),
                          IconButton(
                            tooltip: context.l10n.search,
                            icon: const Icon(Icons.search),
                            onPressed: () => openSearch(ref),
                          ),
                          const ServerAvatarButton(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
