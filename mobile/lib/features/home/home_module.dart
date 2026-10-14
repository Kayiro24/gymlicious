import 'package:go_router/go_router.dart';
import 'package:gym_tracker/core/module/feature_module.dart';
import 'package:gym_tracker/features/home/presentation/screens/home_screen.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

abstract final class HomeRoutes {
  static const root = '/';
}

final homeModule = FeatureModule(
  name: 'home',
  tab: TabDestination(
    order: 0,
    label: (l10n) => l10n.tabHome,
    icon: LucideIcons.house,
    selectedIcon: LucideIcons.house,
    route: GoRoute(
      path: HomeRoutes.root,
      builder: (context, state) => const HomeScreen(),
    ),
  ),
);
