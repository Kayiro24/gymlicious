import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/clock/today_provider.dart';
import 'package:gym_tracker/core/failure/failure.dart';
import 'package:gym_tracker/core/failure/result.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/layout/content_width.dart';
import 'package:gym_tracker/core/platform/platform_providers.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_button.dart';
import 'package:gym_tracker/design_system/app_card.dart';
import 'package:gym_tracker/design_system/app_progress_sheet.dart';
import 'package:gym_tracker/design_system/app_section_header.dart';
import 'package:gym_tracker/design_system/app_segmented.dart';
import 'package:gym_tracker/design_system/app_toast.dart';
import 'package:gym_tracker/features/settings/settings.dart';
import 'package:gym_tracker/features/year_dots/domain/year_progress.dart';
import 'package:gym_tracker/features/year_dots/presentation/wallpaper_image_renderer.dart';
import 'package:gym_tracker/features/year_dots/presentation/year_dots_text.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

final _liveWallpaperSupportedProvider = FutureProvider<bool>(
  (ref) => ref.watch(wallpaperGatewayProvider).isLiveWallpaperSupported(),
);

/// Wallpaper settings with a live preview, "Set as wallpaper" (Android) and
/// "Save wallpaper image" (both platforms).
class WallpaperScreen extends ConsumerWidget {
  const new({super.key});

  static const _previewHeight = 360.0;

  void _update(
    WidgetRef ref,
    YearDotsSettings Function(YearDotsSettings) change,
  ) => ref
      .read(settingsControllerProvider.notifier)
      .update(
        (settings) => settings.copyWith(yearDots: change(settings.yearDots)),
      );

  List<String> _monthInitials(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return [
      for (var month = 1; month <= DateTime.monthsPerYear; month++)
        DateFormat('MMMMM', locale).format(DateTime(2001, month)),
    ];
  }

  Future<void> _saveImage(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final view = View.of(context);
    final pixelRatio = view.devicePixelRatio;
    final settings = ref.read(settingsControllerProvider).yearDots;
    final progress = YearProgress(ref.read(todayProvider));
    final textLine = YearDotsText.line(l10n, progress, settings.textLine);
    final monthInitials = _monthInitials(context);
    await runWithProgressSheet<void>(
      context: context,
      workingText: l10n.wallpaperWorking,
      successText: l10n.wallpaperSaved,
      failureText: (_) => l10n.wallpaperSaveFailed,
      task: () async {
        final png = await WallpaperImageRenderer.renderPng(
          pixelSize: view.physicalSize,
          pixelRatio: pixelRatio,
          settings: settings,
          progress: progress,
          textLine: textLine,
          monthInitials: monthInitials,
        );
        final isSaved = await ref
            .read(wallpaperGatewayProvider)
            .saveImageToPhotos(png);
        return isSaved
            ? const Ok(null)
            : const Err(PlatformFailure('Photos refused the image'));
      },
    );
  }

