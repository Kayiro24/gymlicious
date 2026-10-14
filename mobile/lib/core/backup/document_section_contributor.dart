import 'package:gym_tracker/core/backup/backup_contributor.dart';
import 'package:gym_tracker/core/storage/data_section.dart';
import 'package:gym_tracker/core/storage/document_store.dart';

/// Backs up a document section; restore writes in memory and the caller
/// flushes once after every contributor has restored.
class DocumentSectionContributor implements BackupContributor {
  const new(this.section, this.store);

  final DataSection section;
  final DocumentStore store;

  @override
  String get payloadKey => section.key;

  @override
  bool get isOptional => false;

  @override
  Future<Object?> export() async => store.read(section.key);

  @override
  String? validate(Object? value) => section.validate(value);

  @override
  Future<void> restore(Object? value) async => store.write(section.key, value);
}
