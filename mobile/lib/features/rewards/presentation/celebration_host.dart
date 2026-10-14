import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/core/clock/today_provider.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/providers.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/flame_icon.dart';
import 'package:gym_tracker/features/checkin/checkin.dart';
import 'package:gym_tracker/features/rewards/domain/badges.dart';
import 'package:gym_tracker/features/rewards/presentation/badge_text.dart';
import 'package:gym_tracker/features/rewards/presentation/state/rewards_providers.dart';
import 'package:gym_tracker/shared/celebration_overlay.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

typedef _Moment = ({
  int dataVersion,
  bool isTodayDone,
  int streakDays,
  CalendarDate monday,
  bool isWeekMet,
  int personalRecords,
  int level,
  Set<BadgeKind> deserved,
});

final _momentProvider = Provider<_Moment>((ref) {
  final streak = ref.watch(streakSnapshotProvider);
  final summary = ref.watch(rewardsSummaryProvider);
  return (
    dataVersion: ref.watch(dataVersionProvider),
    isTodayDone: ref.watch(isTodayDoneProvider),
    streakDays: streak.currentDays,
    monday: streak.currentWeek.monday,
    isWeekMet: streak.currentWeek.status == WeekStatus.met,
    personalRecords: summary.metrics.personalRecords,
    level: summary.level.level,
    deserved: Badges.deserved(summary.metrics),
  );
});

enum _Kind { level, badge, personalRecord, weekGoal, checkIn }

typedef _Celebration = ({
  _Kind kind,
  String title,
  String? message,
  Widget leading,
});

/// Turns real changes into one short celebration. App start and restores
/// (a data-version change) only record badges silently (D46).
class CelebrationHost extends ConsumerStatefulWidget {
  const new({required this.navigatorKey, required this.child, super.key});

  final GlobalKey<NavigatorState> navigatorKey;
  final Widget child;

  @override
  ConsumerState<CelebrationHost> createState() => _CelebrationHostState();
}

class _CelebrationHostState extends ConsumerState<CelebrationHost> {
  _Moment? _last;
  bool _isShowing = false;

  @override
  void initState() {
    super.initState();
    ref.listenManual<_Moment>(
      _momentProvider,
      (_, next) => scheduleMicrotask(() => _onMoment(next)),
      fireImmediately: true,
    );
  }

  void _onMoment(_Moment next) {
    if (!mounted) {
      return;
    }
    final last = _last;
    _last = next;
    final rewards = ref.read(rewardsControllerProvider.notifier);
    final previousLevel =
        ref.read(rewardsControllerProvider).lastCelebratedLevel ?? next.level;
    final fresh = rewards.record(
      deserved: next.deserved,
      level: next.level,
      today: ref.read(todayProvider),
    );
    if (last == null || last.dataVersion != next.dataVersion) {
      return;
    }
    final l10n = AppLocalizations.of(context);
    final celebrations = <_Celebration>[
      if (next.level > previousLevel)
        (
          kind: _Kind.level,
          title: l10n.celebrateLevelUp(next.level),
          message: l10n.celebrateLevelUpMessage,
          leading: _Medallion(child: Text('${next.level}')),
        ),
      for (final kind in fresh)
        (
          kind: _Kind.badge,
          title: l10n.celebrateBadge(BadgeText.title(l10n, kind)),
          message: null,
          leading: _Medallion(child: Icon(BadgeText.icon(kind))),
        ),
      if (next.personalRecords > last.personalRecords)
        (
          kind: _Kind.personalRecord,
          title: l10n.celebratePr,
          message: l10n.celebratePrMessage,
          leading: const _Medallion(child: Icon(LucideIcons.trophy)),
        ),
      if (next.isWeekMet && !(last.isWeekMet && last.monday == next.monday))
        (
          kind: _Kind.weekGoal,
          title: l10n.celebrateWeekGoal,
          message: null,
          leading: FlameIcon(streakDays: next.streakDays, size: _leadingSize),
        ),
      if (next.isTodayDone && !last.isTodayDone)
        (
          kind: _Kind.checkIn,
          title: l10n.celebrateCheckIn(next.streakDays),
          message: CheckInText.status(
            l10n,
            ref.read(streakSnapshotProvider),
            isTodayDone: true,
          ),
          leading: FlameIcon(streakDays: next.streakDays, size: _leadingSize),
        ),
    ]..sort((a, b) => a.kind.index.compareTo(b.kind.index));
    if (celebrations.isNotEmpty) {
      unawaited(_show(celebrations));
    }
  }

  static const double _leadingSize = TokenSpace.xxxl * 1.5;

  Future<void> _show(List<_Celebration> celebrations) async {
    final overlayContext = widget.navigatorKey.currentState?.overlay?.context;
    if (_isShowing || overlayContext == null) {
      return;
    }
    _isShowing = true;
    final first = celebrations.first;
    final rest = [for (final item in celebrations.skip(1)) item.title];
    await CelebrationOverlay.show(
      overlayContext,
      title: first.title,
      message: [?first.message, ...rest].join('\n'),
      leading: first.leading,
    );
    _isShowing = false;
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _Medallion extends StatelessWidget {
  const new({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: _CelebrationHostState._leadingSize,
      height: _CelebrationHostState._leadingSize,
      alignment: Alignment.center,
      decoration: ShapeDecoration(
        shape: const CircleBorder(),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.gold, colors.ember],
        ),
      ),
      child: IconTheme(
        data: IconThemeData(
          color: colors.onGold,
          size: _CelebrationHostState._leadingSize / 2,
        ),
        child: DefaultTextStyle(
          style: context.textStyles.displaySmall!.copyWith(
            color: colors.onGold,
          ),
          child: child,
        ),
      ),
    );
  }
}
