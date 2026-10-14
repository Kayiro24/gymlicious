import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/layout/content_width.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_card.dart';
import 'package:gym_tracker/design_system/app_section_header.dart';
import 'package:gym_tracker/design_system/brand_mark.dart';
import 'package:package_info_plus/package_info_plus.dart';

final _packageInfoProvider = FutureProvider<PackageInfo>(
  (ref) => PackageInfo.fromPlatform(),
);

class AboutScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final version = ref.watch(_packageInfoProvider).value?.version;
    final text = context.textStyles;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsAbout)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(TokenSpace.lg),
          children: [
            ContentWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(child: BrandMark()),
                        const SizedBox(height: TokenSpace.lg),
                        Text(l10n.appTitle, style: text.headlineSmall),
                        if (version != null)
                          Text(
                            l10n.aboutVersion(version),
                            style: text.bodySmall,
                          ),
                        const SizedBox(height: TokenSpace.md),
                        Text(l10n.aboutBody, style: text.bodyLarge),
                        const SizedBox(height: TokenSpace.md),
                        Text(l10n.aboutMedical, style: text.bodyMedium),
                      ],
                    ),
                  ),
                  AppSectionHeader(l10n.aboutCredits),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.aboutAnimeChanCredit, style: text.bodyMedium),
                        const SizedBox(height: TokenSpace.sm),
                        Text(l10n.aboutFontCredit, style: text.bodyMedium),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
