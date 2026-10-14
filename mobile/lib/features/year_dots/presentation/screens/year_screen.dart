import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_tracker/core/clock/today_provider.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/app_theme.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_segmented.dart';
import 'package:gym_tracker/features/settings/settings.dart';
import 'package:gym_tracker/features/year_dots/domain/dot_layout.dart';
import 'package:gym_tracker/features/year_dots/domain/year_progress.dart';
import 'package:gym_tracker/features/year_dots/presentation/widgets/year_dots_grid.dart';
import 'package:gym_tracker/features/year_dots/presentation/widgets/year_dots_palette.dart';
import 'package:gym_tracker/features/year_dots/presentation/year_dots_routes.dart';
import 'package:gym_tracker/features/year_dots/presentation/year_dots_text.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// One screen, no scrolling: the year as dots plus a single text line.
class YearScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final progress = YearProgress(ref.watch(todayProvider));
    final layout = ref.watch(
      settingsControllerProvider.select((s) => s.yearDots.layout),
    );
    final kind = layout == YearDotsLayout.months
        ? DotLayoutKind.months
        : DotLayoutKind.continuous;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.yearTitle),
        actions: [
          IconButton(
            tooltip: l10n.yearWallpaper,
            icon: const Icon(LucideIcons.wallpaper),
            onPressed: () => context.push(YearDotsRoutes.wallpaper),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(TokenSpace.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSegmented<YearDotsLayout>(
                selected: layout,
                options: [
                  AppSegmentOption(
                    YearDotsLayout.continuous,
                    l10n.yearLayoutContinuous,
                  ),
                  AppSegmentOption(
                    YearDotsLayout.months,
                    l10n.yearLayoutMonths,
                  ),
                ],
                onChanged: (value) => ref
                    .read(settingsControllerProvider.notifier)
                    .update(
                      (settings) => settings.copyWith(
                        yearDots: settings.yearDots.copyWith(layout: value),
                      ),
                    ),
              ),
              const SizedBox(height: TokenSpace.lg),
              Expanded(
                child: Semantics(
                  label: l10n.yearGridSummary(
                    progress.dayOfYear,
                    progress.daysInYear,
                    progress.daysLeft,
                  ),
                  child: YearDotsGrid(
                    progress: progress,
                    kind: kind,
                    palette: YearDotsPalette.fromTheme(context.colors),
                  ),
                ),
              ),
              const SizedBox(height: TokenSpace.lg),
              ExcludeSemantics(
                child: Text(
                  YearDotsText.summary(l10n, progress),
                  textAlign: TextAlign.center,
                  style: context.textStyles.bodyMedium?.copyWith(
                    color: context.colors.textSecondary,
                    fontFeatures: AppTheme.tabularFigures,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
