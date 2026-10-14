import 'package:flutter/widgets.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';

/// Caps readable content at the token width and centres it on large screens.
class ContentWidth extends StatelessWidget {
  const new({
    required this.child,
    super.key,
    this.maxWidth = TokenLayout.contentMaxWidth,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child,
    ),
  );
}
