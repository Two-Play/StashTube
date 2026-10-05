import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/format.dart';
import '../../data/models/list_queries.dart';
import '../../data/models/studio.dart';
import '../../data/providers.dart';
import '../../widgets/paged_sliver.dart';
import '../../widgets/stash_image.dart';
import '../shell/navigation.dart';

/// All studios as a channel list.
class StudiosPage extends ConsumerWidget {
  const StudiosPage({super.key});

  static const _query = StudioQuery();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = studioListProvider(_query);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Studios'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () => openSearch(ref)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => refreshFuture(ref, provider.future),
        child: LoadMoreListener(
          onLoadMore: () => ref.read(provider.notifier).loadMore(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              PagedSliver<Studio>(
                value: ref.watch(provider),
                emptyMessage: 'No studios found',
                onRetry: () => ref.invalidate(provider),
                onLoadMore: () => ref.read(provider.notifier).loadMore(),
                itemBuilder: (_, studio) => ListTile(
                  leading: ChannelAvatar(name: studio.name, imageUrl: studio.imageUrl, radius: 24),
                  title: Text(studio.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text([
                    formatCount(studio.sceneCount, 'scene'),
                    if (studio.parent != null) 'Part of ${studio.parent!.name}',
                  ].join(' • ')),
                  onTap: () => openStudio(ref, studio.id),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
