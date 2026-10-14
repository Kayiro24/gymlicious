# Adding to the app

## A feature

1. Create `mobile/lib/features/<name>/` with `domain/`, `data/` and `presentation/` as needed.
2. Add `<name>.dart` (the public API other features may import) and, if other domains need its types, `<name>_domain.dart` (pure Dart).
3. Add `<name>_module.dart` exporting a `FeatureModule` and list it in `lib/app/app_modules.dart`.
4. Add a short `README.md` in the feature folder: what it owns and how to run its tests.
5. Add tests under `test/features/<name>/`. Domain rules need unit tests; screens need a widget test.
6. Run `dart analyze` and `flutter test` (the architecture test checks the imports).

## A tab

Set `tab:` on the module with a `TabDestination` (order, label, icons, root `GoRoute`). The shell picks it up for both the bottom bar and the rail. Keep the tab count at five or fewer; today they are Home, Plan, Train, Stats and Me (D44), so a new screen usually belongs behind one of them.

## A screen or route

Add a typed route class in the feature's `presentation/<name>_routes.dart`, then add the `GoRoute` to the module's `routes` (or under the tab's route for screens inside the tab).

## A data section

1. Define a `DataSection` in the feature's data layer with its key, default value and validator; add it to the module's `sections`.
2. Read and write it only through that feature's repository.
3. If it changes the shape of existing data, bump `currentSchemaVersion` and add a migration in `core/storage/schema_migrations.dart` with a test.
4. Add a `DocumentSectionContributor` (or a custom `BackupContributor`) to `backupContributors` so it is backed up and restored, and extend the backup round-trip test.
5. If the feature keeps files outside the store, delete them in `clearLocalData`.

## A quote provider

1. Check the provider against `docs/quote-providers.md` (key-less, terms allow storage and commercial use, attribution) and record the result there.
2. Implement `QuoteSource` in `features/quotes/data/` with a 5 s timeout and no user data in requests.
3. Give it its own `RateBudget` and register it in the sources provider.
4. Add fixture-based tests; CI never calls live APIs.

## A string

Add it to `lib/core/l10n/arb/app_en.arb` with a description, then run `flutter gen-l10n`. Never hard-code user-visible text.
