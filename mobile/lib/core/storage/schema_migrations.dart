import 'package:gym_tracker/core/storage/migrations/v1_to_v2_migration.dart';
import 'package:gym_tracker/core/storage/schema_migrator.dart';

const currentSchemaVersion = 2;

/// Every schema bump adds one migration here, plus a test.
final appSchemaMigrator = SchemaMigrator(
  currentVersion: currentSchemaVersion,
  migrations: const [V1ToV2Migration()],
);
