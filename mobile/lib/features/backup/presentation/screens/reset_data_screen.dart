import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/layout/content_width.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_button.dart';
import 'package:gym_tracker/design_system/app_card.dart';
import 'package:gym_tracker/design_system/app_text_field.dart';
import 'package:gym_tracker/design_system/app_toast.dart';
import 'package:gym_tracker/features/backup/presentation/backup_actions.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Offers a backup first, then requires typing the confirmation word.
class ResetDataScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<ResetDataScreen> createState() => _ResetDataScreenState();
}

class _ResetDataScreenState extends ConsumerState<ResetDataScreen> {
  final _confirmation = TextEditingController();
  bool _isBackingUp = false;
  bool _isErasing = false;

  @override
  void dispose() {
    _confirmation.dispose();
    super.dispose();
  }

  Future<void> _backupFirst() async {
    setState(() => _isBackingUp = true);
    await BackupActions.export(context, ref, ExportTarget.device);
    if (mounted) {
      setState(() => _isBackingUp = false);
    }
  }

  Future<void> _erase() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _isErasing = true);
    await BackupActions.resetAllData(ref);
    if (mounted) {
      showAppToast(context, l10n.resetDone);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final word = l10n.resetConfirmWord;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.resetTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(TokenSpace.lg),
          children: [
            ContentWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppCard(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          LucideIcons.triangleAlert,
                          color: context.colors.danger,
                        ),
                        const SizedBox(width: TokenSpace.md),
                        Expanded(
                          child: Text(
                            l10n.resetIntro,
                            style: context.textStyles.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: TokenSpace.xl),
                  AppButton(
                    label: l10n.resetBackupFirst,
                    icon: LucideIcons.download,
                    variant: AppButtonVariant.secondary,
                    isExpanded: true,
                    isLoading: _isBackingUp,
                    onPressed: _isErasing ? null : _backupFirst,
                  ),
                  const SizedBox(height: TokenSpace.xl),
                  AppTextField(
                    label: l10n.resetTypeToConfirm(word),
                    controller: _confirmation,
                    isRequired: true,
                    textCapitalization: TextCapitalization.characters,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: TokenSpace.lg),
                  AppButton(
                    label: l10n.resetButton,
                    variant: AppButtonVariant.danger,
                    isExpanded: true,
                    isLoading: _isErasing,
                    onPressed:
                        _confirmation.text.trim() == word && !_isBackingUp
                        ? _erase
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
