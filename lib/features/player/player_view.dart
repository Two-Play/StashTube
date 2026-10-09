import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/format.dart';
import '../../data/models/list_queries.dart';
import '../../data/models/scene.dart';
import '../../data/providers.dart';
import '../../widgets/play_pause_icon.dart';
import '../../widgets/scene_card.dart';
import '../../widgets/scene_feed.dart';
import '../../widgets/stash_image.dart';
import '../shell/navigation.dart';
import '../cast/cast_providers.dart';
import 'drag_to_minimize.dart';
import 'file_info.dart';
import 'player_controls.dart';
import 'player_providers.dart';
import 'player_transition.dart';
import '../tags/tag_editor.dart';
import 'scene_actions.dart';
import 'scene_edits.dart';
import '../../l10n/l10n.dart';

/// Width / height of [scene]'s video, updated once the player knows the
/// decoded size.
final _videoAspectProvider = Provider.autoDispose.family<double?, Scene>((ref, scene) {
  final player = ref.watch(playerProvider);
  final subscriptions = [
    player.stream.width.listen((_) => ref.invalidateSelf()),
    player.stream.height.listen((_) => ref.invalidateSelf()),
  ];
  ref.onDispose(() {
    for (final s in subscriptions) {
      s.cancel();
    }
  });
  return videoAspect(player.state, scene, sceneFirst: true);
});

/// Content of the miniplayer panel: one layout that [PlayerTransition]
/// morphs continuously from the collapsed bar into the full player page.
///
/// The widget tree keeps the same structure at every height (the video stays
/// the first child of the first row), so the video is never rebuilt and the
/// transition doesn't flicker.
///
/// A portrait video's extra height sits over a spacer at the top of the
/// details, so scrolling them shrinks the video to the 16:9 size, following
/// the finger (4.20).
class PlayerPanel extends ConsumerStatefulWidget {
  const PlayerPanel({super.key, required this.scene, required this.height, required this.maxHeight});

  final Scene scene;
  final double height;
  final double maxHeight;

  @override
  ConsumerState<PlayerPanel> createState() => _PlayerPanelState();
}

class _PlayerPanelState extends ConsumerState<PlayerPanel> {
  /// How far the details list is scrolled.
  final _detailsScroll = ValueNotifier<double>(0);

