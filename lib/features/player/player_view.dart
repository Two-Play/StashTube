import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/format.dart';
import '../../data/models/list_queries.dart';
import '../../data/models/scene.dart';
import '../../data/providers.dart';
import '../../widgets/scene_card.dart';
import '../../widgets/scene_feed.dart';
import '../../widgets/stash_image.dart';
import '../shell/navigation.dart';
import '../cast/cast_providers.dart';
import 'drag_to_minimize.dart';
import 'player_controls.dart';
import 'player_providers.dart';
import 'player_transition.dart';
import '../tags/tag_editor.dart';
import 'scene_actions.dart';
import 'scene_edits.dart';

/// Content of the miniplayer panel: one layout that [PlayerTransition]
/// morphs continuously from the collapsed bar into the full player page.
///
/// The widget tree keeps the same structure at every height (the video stays
/// the first child of the first row), so the video is never rebuilt and the
/// transition doesn't flicker.
class PlayerPanel extends ConsumerWidget {
  const PlayerPanel({super.key, required this.scene, required this.height, required this.maxHeight});

  final Scene scene;
  final double height;
  final double maxHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final media = MediaQuery.of(context);
    final t = PlayerTransition(
      height: height,
      minHeight: kMiniPlayerHeight,
      maxHeight: maxHeight,
      screenWidth: media.size.width,
      topInset: media.padding.top,
    );
    final markers = ref.watch(sceneDetailsProvider(scene.id)).value?.markers ?? const [];

