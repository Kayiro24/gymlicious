import 'package:flutter/material.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/app_theme.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_loading_ring.dart';
import 'package:gym_tracker/design_system/app_skeleton.dart';
import 'package:gym_tracker/design_system/motion.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Home quote, set like a pull quote: a large ember quotation mark, the line
/// in the display face, and a dashed-off attribution. Crossfades with a
/// small upward slide on change, shows a skeleton in the quote's shape while
/// fetching, and swaps plainly with reduced motion.
class QuoteCard extends StatelessWidget {
  const new({
    required this.text,
    required this.onRefresh,
    super.key,
    this.attribution,
    this.isLoading = false,
  });

  static const _slideOffset = 0.06;
  static const double _markSize = 72;
  static const _markOpacity = 0.9;
  static const _closingOpacity = 0.35;

  final String text;
  final String? attribution;
  final bool isLoading;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final isReduced = AppMotion.isReduced(context);
    final radius = BorderRadius.circular(TokenRadius.hero);
    final mark = TextStyle(
      fontFamily: AppTheme.displayFontFamily,
      fontWeight: FontWeight.w800,
      fontSize: _markSize,
      height: 1,
      color: colors.ember.withValues(alpha: _markOpacity),
    );
    final content = isLoading
        ? const _QuoteSkeleton(key: ValueKey('skeleton'))
        : _QuoteBody(key: ValueKey(text), text: text, attribution: attribution);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.heroGlow, colors.surface],
        ),
        border: Border.all(color: colors.hairline),
      ),
      child: Stack(
        children: [
          Positioned(
            right: TokenSpace.lg,
            bottom: -TokenSpace.lg,
            child: ExcludeSemantics(
              child: Text(
                '”',
                style: mark.copyWith(
                  color: colors.ember.withValues(alpha: _closingOpacity),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              TokenSpace.xl,
              TokenSpace.lg,
              TokenSpace.xl,
              TokenSpace.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ExcludeSemantics(
                  child: SizedBox(
                    height: TokenSpace.xxxl,
                    child: Text('“', style: mark),
                  ),
                ),
                Semantics(
                  liveRegion: true,
                  child: AnimatedSwitcher(
                    duration: AppMotion.of(context),
                    switchInCurve: AppMotion.curve,
                    transitionBuilder: (child, animation) => isReduced
                        ? child
                        : FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween(
                                begin: const Offset(0, _slideOffset),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          ),
                    child: content,
                  ),
                ),
                const SizedBox(height: TokenSpace.sm),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: isLoading
                      ? Padding(
                          padding: const EdgeInsets.all(TokenSpace.md),
                          child: AppLoadingRing(
                            semanticLabel: l10n.quoteLoading,
                          ),
                        )
                      : TextButton.icon(
                          onPressed: onRefresh,
                          style: TextButton.styleFrom(
                            foregroundColor: colors.accent,
                            minimumSize: const Size(
                              TokenLayout.minTouchTarget,
                              TokenLayout.minTouchTarget,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: TokenSpace.sm,
                            ),
                          ),
                          icon: const Icon(
                            LucideIcons.refreshCw,
                            size: TokenSpace.lg + TokenSpace.xxs,
                          ),
                          label: Text(
                            l10n.quoteNew,
                            semanticsLabel: l10n.quoteRefresh,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuoteBody extends StatelessWidget {
  const new({required this.text, required this.attribution, super.key});

  final String text;
  final String? attribution;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final byline = attribution;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: context.textStyles.titleLarge?.copyWith(
            height: 1.35,
            fontFeatures: const [],
          ),
        ),
        if (byline != null) ...[
          const SizedBox(height: TokenSpace.md),
          Row(
            children: [
              Container(
                width: TokenSpace.xl,
                height: TokenSpace.xxs,
                decoration: ShapeDecoration(
                  shape: const StadiumBorder(),
                  color: colors.ember,
                ),
              ),
              const SizedBox(width: TokenSpace.sm),
              Flexible(
                child: Text(
                  byline,
                  style: context.textStyles.labelMedium?.copyWith(
                    color: colors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _QuoteSkeleton extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppSkeleton.line(),
      SizedBox(height: TokenSpace.sm),
      AppSkeleton.line(widthFactor: 0.85),
      SizedBox(height: TokenSpace.sm),
      AppSkeleton.line(widthFactor: 0.6),
      SizedBox(height: TokenSpace.md),
      AppSkeleton.line(widthFactor: 0.35),
    ],
  );
}
