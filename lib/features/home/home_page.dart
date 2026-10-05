import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/list_queries.dart';
import '../../widgets/scene_feed.dart';
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

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SceneFeedView(
          initialQuery: _query,
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
          ],
        ),
      ),
    );
  }
}
