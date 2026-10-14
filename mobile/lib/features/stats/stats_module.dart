import 'package:go_router/go_router.dart';
import 'package:gym_tracker/core/module/feature_module.dart';
import 'package:gym_tracker/features/stats/presentation/screens/stats_screen.dart';
import 'package:gym_tracker/features/stats/presentation/stats_routes.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Read-only; owns no data.
final statsModule = FeatureModule(
  name: 'stats',
  tab: TabDestination(
    order: 3,
    label: (l10n) => l10n.tabStats,
    icon: LucideIcons.chartColumn,
    selectedIcon: LucideIcons.chartColumnBig,
    route: GoRoute(
      path: StatsRoutes.root,
      builder: (context, state) => const StatsScreen(),
    ),
  ),
);
