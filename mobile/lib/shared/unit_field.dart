import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_tracker/design_system/app_text_field.dart';

/// Decimal entry with its unit shown as a suffix (kg / lb / cm).
class UnitField extends StatelessWidget {
  const new({
    required this.label,
    required this.unitLabel,
    required this.controller,
    required this.onChanged,
    super.key,
    this.errorText,
    this.focusNode,
    this.isRequired = true,
    this.allowsDecimals = true,
    this.textInputAction = TextInputAction.next,
  });

  static final _decimalInput = FilteringTextInputFormatter.allow(
    RegExp(r'^\d{0,4}([.,]\d{0,2})?$'),
  );

  final String label;
  final String unitLabel;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String? errorText;
  final FocusNode? focusNode;
  final bool isRequired;
  final bool allowsDecimals;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) => AppTextField(
    label: label,
    controller: controller,
    focusNode: focusNode,
    isRequired: isRequired,
    errorText: errorText,
    suffixText: unitLabel,
    isNumeric: true,
    textInputAction: textInputAction,
    keyboardType: TextInputType.numberWithOptions(decimal: allowsDecimals),
    inputFormatters: [
      if (allowsDecimals)
        _decimalInput
      else
        FilteringTextInputFormatter.digitsOnly,
    ],
    onChanged: onChanged,
  );
}
