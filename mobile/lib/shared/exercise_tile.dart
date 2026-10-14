import 'package:flutter/material.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/shared/stat_pill.dart';

/// Library row: name, a quiet subtitle, and Last / Max pills.
class ExerciseTile extends StatelessWidget {
  const new({
    required this.name,
    required this.subtitle,
    required this.lastText,
    required this.maxText,
    super.key,
    this.onTap,
    this.trailing,
    this.isSelected = false,
  });

  final String name;
  final String subtitle;
  final String lastText;
  final String maxText;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    return Material(
      color: isSelected ? colors.accentSoft : colors.surface,
      borderRadius: BorderRadius.circular(TokenRadius.input),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(TokenRadius.input),
        child: Padding(
          padding: const EdgeInsets.all(TokenSpace.lg),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: context.textStyles.titleMedium),
                    const SizedBox(height: TokenSpace.xxs),
                    Text(subtitle, style: context.textStyles.bodySmall),
                    const SizedBox(height: TokenSpace.sm),
                    Wrap(
                      spacing: TokenSpace.sm,
                      runSpacing: TokenSpace.xs,
                      children: [
                        StatPill(label: l10n.statLast, value: lastText),
                        StatPill(label: l10n.statMax, value: maxText),
                      ],
                    ),
                  ],
                ),
              ),
              ?trailing,
            ],
          ),
        ),
      ),
    );
  }
}
