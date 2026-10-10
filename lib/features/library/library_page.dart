import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/list_queries.dart';
import '../../l10n/l10n.dart';
import '../../widgets/scene_feed.dart';
import '../search/search_page.dart';
import '../shell/navigation.dart';
import 'galleries_tab.dart';
import 'groups.dart';
import 'images_tab.dart';
import 'markers_tab.dart';
import 'stats_tab.dart';
import 'watch_later_tab.dart';
import '../settings/settings_button.dart';

/// The parts of the library. Each is a tab of [LibraryPage] and can also be
/// its own tab in the navigation bar ([LibrarySectionPage], 13.7).
enum LibrarySection {
  scenes(Icons.movie_outlined),
  history(Icons.history),
  watchLater(Icons.watch_later_outlined),
  groups(Icons.playlist_play),
  markers(Icons.bookmarks_outlined),
  images(Icons.image_outlined),
  galleries(Icons.photo_library_outlined),
  stats(Icons.insights_outlined);

  const LibrarySection(this.icon);

  final IconData icon;

  String label(AppLocalizations l) => switch (this) {
        scenes => l.libraryScenes,
        history => l.libraryHistory,
        watchLater => l.libraryWatchLater,
        groups => l.libraryGroups,
        markers => l.libraryMarkers,
        images => l.libraryImages,
        galleries => l.libraryGalleries,
        stats => l.libraryStats,
      };

  /// What the app bar's search button searches in this section.
  SearchScope get searchScope => switch (this) {
        images => SearchScope.images,
        galleries => SearchScope.galleries,
        _ => SearchScope.scenes,
      };

  Widget body(AppLocalizations l) => switch (this) {
        scenes => SceneFeedView(
            initialQuery: SceneQuery(sort: SceneSort.recentlyAdded),
            layout: SceneFeedLayout.grid,
            showCount: true,
            filterable: true,
          ),
        history => SceneFeedView(
            initialQuery: SceneQuery(sort: SceneSort.lastPlayed, playedOnly: true),
            sorts: const [],
            layout: SceneFeedLayout.list,
            emptyMessage: l.historyEmpty,
            emptyIcon: Icons.history,
            emptyHint: l.historyEmptyHint,
          ),
        watchLater => const WatchLaterTab(),
        groups => const GroupsTab(),
        markers => const MarkersTab(),
        images => const ImagesTab(),
        galleries => const GalleriesTab(),
        stats => const StatsTab(),
      };
}

/// Library tab: all [LibrarySection]s as swipeable tabs.
class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return DefaultTabController(
      length: LibrarySection.values.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.libraryTitle),
          actions: [
            // Below the tab controller, to search the selected section.
            Builder(
              builder: (context) => IconButton(
                tooltip: l.search,
                icon: const Icon(Icons.search),
                onPressed: () => openSearch(
                  ref,
                  scope: LibrarySection.values[DefaultTabController.of(context).index].searchScope,
                ),
              ),
            ),
            const SettingsButton(),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              for (final section in LibrarySection.values) Tab(icon: Icon(section.icon), text: section.label(l)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            for (final section in LibrarySection.values) _KeepAlive(child: section.body(l)),
          ],
        ),
      ),
    );
  }
}

/// One [LibrarySection] on its own, as a tab of the navigation bar.
class LibrarySectionPage extends ConsumerWidget {
  const LibrarySectionPage({super.key, required this.section});

  final LibrarySection section;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        appBar: AppBar(
          title: Text(section.label(context.l10n)),
          actions: [
            IconButton(
              tooltip: context.l10n.search,
              icon: const Icon(Icons.search),
              onPressed: () => openSearch(ref, scope: section.searchScope),
            ),
            const SettingsButton(),
          ],
        ),
        body: section.body(context.l10n),
      );
}

/// Keeps a tab's scroll position and loaded pages when switching tabs.
class _KeepAlive extends StatefulWidget {
  const _KeepAlive({required this.child});

  final Widget child;

  @override
  State<_KeepAlive> createState() => _KeepAliveState();
}

class _KeepAliveState extends State<_KeepAlive> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
