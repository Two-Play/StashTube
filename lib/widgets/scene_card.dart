import 'dart:math' show max;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/haptics.dart';
import '../core/utils/format.dart';
import '../data/models/scene.dart';
import '../features/edit/edit_common.dart';
import '../features/edit/edit_pages.dart';
import '../features/library/watch_later.dart';
import '../features/player/player_providers.dart';
import '../features/player/scene_edits.dart';
import '../features/settings/scene_card_config.dart';
import '../features/shell/navigation.dart';
import 'auto_preview.dart';
import 'stash_image.dart';
import '../l10n/l10n.dart';

/// The "uploader" of a scene as the settings choose it: the studio or the
/// performers, falling back to the other one.
class SceneChannel {
  SceneChannel(AppLocalizations l, Scene scene, CardChannel channel) {
    final studio = scene.studio;
    final performers = scene.performers;
    final useStudio = studio != null && (channel == CardChannel.studio || performers.isEmpty);
    if (useStudio) {
      name = studio.name;
      imageUrl = studio.imageUrl;
      open = (ref) => openStudio(ref, studio.id);
    } else if (performers.isNotEmpty) {
      name = performers.map((p) => p.name).join(', ');
      imageUrl = performers.first.imageUrl;
      open = (ref) => openPerformer(ref, performers.first.id);
    } else {
      name = l.channelUnknown;
    }
  }

  late final String name;
  String? imageUrl;
  void Function(WidgetRef ref)? open;
}

/// The channel of [scene] for a card (watches the card settings).
SceneChannel sceneChannel(BuildContext context, WidgetRef ref, Scene scene) =>
    SceneChannel(context.l10n, scene, ref.watch(sceneCardConfigProvider.select((c) => c.channel)));

/// Plays, rating and date, as far as the settings show them.
String sceneMetaLine(BuildContext context, WidgetRef ref, Scene scene, {bool withDate = true}) {
  final l = context.l10n;
  final config = ref.watch(sceneCardConfigProvider);
  final stars = config.showRating ? effectiveStars(ref, scene) : 0;
  final parts = <String>[
    if (config.showPlays) l.playsCount(scene.playCount),
    if (stars > 0) '★ $stars',
    if (withDate && scene.displayDate != null) formatTimeAgo(l, scene.displayDate!, DateTime.now()),
  ];
  return parts.join(' • ');
}

/// [seconds] as a screen reader should say it: "12 minutes 5 seconds".
String spokenDuration(AppLocalizations l, double seconds) {
  final total = seconds.isFinite && seconds > 0 ? seconds.round() : 0;
  final h = total ~/ 3600;
  final m = (total % 3600) ~/ 60;
  final s = total % 60;
  return [
    if (h > 0) l.durationHours(h),
    if (m > 0) l.durationMinutes(m),
    if (s > 0 || total == 0) l.durationSeconds(s),
  ].join(' ');
}

/// What a screen reader says for a whole scene tile, in one go: title,
/// channel, duration, plays, stars and how much was watched, as far as the
/// tile and the card settings show them (A11Y-1).
String sceneSemanticsLabel(
  BuildContext context,
  WidgetRef ref,
  Scene scene, {
  bool withDate = false,
  bool withResolution = false,
}) {
  final l = context.l10n;
  final config = ref.watch(sceneCardConfigProvider);
  final stars = config.showRating ? effectiveStars(ref, scene) : 0;
  final watched = scene.duration > 0 ? (effectiveResumeTime(ref, scene) / scene.duration).clamp(0.0, 1.0) : 0.0;
  final resolution = withResolution ? resolutionLabel(scene.height) : null;
  return [
    scene.title,
    sceneChannel(context, ref, scene).name,
    if (scene.duration > 0) spokenDuration(l, scene.duration),
    ?resolution,
    if (config.showPlays) l.playsCount(scene.playCount),
    if (stars > 0) l.starsCount(stars),
    if (watched > 0) l.watchedPercent(max(1, (watched * 100).round())),
    if (withDate && scene.displayDate != null) formatTimeAgo(l, scene.displayDate!, DateTime.now()),
  ].join(', ');
}

/// One screen-reader node for a tile: [label], announced as a button. The
/// tile's texts and thumbnail belong in an [ExcludeSemantics]; buttons of
/// their own inside it (the ⋮ menu) stay separate nodes.
class TileSemantics extends StatelessWidget {
  const TileSemantics({super.key, required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) => Semantics(container: true, button: true, label: label, child: child);
}

/// Full-width feed card: 16:9 thumbnail, channel avatar, title and meta line.
class SceneCard extends ConsumerWidget {
  const SceneCard({super.key, required this.scene});

  final Scene scene;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final channel = sceneChannel(context, ref, scene);
    final meta = [channel.name, sceneMetaLine(context, ref, scene)].where((s) => s.isNotEmpty).join(' • ');

    final openChannel = channel.open;

