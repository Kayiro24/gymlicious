import 'package:go_router/go_router.dart';
import 'package:gym_tracker/core/module/feature_module.dart';
import 'package:gym_tracker/features/onboarding/presentation/onboarding_routes.dart';
import 'package:gym_tracker/features/onboarding/presentation/screens/all_set_screen.dart';
import 'package:gym_tracker/features/onboarding/presentation/screens/gate_screen.dart';
import 'package:gym_tracker/features/onboarding/presentation/screens/goal_step_screen.dart';
import 'package:gym_tracker/features/onboarding/presentation/screens/split_step_screen.dart';
import 'package:gym_tracker/features/onboarding/presentation/screens/weights_step_screen.dart';
import 'package:gym_tracker/features/onboarding/presentation/state/gate_providers.dart';

final onboardingModule = FeatureModule(
  name: 'onboarding',
  routes: [
    GoRoute(
      path: OnboardingRoutes.gate,
      builder: (context, state) => const GateScreen(),
      routes: [
        GoRoute(
          path: 'goal',
          builder: (context, state) => const GoalStepScreen(),
        ),
        GoRoute(
          path: 'done',
          builder: (context, state) => const AllSetScreen(),
        ),
        GoRoute(
          path: 'split',
          builder: (context, state) => const SplitStepScreen(),
        ),
        GoRoute(
          path: 'weights',
          builder: (context, state) => WeightsStepScreen(
            splitId:
                state.uri.queryParameters[OnboardingRoutes.splitIdParameter],
          ),
        ),
      ],
    ),
  ],
  clearLocalData: (read) => read(gateDraftStoreProvider).delete(),
);
