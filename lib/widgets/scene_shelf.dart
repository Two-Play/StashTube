import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/haptics.dart';
import '../data/models/list_queries.dart';
import '../data/models/scene.dart';
import '../data/providers.dart';
import '../features/player/player_providers.dart';
import 'scene_card.dart';
import 'skeleton.dart';

/// Horizontal row of scenes with a heading, like YouTube's home shelves.
///
/// Shows placeholders while loading (HOME-2) and renders nothing on errors
/// or when empty.
class SceneShelf extends ConsumerWidget {
  const SceneShelf({super.key, required this.title, required this.query, this.icon, this.hideFinished = false});

  final String title;
  final SceneQuery query;
  final IconData? icon;

  /// Drop scenes finished during this session (their saved resume time is 0).
  final bool hideFinished;

  static const double _height = 230;
  static const double _cardWidth = 240;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(sceneListProvider(query));
    final loading = value.current == null && !value.hasError;
    var scenes = value.current?.items ?? const <Scene>[];
    if (hideFinished) {
      final resumeTimes = ref.watch(resumeTimesProvider);
      scenes = scenes.where((s) => (resumeTimes[s.id] ?? s.resumeTime) > 0).toList();
    }
    if (scenes.isEmpty && !loading) return const SizedBox.shrink();

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
        if (loading)
          const ShelfSkeleton(height: _height, itemWidth: _cardWidth)
        else
          SizedBox(
            height: _height,
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
      width: SceneShelf._cardWidth,
      child: TileSemantics(
        label: sceneSemanticsLabel(context, ref, scene),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => ref.read(nowPlayingProvider.notifier).play(scene),
          // A shortcut for the ⋮ next to the title.
          onLongPress: () {
            Haptics.heavy();
            showSceneMenu(context, ref, scene);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExcludeSemantics(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SceneThumbnail(scene: scene, compact: true),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ExcludeSemantics(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            scene.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall,
                          ),
                          Text(
                            sceneChannel(context, ref, scene).name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: muted,
                          ),
                          if (meta.isNotEmpty) Text(meta, maxLines: 1, overflow: TextOverflow.ellipsis, style: muted),
                        ],
                      ),
                    ),
                  ),
                  SceneMenuButton(scene: scene, dense: true),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
