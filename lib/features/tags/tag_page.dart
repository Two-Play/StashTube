import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/format.dart';
import '../../data/models/list_queries.dart';
import '../../data/models/scene_filter.dart';
import '../../data/models/tag.dart';
import '../../data/providers.dart';
import '../../widgets/channel_header.dart';
import '../../widgets/scene_feed.dart';
import '../../widgets/status_views.dart';

/// All scenes with one tag (8.1).
class TagPage extends ConsumerWidget {
  const TagPage({super.key, required this.tagId});

  final String tagId;

  static const _sorts = [SceneSort.newest, SceneSort.recentlyAdded, SceneSort.topRated, SceneSort.random];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tag = ref.watch(tagProvider(tagId));

    return Scaffold(
      appBar: AppBar(title: Text(tag.value == null ? '' : '#${tag.value!.name}', maxLines: 1, overflow: TextOverflow.ellipsis)),
      body: SceneFeedView(
        initialQuery: SceneQuery(
          sort: SceneSort.newest,
          // The filter compares tags by id only.
          filter: SceneFilter(tags: [Tag(id: tagId, name: '')]),
        ),
        sorts: _sorts,
        headerSlivers: [
          SliverToBoxAdapter(
            child: tag.when(
              loading: () => const LoadingView(),
              error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(tagProvider(tagId))),
              data: (t) => ChannelHeader(
                name: '#${t.name}',
                imageUrl: t.imageUrl,
                subtitle: formatCount(t.sceneCount, 'scene'),
                description: t.description,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
