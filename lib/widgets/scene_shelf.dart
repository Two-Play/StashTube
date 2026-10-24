import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/haptics.dart';
import '../core/config/theme.dart';
import '../data/models/list_queries.dart';
import '../data/models/scene.dart';
import '../data/providers.dart';
import '../features/player/player_providers.dart';
import '../l10n/l10n.dart';
import 'scene_card.dart';
import 'skeleton.dart';

/// Horizontal row of scenes with a heading, like YouTube's home shelves.
///
/// Shows placeholders while loading (HOME-2) and renders nothing on errors
/// or when empty.
class SceneShelf extends ConsumerWidget {
  const SceneShelf({
    super.key,
    required this.title,
    required this.query,
    this.icon,
    this.hideFinished = false,
    this.onSeeAll,
  });

  final String title;
  final SceneQuery query;
  final IconData? icon;

  /// Shows "See all" in the heading.
  final VoidCallback? onSeeAll;

  /// Drop scenes finished during this session (their saved resume time is 0).
  final bool hideFinished;

  static const double _cardWidth = 240;

  /// The 16:9 thumbnail plus the text below it, which grows with the text
  /// size.
  static double height(BuildContext context) =>
      _cardWidth * 9 / 16 + 6 + MediaQuery.textScalerOf(context).scale(89);

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShelfHeader(title: title, icon: icon, onSeeAll: onSeeAll),
        if (loading)
          ShelfSkeleton(height: height(context), itemWidth: _cardWidth)
        else
          SceneShelfRow(scenes: scenes),
        const Divider(height: 16),
      ],
    );
  }
}

/// The heading of a shelf, optionally with "See all".
class ShelfHeader extends StatelessWidget {
  const ShelfHeader({super.key, required this.title, this.icon, this.onSeeAll, this.padding});

  final String title;
  final IconData? icon;
  final VoidCallback? onSeeAll;

  /// Around the row; by default the shelves' margins.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: padding ??
          EdgeInsetsDirectional.fromSTEB(
            AppSpacing.l,
            AppSpacing.s,
            onSeeAll == null ? AppSpacing.l : AppSpacing.xs,
            AppSpacing.s,
          ),
      child: LayoutBuilder(
        builder: (context, constraints) => Row(
        children: [
          if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: AppSpacing.s)],
          Expanded(
            child: Semantics(
              header: true,
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          // At the end; takes at most half the width at large text sizes.
          if (onSeeAll != null)
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth / 2),
              child: TextButton(
                onPressed: onSeeAll,
                child: Text(
                  context.l10n.seeAll,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  semanticsLabel: '${context.l10n.seeAll}: $title',
                ),
              ),
            ),
        ],
      ),
      ),
    );
  }
}

/// A horizontal row of scene cards, as tall as a [SceneShelf]'s. Tapping
/// a card plays its scene, or calls [onTap] with its index.
class SceneShelfRow extends StatelessWidget {
  const SceneShelfRow({super.key, required this.scenes, this.onTap});

  final List<Scene> scenes;
  final void Function(int index)? onTap;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: SceneShelf.height(context),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
          itemCount: scenes.length,
          separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.m),
          itemBuilder: (_, i) => _ShelfCard(scene: scenes[i], onTap: onTap == null ? null : () => onTap!(i)),
        ),
      );
}

class _ShelfCard extends ConsumerWidget {
  const _ShelfCard({required this.scene, this.onTap});

  final Scene scene;
  final VoidCallback? onTap;

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
          borderRadius: AppRadius.thumbnailBorder,
          onTap: onTap ?? () => ref.read(nowPlayingProvider.notifier).play(scene),
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
                  borderRadius: AppRadius.thumbnailBorder,
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
