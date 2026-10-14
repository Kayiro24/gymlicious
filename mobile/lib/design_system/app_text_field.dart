import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';

/// Labelled text field that marks itself as required or optional.
class AppTextField extends StatelessWidget {
  const new({
    required this.label,
    super.key,
    this.controller,
    this.focusNode,
    this.isRequired = false,
    this.helperText,
    this.errorText,
    this.hintText,
    this.suffixText,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.maxLength,
    this.maxLines = 1,
    this.textCapitalization = TextCapitalization.none,
    this.autofocus = false,
    this.isNumeric = false,
  });

  final String label;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool isRequired;
  final String? helperText;
  final String? errorText;
  final String? hintText;
  final String? suffixText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final int? maxLength;
  final int maxLines;
  final TextCapitalization textCapitalization;
  final bool autofocus;
  final bool isNumeric;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = context.textStyles;
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
              style: text.labelMedium,
              children: [
                TextSpan(text: '  ·  $marker', style: text.labelSmall),
              ],
            ),
          ),
        ),
        TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          maxLength: maxLength,
          maxLines: maxLines,
          autofocus: autofocus,
          textCapitalization: textCapitalization,
          style: isNumeric
              ? text.bodyLarge?.copyWith(
                  fontFeatures: const [FontFeature.tabularFigures()],
                )
              : text.bodyLarge,
          decoration: InputDecoration(
            hintText: hintText,
            helperText: helperText,
            errorText: errorText,
            errorMaxLines: 3,
            helperMaxLines: 3,
            suffixText: suffixText,
            counterText: '',
          ),
        ),
      ],
    );
  }
}
