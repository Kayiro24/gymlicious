import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/layout/content_width.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_button.dart';
import 'package:gym_tracker/design_system/flame_icon.dart';
import 'package:gym_tracker/design_system/motion.dart';
import 'package:gym_tracker/features/onboarding/presentation/onboarding_routes.dart';
import 'package:gym_tracker/features/profile/profile.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// The short "You're all set" moment that lands on Home.
class AllSetScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<AllSetScreen> createState() => _AllSetScreenState();
}

class _AllSetScreenState extends ConsumerState<AllSetScreen> {
  static const _startScale = 0.6;

  @override
  void initState() {
    super.initState();
    unawaited(HapticFeedback.mediumImpact());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final name =
        ref.watch(profileControllerProvider)?.name.split(' ').first ?? '';
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: DecoratedBox(
          decoration: BoxDecoration(gradient: colors.heroGradient),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(TokenSpace.xl),
                child: ContentWidth(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: _startScale, end: 1),
                        duration: AppMotion.of(
                          context,
                          TokenMotion.celebration,
                        ),
                        curve: Curves.easeOutBack,
                        builder: (context, scale, child) =>
                            Transform.scale(scale: scale, child: child),
                        child: const FlameIcon(
                          streakDays: TokenFlame.tier3Days,
                          size: TokenSpace.xxxl * 2,
                        ),
                      ),
                      const SizedBox(height: TokenSpace.xl),
                      Semantics(
                        header: true,
                        liveRegion: true,
                        child: Text(
                          l10n.allSetTitle(name),
                          textAlign: TextAlign.center,
                          style: context.textStyles.displaySmall,
                        ),
                      ),
                      const SizedBox(height: TokenSpace.sm),
                      Text(
                        l10n.allSetBody,
                        textAlign: TextAlign.center,
                        style: context.textStyles.bodyLarge,
                      ),
                      const SizedBox(height: TokenSpace.xxl),
                      AppButton(
                        label: l10n.allSetGo,
                        icon: LucideIcons.arrowRight,
                        isExpanded: true,
                        onPressed: () => context.go(OnboardingLinks.home),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
