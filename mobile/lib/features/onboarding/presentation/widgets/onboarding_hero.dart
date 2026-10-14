import 'package:flutter/material.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/flame_icon.dart';
import 'package:gym_tracker/design_system/hero_card.dart';
import 'package:gym_tracker/design_system/step_indicator.dart';

/// Warm header shared by every onboarding step: flame mark, step progress,
/// a big heading and one supporting line.
class OnboardingHero extends StatelessWidget {
  const new({
    required this.title,
    required this.subtitle,
    super.key,
    this.step,
    this.flameDays = 1,
    this.mark,
  });

  static const totalSteps = 4;

  final String title;
  final String subtitle;

  /// 1-based; null hides the step indicator (the final screen).
  final int? step;
  final int flameDays;

  /// Replaces the flame (the welcome screen shows the logo).
  final Widget? mark;

  @override
  Widget build(BuildContext context) => HeroCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        mark ?? FlameIcon(streakDays: flameDays, size: TokenSpace.xxxl),
        const SizedBox(height: TokenSpace.lg),
        if (step case final step?) ...[
          StepIndicator(current: step, total: totalSteps),
          const SizedBox(height: TokenSpace.lg),
        ],
        Semantics(
          header: true,
          child: Text(title, style: context.textStyles.displaySmall),
        ),
        const SizedBox(height: TokenSpace.sm),
        Text(subtitle, style: context.textStyles.bodyLarge),
      ],
    ),
  );
}
