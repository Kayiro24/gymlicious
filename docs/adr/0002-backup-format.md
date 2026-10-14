# ADR 0002: Backup file format

Status: accepted (2026-10-14)

## Context
Spec 5.9 requires a single human-readable backup file that can be shared, verified before restore, and restored on any later app version. Restores must be undoable once.

## Decision
A backup is a UTF-8 JSON file named `gymtracker_backup_<date>.json`:

```json
{
  "app": "gymtracker",
  "formatVersion": 1,
  "schemaVersion": 1,
  "appVersion": "1.0.0",
  "createdAt": "2026-10-14T09:30:00.000+05:30",
  "checksum": "<sha256 hex of the canonical payload>",
  "payload": { "profile": {}, "settings": {}, "exercises": [], "splits": [], "sessions": [], "photoBase64": null }
}
```

- `payload` is assembled from every feature's `BackupContributor`. Transient sections (the in-progress session, D17) are left out.
- `photoBase64` is the stored 512 px JPEG unchanged (D5).
- **Checksum (D16):** SHA-256 over the canonical payload: object keys sorted recursively, no whitespace, Dart `jsonEncode` number formatting, UTF-8.
  Test vector: `{"b":true,"a":{"d":[1,2.5],"c":"x"}}` canonicalises to `{"a":{"c":"x","d":[1,2.5]},"b":true}` with SHA-256 `581a9cae457de5ab13a349174029ad804d18793f69fcdbf4548122c612d7ebdc`.
- **Restore:** decode, check the `app` marker and checksum, reject a `schemaVersion` newer than the app's, migrate older ones, show a summary, then replace everything. The current data is written to `pre_restore.json` first so "Undo last restore" can put it back (D18).

## Consequences
- Files are readable and diffable, and a checksum mismatch is caught before any data changes.
- Restores are all-or-nothing; there is no merge.
- Changing a section's shape needs a schema migration so old backups still restore.
