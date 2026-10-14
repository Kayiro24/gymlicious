import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/app_theme.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/motion.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// One set: weight with steppers, reps, warm-up toggle and a done check.
/// Swiping removes it. Values arrive already formatted for display.
class SetRow extends StatefulWidget {
  const new({
    required this.number,
    required this.weightText,
    required this.repsText,
    required this.unitLabel,
    required this.isWarmup,
    required this.isDone,
    required this.onWeightChanged,
    required this.onRepsChanged,
    required this.onIncrement,
    required this.onDecrement,
    required this.onWarmupToggled,
    required this.onDoneToggled,
    required this.onRemove,
    super.key,
    this.isNewMax = false,
  });

  /// Below this width (or at large text) the row stacks onto two lines.
  static const compactBreakpoint = 360.0;
  static const largeTextScale = 1.3;

  final int number;
  final String weightText;
  final String repsText;
  final String unitLabel;
  final bool isWarmup;
  final bool isDone;
  final bool isNewMax;
  final ValueChanged<String> onWeightChanged;
  final ValueChanged<String> onRepsChanged;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onWarmupToggled;
  final VoidCallback onDoneToggled;
  final VoidCallback onRemove;

  @override
  State<SetRow> createState() => _SetRowState();
}

class _SetRowState extends State<SetRow> {
  late final _weight = TextEditingController(text: widget.weightText);
  late final _reps = TextEditingController(text: widget.repsText);
  final _weightFocus = FocusNode();
  final _repsFocus = FocusNode();

  @override
  void didUpdateWidget(SetRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync(_weight, _weightFocus, widget.weightText);
    _sync(_reps, _repsFocus, widget.repsText);
  }

  void _sync(TextEditingController controller, FocusNode focus, String text) {
    if (!focus.hasFocus && controller.text != text) {
      controller.text = text;
    }
  }

