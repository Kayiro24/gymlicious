import 'package:flutter/material.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_chip.dart';

class AppSegmentOption<T> {
  const new(this.value, this.label);

  final T value;
  final String label;
}

/// Single-choice group of pills that wraps on narrow widths and large text.
class AppSegmented<T> extends StatelessWidget {
  const new({
    required this.options,
    required this.selected,
    required this.onChanged,
    super.key,
    this.semanticLabel,
  });

  final List<AppSegmentOption<T>> options;
  final T? selected;
  final ValueChanged<T> onChanged;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) => Semantics(
    label: semanticLabel,
    container: true,
    child: Wrap(
      spacing: TokenSpace.sm,
      runSpacing: TokenSpace.sm,
      children: [
        for (final option in options)
          AppChip(
            label: option.label,
            isSelected: option.value == selected,
            onSelected: (_) => onChanged(option.value),
          ),
      ],
    ),
  );
}
