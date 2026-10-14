import 'package:flutter/widgets.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';

enum WindowSizeClass {
  compact,
  medium,
  expanded;

  static WindowSizeClass fromWidth(double width) {
    if (width < TokenLayout.compactMaxWidth) {
      return WindowSizeClass.compact;
    }
    if (width <= TokenLayout.mediumMaxWidth) {
      return WindowSizeClass.medium;
    }
    return WindowSizeClass.expanded;
  }

  static WindowSizeClass of(BuildContext context) =>
      fromWidth(MediaQuery.sizeOf(context).width);

  bool get isCompact => this == WindowSizeClass.compact;

  bool get isExpanded => this == WindowSizeClass.expanded;
}
