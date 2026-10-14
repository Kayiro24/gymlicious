import 'package:go_router/go_router.dart';
import 'package:gym_tracker/core/module/feature_module.dart';
import 'package:gym_tracker/features/exercises/presentation/exercises_routes.dart';
import 'package:gym_tracker/features/exercises/presentation/screens/exercise_detail_screen.dart';
import 'package:gym_tracker/features/exercises/presentation/screens/exercises_screen.dart';

/// Reached from Train (D44), so it has no tab of its own.
final exercisesModule = FeatureModule(
  name: 'exercises',
  routes: [
    GoRoute(
      path: ExercisesRoutes.root,
      builder: (context, state) => const ExercisesScreen(),
      routes: [
        GoRoute(
          path: ':${ExercisesRoutes.idParameter}',
          builder: (context, state) => ExerciseDetailScreen(
            exerciseId: state.pathParameters[ExercisesRoutes.idParameter]!,
          ),
        ),
      ],
    ),
  ],
);
