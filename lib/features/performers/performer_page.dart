import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/list_queries.dart';
import '../../data/providers.dart';
import '../../widgets/channel_header.dart';
import '../../widgets/performer_tile.dart';
import '../../widgets/scene_feed.dart';
import '../../widgets/status_views.dart';
import '../edit/edit_common.dart';
import '../edit/edit_pages.dart';
import '../shell/navigation.dart';
import '../shorts/shorts_feed.dart';
import '../shorts/shorts_page.dart';
import 'favorite_button.dart';
import '../../l10n/l10n.dart';

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
              tooltip: context.l10n.edit,
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => openEditor(context, ref, PerformerEditPage(performer: value)),
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
                    context.l10n.scenesCount(p.sceneCount),
                    if (age != null) context.l10n.ageYears(age),
                  ].join(' • '),
                  description: p.details,
                  action: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FavoriteButton(performer: p),
                      _ShortsButton(performerId: performerId, name: p.name),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Opens the performer's short videos in the shorts player; appears (with
/// a little pop) once it is known that there are any.
class _ShortsButton extends ConsumerWidget {
  const _ShortsButton({required this.performerId, required this.name});

  final String performerId;
  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(performerShortsCountProvider(performerId)).value ?? 0;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOutBack,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(scale: Tween(begin: 0.6, end: 1.0).animate(animation), child: child),
      ),
      child: count == 0
          ? const SizedBox.shrink()
          : OutlinedButton.icon(
              style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact),
              onPressed: () => openPage(
                ref,
                ShortsPage(source: ShortsSource.performer(performerId, title: name)),
              ),
              icon: const Icon(Icons.slow_motion_video),
              label: Text(context.l10n.performerShorts(count)),
            ),
    );
  }
}
