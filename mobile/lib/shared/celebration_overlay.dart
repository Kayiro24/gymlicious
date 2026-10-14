import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/motion.dart';

/// A brief, tasteful celebration: a card that pops in with a light haptic
/// and a dozen soft sparks. With reduced motion it simply fades in.
class CelebrationOverlay extends StatefulWidget {
  const new({
    required this.title,
    required this.leading,
    super.key,
    this.message,
  });

  final String title;
  final String? message;
  final Widget leading;

  static const _sparkCount = 12;
  static const _barrierOpacity = 0.24;
  static const _popFrom = 0.85;

  /// Shows the overlay; it closes on tap or after two celebration beats.
  static Future<void> show(
    BuildContext context, {
    required String title,
    required Widget leading,
    String? message,
  }) async {
    unawaited(HapticFeedback.mediumImpact());
    final duration = AppMotion.of(context, TokenMotion.slow);
    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: AppLocalizations.of(context).celebrationContinue,
      barrierColor: context.colors.textPrimary.withValues(
        alpha: CelebrationOverlay._barrierOpacity,
      ),
      transitionDuration: duration,
      pageBuilder: (context, _, _) =>
          CelebrationOverlay(title: title, leading: leading, message: message),
      transitionBuilder: (context, animation, _, child) => FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: AppMotion.curve),
        child: child,
      ),
    );
  }

  @override
  State<CelebrationOverlay> createState() => _CelebrationOverlayState();
}

class _CelebrationOverlayState extends State<CelebrationOverlay>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: TokenMotion.celebration,
  );
  Timer? _autoClose;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_autoClose != null) {
      return;
    }
    if (!AppMotion.isReduced(context)) {
      _controller.forward();
    }
    _autoClose = Timer(TokenMotion.celebration * 2, _close);
  }

  void _close() {
    if (mounted && ModalRoute.of(context)?.isCurrent == true) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _autoClose?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final pop = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.45, curve: Curves.easeOutBack),
    );
    final card = Container(
      constraints: const BoxConstraints(
        maxWidth: TokenLayout.contentMaxWidth / 1.5,
      ),
      padding: const EdgeInsets.all(TokenSpace.xl),
      decoration: BoxDecoration(
        gradient: colors.heroGradient,
        borderRadius: BorderRadius.circular(TokenRadius.hero),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.leading,
          const SizedBox(height: TokenSpace.lg),
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: context.textStyles.headlineSmall,
          ),
          if (widget.message case final message?) ...[
            const SizedBox(height: TokenSpace.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.textStyles.bodyLarge,
            ),
          ],
          const SizedBox(height: TokenSpace.lg),
          Text(l10n.celebrationContinue, style: context.textStyles.bodySmall),
        ],
      ),
    );
    return Semantics(
      liveRegion: true,
      label: [widget.title, ?widget.message].join('. '),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _close,
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(TokenSpace.xl),
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: _SparkPainter(
                          progress: _controller,
                          colors: [colors.ember, colors.gold, colors.highlight],
                        ),
                      ),
                    ),
                  ),
                  Material(
                    type: MaterialType.transparency,
                    child: AppMotion.isReduced(context)
                        ? card
                        : ScaleTransition(
                            scale: Tween<double>(
                              begin: CelebrationOverlay._popFrom,
                              end: 1,
                            ).animate(pop),
                            child: card,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SparkPainter extends CustomPainter {
  new({required this.progress, required this.colors})
    : super(repaint: progress);

  final Animation<double> progress;
  final List<Color> colors;

  static const _reachRatio = 0.6;
  static const _baseSpread = 0.8;
  static const _spreadStep = 0.1;

  @override
  void paint(Canvas canvas, Size size) {
    final t = progress.value;
    if (t == 0 || t == 1) {
      return;
    }
    final centre = size.center(Offset.zero);
    final reach = size.shortestSide * _reachRatio;
    final fade = 1 - t;
    for (var index = 0; index < CelebrationOverlay._sparkCount; index++) {
      final angle = index * math.pi * 2 / CelebrationOverlay._sparkCount;
      final distance =
          reach *
          Curves.easeOut.transform(t) *
          (_baseSpread + (index % 3) * _spreadStep);
      final position =
          centre + Offset(math.cos(angle), math.sin(angle)) * distance;
      canvas.drawCircle(
        position,
        TokenSpace.xs * (1 + (index % 2)) * fade + 1,
        Paint()..color = colors[index % colors.length].withValues(alpha: fade),
      );
    }
  }

  @override
  bool shouldRepaint(_SparkPainter oldDelegate) => false;
}