  @override
  void dispose() {
    _weight.dispose();
    _reps.dispose();
    _weightFocus.dispose();
    _repsFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final background = widget.isNewMax
        ? colors.highlight
        : widget.isDone
        ? colors.accentSoft
        : colors.surfaceMuted;
    return Dismissible(
      key: ValueKey('set-${widget.number}-${widget.key}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => widget.onRemove(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: TokenSpace.xl),
        decoration: BoxDecoration(
          color: colors.danger,
          borderRadius: BorderRadius.circular(TokenRadius.input),
        ),
        child: Icon(LucideIcons.trash2, color: colors.onDanger),
      ),
      child: Semantics(
        label: l10n.setRowLabel(widget.number),
        customSemanticsActions: {
          CustomSemanticsAction(label: l10n.setRowRemove): widget.onRemove,
        },
        child: AnimatedContainer(
          duration: AppMotion.of(context),
          curve: AppMotion.curve,
          padding: const EdgeInsets.all(TokenSpace.sm),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(TokenRadius.input),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isStacked =
                  constraints.maxWidth < SetRow.compactBreakpoint ||
                  MediaQuery.textScalerOf(context).scale(1) >
                      SetRow.largeTextScale;
              return isStacked
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            _label(context),
                            const Spacer(),
                            _warmupToggle(context),
                            _doneCheck(context),
                          ],
                        ),
                        const SizedBox(height: TokenSpace.xs),
                        Row(
                          children: [
                            Expanded(flex: 3, child: _weightStepper(context)),
                            const SizedBox(width: TokenSpace.sm),
                            Expanded(flex: 2, child: _repsField(context)),
                          ],
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        _label(context),
                        const SizedBox(width: TokenSpace.xs),
                        Expanded(flex: 5, child: _weightStepper(context)),
                        const SizedBox(width: TokenSpace.sm),
                        Expanded(flex: 2, child: _repsField(context)),
                        _warmupToggle(context),
                        _doneCheck(context),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }

  Widget _label(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TokenSpace.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${widget.number}',
            style: context.textStyles.titleMedium?.copyWith(
              fontFeatures: AppTheme.tabularFigures,
            ),
          ),
          if (widget.isNewMax)
            Text(l10n.setRowNewMax, style: context.textStyles.labelSmall),
        ],
      ),
    );
  }

  Widget _weightStepper(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        IconButton(
          tooltip: l10n.setRowDecrease,
          onPressed: widget.onDecrement,
          icon: const Icon(LucideIcons.minus),
        ),
        Expanded(
          child: _numberField(
            context,
            controller: _weight,
            focusNode: _weightFocus,
            label: l10n.setRowWeight,
            suffix: widget.unitLabel,
            allowsDecimals: true,
            onChanged: widget.onWeightChanged,
          ),
        ),
        IconButton(
          tooltip: l10n.setRowIncrease,
          onPressed: widget.onIncrement,
          icon: const Icon(LucideIcons.plus),
        ),
      ],
    );
  }

  Widget _repsField(BuildContext context) => _numberField(
    context,
    controller: _reps,
    focusNode: _repsFocus,
    label: AppLocalizations.of(context).setRowReps,
    suffix: null,
    allowsDecimals: false,
    onChanged: widget.onRepsChanged,
  );

  Widget _numberField(
    BuildContext context, {
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String? suffix,
    required bool allowsDecimals,
    required ValueChanged<String> onChanged,
  }) => TextField(
    controller: controller,
    focusNode: focusNode,
    onChanged: onChanged,
    textAlign: TextAlign.center,
    keyboardType: TextInputType.numberWithOptions(decimal: allowsDecimals),
    inputFormatters: [
      if (allowsDecimals)
        FilteringTextInputFormatter.allow(RegExp(r'^\d{0,4}([.,]\d{0,2})?$'))
      else
        FilteringTextInputFormatter.digitsOnly,
    ],
    style: context.textStyles.titleMedium?.copyWith(
      fontFeatures: AppTheme.tabularFigures,
    ),
    decoration: InputDecoration(
      labelText: label,
      suffixText: suffix,
      isDense: true,
      fillColor: context.colors.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: TokenSpace.sm,
        vertical: TokenSpace.md,
      ),
    ),
  );

  Widget _warmupToggle(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    return Tooltip(
      message: l10n.setRowWarmup,
      child: Semantics(
        toggled: widget.isWarmup,
        label: l10n.setRowWarmup,
        button: true,
        excludeSemantics: true,
        child: InkWell(
          onTap: widget.onWarmupToggled,
          customBorder: const CircleBorder(),
          child: SizedBox.square(
            dimension: TokenLayout.minTouchTarget,
            child: Icon(
              LucideIcons.flame,
              color: widget.isWarmup ? colors.danger : colors.hairline,
            ),
          ),
        ),
      ),
    );
  }

  Widget _doneCheck(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    return Tooltip(
      message: widget.isDone ? l10n.setRowMarkNotDone : l10n.setRowMarkDone,
      child: Semantics(
        checked: widget.isDone,
        button: true,
        label: l10n.setRowMarkDone,
        excludeSemantics: true,
        child: InkWell(
          onTap: () {
            if (!widget.isDone) {
              unawaited(HapticFeedback.lightImpact());
            }
            widget.onDoneToggled();
          },
          customBorder: const CircleBorder(),
          child: SizedBox.square(
            dimension: TokenLayout.minTouchTarget,
            child: AnimatedContainer(
              duration: AppMotion.of(context),
              margin: const EdgeInsets.all(TokenSpace.sm),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.isDone ? colors.accent : Colors.transparent,
                border: Border.all(
                  color: widget.isDone ? colors.accent : colors.textSecondary,
                  width: 2,
                ),
              ),
              child: widget.isDone
                  ? Icon(
                      LucideIcons.check,
                      size: TokenSpace.lg,
                      color: colors.onAccent,
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
