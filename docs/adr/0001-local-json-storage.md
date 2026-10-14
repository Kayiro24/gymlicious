# ADR 0001: Local storage is one JSON document

Status: accepted (2026-10-14)

## Context
Spec 4.1 asks for offline-first storage that survives crashes, can be backed up as a single file and can migrate between schema versions. Expected data is small: two years of daily logging is a few MB.

## Decision
- All user data except the photo lives in `gymtracker_data.json` in the app documents directory. The profile photo is `profile_photo.jpg`. The quote cache (`quotes_cache.json`) and the onboarding draft (`onboarding_draft.json`) are separate because they are disposable.
- `AtomicJsonStore` writes `.tmp`, flushes, copies the current file to `.bak`, then renames `.tmp` over the primary. On load, a missing or corrupt primary falls back to `.bak`; if both fail, the app opens the recovery screen.
- Encoding and decoding run in a background isolate.
- `DocumentStore` holds the parsed document. Each feature owns named sections (`DataSection`) and reads and writes only those. Saves are debounced by 500 ms and flushed when the app is paused.
- The document carries `schemaVersion`. `SchemaMigrator` applies ordered, pure migrations on load and on restore.

## Consequences
- No database dependency, and a backup is close to a copy of the file.
- Every save rewrites the whole file. That is fine at this size; the `DataStore` interface is the seam for swapping in SQLite if logs ever grow past a few MB (plan risk R8).
- New persisted data needs a section, a migration if it changes existing shape, and a `BackupContributor`.