    return TileSemantics(
      label: sceneSemanticsLabel(context, ref, scene, withDate: true, withResolution: true),
      child: InkWell(
        onTap: () => ref.read(nowPlayingProvider.notifier).play(scene),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExcludeSemantics(child: SceneThumbnail(scene: scene)),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // A button of its own for screen readers: "Go to <channel>".
                    Semantics(
                      container: true,
                      button: openChannel != null,
                      label: openChannel == null ? null : context.l10n.goTo(channel.name),
                      onTap: openChannel == null ? null : () => openChannel(ref),
                      excludeSemantics: true,
                      child: GestureDetector(
                        excludeFromSemantics: true,
                        onTap: openChannel == null ? null : () => openChannel(ref),
                        child: ChannelAvatar(name: channel.name, imageUrl: channel.imageUrl),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ExcludeSemantics(
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
                              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SceneMenuButton(scene: scene),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact row used for "Up next" and search results: thumbnail left, text right.
class SceneListTile extends ConsumerWidget {
  const SceneListTile({super.key, required this.scene, this.onTap});

  final Scene scene;

  /// Defaults to playing the scene on its own.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant);

    return TileSemantics(
      label: sceneSemanticsLabel(context, ref, scene, withDate: true),
      child: InkWell(
        onTap: onTap ?? () => ref.read(nowPlayingProvider.notifier).play(scene),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 6, 0, 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ExcludeSemantics(
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
                            Text(
                              scene.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleSmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              sceneChannel(context, ref, scene).name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: muted,
                            ),
                            Text(
                              sceneMetaLine(context, ref, scene),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: muted,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SceneMenuButton(scene: scene),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dense grid cell: thumbnail with title and channel below.
class SceneGridTile extends ConsumerWidget {
  const SceneGridTile({super.key, required this.scene});

  final Scene scene;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    // The grid is dense: no date, only plays and rating.
    final meta = sceneMetaLine(context, ref, scene, withDate: false);
    return TileSemantics(
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
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ExcludeSemantics(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              scene.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleSmall,
                            ),
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
            ),
          ],
        ),
      ),
    );
  }
}

class SceneThumbnail extends ConsumerWidget {
  const SceneThumbnail({super.key, required this.scene, this.compact = false});

  final Scene scene;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resolution = resolutionLabel(scene.height);
    final resume = effectiveResumeTime(ref, scene);
    final progress = scene.duration > 0 ? (resume / scene.duration).clamp(0.0, 1.0) : 0.0;
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // In lists, the first fully shown video plays its preview.
          AutoPreview(
            url: scene.webpUrl,
            videoUrl: scene.previewUrl,
            child: StashImage(scene.screenshotUrl, fallbackIcon: Icons.movie_outlined),
          ),
          if (resolution != null && !compact) Positioned(left: 8, bottom: 8, child: _Badge(text: resolution)),
          if (scene.duration > 0)
            Positioned(
              right: compact ? 4 : 8,
              bottom: (compact ? 4 : 8) + (progress > 0 ? 3 : 0),
              child: _Badge(text: formatDuration(scene.duration)),
            ),
          // "Continue watching" progress, like YouTube's red bar.
          if (progress > 0)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 3,
                color: Theme.of(context).colorScheme.primary,
                backgroundColor: Colors.white24,
              ),
            ),
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
    decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.8), borderRadius: BorderRadius.circular(4)),
    child: Text(
      text,
      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
    ),
  );
}

/// Bottom sheet with actions for a scene: play and go to its channels.
void showSceneMenu(BuildContext context, WidgetRef ref, Scene scene) => showModalBottomSheet<void>(
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
            title: Text(context.l10n.sceneMenuPlay),
            onTap: () => go(() => ref.read(nowPlayingProvider.notifier).play(scene)),
          ),
          Consumer(
            builder: (context, ref, _) {
              final saved = ref.watch(watchLaterProvider).contains(scene.id);
              return ListTile(
                leading: Icon(saved ? Icons.watch_later : Icons.watch_later_outlined),
                title: Text(saved ? context.l10n.watchLaterRemove : context.l10n.watchLaterSave),
                onTap: () => go(() => ref.read(watchLaterProvider.notifier).toggle(scene.id)),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: Text(context.l10n.editDetails),
            onTap: () => go(() => openEditor(context, ref, SceneEditPage(scene: scene))),
          ),
          if (studio != null)
            ListTile(
              leading: const Icon(Icons.subscriptions_outlined),
              title: Text(context.l10n.goTo(studio.name)),
              onTap: () => go(() => openStudio(ref, studio.id)),
            ),
          for (final p in scene.performers)
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: Text(context.l10n.goTo(p.name)),
              onTap: () => go(() => openPerformer(ref, p.id)),
            ),
        ],
      ),
    );
  },
);

/// "⋮" button opening [showSceneMenu]. [dense] makes it narrow (for grid
/// tiles and shelf cards) but keeps it 48 dp tall.
class SceneMenuButton extends ConsumerWidget {
  const SceneMenuButton({super.key, required this.scene, this.dense = false});

  final Scene scene;
  final bool dense;

  @override
  Widget build(BuildContext context, WidgetRef ref) => IconButton(
    tooltip: context.l10n.sceneMoreOptions,
    icon: Icon(Icons.more_vert, size: dense ? 18 : 20),
    visualDensity: dense ? null : VisualDensity.compact,
    padding: dense ? EdgeInsets.zero : null,
    constraints: dense ? const BoxConstraints.tightFor(width: 36, height: 48) : null,
    onPressed: () => showSceneMenu(context, ref, scene),
  );
}
