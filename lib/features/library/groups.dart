import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/format.dart';
import '../../data/models/group.dart';
import '../../data/models/list_queries.dart';
import '../../data/providers.dart';
import '../../data/repositories/stash_repository.dart';
import '../../widgets/paged_sliver.dart';
import '../../widgets/scene_feed.dart';
import '../../widgets/stash_image.dart';
import '../../widgets/status_views.dart';
import '../player/player_providers.dart';
import '../shell/navigation.dart';
import '../../l10n/l10n.dart';

/// Groups (formerly "movies") as playlists (9.3). Needs Stash v0.27+.
class GroupsTab extends ConsumerWidget {
  const GroupsTab({super.key});

  static const _query = GroupQuery();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = groupListProvider(_query);
    return RefreshIndicator(
      onRefresh: () => refreshFuture(ref, provider.future),
      child: LoadMoreListener(
        onLoadMore: () => ref.read(provider.notifier).loadMore(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            PagedSliver<Group>(
              value: ref.watch(provider),
              emptyMessage: context.l10n.groupsEmpty,
              emptyIcon: Icons.video_library_outlined,
              emptyHint: context.l10n.groupsEmptyHint,
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 160,
                childAspectRatio: 0.52,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              onRetry: () => ref.invalidate(provider),
              onLoadMore: () => ref.read(provider.notifier).loadMore(),
              itemBuilder: (_, group) => GroupTile(group: group),
            ),
          ],
        ),
      ),
    );
  }
}

class GroupTile extends ConsumerWidget {
  const GroupTile({super.key, required this.group});

  final Group group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => openPage(ref, GroupPage(groupId: group.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 2 / 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: StashImage(group.frontImageUrl, fallbackIcon: Icons.video_library_outlined),
            ),
          ),
          const SizedBox(height: 6),
          Text(group.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleSmall),
          Text(
            context.l10n.scenesCount(group.sceneCount),
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

/// A group: poster, details, "Play all" and its scenes in group order.
class GroupPage extends ConsumerWidget {
  const GroupPage({super.key, required this.groupId});

  final String groupId;

  Future<void> _playAll(BuildContext context, WidgetRef ref, Group group) async {
    final messenger = ScaffoldMessenger.of(context);
    final l = context.l10n;
    try {
      final result = await ref
          .read(stashRepositoryProvider)
          .findScenes(SceneQuery(groupId: groupId, sort: SceneSort.groupOrder), perPage: 500);
      ref.read(nowPlayingProvider.notifier).playQueue(result.items, title: group.name);
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(l.groupLoadFailed(errorText(l, e)))));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final group = ref.watch(groupProvider(groupId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(group.value?.name ?? '', maxLines: 1, overflow: TextOverflow.ellipsis)),
      body: SceneFeedView(
        initialQuery: SceneQuery(groupId: groupId, sort: SceneSort.groupOrder),
        sorts: const [],
        layout: SceneFeedLayout.list,
        emptyMessage: context.l10n.groupNoScenes,
        emptyIcon: Icons.playlist_remove,
        headerSlivers: [
          SliverToBoxAdapter(
            child: group.when(
              loading: () => const LoadingView(),
              error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(groupProvider(groupId))),
              data: (g) => Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 110,
                      child: AspectRatio(
                        aspectRatio: 2 / 3,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: StashImage(g.frontImageUrl, fallbackIcon: Icons.video_library_outlined),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(g.name, maxLines: 3, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleLarge),
                          const SizedBox(height: 4),
                          Text(
                            [
                              context.l10n.scenesCount(g.sceneCount),
                              if (g.duration > 0) formatLongDuration(g.duration),
                              if (g.date != null) formatDate(g.date!),
                              if (g.studio != null) g.studio!.name,
                            ].join(' • '),
                            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                          ),
                          if (g.synopsis != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              g.synopsis!,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                          const SizedBox(height: 12),
                          FilledButton.icon(
                            icon: const Icon(Icons.play_arrow),
                            label: Text(context.l10n.playAll),
                            onPressed: g.sceneCount == 0 ? null : () => _playAll(context, ref, g),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
