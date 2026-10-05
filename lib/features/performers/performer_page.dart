import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/format.dart';
import '../../data/models/list_queries.dart';
import '../../data/providers.dart';
import '../../widgets/channel_header.dart';
import '../../widgets/performer_tile.dart';
import '../../widgets/scene_feed.dart';
import '../../widgets/status_views.dart';
import '../edit/edit_pages.dart';
import '../shell/navigation.dart';
import 'favorite_button.dart';

/// Performer "channel": header with profile info and all of their scenes.
class PerformerPage extends ConsumerWidget {
  const PerformerPage({super.key, required this.performerId});

  final String performerId;

  static const _sorts = [SceneSort.newest, SceneSort.recentlyAdded, SceneSort.topRated, SceneSort.random];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final performer = ref.watch(performerProvider(performerId));

    return Scaffold(
      appBar: AppBar(
        title: Text(performer.value?.name ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          if (performer.value case final value?)
            IconButton(
              tooltip: 'Edit',
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => openPage(ref, PerformerEditPage(performer: value)),
            ),
        ],
      ),
      body: SceneFeedView(
        initialQuery: SceneQuery(sort: SceneSort.newest, performerId: performerId),
        sorts: _sorts,
        headerSlivers: [
          SliverToBoxAdapter(
            child: performer.when(
              loading: () => const LoadingView(),
              error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(performerProvider(performerId))),
              data: (p) {
                final age = p.ageAt(DateTime.now());
                return ChannelHeader(
                  name: p.disambiguation == null ? p.name : '${p.name} (${p.disambiguation})',
                  imageUrl: p.imageUrl,
                  leadingBadge: p.country == null ? null : CountryFlagIcon(code: p.country!),
                  subtitle: [
                    formatCount(p.sceneCount, 'scene'),
                    if (age != null) '$age years',
                  ].join(' • '),
                  description: p.details,
                  action: FavoriteButton(performer: p),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
