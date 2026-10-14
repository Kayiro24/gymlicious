import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/layout/content_width.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/features/history/presentation/widgets/session_detail_view.dart';

class SessionDetailScreen extends StatelessWidget {
  const new({required this.sessionId, super.key});

  final String sessionId;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(AppLocalizations.of(context).sessionDetailTitle),
    ),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(TokenSpace.lg),
        child: ContentWidth(
          child: SessionDetailView(
            sessionId: sessionId,
            onDeleted: () => context.pop(),
          ),
        ),
      ),
    ),
  );
}
