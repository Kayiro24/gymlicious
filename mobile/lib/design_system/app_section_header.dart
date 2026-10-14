import 'package:flutter/material.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';

class AppSectionHeader extends StatelessWidget {
  const new(this.title, {super.key, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(
      top: TokenSpace.xl,
      bottom: TokenSpace.sm,
      left: TokenSpace.xs,
    ),
    child: Row(
      children: [
        Expanded(
          child: Semantics(
            header: true,
            child: Text(title, style: context.textStyles.titleMedium),
          ),
        ),
        ?trailing,
      ],
    ),
  );
}
