import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/list_queries.dart';
import '../../data/models/studio.dart';
import '../../data/providers.dart';
import '../../widgets/paged_sliver.dart';
import '../../widgets/stash_image.dart';
import '../search/search_page.dart';
import '../shell/navigation.dart';
import '../../l10n/l10n.dart';
import '../settings/settings_button.dart';

/// All studios as a channel list.
class StudiosPage extends ConsumerWidget {
  const StudiosPage({super.key});

  static const _query = StudioQuery();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = studioListProvider(_query);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.studiosTitle),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () => openSearch(ref, scope: SearchScope.studios)),
          const SettingsButton(),
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
                emptyMessage: context.l10n.studiosEmpty,
                emptyIcon: Icons.subscriptions_outlined,
                emptyHint: context.l10n.studiosEmptyHint,
                onRetry: () => ref.invalidate(provider),
                onLoadMore: () => ref.read(provider.notifier).loadMore(),
                onGoToPage: (page) => ref.read(provider.notifier).goToPage(page),
                columnWidth: 400,
                itemBuilder: (_, studio) => StudioListTile(studio: studio),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A studio as a channel row; opens its page.
class StudioListTile extends ConsumerWidget {
  const StudioListTile({super.key, required this.studio});

  final Studio studio;

  @override
  Widget build(BuildContext context, WidgetRef ref) => ListTile(
        leading: ChannelAvatar(name: studio.name, imageUrl: studio.imageUrl, radius: 24),
        title: Text(studio.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text([
          context.l10n.scenesCount(studio.sceneCount),
          if (studio.parent != null) context.l10n.partOf(studio.parent!.name),
        ].join(' • ')),
        onTap: () => openStudio(ref, studio.id),
      );
}
