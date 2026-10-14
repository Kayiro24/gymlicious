import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/platform/photo_gateway.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/core/units/number_format.dart';
import 'package:gym_tracker/core/units/units.dart';
import 'package:gym_tracker/design_system/app_button.dart';
import 'package:gym_tracker/design_system/app_segmented.dart';
import 'package:gym_tracker/design_system/app_text_field.dart';
import 'package:gym_tracker/features/profile/domain/profile.dart';
import 'package:gym_tracker/features/profile/domain/profile_draft.dart';
import 'package:gym_tracker/features/profile/domain/profile_rules.dart';
import 'package:gym_tracker/features/profile/domain/profile_validator.dart';
import 'package:gym_tracker/features/profile/presentation/widgets/profile_error_text.dart';
import 'package:gym_tracker/shared/date_picker_field.dart';
import 'package:gym_tracker/shared/height_field.dart';
import 'package:gym_tracker/shared/photo_picker.dart';
import 'package:gym_tracker/shared/unit_field.dart';

/// The profile fields used by the first-launch gate and the Profile screen.
class ProfileForm extends StatefulWidget {
  const new({
    required this.initialDraft,
    required this.today,
    required this.errors,
    required this.onChanged,
    required this.photoBytes,
    required this.onPickPhoto,
    required this.onRemovePhoto,
    super.key,
    this.isPhotoBusy = false,
  });

  final ProfileDraft initialDraft;
  final CalendarDate today;
  final Map<ProfileField, ProfileProblem> errors;
  final ValueChanged<ProfileDraft> onChanged;
  final Uint8List? photoBytes;
  final ValueChanged<PhotoSource> onPickPhoto;
  final VoidCallback onRemovePhoto;
  final bool isPhotoBusy;

  @override
  State<ProfileForm> createState() => ProfileFormState();
}

class ProfileFormState extends State<ProfileForm> {
  late ProfileDraft _draft = widget.initialDraft;
  late final _name = TextEditingController(text: _draft.name);
  late final _weight = TextEditingController(text: _draft.weight);
  late final _heightCm = TextEditingController(text: _draft.heightCm);
  late final _feet = TextEditingController(text: _draft.heightFeet);
  late final _inches = TextEditingController(text: _draft.heightInches);
  late final _age = TextEditingController(text: _draft.age);
  final Map<ProfileField, GlobalKey<State<StatefulWidget>>> _fieldKeys = {
    for (final field in ProfileField.values) field: GlobalKey(),
  };

  /// Scrolls the first invalid field into view (spec 5.1 point 6).
  Future<void> scrollToFirstError() async {
    if (widget.errors.isEmpty) {
      return;
    }
    final target = _fieldKeys[widget.errors.keys.first]?.currentContext;
    if (target != null) {
      await Scrollable.ensureVisible(
        target,
        duration: const Duration(milliseconds: 250),
        alignment: 0.2,
      );
    }
  }

