import 'package:flutter/material.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/motion.dart';

/// Big tappable number choices (days per week) sharing one row. The selected
/// chip is filled, outlined and bold, so it reads without colour.
class NumberChoiceChips extends StatelessWidget {
  const new({
    required this.values,
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final List<int> values;
  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      for (final (index, value) in values.indexed) ...[
        if (index > 0) const SizedBox(width: TokenSpace.sm),
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: TokenLayout.primaryButtonHeight,
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: _NumberChip(
                  value: value,
                  isSelected: value == selected,
                  onTap: () => onChanged(value),
                ),
              ),
            ),
          ),
        ),
      ],
    ],
  );
}

class _NumberChip extends StatelessWidget {
  const new({
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  final int value;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      selected: isSelected,
      label: AppLocalizations.of(context).numberChoiceSemantics(value),
      child: ExcludeSemantics(
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: AnimatedContainer(
            duration: AppMotion.of(context),
            curve: AppMotion.curve,
            alignment: Alignment.center,
            decoration: ShapeDecoration(
              color: isSelected ? colors.accent : colors.surfaceMuted,
              shape: CircleBorder(
                side: isSelected
                    ? BorderSide(
                        color: colors.textPrimary,
                        width: TokenSpace.xxs,
                      )
                    : BorderSide.none,
              ),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '$value',
                style: context.textStyles.titleLarge?.copyWith(
                  color: isSelected ? colors.onAccent : colors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
