import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_button.dart';
import 'package:gym_tracker/design_system/app_card.dart';
import 'package:gym_tracker/features/train/train.dart';
import 'package:gym_tracker/features/workouts/workouts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Shown only while an unfinished workout exists; starting one lives on
/// the Today card.
class ResumeWorkoutCard extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final draft = ref.watch(
      workoutsControllerProvider.select((d) => d.activeSession),
    );
    if (draft != null) {
      final time = DateFormat.jm(
        Localizations.localeOf(context).toLanguageTag(),
      ).format(draft.startedAt);
      return Padding(
        padding: const EdgeInsets.only(bottom: TokenSpace.lg),
        child: AppCard(
          color: context.colors.accentSoft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.homeResumeTitle, style: context.textStyles.titleLarge),
              Text(
                l10n.homeResumeSubtitle(
                  draft.dayName ?? l10n.sessionFreestyle,
                  time,
                ),
                style: context.textStyles.bodyMedium,
              ),
              const SizedBox(height: TokenSpace.lg),
              AppButton(
                label: l10n.trainResume,
                icon: LucideIcons.play,
                isExpanded: true,
                onPressed: () => context.push(TrainRoutes.session),
              ),
              AppButton(
                label: l10n.trainDiscard,
                variant: AppButtonVariant.quiet,
                onPressed: () async {
                  if (await TrainActions.confirmDiscard(context)) {
                    ref
                        .read(workoutsControllerProvider.notifier)
                        .discardActiveSession();
                  }
                },
              ),
            ],
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
