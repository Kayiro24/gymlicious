# Contributing to Gymlicious

Thanks for helping. Bug reports, ideas and pull requests are all welcome.

## Ground rules

- **No user data leaves the device.** No analytics, crash reporters, accounts or cloud sync. Pull requests that add any of these will be declined.
- **Keep it simple and kind.** Plain words, positive copy, no streak-shaming, no dark patterns.
- Be respectful: see the [Code of Conduct](CODE_OF_CONDUCT.md).

## Getting set up

```sh
cd mobile
flutter pub get
flutter run --flavor dev --dart-define-from-file=config/dev.json
```

You don't need any keys or secrets to build, run or test. Release signing is only needed for store uploads (see [docs/releasing.md](docs/releasing.md)).

## Before you open a pull request

```sh
cd mobile
dart format lib test catalogue integration_test tool
dart analyze --fatal-infos
flutter test
```

If you changed `design-tokens/tokens.json`, run `dart design-tokens/tool/generate_theme.dart` from the repo root. If you changed models or strings, run `dart run build_runner build -d` and `flutter gen-l10n`. If your change alters a screen on purpose, regenerate goldens with `flutter test --update-goldens` and check the images.

The code conventions live in [docs/requirements.md](docs/requirements.md) (Section 10A) and [docs/adding-a-feature.md](docs/adding-a-feature.md). In short:
- Feature-first clean architecture; the architecture test enforces layer rules.
- Comments only for a non-obvious "why", in one or two lines.
- No hard-coded colours, sizes or user-visible strings: use tokens and `app_en.arb`.
- New persisted data needs a schema migration and is backed up automatically through its data section.
- Use [Conventional Commits](https://www.conventionalcommits.org) (`feat:`, `fix:`, `docs:` …).

Decisions that change behaviour go in [docs/decisions.md](docs/decisions.md).

## Reporting bugs

Open an issue with the steps to reproduce, what you expected, and your device and OS version. Please don't attach backup files: they contain your personal data.

Security problems: see [SECURITY.md](SECURITY.md) instead of opening a public issue.
