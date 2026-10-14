import 'package:gym_tracker/core/module/feature_module.dart';
import 'package:gym_tracker/features/quotes/presentation/state/quote_controller.dart';

/// Quotes keep only a disposable cache outside the document, never backed up.
final quotesModule = FeatureModule(
  name: 'quotes',
  clearLocalData: (read) => read(quoteCacheRepositoryProvider).clear(),
);
