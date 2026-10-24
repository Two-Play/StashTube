import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/scene.dart';
import '../../widgets/scene_card.dart';
import '../../widgets/sliver_columns.dart';
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                EmptyView(
                  message: context.l10n.watchLaterEmpty,
                  icon: Icons.watch_later_outlined,
                  hint: context.l10n.watchLaterEmptyHint,
                ),
                const WatchLaterDeviceOnlyNote(),
              ],
            ),
          ),
        ),
      AsyncValue(:final value?) => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
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
              ),
            ),
            SliverColumns(
              itemCount: value.length,
              columnWidth: 480,
              itemBuilder: (context, i) => _item(context, ref, value, i),
            ),
            const SliverToBoxAdapter(child: WatchLaterDeviceOnlyNote()),
          ],
        ),
      _ => const LoadingView(),
    };
  }

  /// Swipe to remove; tapping plays the list from this scene on.
  Widget _item(BuildContext context, WidgetRef ref, List<Scene> value, int i) {
    final scene = value[i];
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
      child: SceneListTile(
        scene: scene,
        onTap: () => ref.read(nowPlayingProvider.notifier).playQueue(value, title: context.l10n.libraryWatchLater, start: i),
      ),
    );
  }
}

/// The list is stored per server on this device only (PL-2): a second
/// device shows its own list.
class WatchLaterDeviceOnlyNote extends StatelessWidget {
  const WatchLaterDeviceOnlyNote({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.smartphone_outlined, size: 16, color: color),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              context.l10n.watchLaterDeviceOnly,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}
