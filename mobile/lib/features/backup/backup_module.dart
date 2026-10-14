import 'package:go_router/go_router.dart';
import 'package:gym_tracker/core/module/feature_module.dart';
import 'package:gym_tracker/features/backup/presentation/backup_routes.dart';
import 'package:gym_tracker/features/backup/presentation/screens/backup_screen.dart';
import 'package:gym_tracker/features/backup/presentation/screens/reset_data_screen.dart';

final backupModule = FeatureModule(
  name: 'backup',
  routes: [
    GoRoute(
      path: BackupRoutes.backup,
      builder: (context, state) => const BackupScreen(),
      routes: [
        GoRoute(
          path: 'reset',
          builder: (context, state) => const ResetDataScreen(),
        ),
      ],
    ),
  ],
);
