import 'package:flutter/material.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/layout/content_width.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/features/rewards/presentation/widgets/reward_widgets.dart';

class BadgesScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(AppLocalizations.of(context).badgesTitle)),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(TokenSpace.lg),
        children: const [
          ContentWidth(child: NextBadgeTeaser()),
          SizedBox(height: TokenSpace.lg),
          ContentWidth(child: BadgeGrid()),
          SizedBox(height: TokenSpace.xxl),
        ],
      ),
    ),
  );
}
