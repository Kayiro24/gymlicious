import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/core/units/units.dart';

/// Height on a scrollable wheel (one step per inch or centimetre), with the
/// same height in the other unit underneath.
class HeightField extends StatefulWidget {
  const new({
    required this.label,
    required this.unit,
    required this.centimetres,
    required this.onChanged,
    super.key,
    this.errorText,
  });

  static const double minCentimetres = 90;
  static const double maxCentimetres = 250;

  final String label;
  final HeightUnit unit;
  final double centimetres;
  final ValueChanged<double> onChanged;
  final String? errorText;

  /// Whole inches or centimetres the wheel can show, smallest first.
  static List<int> stepsFor(HeightUnit unit) => unit == HeightUnit.cm
      ? [for (var cm = minCentimetres.ceil(); cm <= maxCentimetres; cm++) cm]
      : [
          for (
            var inches = (minCentimetres / UnitConversion.centimetresPerInch)
                .ceil();
            inches * UnitConversion.centimetresPerInch <= maxCentimetres;
            inches++
          )
            inches,
        ];

  static double centimetresOf(HeightUnit unit, int step) =>
      unit == HeightUnit.cm
      ? step.toDouble()
      : step * UnitConversion.centimetresPerInch;

  static int stepOf(HeightUnit unit, double centimetres) =>
      unit == HeightUnit.cm
      ? centimetres.round()
      : (centimetres / UnitConversion.centimetresPerInch).round();

  static String format(AppLocalizations l10n, HeightUnit unit, int step) =>
      unit == HeightUnit.cm
      ? l10n.heightCentimetres(step)
      : l10n.heightFeetInches(
          step ~/ UnitConversion.inchesPerFoot,
          step % UnitConversion.inchesPerFoot,
        );

  @override
  State<HeightField> createState() => _HeightFieldState();
}

class _HeightFieldState extends State<HeightField> {
  static const double _itemExtent = TokenLayout.minTouchTarget;
  static const double _wheelHeight = _itemExtent * 5;

  late List<int> _steps = HeightField.stepsFor(widget.unit);
  late FixedExtentScrollController _controller = FixedExtentScrollController(
    initialItem: _indexFor(widget.centimetres),
  );

  int _indexFor(double centimetres) {
    final step = HeightField.stepOf(widget.unit, centimetres);
    final index = _steps.indexOf(step);
    if (index >= 0) {
      return index;
    }
    return step < _steps.first ? 0 : _steps.length - 1;
  }

  @override
  void didUpdateWidget(HeightField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.unit != widget.unit) {
      _steps = HeightField.stepsFor(widget.unit);
      _controller.dispose();
      _controller = FixedExtentScrollController(
        initialItem: _indexFor(widget.centimetres),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _select(int index) {
    unawaited(HapticFeedback.selectionClick());
    widget.onChanged(HeightField.centimetresOf(widget.unit, _steps[index]));
  }

  void _nudge(int delta) {
    final next = (_controller.selectedItem + delta).clamp(0, _steps.length - 1);
    _controller.jumpToItem(next);
    _select(next);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final step = HeightField.stepOf(widget.unit, widget.centimetres);
    final other = widget.unit == HeightUnit.cm
        ? HeightUnit.ftIn
        : HeightUnit.cm;
    final shown = HeightField.format(l10n, widget.unit, step);
    final converted = HeightField.format(
      l10n,
      other,
      HeightField.stepOf(other, widget.centimetres),
    );
    final error = widget.errorText;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text.rich(
          TextSpan(
            text: widget.label,
            style: context.textStyles.labelMedium,
            children: [
              TextSpan(
                text: '  ·  ${l10n.commonRequired}',
                style: context.textStyles.labelSmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: TokenSpace.sm),
        Semantics(
          label: widget.label,
          value: shown,
          increasedValue: step < _steps.last
              ? HeightField.format(l10n, widget.unit, step + 1)
              : null,
          decreasedValue: step > _steps.first
              ? HeightField.format(l10n, widget.unit, step - 1)
              : null,
          onIncrease: () => _nudge(1),
          onDecrease: () => _nudge(-1),
          child: ExcludeSemantics(
            child: Container(
              height: _wheelHeight,
              decoration: BoxDecoration(
                color: colors.surfaceMuted,
                borderRadius: BorderRadius.circular(TokenRadius.input),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: _itemExtent,
                    margin: const EdgeInsets.symmetric(
                      horizontal: TokenSpace.md,
                    ),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(TokenRadius.input),
                      border: Border.all(color: colors.accent, width: 2),
                    ),
                  ),
                  ListWheelScrollView.useDelegate(
                    controller: _controller,
                    itemExtent: _itemExtent,
                    diameterRatio: 1.6,
                    perspective: 0.004,
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: _select,
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: _steps.length,
                      builder: (context, index) {
                        final isSelected = _steps[index] == step;
                        return Center(
                          child: Text(
                            HeightField.format(
                              l10n,
                              widget.unit,
                              _steps[index],
                            ),
                            style: isSelected
                                ? context.textStyles.titleLarge
                                : context.textStyles.titleMedium?.copyWith(
                                    color: colors.textSecondary,
                                  ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: TokenSpace.sm),
        Semantics(
          liveRegion: true,
          child: Text(
            l10n.heightThatIs(converted),
            textAlign: TextAlign.center,
            style: context.textStyles.bodyMedium?.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(
              top: TokenSpace.xs,
              left: TokenSpace.lg,
            ),
            child: Text(
              error,
              style: context.textStyles.bodySmall?.copyWith(
                color: colors.danger,
              ),
            ),
          ),
      ],
    );
  }
}
