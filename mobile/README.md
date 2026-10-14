# Gymlicious app

Flutter 3.47.7 / Dart 3.13.5.

## Run
```sh
flutter pub get
flutter run --flavor dev --dart-define-from-file=config/dev.json
```
Flavors: `dev`, `staging`, `prod` (app ID `com.kayiro.gymlicious`, with `.dev` / `.staging` suffixes). Device tests run on `staging`, which has its own storage. iOS has no schemes yet, so run it without `--flavor`.

## Check
```sh
dart format --set-exit-if-changed lib test
dart analyze
flutter test
cd android && ./gradlew :app:testDevDebugUnitTest   # Kotlin layout parity
```

## Generate
```sh
dart run build_runner build -d                     # freezed / json_serializable
flutter gen-l10n                                   # strings from lib/core/l10n/arb
(cd .. && dart design-tokens/tool/generate_theme.dart)  # tokens -> Dart + Kotlin
```

## Catalogue
`flutter run -t catalogue/main.dart` shows every design-system and shared widget (phone/tablet frames, dark mode, 200% text).

## Layout
`lib/app` wires everything, `lib/core` holds shared infrastructure, `lib/design_system` and `lib/shared` hold widgets, and `lib/features/<name>` holds each feature. See `docs/architecture.md`.
