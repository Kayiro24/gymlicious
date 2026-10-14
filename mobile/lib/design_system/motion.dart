import 'package:flutter/widgets.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';

abstract final class AppMotion {
  static const Cubic curve = Curves.easeOutCubic;

  static bool isReduced(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context);

  /// [duration], or zero when the OS asks to reduce motion.
  static Duration of(
    BuildContext context, [
    Duration duration = TokenMotion.normal,
  ]) => isReduced(context) ? Duration.zero : duration;
}
