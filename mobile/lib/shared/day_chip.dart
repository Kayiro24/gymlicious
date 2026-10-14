import 'package:flutter/material.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/motion.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// How a calendar day looks. A past day without a workout is a neutral
/// "no workout", never styled as a failure.
enum DayChipState { done, noWorkout, rest, planned, upcoming }

typedef DayChipData = ({
  String dayNumber,
  DayChipState state,
  bool isToday,
  String semanticLabel,
});

/// One day as a round chip with a small badge for its state, so states read
/// without colour. Today gets an outer ring.
class DayChip extends StatelessWidget {
  const new({
    required this.data,
    super.key,
    this.weekdayLabel,
    this.onTap,
    this.diameter = TokenSpace.xxl + TokenSpace.sm,
  });

  final DayChipData data;
  final String? weekdayLabel;
  final VoidCallback? onTap;
  final double diameter;

  static const _badgeRatio = 0.42;
  static const _badgeIconRatio = 0.62;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (fill, textColor, badge) = switch (data.state) {
      DayChipState.done => (colors.ember, colors.onEmber, LucideIcons.check),
      DayChipState.noWorkout => (
        colors.surfaceMuted,
        colors.textSecondary,
        null,
      ),
      DayChipState.rest => (
        colors.surfaceMuted,
        colors.textSecondary,
        LucideIcons.moon,
      ),
      DayChipState.planned => (
        colors.accentSoft,
        colors.textPrimary,
        LucideIcons.pencil,
      ),
      DayChipState.upcoming => (Colors.transparent, colors.textPrimary, null),
    };
    final badgeSize = diameter * _badgeRatio;
    final circle = AnimatedContainer(
      duration: AppMotion.of(context),
      curve: AppMotion.curve,
      width: diameter,
      height: diameter,
      alignment: Alignment.center,
      decoration: ShapeDecoration(
        color: fill,
        shape: CircleBorder(
          side: data.state == DayChipState.upcoming
              ? BorderSide(color: colors.hairline, width: TokenSpace.xxs)
              : BorderSide.none,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(TokenSpace.xs),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            data.dayNumber,
            style: context.textStyles.labelLarge?.copyWith(
              color: textColor,
              fontWeight: data.isToday || data.state == DayChipState.done
                  ? FontWeight.w800
                  : FontWeight.w500,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ),
    );
    final ringed = Container(
      padding: const EdgeInsets.all(TokenSpace.xxs),
      decoration: ShapeDecoration(
        shape: CircleBorder(
          side: BorderSide(
            color: data.isToday ? colors.accent : Colors.transparent,
            width: TokenSpace.xxs,
          ),
        ),
      ),
      child: circle,
    );
    final withBadge = Stack(
      clipBehavior: Clip.none,
      children: [
        ringed,
        if (badge != null)
          Positioned(
            right: -TokenSpace.xxs,
            bottom: -TokenSpace.xxs,
            child: Container(
              width: badgeSize,
              height: badgeSize,
              decoration: ShapeDecoration(
                color: colors.surface,
                shape: CircleBorder(side: BorderSide(color: colors.hairline)),
              ),
              child: Icon(
                badge,
                size: badgeSize * _badgeIconRatio,
                color: data.state == DayChipState.done
                    ? colors.accent
                    : colors.textSecondary,
              ),
            ),
          ),
      ],
    );
    return Semantics(
      label: data.semanticLabel,
      button: onTap != null,
      child: ExcludeSemantics(
        child: InkWell(
          onTap: onTap,
          customBorder: const StadiumBorder(),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: TokenLayout.minTouchTarget,
              minHeight: TokenLayout.minTouchTarget,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: TokenSpace.xs),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (weekdayLabel case final label?) ...[
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: context.textStyles.labelSmall?.copyWith(
                        fontWeight: data.isToday ? FontWeight.w700 : null,
                        color: data.isToday
                            ? colors.textPrimary
                            : colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: TokenSpace.xs),
                  ],
                  withBadge,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
