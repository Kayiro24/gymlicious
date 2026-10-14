import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';

/// Round profile image, or initials on a soft accent background.
class AppAvatar extends StatelessWidget {
  const new({
    required this.name,
    super.key,
    this.photoBytes,
    this.size = TokenLayout.minTouchTarget,
  });

  final String name;
  final Uint8List? photoBytes;
  final double size;

  static String initialsOf(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty);
    return parts
        .take(2)
        .map((part) => part.characters.first.toUpperCase())
        .join();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bytes = photoBytes;
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: size,
        child: ClipOval(
          child: bytes != null
              ? Image.memory(bytes, fit: BoxFit.cover, gaplessPlayback: true)
              : ColoredBox(
                  color: colors.accentSoft,
                  child: Center(
                    child: Text(
                      initialsOf(name),
                      style: context.textStyles.titleMedium?.copyWith(
                        fontSize: size * 0.38,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
