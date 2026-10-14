import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/providers.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_avatar.dart';
import 'package:gym_tracker/features/profile/profile.dart';

class HomeHeader extends ConsumerWidget {
  const new({super.key});

  static const _afternoonHour = 12;
  static const _eveningHour = 18;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final profile = ref.watch(profileControllerProvider);
    final photo = ref.watch(profilePhotoProvider).value;
    final name = profile?.name.split(' ').first ?? '';
    final hour = ref.watch(clockProvider).now().hour;
    final greeting = hour < _afternoonHour
        ? l10n.homeGreetingMorning(name)
        : hour < _eveningHour
        ? l10n.homeGreetingAfternoon(name)
        : l10n.homeGreetingEvening(name);
    return Row(
      children: [
        Expanded(
          child: Semantics(
            header: true,
            child: Text(greeting, style: context.textStyles.headlineSmall),
          ),
        ),
        const SizedBox(width: TokenSpace.md),
        Semantics(
          button: true,
          label: l10n.homeOpenProfile,
          child: InkWell(
            onTap: () => context.push(ProfileRoutes.profile),
            customBorder: const CircleBorder(),
            child: AppAvatar(name: profile?.name ?? '', photoBytes: photo),
          ),
        ),
      ],
    );
  }
}
