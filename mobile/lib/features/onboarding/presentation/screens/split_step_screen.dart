import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/layout/content_width.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_button.dart';
import 'package:gym_tracker/features/onboarding/presentation/onboarding_routes.dart';
import 'package:gym_tracker/features/onboarding/presentation/widgets/onboarding_hero.dart';
import 'package:gym_tracker/features/settings/settings.dart';
import 'package:gym_tracker/features/workouts/workouts.dart';
import 'package:gym_tracker/shared/split_day_chip.dart';

/// Optional setup step 2: copy a preset split and make it active.
class SplitStepScreen extends ConsumerWidget {
  const new({super.key});

  void _choose(BuildContext context, WidgetRef ref, WorkoutSplit preset) {
    final split = ref
        .read(workoutsControllerProvider.notifier)
        .addSplitFromPreset(preset);
    ref
        .read(settingsControllerProvider.notifier)
        .update((settings) => settings.copyWith(activeSplitId: split.id));
    context.go(OnboardingRoutes.weightsFor(split.id));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final presets = ref.watch(seedCatalogProvider).presets;
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
                      step: 3,
                      flameDays: TokenFlame.tier2Days,
                      title: l10n.splitStepTitle,
                      subtitle: l10n.splitStepSubtitle,
                    ),
                    const SizedBox(height: TokenSpace.xl),
                    for (final preset in presets) ...[
                      SplitDayChip(
                        name: preset.name,
                        detail: [
                          l10n.splitStepDays(preset.trainingDays.length),
                          preset.trainingDays
                              .map((day) => day.name)
                              .join(' · '),
                        ].join('  ·  '),
                        onTap: () => _choose(context, ref, preset),
                      ),
                      const SizedBox(height: TokenSpace.sm),
                    ],
                    SplitDayChip(
                      name: l10n.splitStepOwn,
                      detail: l10n.splitStepOwnSubtitle,
                      onTap: () {
                        context.go(OnboardingLinks.home);
                        unawaited(context.push(OnboardingLinks.newSplit));
                      },
                    ),
                    const SizedBox(height: TokenSpace.xl),
                    AppButton(
                      label: l10n.setUpLater,
                      variant: AppButtonVariant.quiet,
                      onPressed: () => context.go(OnboardingRoutes.done),
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
