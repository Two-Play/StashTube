import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/list_queries.dart';
import '../../widgets/scene_feed.dart';
import '../shell/navigation.dart';
import 'galleries_tab.dart';
import 'images_tab.dart';
import 'stats_tab.dart';

/// Library tab: every scene as a grid, every image, galleries and statistics.
class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage> {
  final _scenes = SceneQuery(sort: SceneSort.recentlyAdded);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Library'),
          actions: [IconButton(icon: const Icon(Icons.search), onPressed: () => openSearch(ref))],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.movie_outlined), text: 'Scenes'),
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
