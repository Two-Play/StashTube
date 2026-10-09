import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// From this width (in logical pixels) lists get several columns (13.5):
/// tablets, and phones in landscape.
const double kWideLayoutBreakpoint = 600;

/// How many columns of about [columnWidth] fit into [width]: one below
/// [kWideLayoutBreakpoint], else at least two.
int listColumns(double width, double columnWidth) =>
    width < kWideLayoutBreakpoint ? 1 : math.max(2, (width / columnWidth).floor());

/// A list that becomes rows of several columns on wide screens (13.5).
/// Unlike a grid, the rows take the height of their tallest item, so items
/// of any height (and any text size) fit.
class SliverColumns extends StatelessWidget {
  const SliverColumns({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.columnWidth,
    this.spacing = 12,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  /// About how wide one column may get before another one is added.
  final double columnWidth;

  /// Between the columns and at the sides, with several columns.
  final double spacing;

  @override
  Widget build(BuildContext context) => SliverLayoutBuilder(
        builder: (context, constraints) {
          final columns = listColumns(constraints.crossAxisExtent, columnWidth);
          if (columns == 1) return SliverList.builder(itemCount: itemCount, itemBuilder: itemBuilder);
          return SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: spacing),
            sliver: SliverList.builder(
              itemCount: (itemCount / columns).ceil(),
              itemBuilder: (context, row) => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var column = 0; column < columns; column++) ...[
                    if (column > 0) SizedBox(width: spacing),
                    Expanded(
                      child: row * columns + column < itemCount
                          ? itemBuilder(context, row * columns + column)
                          : const SizedBox.shrink(),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      );
}