  Future<void> _setLive(BuildContext context, WidgetRef ref) async {
    final isOpened = await ref
        .read(wallpaperGatewayProvider)
        .openLiveWallpaperPicker();
    if (!isOpened && context.mounted) {
      showAppToast(context, AppLocalizations.of(context).wallpaperLiveFailed);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(
      settingsControllerProvider.select((s) => s.yearDots),
    );
    final progress = YearProgress(ref.watch(todayProvider));
    final isLiveSupported =
        ref.watch(_liveWallpaperSupportedProvider).value ?? false;
    final screen = MediaQuery.sizeOf(context);
    final previewWidth = _previewHeight * screen.width / screen.height;
    final textLine = YearDotsText.line(l10n, progress, settings.textLine);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.wallpaperTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(TokenSpace.lg),
          children: [
            ContentWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: ExcludeSemantics(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(TokenRadius.card),
                        child: SizedBox(
                          width: previewWidth,
                          height: _previewHeight,
                          child: CustomPaint(
                            painter: _PreviewPainter(
                              settings: settings,
                              progress: progress,
                              textLine: textLine,
                              monthInitials: _monthInitials(context),
                              scale: _previewHeight / screen.height,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  AppSectionHeader(l10n.wallpaperLayout),
                  AppSegmented<YearDotsLayout>(
                    selected: settings.layout,
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
                    onChanged: (value) =>
                        _update(ref, (s) => s.copyWith(layout: value)),
                  ),
                  AppSectionHeader(l10n.wallpaperColours),
                  AppSegmented<YearDotsColorPreset>(
                    selected: settings.colorPreset,
                    options: [
                      AppSegmentOption(
                        YearDotsColorPreset.light,
                        l10n.wallpaperPresetLight,
                      ),
                      AppSegmentOption(
                        YearDotsColorPreset.dark,
                        l10n.wallpaperPresetDark,
                      ),
                      AppSegmentOption(
                        YearDotsColorPreset.black,
                        l10n.wallpaperPresetBlack,
                      ),
                      AppSegmentOption(
                        YearDotsColorPreset.ember,
                        l10n.wallpaperPresetEmber,
                      ),
                    ],
                    onChanged: (value) =>
                        _update(ref, (s) => s.copyWith(colorPreset: value)),
                  ),
                  AppSectionHeader(l10n.wallpaperTextLine),
                  AppSegmented<YearDotsTextLine>(
                    selected: settings.textLine,
                    options: [
                      AppSegmentOption(
                        YearDotsTextLine.leftAndPercent,
                        l10n.wallpaperTextLeftAndPercent,
                      ),
                      AppSegmentOption(
                        YearDotsTextLine.leftOnly,
                        l10n.wallpaperTextLeftOnly,
                      ),
                      AppSegmentOption(
                        YearDotsTextLine.none,
                        l10n.wallpaperTextNone,
                      ),
                    ],
                    onChanged: (value) =>
                        _update(ref, (s) => s.copyWith(textLine: value)),
                  ),
                  const SizedBox(height: TokenSpace.lg),
                  Text(
                    l10n.wallpaperTopMargin(settings.topMarginPercent),
                    style: context.textStyles.labelMedium,
                  ),
                  Slider(
                    value: settings.topMarginPercent.toDouble(),
                    min: YearDotsSettings.minTopMarginPercent.toDouble(),
                    max: YearDotsSettings.maxTopMarginPercent.toDouble(),
                    divisions:
                        YearDotsSettings.maxTopMarginPercent -
                        YearDotsSettings.minTopMarginPercent,
                    label: '${settings.topMarginPercent}%',
                    onChanged: (value) => _update(
                      ref,
                      (s) => s.copyWith(topMarginPercent: value.round()),
                    ),
                  ),
                  Text(
                    l10n.wallpaperPadding(settings.padding),
                    style: context.textStyles.labelMedium,
                  ),
                  Slider(
                    value: settings.padding.toDouble(),
                    min: YearDotsSettings.minPadding.toDouble(),
                    max: YearDotsSettings.maxPadding.toDouble(),
                    divisions:
                        (YearDotsSettings.maxPadding -
                            YearDotsSettings.minPadding) ~/
                        4,
                    label: '${settings.padding}',
                    onChanged: (value) =>
                        _update(ref, (s) => s.copyWith(padding: value.round())),
                  ),
                  const SizedBox(height: TokenSpace.xl),
                  if (isLiveSupported) ...[
                    AppButton(
                      label: l10n.wallpaperSetLive,
                      icon: LucideIcons.smartphone,
                      isExpanded: true,
                      onPressed: () => _setLive(context, ref),
                    ),
                    const SizedBox(height: TokenSpace.xs),
                    Text(
                      l10n.wallpaperSetLiveHint,
                      style: context.textStyles.bodySmall,
                    ),
                    const SizedBox(height: TokenSpace.lg),
                  ],
                  AppButton(
                    label: l10n.wallpaperSaveImage,
                    icon: LucideIcons.imageDown,
                    isExpanded: true,
                    variant: isLiveSupported
                        ? AppButtonVariant.secondary
                        : AppButtonVariant.primary,
                    onPressed: () => _saveImage(context, ref),
                  ),
                  const SizedBox(height: TokenSpace.xs),
                  Text(
                    l10n.wallpaperSaveImageHint,
                    style: context.textStyles.bodySmall,
                  ),
                  const SizedBox(height: TokenSpace.lg),
                  AppCard(
                    color: context.colors.surfaceMuted,
                    child: Text(
                      Platform.isIOS
                          ? l10n.wallpaperIosNote
                          : l10n.wallpaperSamsungNote,
                      style: context.textStyles.bodyMedium,
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

class _PreviewPainter extends CustomPainter {
  new({
    required this.settings,
    required this.progress,
    required this.textLine,
    required this.monthInitials,
    required this.scale,
  });

  final YearDotsSettings settings;
  final YearProgress progress;
  final String? textLine;
  final List<String> monthInitials;

  /// Preview height ÷ screen height, so padding scales like the real thing.
  final double scale;

  @override
  void paint(Canvas canvas, Size size) => WallpaperImageRenderer.paint(
    canvas,
    size,
    settings: settings,
    progress: progress,
    textLine: textLine,
    monthInitials: monthInitials,
    pixelRatio: scale,
  );

  @override
  bool shouldRepaint(_PreviewPainter oldDelegate) =>
      oldDelegate.settings != settings ||
      oldDelegate.progress.today != progress.today ||
      oldDelegate.textLine != textLine;
}
