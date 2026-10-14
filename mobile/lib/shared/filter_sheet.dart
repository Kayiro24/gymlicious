import 'package:flutter/material.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_button.dart';
import 'package:gym_tracker/design_system/app_chip.dart';
import 'package:gym_tracker/design_system/app_sheet.dart';

typedef FilterOption<T> = ({T value, String label});

/// Single-choice filter in a sheet; null means "All". Resolves to the
/// chosen value, or keeps [selected] when dismissed.
Future<T?> showFilterSheet<T>({
  required BuildContext context,
  required List<FilterOption<T>> options,
  required T? selected,
}) async {
  final l10n = AppLocalizations.of(context);
  final result = await showAppSheet<({T? value})>(
    context: context,
    title: l10n.filterTitle,
    builder: (sheetContext) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: TokenSpace.sm,
          runSpacing: TokenSpace.sm,
          children: [
            AppChip(
              label: l10n.filterAll,
              isSelected: selected == null,
              onSelected: (_) => Navigator.of(sheetContext).pop((value: null)),
            ),
            for (final option in options)
              AppChip(
                label: option.label,
                isSelected: option.value == selected,
                onSelected: (_) =>
                    Navigator.of(sheetContext).pop((value: option.value)),
              ),
          ],
        ),
        const SizedBox(height: TokenSpace.lg),
        AppButton(
          label: l10n.commonClose,
          variant: AppButtonVariant.quiet,
          onPressed: () => Navigator.of(sheetContext).pop(),
        ),
      ],
    ),
  );
  return result == null ? selected : result.value;
}
