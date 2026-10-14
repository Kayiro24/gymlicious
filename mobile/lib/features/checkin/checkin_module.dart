import 'package:go_router/go_router.dart';
import 'package:gym_tracker/core/module/feature_module.dart';
import 'package:gym_tracker/features/checkin/data/check_in_repository.dart';
import 'package:gym_tracker/features/checkin/presentation/check_in_routes.dart';
import 'package:gym_tracker/features/checkin/presentation/screens/plan_screen.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

final checkinModule = FeatureModule(
  name: 'checkin',
  sections: const [CheckInRepository.section],
  tab: TabDestination(
    order: 1,
    label: (l10n) => l10n.tabPlan,
    icon: LucideIcons.calendar,
    selectedIcon: LucideIcons.calendarCheck,
    route: GoRoute(
      path: CheckInRoutes.plan,
      builder: (context, state) => const PlanScreen(),
    ),
  ),
);