  @override
  void dispose() {
    for (final controller in [
      _name,
      _weight,
      _heightCm,
      _feet,
      _inches,
      _age,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  void _update(ProfileDraft Function(ProfileDraft) change) {
    setState(() => _draft = change(_draft));
    widget.onChanged(_draft);
  }

  void _syncText() => _update(
    (draft) => draft.copyWith(
      name: _name.text,
      weight: _weight.text,
      heightCm: _heightCm.text,
      heightFeet: _feet.text,
      heightInches: _inches.text,
      age: _age.text,
    ),
  );

  /// Switching units converts what is already typed, so nothing is lost.
  void _setImperial({required bool isImperial}) {
    final weightUnit = isImperial ? WeightUnit.lb : WeightUnit.kg;
    final heightUnit = isImperial ? HeightUnit.ftIn : HeightUnit.cm;
    if (weightUnit == _draft.weightUnit) {
      return;
    }
    final weight = NumberText.parseDecimal(_weight.text);
    if (weight != null) {
      final kilograms = UnitConversion.fromDisplayWeight(
        weight,
        _draft.weightUnit,
      );
      _weight.text = NumberText.trimmed(
        UnitConversion.toDisplayWeight(kilograms, weightUnit),
      );
    }
    if (heightUnit == HeightUnit.ftIn) {
      final centimetres = NumberText.parseDecimal(_heightCm.text);
      if (centimetres != null) {
        final (:feet, :inches) = UnitConversion.cmToFeetInches(centimetres);
        _feet.text = '$feet';
        _inches.text = NumberText.trimmed(inches);
      }
    } else {
      final feet = int.tryParse(_feet.text);
      if (feet != null) {
        final inches = NumberText.parseDecimal(_inches.text) ?? 0;
        _heightCm.text = NumberText.trimmed(
          UnitConversion.feetInchesToCm(feet, inches),
          step: 1,
        );
      }
    }
    _update(
      (draft) => draft.copyWith(weightUnit: weightUnit, heightUnit: heightUnit),
    );
    _syncText();
  }

  String? _error(AppLocalizations l10n, ProfileField field) {
    final problem = widget.errors[field];
    return problem == null
        ? null
        : ProfileErrorText.of(
            l10n,
            field,
            problem,
            weightUnit: _draft.weightUnit,
            heightUnit: _draft.heightUnit,
          );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isImperial = _draft.weightUnit == WeightUnit.lb;
    final dateOfBirth = _draft.dateOfBirth;
    final age = dateOfBirth == null || dateOfBirth.isAfter(widget.today)
        ? null
        : ProfileRules.wholeYearsBetween(dateOfBirth, widget.today);
    const gap = SizedBox(height: TokenSpace.xl);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.profileUnitsLabel, style: context.textStyles.labelMedium),
        const SizedBox(height: TokenSpace.sm),
        AppSegmented<bool>(
          semanticLabel: l10n.profileUnitsLabel,
          selected: isImperial,
          options: [
            AppSegmentOption(false, l10n.profileUnitsMetric),
            AppSegmentOption(true, l10n.profileUnitsImperial),
          ],
          onChanged: (value) => _setImperial(isImperial: value),
        ),
        gap,
        Center(
          child: PhotoPicker(
            name: _draft.name,
            photoBytes: widget.photoBytes,
            isBusy: widget.isPhotoBusy,
            onPick: widget.onPickPhoto,
            onRemove: widget.onRemovePhoto,
          ),
        ),
        gap,
        AppTextField(
          key: _fieldKeys[ProfileField.name],
          label: l10n.profileName,
          controller: _name,
          isRequired: true,
          maxLength: ProfileRules.nameMaxLength,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          errorText: _error(l10n, ProfileField.name),
          onChanged: (_) => _syncText(),
        ),
        gap,
        _GenderPicker(
          key: _fieldKeys[ProfileField.gender],
          selected: _draft.gender,
          errorText: _error(l10n, ProfileField.gender),
          onChanged: (gender) =>
              _update((draft) => draft.copyWith(gender: gender)),
        ),
        gap,
        UnitField(
          key: _fieldKeys[ProfileField.weight],
          label: l10n.profileWeight,
          unitLabel: _draft.weightUnit.name,
          controller: _weight,
          errorText: _error(l10n, ProfileField.weight),
          onChanged: (_) => _syncText(),
        ),
        gap,
        HeightField(
          key: _fieldKeys[ProfileField.height],
          label: l10n.profileHeight,
          unit: _draft.heightUnit,
          centimetres: _heightCm,
          feet: _feet,
          inches: _inches,
          errorText: _error(l10n, ProfileField.height),
          onChanged: _syncText,
        ),
        gap,
        if (_draft.usesAge)
          UnitField(
            key: _fieldKeys[ProfileField.age],
            label: l10n.profileAge,
            unitLabel: '',
            controller: _age,
            allowsDecimals: false,
            textInputAction: TextInputAction.done,
            errorText: _error(l10n, ProfileField.age),
            onChanged: (_) => _syncText(),
          )
        else
          DatePickerField(
            key: _fieldKeys[ProfileField.dateOfBirth],
            label: l10n.profileDateOfBirth,
            value: dateOfBirth,
            firstDate: CalendarDate(
              widget.today.year - ProfileRules.maxAge - 1,
              1,
              1,
            ),
            lastDate: widget.today,
            errorText: _error(l10n, ProfileField.dateOfBirth),
            helperText: age == null ? null : l10n.profileAgeIs(age),
            onChanged: (date) =>
                _update((draft) => draft.copyWith(dateOfBirth: date)),
          ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: AppButton(
            label: _draft.usesAge
                ? l10n.profileUseDateOfBirth
                : l10n.profileUseAge,
            variant: AppButtonVariant.quiet,
            onPressed: () =>
                _update((draft) => draft.copyWith(usesAge: !draft.usesAge)),
          ),
        ),
      ],
    );
  }
}

class _GenderPicker extends StatelessWidget {
  const new({
    required this.selected,
    required this.onChanged,
    super.key,
    this.errorText,
  });

  final Gender? selected;
  final ValueChanged<Gender> onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final error = errorText;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text.rich(
          TextSpan(
            text: l10n.profileGender,
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
        AppSegmented<Gender>(
          semanticLabel: l10n.profileGender,
          selected: selected,
          options: [
            AppSegmentOption(Gender.male, l10n.profileGenderMale),
            AppSegmentOption(Gender.female, l10n.profileGenderFemale),
            AppSegmentOption(Gender.other, l10n.profileGenderOther),
            AppSegmentOption(
              Gender.preferNotToSay,
              l10n.profileGenderPreferNot,
            ),
          ],
          onChanged: onChanged,
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(
              top: TokenSpace.xs,
              left: TokenSpace.xs,
            ),
            child: Text(
              error,
              style: context.textStyles.bodySmall?.copyWith(
                color: context.colors.danger,
              ),
            ),
          ),
      ],
    );
  }
}
