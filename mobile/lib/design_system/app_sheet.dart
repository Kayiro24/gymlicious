import 'package:flutter/material.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';

/// Shows a soft bottom sheet with an optional [title]; scrolls when tall.
Future<T?> showAppSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  String? title,
  bool isDismissible = true,
}) => showModalBottomSheet<T>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  isDismissible: isDismissible,
  enableDrag: isDismissible,
  builder: (sheetContext) =>
      AppSheetBody(title: title, child: builder(sheetContext)),
);

class AppSheetBody extends StatelessWidget {
  const new({required this.child, super.key, this.title});

  final String? title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final heading = title;
    return Padding(
      padding: EdgeInsets.only(
        left: TokenSpace.xl,
        right: TokenSpace.xl,
        bottom: TokenSpace.xl + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (heading != null) ...[
              Semantics(
                header: true,
                child: Text(heading, style: context.textStyles.titleLarge),
              ),
              const SizedBox(height: TokenSpace.lg),
            ],
            child,
          ],
        ),
      ),
    );
  }
}
