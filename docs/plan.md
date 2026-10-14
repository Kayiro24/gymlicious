# Gym Tracker: build plan

Revised 2026-10-14 for the spec revision that removes the backend (see `docs/requirements.md`). Package versions were taken from pub.dev on that date.

Contents: 1. Toolchain · 2. Repository layout · 3. Pinned packages · 4. Deviations from spec Section 2 · 5. Risks

---

## 1. Toolchain

| Tool | Version | Notes |
|------|---------|-------|
| Flutter | 3.47.7 stable, Dart 3.13.5 | Upgraded from 3.41.5; `freezed 4`, `riverpod_lint 3` and `very_good_analysis 11` need Dart 3.13. |
| JDK | Android Studio JBR 21 | Android builds and Kotlin parity tests. |
| Xcode | not available (Windows) | iOS is built and tested on a macOS CI runner only. See R1. |

---

## 2. Repository layout

```
gym-tracker/
├── .github/{workflows/mobile.yml, pull_request_template.md, CODEOWNERS}
├── .pre-commit-config.yaml
├── renovate.json
├── design-tokens/
│   ├── tokens.json
│   └── tool/generate_theme.dart          # -> mobile Dart tokens + Kotlin wallpaper palette
├── shared-test-vectors/year_dots/layout_test_vectors.json
├── mobile/
│   ├── assets/{fonts/, seed/, quotes/bundled_quotes.json, brand/}
│   ├── config/{dev,staging,prod}.json     # --dart-define-from-file
│   ├── lib/
│   │   ├── main.dart
│   │   ├── app/                           # bootstrap, router, shell, feature registration
│   │   ├── core/   clock/ failure/ storage/ network/ platform/ module/ backup/
│   │   │           config/ layout/ units/ theme/ l10n/ logging/ ids/
│   │   ├── design_system/                 # AppButton … AppSkeleton, AppLoadingRing, AppProgressSheet, AppToast
│   │   ├── shared/                        # StatPill, SetRow, QuoteCard, … PhotoPicker
│   │   └── features/<feature>/{<feature>.dart, domain/, data/, presentation/}
│   ├── test/ (mirrors lib/; fakes/; architecture/)
│   ├── integration_test/
│   ├── catalogue/main.dart                # design-system catalogue (D40)
│   ├── android/app/src/main/kotlin/…/{wallpaper/, channels/}
│   └── ios/Runner/
└── docs/{requirements, plan, decisions, dependencies, quote-providers, architecture,
          adding-a-feature, privacy-policy}.md, adr/
```

Features: onboarding, home, train, exercises, history, year_dots, profile, settings, backup, quotes, plus **workouts**: a screen-less data feature that owns exercises, splits, sessions and the max/last/up-next rules (D31). `features/<feature>/<feature>.dart` is the only file other features may import.

---

## 3. Pinned packages

Policy: exact versions; the newest release at least two weeks old (cutoff 2026-09-30) unless noted. The final list goes into `docs/dependencies.md`.

### App
| Package | Version | Why |
|---------|---------|-----|
| flutter_riverpod | 3.4.3 | State management and DI. |
| go_router | 18.0.2 | Navigation, shell routes for bottom nav / rail. |
| freezed_annotation | 3.1.0 | Immutable domain entities and sealed unions. |
| json_annotation | 4.12.0 | DTO serialization (data layer only). |
| path_provider | 2.1.6 | App documents directory for the data, photo and quote cache files. |
| dio | 5.11.1 | Quote fetching: 5 s timeouts, no cookies. |
| fl_chart | 1.2.0 | Exercise progress chart. |
| share_plus | 13.3.0 | Share sheet for backups and wallpaper images. |
| file_picker | 13.1.0 | Pick backup files; `saveFile` for SAF / Files export. |
| image_picker | 1.2.3 | Camera or system photo picker. |
| image_cropper | 12.2.1 | Square crop (13.0.0 is a 2-day-old major). |
| image | 4.10.1 | JPEG resize/encode in an isolate. |
| crypto | 3.0.7 | Backup checksum, quote text hashes. |
| intl | 0.20.3 | ARB localisation and locale formatting (pinned by `flutter_localizations`). |
| flutter_local_notifications | 22.3.1 | Optional weekly backup reminder. |
| package_info_plus | 10.2.1 | App version in the backup envelope and About. |
| url_launcher | 6.3.2 | Privacy policy and attribution links. |
| gal | 2.3.3 | Save the wallpaper PNG to Photos. |
| flutter_svg | 2.3.0 | Line-illustration empty states. |
| lucide_icons_flutter | 3.1.20 | Rounded outline icons with consistent stroke. |

### Dev
| Package | Version | Why |
|---------|---------|-----|
| build_runner | 2.16.2 | Code generation (2.16.1 conflicts with analyzer 14.5). |
| freezed | 4.0.2 | Entity and union generation. |
| json_serializable | 6.14.1 | DTO generation. |
| very_good_analysis | 11.0.0 | Strict lint set. |
| riverpod_lint | 3.1.9 | Riverpod misuse lints. |
| alchemist | 0.14.0 | CI-stable golden tests. |
| integration_test / flutter_test | SDK | Tests. |

Not used: `riverpod_generator` and `go_router_builder`, since hand-written providers and typed route classes avoid two code generators (D32); `mocktail` (hand-written fakes); `file_saver`, `android_intent_plus` and `import_lint` (see Section 4).

---

## 4. Deviations from spec Section 2

1. `file_picker.saveFile` instead of `file_saver` (D23).
2. WhatsApp direct button through our own Kotlin channel (D24).
3. Layer rules enforced by a Dart architecture test instead of `import_lint` (D25).
4. `alchemist` for goldens (D26).
5. Font is Plus Jakarta Sans, not DM Sans, for tabular figures (D20).

---

## 5. Risks

| # | Risk | Mitigation |
|---|------|------------|
| R1 | No macOS here: iOS build, privacy manifest, Photos saving and the Swift renderer can't be verified locally. | macOS CI job; real iPhone check before release. |
| R2 | Spec light `accent`/`danger` fail AA. | Darkened in `tokens.json` (D30); a token contrast test runs in CI. |
| R3 | Year Dots "left" dots are deliberately below WCAG 1.4.11's 3:1. | Information also carried by the text line, semantics and tooltips. |
| R4 | Only one verified online quote source (AnimeChan). Its anime dialogue is third-party IP. | Bundled set always works; second slot open (`docs/quote-providers.md`). Online quotes can be switched off with a local flag. |
| R5 | Golden drift between Windows and Linux CI. | Alchemist CI goldens are the gate. |
| R6 | OEM live-wallpaper quirks (Samsung lock screen), iOS Shortcuts prompts. | Static export on both platforms. |
| R7 | Float differences in the Dart/Kotlin/Swift layout. | Vectors compare with an epsilon; column choice uses an explicit tie epsilon. |
| R8 | JSON file growth. | `DataRepository` seam; perf test with ~2 years of synthetic logs. |
| R9 | Android 13+ notification permission; WhatsApp package visibility. | Ask only when the reminder is enabled; `<queries>` entries; share-sheet fallback. |
| R10 | iOS flavors need Xcode schemes, which can't be authored reliably on Windows. | Android flavors now; iOS uses dart-define config only until a Mac/CI pass (D33). |
