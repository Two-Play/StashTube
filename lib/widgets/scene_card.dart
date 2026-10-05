import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/utils/format.dart';
import '../data/models/scene.dart';
import '../features/player/player_providers.dart';
import '../features/shell/navigation.dart';
import 'stash_image.dart';

/// "Uploader" line for a scene: studio, else the first performer.
String _channelName(Scene scene) =>
    scene.studio?.name ?? (scene.performers.isEmpty ? 'Unknown' : scene.performers.first.name);

String _metaLine(Scene scene) {
  final parts = <String>[
    if (scene.playCount > 0) formatCount(scene.playCount, 'play'),
    if (scene.displayDate != null) formatTimeAgo(scene.displayDate!, DateTime.now()),
  ];
  return parts.join(' • ');
}

/// Full-width feed card: 16:9 thumbnail, channel avatar, title and meta line.
class SceneCard extends ConsumerWidget {
  const SceneCard({super.key, required this.scene});

  final Scene scene;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final studio = scene.studio;
    final performer = scene.performers.isEmpty ? null : scene.performers.first;
    final meta = [_channelName(scene), _metaLine(scene)].where((s) => s.isNotEmpty).join(' • ');

    return InkWell(
      onTap: () => ref.read(nowPlayingProvider.notifier).play(scene),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SceneThumbnail(scene: scene),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 0, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (studio != null) {
                        openStudio(ref, studio.id);
                      } else if (performer != null) {
                        openPerformer(ref, performer.id);
                      }
                    },
                    child: ChannelAvatar(
                      name: _channelName(scene),
                      imageUrl: studio?.imageUrl ?? performer?.imageUrl,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          scene.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(fontSize: 15),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          meta,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SceneMenuButton(scene: scene),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact row used for "Up next" and search results: thumbnail left, text right.
class SceneListTile extends ConsumerWidget {
  const SceneListTile({super.key, required this.scene});

  final Scene scene;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant);

    return InkWell(
      onTap: () => ref.read(nowPlayingProvider.notifier).play(scene),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 6, 0, 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 168,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SceneThumbnail(scene: scene, compact: true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(scene.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleSmall),
                  const SizedBox(height: 4),
                  Text(_channelName(scene), maxLines: 1, overflow: TextOverflow.ellipsis, style: muted),
                  Text(_metaLine(scene), maxLines: 1, overflow: TextOverflow.ellipsis, style: muted),
                ],
              ),
            ),
            SceneMenuButton(scene: scene),
          ],
        ),
      ),
    );
  }
}

class SceneThumbnail extends StatelessWidget {
  const SceneThumbnail({super.key, required this.scene, this.compact = false});

  final Scene scene;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final resolution = resolutionLabel(scene.height);
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        fit: StackFit.expand,
        children: [
          StashImage(scene.screenshotUrl, fallbackIcon: Icons.movie_outlined),
          if (resolution != null && !compact)
            Positioned(left: 8, bottom: 8, child: _Badge(text: resolution)),
          if (scene.duration > 0)
            Positioned(right: compact ? 4 : 8, bottom: compact ? 4 : 8, child: _Badge(text: formatDuration(scene.duration))),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
        ),
      );
}

/// "⋮" menu with navigation to the scene's channels.
class SceneMenuButton extends ConsumerWidget {
  const SceneMenuButton({super.key, required this.scene});

  final Scene scene;

  @override
  Widget build(BuildContext context, WidgetRef ref) => IconButton(
        icon: const Icon(Icons.more_vert, size: 20),
        visualDensity: VisualDensity.compact,
        onPressed: () => showModalBottomSheet<void>(
          context: context,
          useRootNavigator: true,
          showDragHandle: true,
          builder: (sheetContext) {
            void go(VoidCallback action) {
              Navigator.pop(sheetContext);
              action();
            }

            final studio = scene.studio;
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.play_arrow),
                    title: const Text('Play'),
                    onTap: () => go(() => ref.read(nowPlayingProvider.notifier).play(scene)),
                  ),
                  if (studio != null)
                    ListTile(
                      leading: const Icon(Icons.subscriptions_outlined),
                      title: Text('Go to ${studio.name}'),
                      onTap: () => go(() => openStudio(ref, studio.id)),
                    ),
                  for (final p in scene.performers)
                    ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: Text('Go to ${p.name}'),
                      onTap: () => go(() => openPerformer(ref, p.id)),
                    ),
                ],
              ),
            );
          },
        ),
      );
}
