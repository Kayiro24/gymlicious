import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/layout/content_width.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/core/units/number_format.dart';
import 'package:gym_tracker/core/units/units.dart';
import 'package:gym_tracker/design_system/app_button.dart';
import 'package:gym_tracker/design_system/app_card.dart';
import 'package:gym_tracker/features/onboarding/presentation/onboarding_routes.dart';
import 'package:gym_tracker/features/onboarding/presentation/widgets/onboarding_hero.dart';
import 'package:gym_tracker/features/settings/settings.dart';
import 'package:gym_tracker/features/workouts/workouts.dart';
import 'package:gym_tracker/shared/unit_field.dart';

/// Optional setup step 3: baseline max and last weights (spec 5.1, D4).
class WeightsStepScreen extends ConsumerStatefulWidget {
  const new({required this.splitId, super.key});

  final String? splitId;

  @override
  ConsumerState<WeightsStepScreen> createState() => _WeightsStepScreenState();
}

class _WeightsStepScreenState extends ConsumerState<WeightsStepScreen> {
  final _max = <String, TextEditingController>{};
  final _last = <String, TextEditingController>{};
  Set<String> _invalid = const {};

  @override
  void dispose() {
    for (final controller in [..._max.values, ..._last.values]) {
      controller.dispose();
    }
    super.dispose();
  }

  List<Exercise> _exercises() {
    final data = ref.read(workoutsControllerProvider);
    final split = data.splitById(widget.splitId);
    final ids = <String>{
      for (final day in split?.days ?? const <SplitDay>[]) ...day.exerciseIds,
    };
    return [for (final id in ids) ?data.exerciseById(id)];
  }

  void _save(WeightUnit unit) {
    final baselines = <String, StartingWeight>{};
    final invalid = <String>{};
    double? parse(TextEditingController? controller, String key) {
      final text = controller?.text.trim() ?? '';
      if (text.isEmpty) {
        return null;
      }
      final value = NumberText.parseDecimal(text);
      if (value == null || value < 0) {
        invalid.add(key);
        return null;
      }
      return UnitConversion.fromDisplayWeight(value, unit);
    }

    for (final exercise in _exercises()) {
      final maxKg = parse(_max[exercise.id], 'max-${exercise.id}');
      final lastKg = parse(_last[exercise.id], 'last-${exercise.id}');
      if (maxKg != null || lastKg != null) {
        baselines[exercise.id] = (maxKg: maxKg, lastKg: lastKg);
      }
    }
    if (invalid.isNotEmpty) {
      setState(() => _invalid = invalid);
      return;
    }
    ref.read(workoutsControllerProvider.notifier).setBaselines(baselines);
    context.go(OnboardingRoutes.done);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final unit = ref.watch(
      settingsControllerProvider.select((settings) => settings.weightUnit),
    );
    final exercises = _exercises();
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
                      step: 4,
                      flameDays: TokenFlame.tier3Days,
                      title: l10n.weightsStepTitle,
                      subtitle: l10n.weightsStepSubtitle,
                    ),
                    const SizedBox(height: TokenSpace.xl),
                    for (final exercise in exercises) ...[
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              exercise.name,
                              style: context.textStyles.titleMedium,
                            ),
                            const SizedBox(height: TokenSpace.md),
                            Wrap(
                              spacing: TokenSpace.md,
                              runSpacing: TokenSpace.md,
                              children: [
                                for (final (key, label, controllers) in [
                                  ('max', l10n.weightsStepMax, _max),
                                  ('last', l10n.weightsStepLast, _last),
                                ])
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      minWidth: TokenLayout.minTouchTarget * 2,
                                      maxWidth:
                                          TokenLayout.contentMaxWidth / 2.4,
                                    ),
                                    child: UnitField(
                                      label: label,
                                      unitLabel: unit.name,
                                      isRequired: false,
                                      controller: controllers.putIfAbsent(
                                        exercise.id,
                                        TextEditingController.new,
                                      ),
                                      errorText:
                                          _invalid.contains(
                                            '$key-${exercise.id}',
                                          )
                                          ? l10n.weightsStepInvalid
                                          : null,
                                      onChanged: (_) {},
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: TokenSpace.md),
                    ],
                    const SizedBox(height: TokenSpace.lg),
                    AppButton(
                      label: l10n.weightsStepSave,
                      isExpanded: true,
                      onPressed: () => _save(unit),
                    ),
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
