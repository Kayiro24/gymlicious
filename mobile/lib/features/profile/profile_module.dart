import 'package:go_router/go_router.dart';
import 'package:gym_tracker/core/module/feature_module.dart';
import 'package:gym_tracker/features/profile/data/photo_backup_contributor.dart';
import 'package:gym_tracker/features/profile/data/profile_repository.dart';
import 'package:gym_tracker/features/profile/presentation/profile_routes.dart';
import 'package:gym_tracker/features/profile/presentation/screens/profile_screen.dart';
import 'package:gym_tracker/features/profile/presentation/state/profile_controller.dart';

final profileModule = FeatureModule(
  name: 'profile',
  sections: const [ProfileRepository.section],
  routes: [
    GoRoute(
      path: ProfileRoutes.profile,
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
  backupContributors: (ref) => [
    PhotoBackupContributor(ref.watch(photoStoreProvider)),
  ],
  clearLocalData: (read) => read(photoStoreProvider).delete(),
);
