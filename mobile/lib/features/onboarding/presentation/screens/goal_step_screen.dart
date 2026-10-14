import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/layout/content_width.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_button.dart';
import 'package:gym_tracker/design_system/number_choice_chips.dart';
import 'package:gym_tracker/features/checkin/checkin.dart';
import 'package:gym_tracker/features/onboarding/presentation/onboarding_routes.dart';
import 'package:gym_tracker/features/onboarding/presentation/widgets/onboarding_hero.dart';

/// Step 2: "How many days a week?" Skipping keeps the default goal.
class GoalStepScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<GoalStepScreen> createState() => _GoalStepScreenState();
}

class _GoalStepScreenState extends ConsumerState<GoalStepScreen> {
  late int _goal = ref.read(weeklyGoalProvider);

  void _continue() {
    ref.read(checkInControllerProvider.notifier).setWeeklyGoal(_goal);
    context.go(OnboardingRoutes.split);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(TokenSpace.xl),
            children: [
              ContentWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    OnboardingHero(
                      step: 2,
                      flameDays: _goal * TokenFlame.tier2Days,
                      title: l10n.goalStepTitle,
                      subtitle: l10n.goalStepBody,
                    ),
                    const SizedBox(height: TokenSpace.xxl),
                    NumberChoiceChips(
                      values: [
                        for (
                          var days = WeeklyGoalHistory.minDays;
                          days <= WeeklyGoalHistory.maxDays;
                          days++
                        )
                          days,
                      ],
                      selected: _goal,
                      onChanged: (value) => setState(() => _goal = value),
                    ),
                    const SizedBox(height: TokenSpace.md),
                    Semantics(
                      liveRegion: true,
                      child: Text(
                        l10n.goalDaysPerWeek(_goal),
                        textAlign: TextAlign.center,
                        style: context.textStyles.titleLarge,
                      ),
                    ),
                    const SizedBox(height: TokenSpace.xxl),
                    AppButton(
                      label: l10n.gateContinue,
                      isExpanded: true,
                      onPressed: _continue,
                    ),
                    AppButton(
                      label: l10n.setUpLater,
                      variant: AppButtonVariant.quiet,
                      onPressed: () => context.go(OnboardingRoutes.split),
                    ),
                    const SizedBox(height: TokenSpace.sm),
                    Text(
                      l10n.meGymDaysHelp,
                      textAlign: TextAlign.center,
                      style: context.textStyles.bodySmall?.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
