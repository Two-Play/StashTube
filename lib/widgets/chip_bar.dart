import 'package:flutter/material.dart';

import '../core/config/haptics.dart';

/// Horizontally scrolling choice chips, like YouTube's feed filters.
class ChipBar<T> extends StatelessWidget {
  const ChipBar({
    super.key,
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.onSelected,
  });

  final List<T> values;
  final T selected;
  final String Function(T) labelOf;
  final ValueChanged<T> onSelected;

  /// The bar's fixed height.
  static const double height = 48;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        itemCount: values.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final value = values[i];
          return ChoiceChip(
            label: Text(labelOf(value)),
            selected: value == selected,
            onSelected: (_) {
              if (value != selected) Haptics.selection();
              onSelected(value);
            },
          );
        },
      ),
    );
  }
}

/// The pinned chips: [topSpace] above them scrolls away down to [inset];
/// the chips get the surface color and a hairline once content passes
/// beneath them.
class PinnedBarDelegate extends SliverPersistentHeaderDelegate {
  PinnedBarDelegate({required this.topSpace, required this.inset, required this.height, required this.child});

  final double topSpace;
  final double inset;
  final double height;
  final Widget child;

  @override
  double get maxExtent => topSpace + height;

  @override
  double get minExtent => inset + height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final colors = Theme.of(context).colorScheme;
    final pinned = shrinkOffset > 0 && shrinkOffset >= maxExtent - minExtent - 0.5;
    return Align(
      alignment: Alignment.bottomCenter,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(
            bottom: BorderSide(color: pinned ? colors.outlineVariant : colors.surface.withValues(alpha: 0), width: 0.5),
          ),
        ),
        child: SizedBox(height: height, child: child),
      ),
    );
  }

  @override
  bool shouldRebuild(PinnedBarDelegate old) =>
      old.topSpace != topSpace || old.inset != inset || old.height != height || old.child != child;
}

/// A bar of chips (sort, filter button) that stays at the top of its list
/// while the content scrolls beneath it, like home's; below other pinned
/// headers (a channel's tab bar) when there are some.
class PinnedBar extends StatelessWidget {
  const PinnedBar({super.key, required this.child, this.height = ChipBar.height});

  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) => SliverPersistentHeader(
        pinned: true,
        delegate: PinnedBarDelegate(topSpace: 0, inset: 0, height: height, child: child),
      );
}
