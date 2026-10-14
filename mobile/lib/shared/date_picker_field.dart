import 'package:flutter/material.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Read-only field that opens the system date picker.
class DatePickerField extends StatelessWidget {
  const new({
    required this.label,
    required this.value,
    required this.firstDate,
    required this.lastDate,
    required this.onChanged,
    super.key,
    this.errorText,
    this.helperText,
    this.isRequired = true,
    this.focusNode,
  });

  final String label;
  final CalendarDate? value;
  final CalendarDate firstDate;
  final CalendarDate lastDate;
  final ValueChanged<CalendarDate> onChanged;
  final String? errorText;
  final String? helperText;
  final bool isRequired;
  final FocusNode? focusNode;

  Future<void> _pick(BuildContext context) async {
    final initial = value ?? lastDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial.toLocalDateTime(),
      firstDate: firstDate.toLocalDateTime(),
      lastDate: lastDate.toLocalDateTime(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if (picked != null) {
      onChanged(CalendarDate.fromDateTime(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final date = value;
    final marker = isRequired ? l10n.commonRequired : l10n.commonOptional;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: TokenSpace.xs,
            bottom: TokenSpace.xs,
          ),
          child: Text.rich(
            TextSpan(
              text: label,
              style: context.textStyles.labelMedium,
              children: [
                TextSpan(
                  text: '  ·  $marker',
                  style: context.textStyles.labelSmall,
                ),
              ],
            ),
          ),
        ),
        InkWell(
          focusNode: focusNode,
          onTap: () => _pick(context),
          borderRadius: BorderRadius.circular(TokenRadius.input),
          child: InputDecorator(
            isEmpty: date == null,
            decoration: InputDecoration(
              hintText: l10n.datePickerChoose,
              errorText: errorText,
              helperText: helperText,
              helperMaxLines: 2,
              errorMaxLines: 3,
              suffixIcon: Icon(
                LucideIcons.calendar,
                color: context.colors.textSecondary,
              ),
            ),
            child: date == null
                ? null
                : Text(
                    DateFormat.yMMMMd(locale).format(date.toLocalDateTime()),
                    style: context.textStyles.bodyLarge,
                  ),
          ),
        ),
      ],
    );
  }
}
