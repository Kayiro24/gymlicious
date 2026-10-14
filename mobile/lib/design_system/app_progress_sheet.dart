import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gym_tracker/core/failure/result.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_button.dart';
import 'package:gym_tracker/design_system/app_sheet.dart';
import 'package:gym_tracker/design_system/motion.dart';

/// Runs a long [task] behind a progress sheet, then shows a quiet success or
/// a failure with Retry. Returns whether the task eventually succeeded.
Future<bool> runWithProgressSheet<T>({
  required BuildContext context,
  required String workingText,
  required String successText,
  required String Function(Result<T> failure) failureText,
  required Future<Result<T>> Function() task,
}) async {
  var isSuccess = false;
  await showAppSheet<void>(
    context: context,
    isDismissible: false,
    builder: (_) => _ProgressSheetContent<T>(
      workingText: workingText,
      successText: successText,
      failureText: failureText,
      task: task,
      onSuccess: (_) => isSuccess = true,
    ),
  );
  return isSuccess;
}

class _ProgressSheetContent<T> extends StatefulWidget {
  const new({
    required this.workingText,
    required this.successText,
    required this.failureText,
    required this.task,
    required this.onSuccess,
  });

  final String workingText;
  final String successText;
  final String Function(Result<T> failure) failureText;
  final Future<Result<T>> Function() task;
  final ValueChanged<T> onSuccess;

  @override
  State<_ProgressSheetContent<T>> createState() =>
      _ProgressSheetContentState<T>();
}

class _ProgressSheetContentState<T> extends State<_ProgressSheetContent<T>> {
  Result<T>? _result;

  @override
  void initState() {
    super.initState();
    unawaited(_run());
  }

  Future<void> _run() async {
    setState(() => _result = null);
    final result = await widget.task();
    if (!mounted) {
      return;
    }
    if (result case Ok<T>(:final value)) {
      widget.onSuccess(value);
    }
    setState(() => _result = result);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final result = _result;
    final (Widget indicator, String message) = switch (result) {
      null => (
        LinearProgressIndicator(
          value: AppMotion.isReduced(context) ? 0.5 : null,
          minHeight: TokenSpace.xs,
          borderRadius: BorderRadius.circular(TokenSpace.xs),
          color: colors.accent,
          backgroundColor: colors.surfaceMuted,
        ),
        widget.workingText,
      ),
      Ok<T>() => (
        Icon(
          Icons.check_circle_outline_rounded,
          color: colors.accent,
          size: TokenSpace.xxxl,
        ),
        widget.successText,
      ),
      Err<T>() => (
        Icon(
          Icons.error_outline_rounded,
          color: colors.danger,
          size: TokenSpace.xxxl,
        ),
        widget.failureText(result),
      ),
    };
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        indicator,
        const SizedBox(height: TokenSpace.lg),
        Semantics(
          liveRegion: true,
          child: Text(
            message,
            style: context.textStyles.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: TokenSpace.xl),
        if (result is Err<T>)
          Wrap(
            spacing: TokenSpace.sm,
            alignment: WrapAlignment.center,
            children: [
              AppButton(
                label: l10n.commonClose,
                variant: AppButtonVariant.quiet,
                onPressed: () => Navigator.of(context).pop(),
              ),
              AppButton(label: l10n.commonRetry, onPressed: _run),
            ],
          ),
        if (result is Ok<T>)
          AppButton(
            label: l10n.commonDone,
            onPressed: () => Navigator.of(context).pop(),
          ),
      ],
    );
  }
}
