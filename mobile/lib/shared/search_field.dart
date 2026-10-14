import 'package:flutter/material.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SearchField extends StatelessWidget {
  const new({
    required this.controller,
    required this.onChanged,
    super.key,
    this.hintText,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) => TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        style: context.textStyles.bodyLarge,
        decoration: InputDecoration(
          hintText: hintText ?? l10n.searchHint,
          prefixIcon: Icon(
            LucideIcons.search,
            color: context.colors.textSecondary,
          ),
          suffixIcon: value.text.isEmpty
              ? null
              : IconButton(
                  tooltip: l10n.searchClear,
                  icon: const Icon(LucideIcons.x),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                ),
        ),
      ),
    );
  }
}
