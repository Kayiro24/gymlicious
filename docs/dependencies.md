# Dependencies

Exact versions, pinned in `mobile/pubspec.yaml`. Policy: the newest release at least two weeks old when added; new dependencies need a one-line reason in the PR. Renovate opens update PRs.

## App
| Package | Version | Why |
|---------|---------|-----|
| flutter_riverpod | 3.4.3 | State management and dependency injection. |
| go_router | 18.0.2 | Navigation; a stateful shell route for the tabs. |
| freezed_annotation | 3.1.0 | Immutable entities and sealed unions. |
| json_annotation | 4.12.0 | DTO serialisation. |
| collection | 1.19.1 | Equality and list helpers. |
| meta | 1.18.3 | Annotations. |
| path | 1.9.1 | File path joins. |
| path_provider | 2.1.6 | App documents and cache directories. |
| dio | 5.11.1 | Quote fetching with timeouts. |
| fl_chart | 1.2.0 | Exercise progress chart. |
| share_plus | 13.3.0 | System share sheet. |
| file_picker | 13.1.0 | Pick a backup file; save-to-device export. |
| image_picker | 1.2.3 | Camera or photo picker for the profile photo. |
| image | 4.10.1 | Square crop and 512 px JPEG resize in an isolate (D38). |
| crypto | 3.0.7 | Backup checksum. |
| intl | 0.20.3 | Localised dates and numbers (pinned by `flutter_localizations`). |
| flutter_local_notifications | 22.3.1 | Optional weekly backup reminder and daily check-in reminder. |
| timezone | 0.11.2 | `TZDateTime` for one-off reminder times (UTC instants only; no tz database). Already a transitive dependency. |
| package_info_plus | 10.2.1 | App version in backups and About. |
| url_launcher | 6.3.2 | Privacy policy and attribution links. |
| gal | 2.3.3 | Save the wallpaper image to Photos. |
| lucide_icons_flutter | 3.1.20 | Outline icon set. |

## Dev
| Package | Version | Why |
|---------|---------|-----|
| build_runner | 2.16.2 | Code generation (2.16.1 conflicts with analyzer 14.5). |
| freezed | 4.0.2 | Entity generation. |
| json_serializable | 6.14.1 | DTO generation. |
| very_good_analysis | 11.0.0 | Strict lints. |
| riverpod_lint | 3.1.9 | Riverpod lints. |
| alchemist | 0.14.0 | Golden tests that are stable across OSes. |
| flutter_test, integration_test | SDK | Tests. |

## Android (Gradle)
| Artifact | Version | Why |
|----------|---------|-----|
| com.android.tools:desugar_jdk_libs | 2.1.5 | Required by flutter_local_notifications. |
| androidx.core:core-ktx | 1.13.1 | `FileProvider` and `ContextCompat` for the native channels and wallpaper. |
| junit:junit | 4.13.2 | Kotlin layout parity test. |
| org.json:json | 20240303 | Reads the shared test vectors in local JVM tests. |

## Removed or not used
`image_cropper` (D38), `file_saver` (D23), `android_intent_plus` (D24), `import_lint` (D25), `riverpod_generator` and `go_router_builder` (D32), `mocktail` (hand-written fakes).
