import 'package:flutter/material.dart';

import '../l10n/l10n.dart';

/// Placeholders shaped like the content that is loading, instead of a
/// spinner: the layout stays where the items will appear (HOME-2).
///
/// [SkeletonPulse] fades its child gently in and out (not with reduced
/// motion), says "Loading" once to screen readers and hides the boxes from
/// them.
class SkeletonPulse extends StatefulWidget {
  const SkeletonPulse({super.key, required this.child});

  final Widget child;

  @override
  State<SkeletonPulse> createState() => _SkeletonPulseState();
}

class _SkeletonPulseState extends State<SkeletonPulse> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
  late final _opacity = Tween<double>(begin: 1, end: 0.55).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller
        ..stop()
        ..value = 0;
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Semantics(
        container: true,
        label: context.l10n.loading,
        child: ExcludeSemantics(
          child: FadeTransition(opacity: _opacity, child: widget.child),
        ),
      );
}

/// A rounded block in the skeleton color.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({super.key, this.width, this.height, this.radius = 8, this.circle = false});

  final double? width;
  final double? height;
  final double radius;
  final bool circle;

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          shape: circle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: circle ? null : BorderRadius.circular(radius),
        ),
      );
}

/// A line of text: [widthFactor] of the available width.
class SkeletonLine extends StatelessWidget {
  const SkeletonLine({super.key, this.widthFactor = 1, this.height = 12});

  final double widthFactor;
  final double height;

  @override
  Widget build(BuildContext context) => FractionallySizedBox(
        alignment: AlignmentDirectional.centerStart,
        widthFactor: widthFactor,
        child: SkeletonBox(height: height, radius: 4),
      );
}

/// Shaped like a feed card ([SceneCard]): 16:9 thumbnail, avatar, two lines.
class SceneCardSkeleton extends StatelessWidget {
  const SceneCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(aspectRatio: 16 / 9, child: SkeletonBox(radius: 0)),
            Padding(
              padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBox(width: 36, height: 36, circle: true),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      children: [
                        SkeletonLine(height: 14),
                        SizedBox(height: 8),
                        SkeletonLine(widthFactor: 0.6),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

/// Shaped like a compact row ([SceneListTile]) and other list tiles:
/// thumbnail on the left, two lines of text.
class ListTileSkeleton extends StatelessWidget {
  const ListTileSkeleton({super.key, this.thumbnailWidth = 160, this.thumbnailAspect = 16 / 9});

  final double thumbnailWidth;
  final double thumbnailAspect;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonBox(width: thumbnailWidth, height: thumbnailWidth / thumbnailAspect),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                children: [
                  SizedBox(height: 4),
                  SkeletonLine(height: 14),
                  SizedBox(height: 8),
                  SkeletonLine(widthFactor: 0.5),
                ],
              ),
            ),
          ],
        ),
      );
}

/// Fills a grid cell ([SceneGridTile]): 16:9 thumbnail and two lines; with
/// [aspectRatio] null the image takes the whole cell.
class GridTileSkeleton extends StatelessWidget {
  const GridTileSkeleton({super.key, this.aspectRatio = 16 / 9});

  final double? aspectRatio;

  @override
  Widget build(BuildContext context) {
    final ratio = aspectRatio;
    if (ratio == null) return const SkeletonBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(aspectRatio: ratio, child: const SkeletonBox()),
        const SizedBox(height: 8),
        const SkeletonLine(height: 14),
        const SizedBox(height: 6),
        const SkeletonLine(widthFactor: 0.6),
      ],
    );
  }
}

/// A shelf's horizontal row while it loads: [count] tiles of [itemWidth] ×
/// [height] from [itemBuilder] (default: a [GridTileSkeleton]).
class ShelfSkeleton extends StatelessWidget {
  const ShelfSkeleton({
    super.key,
    required this.height,
    required this.itemWidth,
    this.count = 4,
    this.spacing = 12,
    this.itemBuilder,
  });

  final double height;
  final double itemWidth;
  final int count;
  final double spacing;
  final WidgetBuilder? itemBuilder;

  @override
  Widget build(BuildContext context) => SkeletonPulse(
        child: SizedBox(
          height: height,
          // Not scrollable: it only holds the space.
          child: ClipRect(
            child: OverflowBox(
              alignment: AlignmentDirectional.centerStart,
              maxWidth: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < count; i++) ...[
                      if (i > 0) SizedBox(width: spacing),
                      SizedBox(
                        width: itemWidth,
                        height: height,
                        child: itemBuilder?.call(context) ?? const GridTileSkeleton(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
