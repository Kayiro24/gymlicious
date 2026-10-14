import 'package:go_router/go_router.dart';
import 'package:gym_tracker/core/module/feature_module.dart';
import 'package:gym_tracker/features/year_dots/presentation/screens/wallpaper_screen.dart';
import 'package:gym_tracker/features/year_dots/presentation/screens/year_screen.dart';
import 'package:gym_tracker/features/year_dots/presentation/year_dots_routes.dart';

/// Derived from the date only: no data section and no backup entry; its
/// wallpaper preferences live in settings. Opened from Stats (D44).
final yearDotsModule = FeatureModule(
  name: 'year_dots',
  routes: [
    GoRoute(
      path: YearDotsRoutes.root,
      builder: (context, state) => const YearScreen(),
    ),
    GoRoute(
      path: YearDotsRoutes.wallpaper,
      builder: (context, state) => const WallpaperScreen(),
    ),
  ],
);
