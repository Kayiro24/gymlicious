abstract final class OnboardingRoutes {
  static const gate = '/welcome';
  static const goal = '/welcome/goal';
  static const done = '/welcome/done';
  static const split = '/welcome/split';
  static const weights = '/welcome/weights';
  static const splitIdParameter = 'split';

  static String weightsFor(String splitId) => Uri(
    path: weights,
    queryParameters: {splitIdParameter: splitId},
  ).toString();
}

/// Destinations owned by other features.
abstract final class OnboardingLinks {
  static const home = '/';
  static const newSplit = '/train/splits/new';
}
