import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/design_tokens.dart';
import '../../data/models/scene.dart';
import '../../l10n/l10n.dart';
import '../shell/navigation.dart';
import 'scene_description.dart';
import 'scene_edits.dart';

/// The watch page's tags: as many of the first [maxShown] tags as fit in
/// one line, then "+N" for the rest, which opens the description sheet with
/// all of them. A tag opens its page. Nothing when the scene has no tags.
class SceneTagsRow extends ConsumerStatefulWidget {
  const SceneTagsRow({super.key, required this.scene, this.maxShown = 5});

  final Scene scene;
  final int maxShown;

  @override
  ConsumerState<SceneTagsRow> createState() => _SceneTagsRowState();
}

class _SceneTagsRowState extends ConsumerState<SceneTagsRow> {
  /// How many tags the last layout showed, so the hidden chips can't take
  /// the keyboard focus (null until the first layout).
  int? _visible;

  void _onLayout(int visible) {
    if (mounted && visible != _visible) setState(() => _visible = visible);
  }

  @override
  Widget build(BuildContext context) {
    final scene = widget.scene;
    final tags = effectiveTags(ref, scene);
    if (tags.isEmpty) return const SizedBox.shrink();
    final l = context.l10n;
    final primary = Theme.of(context).colorScheme.primary;
    final shown = tags.take(widget.maxShown).toList();
    final visible = _visible;

    Widget more(int hidden) => ExcludeFocus(
          excluding: visible != null && tags.length - visible != hidden,
          child: ActionChip(
            label: Text(l.moreTags(hidden), semanticsLabel: l.moreTagsSemantics(hidden)),
            onPressed: () => showSceneDescription(context, scene),
          ),
        );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
      child: _FitRow(
        spacing: AppSpacing.s,
        itemCount: shown.length,
        total: tags.length,
        onLayout: _onLayout,
        children: [
          for (final (i, tag) in shown.indexed)
            ExcludeFocus(
              excluding: visible != null && i >= visible,
              child: ActionChip(
                label: Text('#${tag.name}', maxLines: 1, overflow: TextOverflow.ellipsis),
                labelStyle: TextStyle(color: primary),
                onPressed: () => openTag(ref, tag.id),
              ),
            ),
          // "+N" for every number of tags that might not fit; the row shows
          // the one that matches.
          for (var n = shown.length; n >= 0; n--)
            if (tags.length - n > 0) more(tags.length - n),
        ],
      ),
    );
  }
}

/// One line of [itemCount] items followed by "+N" chips, one per possible
/// N = [total] − visible items (largest visible count first). Lays out as
/// many leading items as fit together with the matching "+N" chip; the
/// others are neither painted, hit-tested nor read out. If not even one
/// item fits next to its "+N", the first one is squeezed (its label
/// ellipsizes).
class _FitRow extends MultiChildRenderObjectWidget {
  const _FitRow({
    required this.spacing,
    required this.itemCount,
    required this.total,
    required this.onLayout,
    required super.children,
  });

  final double spacing;
  final int itemCount;
  final int total;

  /// Told after a frame whose layout showed a different number of items.
  final ValueChanged<int> onLayout;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderFitRow(spacing, itemCount, total, onLayout);

  @override
  void updateRenderObject(BuildContext context, _RenderFitRow renderObject) => renderObject
    ..spacing = spacing
    ..itemCount = itemCount
    ..total = total
    ..onLayout = onLayout;
}

class _FitRowParentData extends ContainerBoxParentData<RenderBox> {
  bool shown = false;
}

class _RenderFitRow extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, _FitRowParentData>, RenderBoxContainerDefaultsMixin<RenderBox, _FitRowParentData> {
  _RenderFitRow(this._spacing, this._itemCount, this._total, this.onLayout);

  ValueChanged<int> onLayout;
  int? _reported;

  double _spacing;
  set spacing(double value) {
    if (value == _spacing) return;
    _spacing = value;
    markNeedsLayout();
  }

  int _itemCount;
  set itemCount(int value) {
    if (value == _itemCount) return;
    _itemCount = value;
    markNeedsLayout();
  }

  int _total;
  set total(int value) {
    if (value == _total) return;
    _total = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _FitRowParentData) child.parentData = _FitRowParentData();
  }

  List<RenderBox> get _children {
    final list = <RenderBox>[];
    var child = firstChild;
    while (child != null) {
      list.add(child);
      child = childAfter(child);
    }
    return list;
  }

  @override
  void performLayout() {
    final children = _children;
    final maxWidth = constraints.maxWidth;
    final loose = BoxConstraints(maxWidth: maxWidth);
    for (final child in children) {
      child.layout(loose, parentUsesSize: true);
      (child.parentData! as _FitRowParentData).shown = false;
    }
    final items = children.take(_itemCount).toList();
    // The "+N" chip for [visible] items, if any are hidden.
    RenderBox? moreFor(int visible) {
      if (_total - visible <= 0) return null;
      // No chip for all items when nothing is left over.
      final index = _itemCount + (_itemCount - visible) - (_total > _itemCount ? 0 : 1);
      return index < children.length ? children[index] : null;
    }

    double widthOf(int visible) {
      var width = 0.0;
      for (var i = 0; i < visible; i++) {
        width += items[i].size.width + (i > 0 ? _spacing : 0);
      }
      final more = moreFor(visible);
      if (more != null) width += more.size.width + (visible > 0 ? _spacing : 0);
      return width;
    }

    var visible = _itemCount;
    while (visible > 0 && widthOf(visible) > maxWidth) {
      visible--;
    }
    if (visible == 0 && _itemCount > 0) {
      // Squeeze the first item next to its "+N".
      visible = 1;
      final more = moreFor(1);
      final room = maxWidth - (more == null ? 0 : more.size.width + _spacing);
      items.first.layout(BoxConstraints(maxWidth: math.max(0, room)), parentUsesSize: true);
    }

    if (visible != _reported) {
      _reported = visible;
      final count = visible;
      SchedulerBinding.instance.addPostFrameCallback((_) => onLayout(count));
    }

    final shown = [...items.take(visible), ?moreFor(visible)];
    final height = shown.fold<double>(0, (h, c) => math.max(h, c.size.height));
    var x = 0.0;
    for (final child in shown) {
      (child.parentData! as _FitRowParentData)
        ..shown = true
        ..offset = Offset(x, (height - child.size.height) / 2);
      x += child.size.width + _spacing;
    }
    size = constraints.constrain(Size(maxWidth.isFinite ? maxWidth : math.max(0, x - _spacing), height));
  }

  @override
  double computeMinIntrinsicHeight(double width) => _children.fold(0, (h, c) => math.max(h, c.getMinIntrinsicHeight(double.infinity)));

  @override
  double computeMaxIntrinsicHeight(double width) => _children.fold(0, (h, c) => math.max(h, c.getMaxIntrinsicHeight(double.infinity)));

  bool _isShown(RenderBox child) => (child.parentData! as _FitRowParentData).shown;

  @override
  void paint(PaintingContext context, Offset offset) {
    for (final child in _children.where(_isShown)) {
      context.paintChild(child, (child.parentData! as _FitRowParentData).offset + offset);
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    for (final child in _children.reversed.where(_isShown)) {
      final offset = (child.parentData! as _FitRowParentData).offset;
      final hit = result.addWithPaintOffset(
        offset: offset,
        position: position,
        hitTest: (result, transformed) => child.hitTest(result, position: transformed),
      );
      if (hit) return true;
    }
    return false;
  }

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    for (final child in _children.where(_isShown)) {
      visitor(child);
    }
  }
}
