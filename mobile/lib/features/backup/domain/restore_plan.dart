import 'package:gym_tracker/core/storage/data_store.dart';

/// What the user sees before confirming a restore.
class BackupPreview {
  const new({
    required this.profileName,
    required this.exerciseCount,
    required this.sessionCount,
    required this.createdAt,
    required this.hasPhoto,
  });

  final String? profileName;
  final int exerciseCount;
  final int sessionCount;
  final DateTime createdAt;
  final bool hasPhoto;
}

/// A validated, migrated payload ready to replace the current data.
class RestorePlan {
  const new({required this.payload, required this.preview});

  final JsonMap payload;
  final BackupPreview preview;
}
