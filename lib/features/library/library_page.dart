import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/list_queries.dart';
import '../../widgets/scene_feed.dart';
import '../shell/navigation.dart';
import 'galleries_tab.dart';
import 'groups.dart';
import 'images_tab.dart';
import 'stats_tab.dart';
import 'watch_later_tab.dart';

/// Library tab: all scenes, history, watch later, groups, images, galleries
/// and statistics.
class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage> {
  final _scenes = SceneQuery(sort: SceneSort.recentlyAdded);
  final _history = SceneQuery(sort: SceneSort.lastPlayed, playedOnly: true);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Library'),
          actions: [IconButton(icon: const Icon(Icons.search), onPressed: () => openSearch(ref))],
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(icon: Icon(Icons.movie_outlined), text: 'Scenes'),
              Tab(icon: Icon(Icons.history), text: 'History'),
              Tab(icon: Icon(Icons.watch_later_outlined), text: 'Watch later'),
              Tab(icon: Icon(Icons.video_library_outlined), text: 'Groups'),
              Tab(icon: Icon(Icons.image_outlined), text: 'Images'),
              Tab(icon: Icon(Icons.photo_library_outlined), text: 'Galleries'),
              Tab(icon: Icon(Icons.insights_outlined), text: 'Stats'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _KeepAlive(
              child: SceneFeedView(
                initialQuery: _scenes,
                layout: SceneFeedLayout.grid,
                showCount: true,
                filterable: true,
              ),
            ),
            _KeepAlive(
              child: SceneFeedView(
                initialQuery: _history,
                sorts: const [],
                layout: SceneFeedLayout.list,
                emptyMessage: 'Nothing watched yet',
                emptyIcon: Icons.history,
                emptyHint: 'Scenes you play show up here.',
              ),
            ),
            const WatchLaterTab(),
            const GroupsTab(),
            const ImagesTab(),
            const GalleriesTab(),
            const StatsTab(),
          ],
        ),
      ),
    );
  }
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
