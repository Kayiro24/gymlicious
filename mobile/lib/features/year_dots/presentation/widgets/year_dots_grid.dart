import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/features/year_dots/domain/dot_layout.dart';
import 'package:gym_tracker/features/year_dots/domain/year_progress.dart';
import 'package:gym_tracker/features/year_dots/presentation/widgets/year_dots_painter.dart';
import 'package:gym_tracker/features/year_dots/presentation/widgets/year_dots_palette.dart';
import 'package:intl/intl.dart';

/// The whole year, sized to the space it is given (no scrolling). Tapping
/// or long-pressing a dot shows its date.
class YearDotsGrid extends StatefulWidget {
  const new({
    required this.progress,
    required this.kind,
    required this.palette,
    super.key,
    this.isInteractive = true,
  });

  final YearProgress progress;
  final DotLayoutKind kind;
  final YearDotsPalette palette;
  final bool isInteractive;

  @override
  State<YearDotsGrid> createState() => _YearDotsGridState();
}

class _YearDotsGridState extends State<YearDotsGrid> {
  static const _tooltipDuration = Duration(seconds: 2);

  int? _tappedIndex;
  Timer? _hideTimer;

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  void _show(DotLayout layout, Offset position) {
    final index = layout.hitTest(position.dx, position.dy);
    if (index == null) {
      return;
    }
    _hideTimer?.cancel();
    setState(() => _tappedIndex = index);
    _hideTimer = Timer(_tooltipDuration, () {
      if (mounted) {
        setState(() => _tappedIndex = null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final progress = widget.progress;
    String dateText(int index) =>
        DateFormat.MMMd(locale)
            .format(progress.dateOf(index).toLocalDateTime());
    String semanticLabel(int index) {
      final date = DateFormat.MMMMd(locale)
          .format(progress.dateOf(index).toLocalDateTime());
      return switch (progress.stateOf(index)) {
        DotState.done => l10n.yearDotDone(date, index + 1),
        DotState.today => l10n.yearDotToday(date, index + 1),
        DotState.left => l10n.yearDotLeft(date, index + 1),
      };
    }

    final monthInitials = [
      for (var month = 1; month <= DotLayout.monthsPerYear; month++)
        DateFormat(
          'MMMMM',
          locale,
        ).format(DateTime(progress.today.year, month)),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final layout = DotLayout.compute(
          widget.kind,
          progress.today.year,
          constraints.maxWidth,
          constraints.maxHeight,
        );
        final tapped = _tappedIndex;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapUp: widget.isInteractive
              ? (details) => _show(layout, details.localPosition)
              : null,
          onLongPressStart: widget.isInteractive
              ? (details) => _show(layout, details.localPosition)
              : null,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              CustomPaint(
                size: constraints.biggest,
                painter: YearDotsPainter(
                  layout: layout,
                  progress: progress,
                  palette: widget.palette,
                  monthInitials: widget.kind == DotLayoutKind.months
                      ? monthInitials
                      : const [],
                  dotLabel: widget.isInteractive ? semanticLabel : null,
                ),
              ),
              if (tapped != null)
                _Tooltip(
                  anchor: layout.cells[tapped],
                  areaWidth: constraints.maxWidth,
                  text: l10n.yearDotTooltip(dateText(tapped), tapped + 1),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _Tooltip extends StatelessWidget {
  const new({
    required this.anchor,
    required this.areaWidth,
    required this.text,
  });

  static const _width = 140.0;

  final DotRect anchor;
  final double areaWidth;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final left = (anchor.left + anchor.width / 2 - _width / 2).clamp(
      0.0,
      (areaWidth - _width).clamp(0.0, double.infinity),
    );
    final isAbove = anchor.top > TokenSpace.xxxl;
    return Positioned(
      left: left,
      width: _width,
      top: isAbove
          ? anchor.top - TokenSpace.xxxl
          : anchor.top + anchor.height + TokenSpace.sm,
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: ShapeDecoration(
            shape: const StadiumBorder(),
            color: colors.textPrimary,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: TokenSpace.md,
              vertical: TokenSpace.sm,
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: context.textStyles.labelMedium?.copyWith(
                color: colors.background,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
