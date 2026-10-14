import 'package:flutter/material.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_card.dart';

/// One big number with a plain label underneath.
class StatTile extends StatelessWidget {
  const new({required this.value, required this.label, super.key, this.icon});

  final String value;
  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      label: '$value $label',
      container: true,
      child: ExcludeSemantics(
        child: AppCard(
          padding: const EdgeInsets.all(TokenSpace.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: TokenSpace.xl, color: colors.accent),
                const SizedBox(height: TokenSpace.sm),
              ],
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(value, style: context.textStyles.displaySmall),
              ),
              const SizedBox(height: TokenSpace.xxs),
              Text(label, style: context.textStyles.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
