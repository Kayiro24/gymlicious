import 'package:go_router/go_router.dart';
import 'package:gym_tracker/core/module/feature_module.dart';
import 'package:gym_tracker/features/settings/data/settings_repository.dart';
import 'package:gym_tracker/features/settings/presentation/screens/about_screen.dart';
import 'package:gym_tracker/features/settings/presentation/screens/privacy_screen.dart';
import 'package:gym_tracker/features/settings/presentation/screens/settings_screen.dart';
import 'package:gym_tracker/features/settings/presentation/settings_routes.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

final settingsModule = FeatureModule(
  name: 'settings',
  sections: const [SettingsRepository.section],
  tab: TabDestination(
    order: 4,
    label: (l10n) => l10n.tabMe,
    icon: LucideIcons.circleUser,
    selectedIcon: LucideIcons.circleUserRound,
    route: GoRoute(
      path: SettingsRoutes.root,
      builder: (context, state) => const SettingsScreen(),
      routes: [
        GoRoute(
          path: 'about',
          builder: (context, state) => const AboutScreen(),
        ),
        GoRoute(
          path: 'privacy',
          builder: (context, state) => const PrivacyScreen(),
        ),
      ],
    ),
  ),
);
