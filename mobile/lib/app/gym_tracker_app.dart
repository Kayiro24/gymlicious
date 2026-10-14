import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/app/router.dart';
import 'package:gym_tracker/core/failure/failure.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/providers.dart';
import 'package:gym_tracker/core/theme/app_theme.dart';
import 'package:gym_tracker/features/rewards/rewards.dart';
import 'package:gym_tracker/features/settings/settings.dart';
import 'package:gym_tracker/features/year_dots/year_dots.dart';

class GymTrackerApp extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<GymTrackerApp> createState() => _GymTrackerAppState();
}

class _GymTrackerAppState extends ConsumerState<GymTrackerApp> {
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();
  late final AppLifecycleListener _lifecycle;
  StreamSubscription<Failure>? _saveFailures;

  @override
  void initState() {
    super.initState();
    final store = ref.read(documentStoreProvider);
    // Debounced saves must reach disk before the OS may kill a background app.
    _lifecycle = AppLifecycleListener(
      onInactive: () => unawaited(store.flush()),
      onHide: () => unawaited(store.flush()),
      onPause: () => unawaited(store.flush()),
      onDetach: () => unawaited(store.flush()),
    );
    _saveFailures = store.saveFailures.listen(_onSaveFailure);
  }

  void _onSaveFailure(Failure failure) {
    final context = _messengerKey.currentContext;
    if (context == null) {
      return;
    }
    final l10n = AppLocalizations.of(context);
    _messengerKey.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(l10n.commonSaveFailed),
          action: SnackBarAction(
            label: l10n.commonRetry,
            onPressed: () => unawaited(ref.read(documentStoreProvider).flush()),
          ),
        ),
      );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    unawaited(_saveFailures?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(settingsControllerProvider.select((s) => s.theme));
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: _messengerKey,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: switch (theme) {
        ThemePreference.system => ThemeMode.system,
        ThemePreference.light => ThemeMode.light,
        ThemePreference.dark => ThemeMode.dark,
      },
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: ref.watch(routerProvider),
      builder: (context, child) => WallpaperConfigSync(
        child: CheckInReminderSync(
          child: CelebrationHost(
            navigatorKey: ref.watch(rootNavigatorKeyProvider),
            child: child ?? const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