    // Only status bar fields: the collapsed panel sits over Android's
    // navigation bar, whose style must stay untouched.
    final lightIcons = t.progress > 0.5 || Theme.of(context).brightness == Brightness.dark;
    final statusBarStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: lightIcons ? Brightness.light : Brightness.dark,
      statusBarBrightness: lightIcons ? Brightness.dark : Brightness.light, // iOS
    );

    // Every wrapper below is always present (only flags change), so the
    // video keeps its place in the tree during the transition.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      // Light status bar icons on the black area above the open player.
      value: statusBarStyle,
      child: DragToMinimize(
        enabled: t.isExpanded,
        controller: ref.watch(miniplayerControllerProvider),
        minHeight: kMiniPlayerHeight,
        maxHeight: maxHeight,
        videoBottom: t.topPadding + t.videoHeight,
        child: PanelTapGuard(
          // Collapsed or mid-drag, a tap should still expand the panel.
          enabled: t.isExpanded,
          child: ColoredBox(
            color: Color.lerp(colors.surfaceContainer, colors.surface, t.progress)!,
            child: Column(
              children: [
                // Status bar area: black like the video, so no colored band
                // grows above it while expanding.
                SizedBox(height: t.topPadding, width: double.infinity, child: const ColoredBox(color: Colors.black)),
                SizedBox(
                  height: t.videoHeight,
                  child: Row(
                    children: [
                      SizedBox(
                        width: t.videoWidth,
                        child: ColoredBox(
                          color: Colors.black,
                          child: PlayerVideo(scene: scene, showControls: t.isExpanded),
                        ),
                      ),
                      // Mini bar info keeps its natural width and is clipped while
                      // the video takes over the row.
                      Expanded(
                        child: ClipRect(
                          child: OverflowBox(
                            alignment: Alignment.centerLeft,
                            minWidth: 0,
                            maxWidth: media.size.width - kMiniPlayerHeight * 16 / 9,
                            child: Opacity(
                              opacity: t.miniBarOpacity,
                              child: IgnorePointer(
                                ignoring: t.miniBarOpacity < 0.5,
                                child: _MiniInfo(scene: scene),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Mini progress line shrinks away so no gap remains under the video.
                SizedBox(
                  height: 2 * t.miniBarOpacity,
                  child: Opacity(opacity: t.miniBarOpacity, child: const _ProgressBar(height: 2)),
                ),
                if (t.showDetails && markers.isNotEmpty)
                  Opacity(
                    opacity: t.detailsOpacity,
                    child: ChapterStrip(markers: markers, duration: scene.duration),
                  ),
                if (t.showDetails)
                  Expanded(
                    child: Opacity(
                      opacity: t.detailsOpacity,
                      child: _SceneDetails(scene: scene),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Title, channel, play/pause and close of the collapsed miniplayer.
class _MiniInfo extends ConsumerWidget {
  const _MiniInfo({required this.scene});

  final Scene scene;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final player = ref.watch(playerProvider);

    return Row(
      children: [
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
        if (ref.watch(isCastingProvider))
          // Controls the cast device while casting.
          Builder(builder: (_) {
            final playing = ref.watch(castPlaybackProvider).value?.playing ?? false;
            final cast = ref.watch(castServiceProvider);
            return IconButton(
              icon: Icon(playing ? Icons.pause : Icons.play_arrow),
              onPressed: playing ? cast.pause : cast.play,
            );
          })
        else
          StreamBuilder<bool>(
            stream: player.stream.playing,
            initialData: player.state.playing,
            builder: (_, snapshot) => IconButton(
              icon: Icon(snapshot.data == true ? Icons.pause : Icons.play_arrow),
              onPressed: player.playOrPause,
            ),
          ),
        IconButton(
          tooltip: 'Close',
          icon: const Icon(Icons.close),
          onPressed: () => ref.read(nowPlayingProvider.notifier).dismiss(),
        ),
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
    final queue = ref.watch(playQueueProvider);
    if (queue != null) return _QueueDetails(scene: scene, queue: queue);

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
      layout: SceneFeedLayout.list,
      // A downward swipe at the top minimizes the player instead.
      refreshable: false,
      physics: const ClampingScrollPhysics(),
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

/// Details plus the queue being played (watch later, a group).
class _QueueDetails extends StatelessWidget {
  const _QueueDetails({required this.scene, required this.queue});

  final Scene scene;
  final PlayQueue queue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CustomScrollView(
      key: ValueKey(scene.id),
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: _SceneInfo(scene: scene)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                Icon(Icons.playlist_play, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${queue.title} · ${queue.index + 1} / ${queue.scenes.length}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverList.builder(
          itemCount: queue.scenes.length,
          itemBuilder: (_, i) => ColoredBox(
            color: i == queue.index ? theme.colorScheme.primaryContainer.withValues(alpha: 0.4) : Colors.transparent,
            child: SceneListTile(scene: queue.scenes[i]),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
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
  bool _titleExpanded = false;

  @override
  Widget build(BuildContext context) {
    final scene = widget.scene;
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    final studio = scene.studio;
    final details = ref.watch(sceneDetailsProvider(scene.id)).value;
    final tags = effectiveTags(ref, scene);

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
          // Long titles (often file names) are cut to two lines; tap to expand.
          child: GestureDetector(
            onTap: () => setState(() => _titleExpanded = !_titleExpanded),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 150),
              alignment: Alignment.topCenter,
              child: Text(
                scene.title,
                maxLines: _titleExpanded ? null : 2,
                overflow: _titleExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(meta, style: muted),
        ),
        SceneActions(scene: scene),
        if (studio != null)
          ListTile(
            leading: ChannelAvatar(name: studio.name, imageUrl: studio.imageUrl),
            title: Text(studio.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleSmall),
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
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: tags.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 6),
            itemBuilder: (_, i) {
              if (i == tags.length) {
                return ActionChip(
                  avatar: Icon(tags.isEmpty ? Icons.add : Icons.edit_outlined, size: 16),
                  label: Text(tags.isEmpty ? 'Add tags' : 'Edit tags'),
                  visualDensity: VisualDensity.compact,
                  onPressed: () => showSceneTagEditor(context, scene, tags),
                );
              }
              final tag = tags[i];
              return ActionChip(
                label: Text('#${tag.name}'),
                labelStyle: TextStyle(color: theme.colorScheme.primary),
                visualDensity: VisualDensity.compact,
                onPressed: () => openTag(ref, tag.id),
              );
            },
          ),
        ),
        if (details != null && details.markers.isNotEmpty) ChapterList(details: details),
        if (scene.details != null)
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
