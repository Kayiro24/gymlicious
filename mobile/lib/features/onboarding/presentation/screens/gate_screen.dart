import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/layout/content_width.dart';
import 'package:gym_tracker/core/providers.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_button.dart';
import 'package:gym_tracker/design_system/app_skeleton.dart';
import 'package:gym_tracker/design_system/brand_mark.dart';
import 'package:gym_tracker/design_system/skeleton_gate.dart';
import 'package:gym_tracker/features/backup/backup.dart';
import 'package:gym_tracker/features/onboarding/presentation/onboarding_routes.dart';
import 'package:gym_tracker/features/onboarding/presentation/state/gate_providers.dart';
import 'package:gym_tracker/features/onboarding/presentation/widgets/onboarding_hero.dart';
import 'package:gym_tracker/features/profile/profile.dart';
import 'package:gym_tracker/features/settings/settings.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// First-launch details gate; replaces sign-up (spec 5.1).
class GateScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<GateScreen> createState() => _GateScreenState();
}

class _GateScreenState extends ConsumerState<GateScreen> {
  final _formKey = GlobalKey<ProfileFormState>();
  late final GateDraftSaver _saver;
  ProfileDraft? _draft;
  Map<ProfileField, ProfileProblem> _errors = const {};
  bool _hasTriedContinue = false;
  bool _isRestoring = false;

  CalendarDate get _today =>
      CalendarDate.fromDateTime(ref.read(clockProvider).now());

  @override
  void initState() {
    super.initState();
    // Created eagerly: dispose() must not touch ref.
    _saver = GateDraftSaver(ref.read(gateDraftStoreProvider));
  }

  @override
  void dispose() {
    _saver.flush();
    super.dispose();
  }

  void _onChanged(ProfileDraft draft) {
    _draft = draft;
    _saver.schedule(draft);
    if (_hasTriedContinue) {
      setState(() => _errors = ProfileValidator.validate(draft, _today).errors);
    }
  }

  Future<void> _continue(ProfileDraft initial) async {
    final draft = _draft ?? initial;
    final validation = ProfileValidator.validate(draft, _today);
    setState(() {
      _hasTriedContinue = true;
      _errors = validation.errors;
    });
    final values = validation.values;
    if (values == null) {
      await WidgetsBinding.instance.endOfFrame;
      await _formKey.currentState?.scrollToFirstError();
      return;
    }
    _saver.cancel();
    ref
        .read(settingsControllerProvider.notifier)
        .update(
          (settings) => settings
              .withWeightUnit(draft.weightUnit)
              .copyWith(heightUnit: draft.heightUnit),
        );
    ref.read(profileControllerProvider.notifier).saveValues(values);
    await ref.read(gateDraftStoreProvider).delete();
    if (mounted) {
      context.go(OnboardingRoutes.goal);
    }
  }

  Future<void> _restore() async {
    setState(() => _isRestoring = true);
    await BackupActions.restoreFromFile(context, ref);
    if (mounted) {
      setState(() => _isRestoring = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final initial = ref.watch(initialGateDraftProvider);
    final draft = initial.value;
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(TokenSpace.xl),
            children: [
              ContentWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: AppButton(
                        label: l10n.gateRestore,
                        icon: LucideIcons.upload,
                        variant: AppButtonVariant.secondary,
                        isLoading: _isRestoring,
                        onPressed: _restore,
                      ),
                    ),
                    const SizedBox(height: TokenSpace.lg),
                    OnboardingHero(
                      step: 1,
                      mark: const BrandMark(width: TokenSpace.xxxl * 3),
                      title: l10n.gateHeading,
                      subtitle: l10n.gateSubheading,
                    ),
                    const SizedBox(height: TokenSpace.xxl),
                    SkeletonGate(
                      isLoading: draft == null,
                      skeleton: const Column(
                        children: [
                          AppSkeleton(height: TokenSpace.xxxl),
                          SizedBox(height: TokenSpace.lg),
                          AppSkeleton(height: TokenSpace.xxxl),
                        ],
                      ),
                      child: draft == null
                          ? const SizedBox.shrink()
                          : _GateForm(
                              formKey: _formKey,
                              draft: draft,
                              today: _today,
                              errors: _errors,
                              hasTriedContinue: _hasTriedContinue,
                              onChanged: _onChanged,
                              onContinue: () => _continue(draft),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GateForm extends ConsumerWidget {
  const new({
    required this.formKey,
    required this.draft,
    required this.today,
    required this.errors,
    required this.hasTriedContinue,
    required this.onChanged,
    required this.onContinue,
  });

  final GlobalKey<ProfileFormState> formKey;
  final ProfileDraft draft;
  final CalendarDate today;
  final Map<ProfileField, ProfileProblem> errors;
  final bool hasTriedContinue;
  final ValueChanged<ProfileDraft> onChanged;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProfileForm(
          key: formKey,
          initialDraft: draft,
          today: today,
          errors: errors,
          onChanged: onChanged,
          photoBytes: ref.watch(profilePhotoProvider).value,
          onPickPhoto: (source) =>
              ProfilePhotoActions.pick(context, ref, source),
          onRemovePhoto: () => ProfilePhotoActions.remove(ref),
        ),
        const SizedBox(height: TokenSpace.xl),
        if (hasTriedContinue && errors.isNotEmpty) ...[
          Semantics(
            liveRegion: true,
            child: Text(
              l10n.gateFixErrors,
              style: context.textStyles.bodyMedium?.copyWith(
                color: context.colors.danger,
              ),
            ),
          ),
          const SizedBox(height: TokenSpace.sm),
        ],
        AppButton(
          label: l10n.gateContinue,
          isExpanded: true,
          onPressed: onContinue,
        ),
        const SizedBox(height: TokenSpace.xxl),
      ],
    );
  }
}
