import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/scene_card.dart';
import '../../widgets/status_views.dart';
import '../player/player_providers.dart';
import 'watch_later.dart';
import '../../l10n/l10n.dart';

/// Saved scenes (9.4): play all as a queue, swipe to remove.
class WatchLaterTab extends ConsumerWidget {
  const WatchLaterTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scenes = ref.watch(watchLaterScenesProvider);
    return switch (scenes) {
      // A server switch reloads the list: don't show the old server's scenes.
      _ when scenes.isReloading => const LoadingView(),
      AsyncError(:final error) => ErrorView(error: error, onRetry: () => ref.invalidate(watchLaterScenesProvider)),
      AsyncValue(:final value?) when value.isEmpty => Center(
          child: EmptyView(
            message: context.l10n.watchLaterEmpty,
            icon: Icons.watch_later_outlined,
            hint: context.l10n.watchLaterEmptyHint,
          ),
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
                      child: Text(context.l10n.scenesCount(value.length), style: Theme.of(context).textTheme.titleMedium),
                    ),
                    FilledButton.icon(
                      icon: const Icon(Icons.play_arrow),
                      label: Text(context.l10n.playAll),
                      onPressed: () => ref.read(nowPlayingProvider.notifier).playQueue(value, title: context.l10n.libraryWatchLater),
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
                onTap: () => ref.read(nowPlayingProvider.notifier).playQueue(value, title: context.l10n.libraryWatchLater, start: i - 1),
              ),
            );
          },
        ),
      _ => const LoadingView(),
    };
  }
}

