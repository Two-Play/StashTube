import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/format.dart';
import '../../data/models/list_queries.dart';
import '../../data/providers.dart';
import '../../widgets/channel_header.dart';
import '../../widgets/scene_feed.dart';
import '../../widgets/status_views.dart';

/// Studio "channel": header and all scenes of the studio.
class StudioPage extends ConsumerWidget {
  const StudioPage({super.key, required this.studioId});

  final String studioId;

  static const _sorts = [SceneSort.newest, SceneSort.recentlyAdded, SceneSort.topRated, SceneSort.random];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studio = ref.watch(studioProvider(studioId));

    return Scaffold(
      appBar: AppBar(title: Text(studio.valueOrNull?.name ?? '')),
      body: SceneFeedView(
        initialQuery: SceneQuery(sort: SceneSort.newest, studioId: studioId),
        sorts: _sorts,
        headerSlivers: [
          SliverToBoxAdapter(
            child: studio.when(
              loading: () => const LoadingView(),
              error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(studioProvider(studioId))),
              data: (s) => ChannelHeader(
                name: s.name,
                imageUrl: s.imageUrl,
                subtitle: formatCount(s.sceneCount, 'scene'),
                description: s.details,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
