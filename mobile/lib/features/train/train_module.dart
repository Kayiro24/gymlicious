import 'package:go_router/go_router.dart';
import 'package:gym_tracker/core/module/feature_module.dart';
import 'package:gym_tracker/features/train/presentation/screens/session_screen.dart';
import 'package:gym_tracker/features/train/presentation/screens/split_editor_screen.dart';
import 'package:gym_tracker/features/train/presentation/screens/train_screen.dart';
import 'package:gym_tracker/features/train/presentation/train_routes.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

final trainModule = FeatureModule(
  name: 'train',
  tab: TabDestination(
    order: 2,
    label: (l10n) => l10n.tabTrain,
    icon: LucideIcons.dumbbell,
    selectedIcon: LucideIcons.dumbbell,
    route: GoRoute(
      path: TrainRoutes.root,
      builder: (context, state) => const TrainScreen(),
      routes: [
        GoRoute(
          path: 'splits/:${TrainRoutes.splitIdParameter}',
          builder: (context, state) {
            final id = state.pathParameters[TrainRoutes.splitIdParameter];
            return SplitEditorScreen(
              splitId: id == TrainRoutes.newSplitId ? null : id,
            );
          },
        ),
      ],
    ),
  ),
  routes: [
    GoRoute(
      path: TrainRoutes.session,
      builder: (context, state) => const SessionScreen(),
    ),
  ],
);
