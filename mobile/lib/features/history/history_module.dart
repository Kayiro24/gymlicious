import 'package:go_router/go_router.dart';
import 'package:gym_tracker/core/module/feature_module.dart';
import 'package:gym_tracker/features/history/presentation/history_routes.dart';
import 'package:gym_tracker/features/history/presentation/screens/history_screen.dart';
import 'package:gym_tracker/features/history/presentation/screens/session_detail_screen.dart';
import 'package:gym_tracker/features/history/presentation/screens/session_edit_screen.dart';

final historyModule = FeatureModule(
  name: 'history',
  routes: [
    GoRoute(
      path: HistoryRoutes.root,
      builder: (context, state) => const HistoryScreen(),
      routes: [
        GoRoute(
          path: ':${HistoryRoutes.idParameter}',
          builder: (context, state) => SessionDetailScreen(
            sessionId: state.pathParameters[HistoryRoutes.idParameter]!,
          ),
          routes: [
            GoRoute(
              path: 'edit',
              builder: (context, state) => SessionEditScreen(
                sessionId: state.pathParameters[HistoryRoutes.idParameter]!,
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);
