import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/layout/content_width.dart';
import 'package:gym_tracker/core/providers.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/core/units/number_format.dart';
import 'package:gym_tracker/design_system/app_button.dart';
import 'package:gym_tracker/design_system/app_card.dart';
import 'package:gym_tracker/design_system/app_toast.dart';
import 'package:gym_tracker/features/profile/domain/profile.dart';
import 'package:gym_tracker/features/profile/domain/profile_draft.dart';
import 'package:gym_tracker/features/profile/domain/profile_rules.dart';
import 'package:gym_tracker/features/profile/domain/profile_validator.dart';
import 'package:gym_tracker/features/profile/presentation/profile_drafts.dart';
import 'package:gym_tracker/features/profile/presentation/profile_photo_actions.dart';
import 'package:gym_tracker/features/profile/presentation/state/profile_controller.dart';
import 'package:gym_tracker/features/profile/presentation/widgets/profile_form.dart';
import 'package:gym_tracker/features/settings/settings.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<ProfileFormState>();
  ProfileDraft? _draft;
  Map<ProfileField, ProfileProblem> _errors = const {};
  bool _hasTriedSaving = false;

  CalendarDate get _today =>
      CalendarDate.fromDateTime(ref.read(clockProvider).now());

  ProfileDraft _initialDraft(Profile profile) {
    final settings = ref.read(settingsControllerProvider);
    return ProfileDrafts.fromProfile(
      profile,
      weightUnit: settings.weightUnit,
      heightUnit: settings.heightUnit,
      currentAge: ProfileRules.ageOf(profile, _today),
    );
  }

  void _onChanged(ProfileDraft draft) {
    _draft = draft;
    if (_hasTriedSaving) {
      setState(() => _errors = ProfileValidator.validate(draft, _today).errors);
    }
  }

  Future<void> _save(ProfileDraft fallback) async {
    final draft = _draft ?? fallback;
    final validation = ProfileValidator.validate(draft, _today);
    setState(() {
      _hasTriedSaving = true;
      _errors = validation.errors;
    });
    final values = validation.values;
    if (values == null) {
      await WidgetsBinding.instance.endOfFrame;
      await _formKey.currentState?.scrollToFirstError();
      return;
    }
    ref.read(profileControllerProvider.notifier).saveValues(values);
    ref
        .read(settingsControllerProvider.notifier)
        .update(
          (settings) => settings
              .withWeightUnit(draft.weightUnit)
              .copyWith(heightUnit: draft.heightUnit),
        );
    showAppToast(context, AppLocalizations.of(context).profileSaved);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final profile = ref.watch(profileControllerProvider);
    final photo = ref.watch(profilePhotoProvider).value;
    if (profile == null) {
      return const Scaffold();
    }
    final initial = _initialDraft(profile);
    final age = ProfileRules.ageOf(profile, _today);
    final bmi = ProfileRules.bodyMassIndex(profile.weightKg, profile.heightCm);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(TokenSpace.lg),
          children: [
            ContentWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (age != null)
                          Text(
                            l10n.profileAgeIs(age),
                            style: context.textStyles.titleMedium,
                          ),
                        const SizedBox(height: TokenSpace.xs),
                        Text(
                          l10n.profileBmi(NumberText.trimmed(bmi)),
                          style: context.textStyles.bodyLarge,
                        ),
                        Text(
                          l10n.profileBmiNote,
                          style: context.textStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: TokenSpace.xl),
                  ProfileForm(
                    key: _formKey,
                    initialDraft: initial,
                    today: _today,
                    errors: _errors,
                    onChanged: _onChanged,
                    photoBytes: photo,
                    onPickPhoto: (source) =>
                        ProfilePhotoActions.pick(context, ref, source),
                    onRemovePhoto: () => ProfilePhotoActions.remove(ref),
                  ),
                  const SizedBox(height: TokenSpace.xl),
                  AppButton(
                    label: l10n.profileSave,
                    isExpanded: true,
                    onPressed: () => _save(initial),
                  ),
                  const SizedBox(height: TokenSpace.xxl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
