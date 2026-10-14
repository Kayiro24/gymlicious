import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_tracker/core/layout/content_width.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/features/exercises/presentation/widgets/exercise_detail_view.dart';

class ExerciseDetailScreen extends StatelessWidget {
  const new({required this.exerciseId, super.key});

  final String exerciseId;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(TokenSpace.lg),
        child: ContentWidth(
          child: ExerciseDetailView(
            exerciseId: exerciseId,
            onRemoved: () => context.pop(),
          ),
        ),
      ),
    ),
  );
}
