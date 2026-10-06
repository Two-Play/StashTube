import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/list_queries.dart';
import '../data/models/scene.dart';
import '../data/providers.dart';
import '../features/player/player_providers.dart';
import 'scene_card.dart';

/// Horizontal row of scenes with a heading, like YouTube's home shelves.
///
/// Renders nothing while loading, on errors or when empty, so a shelf never
/// pushes the main feed down with placeholders.
class SceneShelf extends ConsumerWidget {
  const SceneShelf({super.key, required this.title, required this.query, this.icon, this.hideFinished = false});

  final String title;
  final SceneQuery query;
  final IconData? icon;

  /// Drop scenes finished during this session (their saved resume time is 0).
  final bool hideFinished;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var scenes = ref.watch(sceneListProvider(query)).current?.items ?? const <Scene>[];
    if (hideFinished) {
      final resumeTimes = ref.watch(resumeTimesProvider);
      scenes = scenes.where((s) => (resumeTimes[s.id] ?? s.resumeTime) > 0).toList();
    }
    if (scenes.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            children: [
              if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)],
              Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        SizedBox(
          height: 230,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: scenes.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (_, i) => _ShelfCard(scene: scenes[i]),
          ),
        ),
        const Divider(height: 16),
      ],
    );
  }
}

class _ShelfCard extends ConsumerWidget {
  const _ShelfCard({required this.scene});

  final Scene scene;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    final meta = sceneMetaLine(context, ref, scene, withDate: false);
    return SizedBox(
      width: 240,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => ref.read(nowPlayingProvider.notifier).play(scene),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SceneThumbnail(scene: scene, compact: true),
            ),
            const SizedBox(height: 6),
            Text(scene.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleSmall),
            Text(sceneChannel(context, ref, scene).name, maxLines: 1, overflow: TextOverflow.ellipsis, style: muted),
            if (meta.isNotEmpty) Text(meta, maxLines: 1, overflow: TextOverflow.ellipsis, style: muted),
          ],
        ),
      ),
    );
  }
}
