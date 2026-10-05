import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        itemCount: values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final value = values[i];
          final isSelected = value == selected;
          return ChoiceChip(
            label: Text(labelOf(value)),
            selected: isSelected,
            labelStyle: TextStyle(
              color: isSelected ? colors.surface : colors.onSurface,
              fontWeight: FontWeight.w500,
            ),
            onSelected: (_) => onSelected(value),
          );
        },
      ),
    );
  }
}
