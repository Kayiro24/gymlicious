import 'package:flutter/material.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';

/// The Gymlicious logo (generated from branding/gymlicious-logo.png).
class BrandMark extends StatelessWidget {
  const new({super.key, this.width = defaultWidth});

  static const asset = 'assets/brand/gymlicious_mark.png';
  static const double defaultWidth = 160;

  final double width;

  @override
  Widget build(BuildContext context) => Image.asset(
    asset,
    width: width,
    semanticLabel: AppLocalizations.of(context).appTitle,
  );
}
