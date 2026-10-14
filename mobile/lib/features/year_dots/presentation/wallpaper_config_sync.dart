import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/platform/platform_providers.dart';
import 'package:gym_tracker/features/settings/settings.dart';
import 'package:gym_tracker/features/year_dots/presentation/year_dots_text.dart';
import 'package:intl/intl.dart';

/// Keeps the native wallpaper's stored config in step with settings,
/// including after a restore (spec 5.10 D). Wraps the app below
/// localisations so templates can be translated.
class WallpaperConfigSync extends ConsumerStatefulWidget {
  const new({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<WallpaperConfigSync> createState() =>
      _WallpaperConfigSyncState();
}

class _WallpaperConfigSyncState extends ConsumerState<WallpaperConfigSync> {
  Map<String, Object?>? _lastPushed;

  void _push(YearDotsSettings settings) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final templates = YearDotsText.nativeTemplates(l10n);
    final config = <String, Object?>{
      'layout': settings.layout.name,
      'colorPreset': settings.colorPreset.name,
      'textLine': settings.textLine.storageName,
      'topMarginPercent': settings.topMarginPercent,
      'padding': settings.padding,
      'summaryTemplate': templates.summary,
      'leftOnlyTemplate': templates.leftOnly,
      'monthInitials': [
        for (var month = 1; month <= DateTime.monthsPerYear; month++)
          DateFormat('MMMMM', locale).format(DateTime(2001, month)),
      ].join(','),
    };
    if (_lastPushed.toString() == config.toString()) {
      return;
    }
    _lastPushed = config;
    unawaited(ref.read(wallpaperGatewayProvider).pushConfig(config));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _push(ref.read(settingsControllerProvider).yearDots);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      settingsControllerProvider.select((settings) => settings.yearDots),
      (_, next) => _push(next),
    );
    return widget.child;
  }
}