  @override
  void didUpdateWidget(PlayerPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scene.id != widget.scene.id) _detailsScroll.value = 0;
  }

  @override
  void dispose() {
    _detailsScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scene = widget.scene;
    final height = widget.height;
    final colors = Theme.of(context).colorScheme;
    final media = MediaQuery.of(context);
    final t = PlayerTransition(
      height: height,
      minHeight: kMiniPlayerHeight,
      maxHeight: widget.maxHeight,
      screenWidth: media.size.width,
      topInset: media.padding.top,
      // Portrait videos get a taller video area (4.20).
      videoAspect: ref.watch(_videoAspectProvider(scene)) ?? 16 / 9,
    );

    // Only status bar fields: the collapsed panel sits over Android's
    // navigation bar, whose style must stay untouched.
    final lightIcons = t.progress > 0.5 || Theme.of(context).brightness == Brightness.dark;
    final statusBarStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: lightIcons ? Brightness.light : Brightness.dark,
      statusBarBrightness: lightIcons ? Brightness.dark : Brightness.light, // iOS
    );
    final progressLineHeight = 2 * t.miniBarOpacity;
    final detailsTop = t.topPadding + t.baseVideoHeight + progressLineHeight;

    // Every wrapper below is always present (only flags change), so the
    // video keeps its place in the tree during the transition.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      // Light status bar icons on the black area above the open player.
      value: statusBarStyle,
      child: ValueListenableBuilder<double>(
        valueListenable: _detailsScroll,
        builder: (context, scrolled, _) {
          final shownVideoHeight = t.videoHeight - scrolled.clamp(0.0, t.extraVideoHeight);
          return DragToMinimize(
            enabled: t.isExpanded,
            controller: ref.watch(miniplayerControllerProvider),
            minHeight: kMiniPlayerHeight,
            maxHeight: widget.maxHeight,
            videoBottom: t.topPadding + shownVideoHeight,
            child: PanelTapGuard(
              // Collapsed or mid-drag, a tap should still expand the panel.
              enabled: t.isExpanded,
              child: ColoredBox(
                color: Color.lerp(colors.surfaceContainer, colors.surface, t.progress)!,
                // Always the panel's height: while the phone turns, the space can
                // briefly be smaller than the miniplayer's height.
                child: ClipRect(
                  child: OverflowBox(
                    alignment: Alignment.topCenter,
                    minHeight: height,
                    maxHeight: height,
                    child: Stack(
                      children: [
                        // Below the 16:9 area; the taller video covers their spacer.
                        Positioned(
                          top: detailsTop,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: t.showDetails
                              ? NotificationListener<ScrollNotification>(
                                  onNotification: (n) {
                                    if (n.depth == 0 && n.metrics.axis == Axis.vertical) {
                                      _detailsScroll.value = n.metrics.pixels;
                                    }
                                    return false;
                                  },
                                  child: Opacity(
                                    opacity: t.detailsOpacity,
                                    // Ink of the list tiles above the panel's color.
                                    child: Material(
                                      type: MaterialType.transparency,
                                      child: _SceneDetails(scene: scene, topSpacer: t.extraVideoHeight),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Status bar area: black like the video, so no colored band
                              // grows above it while expanding.
                              SizedBox(
                                height: t.topPadding,
                                width: double.infinity,
                                child: const ColoredBox(color: Colors.black),
                              ),
                      SizedBox(
                        height: shownVideoHeight,
                        // The panel's width even while the phone turns (the video width
                        // comes from the screen size, which can be ahead of the layout).
                        child: ClipRect(
                          child: OverflowBox(
                            alignment: Alignment.centerLeft,
                            minWidth: media.size.width,
                            maxWidth: media.size.width,
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
                        ),
                      ),
                              // Mini progress line shrinks away so no gap remains under the video.
                              SizedBox(
                                height: progressLineHeight,
                                child: Opacity(opacity: t.miniBarOpacity, child: const _ProgressBar(height: 2)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
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
              icon: PlayPauseIcon(playing: playing),
              onPressed: playing ? cast.pause : cast.play,
            );
          })
        else
          StreamBuilder<bool>(
            stream: player.stream.playing,
            initialData: player.state.playing,
            builder: (_, snapshot) => IconButton(
              icon: PlayPauseIcon(playing: snapshot.data == true),
              onPressed: player.playOrPause,
            ),
          ),
        IconButton(
          tooltip: context.l10n.close,
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
  const _SceneDetails({required this.scene, this.topSpacer = 0});

  final Scene scene;

  /// Room at the top for a portrait video's extra height.
  final double topSpacer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queue = ref.watch(playQueueProvider);
    if (queue != null) return _QueueDetails(scene: scene, queue: queue, topSpacer: topSpacer);

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
      emptyMessage: context.l10n.upNextEmpty,
      emptyIcon: Icons.playlist_play,
      headerSlivers: [
        SliverToBoxAdapter(child: SizedBox(height: topSpacer)),
        SliverToBoxAdapter(child: _SceneInfo(scene: scene)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              scene.studio != null ? context.l10n.moreFrom(scene.studio!.name) : context.l10n.upNext,
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
  const _QueueDetails({required this.scene, required this.queue, this.topSpacer = 0});

  final Scene scene;
  final PlayQueue queue;
  final double topSpacer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CustomScrollView(
      key: ValueKey(scene.id),
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: SizedBox(height: topSpacer)),
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
      if (scene.playCount > 0) context.l10n.playsCount(scene.playCount),
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
              separatorBuilder: (_, _) => const SizedBox(width: 8),
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
            separatorBuilder: (_, _) => const SizedBox(width: 6),
            itemBuilder: (_, i) {
              if (i == tags.length) {
                return ActionChip(
                  avatar: Icon(tags.isEmpty ? Icons.add : Icons.edit_outlined, size: 16),
                  label: Text(tags.isEmpty ? context.l10n.addTags : context.l10n.editTags),
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
                      Text(_expanded ? context.l10n.showLess : context.l10n.showMore, style: theme.textTheme.labelMedium),
                    ],
                  ),
                ),
              ),
            ),
          ),
        if (details != null && details.files.isNotEmpty) FileInfoCard(files: details.files),
        const SizedBox(height: 8),
      ],
    );
  }
}
