import 'package:flutter/material.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_card.dart';
import 'package:gym_tracker/features/workouts/workouts.dart';
import 'package:intl/intl.dart';

class SessionCard extends StatelessWidget {
  const new({
    required this.session,
    required this.onTap,
    super.key,
    this.isSelected = false,
  });

  final WorkoutSession session;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final exercises = session.entries
        .where((entry) => entry.countedSets.isNotEmpty)
        .length;
    final sets = session.entries.fold<int>(
      0,
      (count, entry) => count + entry.countedSets.length,
    );
    return AppCard(
      onTap: onTap,
      color: isSelected ? context.colors.accentSoft : null,
      padding: const EdgeInsets.all(TokenSpace.lg),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.dayName ?? l10n.sessionFreestyle,
                  style: context.textStyles.titleMedium,
                ),
                Text(
                  DateFormat.MMMEd(locale).add_jm().format(session.startedAt),
                  style: context.textStyles.bodySmall,
                ),
              ],
            ),
          ),
          Text(
            l10n.historySessionSummary(
              l10n.trainExerciseCount(exercises),
              l10n.historySetCount(sets),
            ),
            style: context.textStyles.labelSmall,
          ),
        ],
      ),
    );
  }
}
