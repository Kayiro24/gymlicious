import 'package:flutter/material.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/layout/content_width.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_card.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class PrivacyScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final points = [
      (LucideIcons.userX, l10n.privacyNoAccounts),
      (LucideIcons.smartphone, l10n.privacyOnDevice),
      (LucideIcons.quote, l10n.privacyQuotes),
      (LucideIcons.fileJson, l10n.privacyBackups),
      (LucideIcons.cloud, l10n.privacyDeviceBackup),
      (LucideIcons.chartNoAxesColumn, l10n.privacyAnalytics),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.privacyTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(TokenSpace.lg),
          children: [
            ContentWidth(
              child: AppCard(
                child: Column(
                  children: [
                    for (final (icon, body) in points)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: TokenSpace.sm,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(icon, color: context.colors.accent),
                            const SizedBox(width: TokenSpace.md),
                            Expanded(
                              child: Text(
                                body,
                                style: context.textStyles.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
