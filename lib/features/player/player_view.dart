import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../../core/utils/format.dart';
import '../../data/models/list_queries.dart';
import '../../data/models/scene.dart';
import '../../data/providers.dart';
import '../../widgets/scene_feed.dart';
import '../../widgets/stash_image.dart';
import '../shell/navigation.dart';
import 'player_controls.dart';
import 'player_providers.dart';

/// Content of the miniplayer panel. Interpolates between the collapsed bar
/// and the full player page depending on the panel [height].
class PlayerPanel extends ConsumerWidget {
  const PlayerPanel({super.key, required this.scene, required this.height, required this.maxHeight});

  final Scene scene;
  final double height;
  final double maxHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final expandedVideoHeight = MediaQuery.sizeOf(context).width * 9 / 16;
    final percentage = ((height - kMiniPlayerHeight) / (maxHeight - kMiniPlayerHeight)).clamp(0.0, 1.0);

    // Mostly collapsed: compact bar, like YouTube's miniplayer.
    if (percentage < 0.2) {
      return ColoredBox(
        color: colors.surfaceContainer,
        child: _MiniBar(scene: scene, height: height),
      );
    }

    // Expanding: video grows to full width, details fade in.
    final markers = ref.watch(sceneDetailsProvider(scene.id)).valueOrNull?.markers ?? const [];
    final videoHeight = kMiniPlayerHeight + (expandedVideoHeight - kMiniPlayerHeight) * percentage;
    return ColoredBox(
      color: colors.surface,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(
              height: videoHeight,
              width: double.infinity,
              child: ColoredBox(color: Colors.black, child: ExpandedVideo(scene: scene)),
            ),
            if (markers.isNotEmpty) ChapterStrip(markers: markers, duration: scene.duration),
            Expanded(
              child: Opacity(
                opacity: percentage,
                child: _SceneDetails(scene: scene),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniBar extends ConsumerWidget {
  const _MiniBar({required this.scene, required this.height});

  final Scene scene;
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final player = ref.watch(playerProvider);
    final barHeight = height.clamp(0.0, kMiniPlayerHeight);

    return Column(
      children: [
        SizedBox(
          height: barHeight - 2,
          child: Row(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Video(controller: ref.watch(videoControllerProvider), controls: NoVideoControls),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(scene.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodyMedium),
                      Text(
                        scene.studio?.name ?? scene.performers.firstOrNull?.name ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ),
              StreamBuilder<bool>(
                stream: player.stream.playing,
                initialData: player.state.playing,
                builder: (_, snapshot) => IconButton(
                  icon: Icon(snapshot.data == true ? Icons.pause : Icons.play_arrow),
                  onPressed: player.playOrPause,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => ref.read(nowPlayingProvider.notifier).close(),
              ),
            ],
          ),
        ),
        const _ProgressBar(height: 2),
      ],
    );
  }
}

class _ProgressBar extends ConsumerWidget {
  const _ProgressBar({required this.height});

  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerProvider);
    return StreamBuilder<Duration>(
      stream: player.stream.position,
      initialData: player.state.position,
      builder: (context, snapshot) {
        final total = player.state.duration.inMilliseconds;
        final value = total == 0 ? 0.0 : (snapshot.data!.inMilliseconds / total).clamp(0.0, 1.0);
        return LinearProgressIndicator(
          value: value,
          minHeight: height,
          color: Theme.of(context).colorScheme.primary,
          backgroundColor: Colors.transparent,
        );
      },
    );
  }
}

/// Everything below the video: title, channel, performers, tags, description
/// and "Up next".
class _SceneDetails extends ConsumerWidget {
  const _SceneDetails({required this.scene});

  final Scene scene;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Prefer more scenes from the same studio, then performer, else random.
    final upNext = SceneQuery(
      sort: SceneSort.random,
      studioId: scene.studio?.id,
      performerId: scene.studio == null ? scene.performers.firstOrNull?.id : null,
      excludeSceneId: scene.id,
      seed: scene.id.hashCode,
    );

    return SceneFeedView(
      key: ValueKey(scene.id),
      initialQuery: upNext,
      sorts: const [],
      compact: true,
      emptyMessage: 'Nothing else to watch here',
      headerSlivers: [
        SliverToBoxAdapter(child: _SceneInfo(scene: scene)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              scene.studio != null ? 'More from ${scene.studio!.name}' : 'Up next',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
      ],
    );
  }
}

class _SceneInfo extends ConsumerStatefulWidget {
  const _SceneInfo({required this.scene});

  final Scene scene;

  @override
  ConsumerState<_SceneInfo> createState() => _SceneInfoState();
}

class _SceneInfoState extends ConsumerState<_SceneInfo> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final scene = widget.scene;
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    final studio = scene.studio;
    final rating = scene.rating100;
    final details = ref.watch(sceneDetailsProvider(scene.id)).valueOrNull;

    final meta = [
      if (scene.playCount > 0) formatCount(scene.playCount, 'play'),
      if (scene.date != null) formatDate(scene.date!),
      if (resolutionLabel(scene.height) != null) resolutionLabel(scene.height)!,
    ].join(' • ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(scene.title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(child: Text(meta, style: muted)),
              if (rating != null) ...[
                Icon(Icons.star, size: 16, color: Colors.amber.shade600),
                const SizedBox(width: 2),
                Text((rating / 20).toStringAsFixed(1), style: muted),
              ],
            ],
          ),
        ),
        if (studio != null)
          ListTile(
            leading: ChannelAvatar(name: studio.name, imageUrl: studio.imageUrl),
            title: Text(studio.name, style: theme.textTheme.titleSmall),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => openStudio(ref, studio.id),
          ),
        if (scene.performers.isNotEmpty)
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: scene.performers.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final p = scene.performers[i];
                return ActionChip(
                  avatar: ChannelAvatar(name: p.name, imageUrl: p.imageUrl, radius: 12),
                  label: Text(p.name),
                  onPressed: () => openPerformer(ref, p.id),
                );
              },
            ),
          ),
        if (details != null && details.markers.isNotEmpty) ChapterList(details: details),
        if (scene.details != null || scene.tags.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: Material(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => setState(() => _expanded = !_expanded),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (scene.tags.isNotEmpty)
                        Text(
                          scene.tags.map((t) => '#${t.name.replaceAll(' ', '')}').join(' '),
                          maxLines: _expanded ? null : 1,
                          overflow: _expanded ? null : TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary),
                        ),
                      if (scene.details != null)
                        Text(
                          scene.details!,
                          maxLines: _expanded ? null : 2,
                          overflow: _expanded ? null : TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium,
                        ),
                      Text(_expanded ? 'Show less' : '...more', style: theme.textTheme.labelMedium),
                    ],
                  ),
                ),
              ),
            ),
          ),
        const SizedBox(height: 8),
      ],
    );
  }
}
