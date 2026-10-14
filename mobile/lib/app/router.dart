import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_tracker/app/app_shell.dart';
import 'package:gym_tracker/app/recovery_screen.dart';
import 'package:gym_tracker/core/providers.dart';
import 'package:gym_tracker/features/home/home.dart';
import 'package:gym_tracker/features/onboarding/onboarding.dart';
import 'package:gym_tracker/features/profile/profile.dart';

/// Re-runs redirects when the gate or recovery conditions change.
class _RedirectTrigger extends ChangeNotifier {
  new(Ref ref) {
    ref
      ..listen(hasValidProfileProvider, (_, _) => notifyListeners())
      ..listen(storageStatusProvider, (_, _) => notifyListeners());
  }
}

/// Lets app-level hosts (celebrations) show dialogs above every route.
final rootNavigatorKeyProvider = Provider<GlobalKey<NavigatorState>>(
  (ref) => GlobalKey<NavigatorState>(),
);

final routerProvider = Provider<GoRouter>((ref) {
  final modules = ref.watch(featureModulesProvider);
  final tabs = [for (final module in modules) ?module.tab]
    ..sort((a, b) => a.order.compareTo(b.order));
  final trigger = _RedirectTrigger(ref);
  final router = GoRouter(
    navigatorKey: ref.watch(rootNavigatorKeyProvider),
    initialLocation: HomeRoutes.root,
    refreshListenable: trigger,
    redirect: (context, state) {
      final location = state.matchedLocation;
      if (ref.read(storageStatusProvider.notifier).isCorrupted) {
        return location == RecoveryScreen.path ? null : RecoveryScreen.path;
      }
      if (location == RecoveryScreen.path) {
        return HomeRoutes.root;
      }
      final hasProfile = ref.read(hasValidProfileProvider);
      if (!hasProfile) {
        return location == OnboardingRoutes.gate ? null : OnboardingRoutes.gate;
      }
      return location == OnboardingRoutes.gate ? HomeRoutes.root : null;
    },
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(shell: shell, tabs: tabs),
        branches: [
          for (final tab in tabs) StatefulShellBranch(routes: [tab.route]),
        ],
      ),
      for (final module in modules) ...module.routes,
      GoRoute(
        path: RecoveryScreen.path,
        builder: (context, state) => const RecoveryScreen(),
      ),
    ],
  );
  ref.onDispose(() {
    router.dispose();
    trigger.dispose();
  });
  return router;
});
