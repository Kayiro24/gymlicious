import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/layout/content_width.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/core/units/number_format.dart';
import 'package:gym_tracker/core/units/units.dart';
import 'package:gym_tracker/design_system/app_card.dart';
import 'package:gym_tracker/design_system/app_list_tile.dart';
import 'package:gym_tracker/design_system/app_section_header.dart';
import 'package:gym_tracker/design_system/app_segmented.dart';
import 'package:gym_tracker/features/settings/domain/app_settings.dart';
import 'package:gym_tracker/features/settings/presentation/settings_routes.dart';
import 'package:gym_tracker/features/settings/presentation/state/settings_controller.dart';
import 'package:gym_tracker/features/settings/presentation/widgets/training_settings.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SettingsScreen extends ConsumerWidget {
  const new({super.key});

  static const kilogramSteps = [1.0, 1.25, 2.5, 5.0];
  static const poundSteps = [2.5, 5.0, 10.0];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);
    final steps = settings.weightUnit == WeightUnit.kg
        ? kilogramSteps
        : poundSteps;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.meTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(TokenSpace.lg),
          children: [
            ContentWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: AppListTile(
                      leadingIcon: LucideIcons.circleUser,
                      title: l10n.meEditProfile,
                      subtitle: l10n.settingsProfileSubtitle,
                      trailing: const Icon(LucideIcons.chevronRight),
                      onTap: () => context.push(SettingsLinks.profile),
                    ),
                  ),
                  AppSectionHeader(l10n.meTraining),
                  const TrainingSettings(),
                  AppSectionHeader(l10n.settingsUnits),
                  _Group(
                    children: [
                      _Labelled(
                        label: l10n.settingsWeightUnit,
                        child: AppSegmented<WeightUnit>(
                          semanticLabel: l10n.settingsWeightUnit,
                          selected: settings.weightUnit,
                          options: [
                            AppSegmentOption(
                              WeightUnit.kg,
                              l10n.settingsUnitKilograms,
                            ),
                            AppSegmentOption(
                              WeightUnit.lb,
                              l10n.settingsUnitPounds,
                            ),
                          ],
                          onChanged: (unit) => controller.update(
                            (current) => current.withWeightUnit(unit),
                          ),
                        ),
                      ),
                      _Labelled(
                        label: l10n.settingsHeightUnit,
                        child: AppSegmented<HeightUnit>(
                          semanticLabel: l10n.settingsHeightUnit,
                          selected: settings.heightUnit,
                          options: [
                            AppSegmentOption(
                              HeightUnit.cm,
                              l10n.settingsUnitCentimetres,
                            ),
                            AppSegmentOption(
                              HeightUnit.ftIn,
                              l10n.settingsUnitFeetInches,
                            ),
                          ],
                          onChanged: (unit) => controller.update(
                            (current) => current.copyWith(heightUnit: unit),
                          ),
                        ),
                      ),
                      _Labelled(
                        label: l10n.settingsIncrement,
                        hint: l10n.settingsIncrementHint,
                        child: AppSegmented<double>(
                          semanticLabel: l10n.settingsIncrement,
                          selected: settings.weightIncrement,
                          options: [
                            for (final step in steps)
                              AppSegmentOption(
                                step,
                                l10n.weightWithUnit(
                                  NumberText.trimmed(step, step: 0.25),
                                  settings.weightUnit.name,
                                ),
                              ),
                          ],
                          onChanged: (step) => controller.update(
                            (current) =>
                                current.copyWith(weightIncrement: step),
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppSectionHeader(l10n.settingsAppearance),
                  _Group(
                    children: [
                      AppSegmented<ThemePreference>(
                        semanticLabel: l10n.settingsAppearance,
                        selected: settings.theme,
                        options: [
                          AppSegmentOption(
                            ThemePreference.system,
                            l10n.settingsThemeSystem,
                          ),
                          AppSegmentOption(
                            ThemePreference.light,
                            l10n.settingsThemeLight,
                          ),
                          AppSegmentOption(
                            ThemePreference.dark,
                            l10n.settingsThemeDark,
                          ),
                        ],
                        onChanged: (theme) => controller.update(
                          (current) => current.copyWith(theme: theme),
                        ),
                      ),
                    ],
                  ),
                  AppSectionHeader(l10n.settingsQuotes),
                  _Group(
                    children: [
                      _Labelled(
                        hint: l10n.settingsQuoteHint,
                        child: AppSegmented<QuoteMode>(
                          semanticLabel: l10n.settingsQuotes,
                          selected: settings.quoteMode,
                          options: [
                            AppSegmentOption(
                              QuoteMode.gym,
                              l10n.settingsQuoteGym,
                            ),
                            AppSegmentOption(
                              QuoteMode.anime,
                              l10n.settingsQuoteAnime,
                            ),
                            AppSegmentOption(
                              QuoteMode.mix,
                              l10n.settingsQuoteMix,
                            ),
                            AppSegmentOption(
                              QuoteMode.off,
                              l10n.settingsQuoteOff,
                            ),
                          ],
                          onChanged: (mode) => controller.update(
                            (current) => current.copyWith(quoteMode: mode),
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppSectionHeader(l10n.settingsData),
                  _LinkGroup(
                    links: [
                      (
                        LucideIcons.archive,
                        l10n.settingsBackup,
                        SettingsLinks.backup,
                      ),
                      (
                        LucideIcons.layoutGrid,
                        l10n.settingsYearDotsWallpaper,
                        SettingsLinks.wallpaper,
                      ),
                    ],
                  ),
                  AppSectionHeader(l10n.settingsAboutSection),
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        AppListTile(
                          leadingIcon: LucideIcons.info,
                          title: l10n.settingsAbout,
                          onTap: () => context.push(SettingsRoutes.about),
                        ),
                        AppListTile(
                          leadingIcon: LucideIcons.shieldCheck,
                          title: l10n.settingsPrivacy,
                          onTap: () => context.push(SettingsRoutes.privacy),
                        ),
                        AppListTile(
                          leadingIcon: LucideIcons.scrollText,
                          title: l10n.settingsLicenses,
                          onTap: () => showLicensePage(
                            context: context,
                            applicationName: l10n.appTitle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppSectionHeader(l10n.settingsDangerZone),
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: AppListTile(
                      leadingIcon: LucideIcons.triangleAlert,
                      title: l10n.settingsReset,
                      subtitle: l10n.settingsResetSubtitle,
                      isDestructive: true,
                      onTap: () => context.push(SettingsLinks.reset),
                    ),
                  ),
                  const SizedBox(height: TokenSpace.xxl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Group extends StatelessWidget {
  const new({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => AppCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (index, child) in children.indexed) ...[
          if (index > 0) const SizedBox(height: TokenSpace.lg),
          child,
        ],
      ],
    ),
  );
}

class _Labelled extends StatelessWidget {
  const new({required this.child, this.label, this.hint});

  final String? label;
  final String? hint;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final title = label;
    final detail = hint;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(title, style: context.textStyles.labelMedium),
          const SizedBox(height: TokenSpace.sm),
        ],
        child,
        if (detail != null) ...[
          const SizedBox(height: TokenSpace.sm),
          Text(detail, style: context.textStyles.bodySmall),
        ],
      ],
    );
  }
}

class _LinkGroup extends StatelessWidget {
  const new({required this.links});

  final List<(IconData, String, String)> links;

  @override
  Widget build(BuildContext context) => AppCard(
    padding: EdgeInsets.zero,
    child: Column(
      children: [
        for (final (icon, title, path) in links)
          AppListTile(
            leadingIcon: icon,
            title: title,
            trailing: const Icon(LucideIcons.chevronRight),
            onTap: () => context.push(path),
          ),
      ],
    ),
  );
}
