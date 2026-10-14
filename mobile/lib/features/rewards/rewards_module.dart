import 'package:go_router/go_router.dart';
import 'package:gym_tracker/core/module/feature_module.dart';
import 'package:gym_tracker/features/rewards/data/rewards_repository.dart';
import 'package:gym_tracker/features/rewards/presentation/rewards_routes.dart';
import 'package:gym_tracker/features/rewards/presentation/screens/badges_screen.dart';

final rewardsModule = FeatureModule(
  name: 'rewards',
  sections: const [RewardsRepository.section],
  routes: [
    GoRoute(
      path: RewardsRoutes.badges,
      builder: (context, state) => const BadgesScreen(),
    ),
  ],
);
