import 'dart:async';

import 'package:alchemist/alchemist.dart';

/// Only CI goldens (text drawn as blocks) are compared, so Windows, macOS
/// and Linux produce identical images.
Future<void> testExecutable(FutureOr<void> Function() testMain) =>
    AlchemistConfig.runWithConfig(
      config: const AlchemistConfig(
        platformGoldensConfig: PlatformGoldensConfig(enabled: false),
      ),
      run: () async {
        await testMain();
      },
    );
