import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/format.dart';
import '../../widgets/scene_card.dart';
import '../../widgets/status_views.dart';
import '../player/player_providers.dart';
import 'watch_later.dart';

/// Saved scenes (9.4): play all as a queue, swipe to remove.
class WatchLaterTab extends ConsumerWidget {
  const WatchLaterTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scenes = ref.watch(watchLaterScenesProvider);
    return switch (scenes) {
      AsyncValue(:final value?) when value.isEmpty => const Center(
          child: EmptyView(message: 'Nothing saved yet.\nUse "Later" on a scene to add it.'),
        ),
      AsyncValue(:final value?) => ListView.builder(
          itemCount: value.length + 1,
          itemBuilder: (context, i) {
            if (i == 0) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(formatCount(value.length, 'scene'), style: Theme.of(context).textTheme.titleMedium),
                    ),
                    FilledButton.icon(
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Play all'),
                      onPressed: () => ref.read(nowPlayingProvider.notifier).playQueue(value, title: 'Watch later'),
                    ),
                  ],
                ),
              );
            }
            final scene = value[i - 1];
            return Dismissible(
              key: ValueKey(scene.id),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Theme.of(context).colorScheme.errorContainer,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 24),
                child: const Icon(Icons.delete_outline),
              ),
              onDismissed: (_) => ref.read(watchLaterProvider.notifier).remove(scene.id),
              // Tapping plays the list from this scene on.
              child: SceneListTile(
                scene: scene,
                onTap: () => ref.read(nowPlayingProvider.notifier).playQueue(value, title: 'Watch later', start: i - 1),
              ),
            );
          },
        ),
      AsyncError(:final error) => ErrorView(error: error, onRetry: () => ref.invalidate(watchLaterScenesProvider)),
      _ => const LoadingView(),
    };
  }
}
