# Releasing Gymlicious

Builds for contributors need no secrets. Only signed store builds do, and those secrets never enter the repository.

## 1. Create the upload key (once)

```sh
keytool -genkey -v -keystore ~/gymlicious-upload.jks -keyalg RSA -keysize 2048 \
  -validity 10000 -alias upload
```

Store the `.jks` file and its passwords in a password manager. **If you lose it, you can't update the app on Play** (unless Play App Signing is on, which is recommended: then this is only the upload key and can be reset).

## 2. Sign locally (optional)

Copy `mobile/android/key.properties.example` to `mobile/android/key.properties` and fill it in. That file is git-ignored. Then:

```sh
cd mobile
flutter build appbundle --release --flavor prod --dart-define-from-file=config/prod.json
```

Without `key.properties` (or the CI variables below) release builds fall back to debug signing, which Play rejects. That's on purpose, so anyone can build release mode locally.

## 3. Sign in CI

Add these **repository secrets** (Settings → Secrets and variables → Actions):

| Secret | Value |
|--------|-------|
| `ANDROID_KEYSTORE_BASE64` | `base64 -w0 gymlicious-upload.jks` (macOS: `base64 -i gymlicious-upload.jks`) |
| `ANDROID_KEYSTORE_PASSWORD` | the keystore password |
| `ANDROID_KEY_ALIAS` | `upload` |
| `ANDROID_KEY_PASSWORD` | the key password |

The build reads them as environment variables (`ANDROID_KEYSTORE_PATH` is set by the workflow after decoding). Nothing is echoed to logs.

## 4. Cut a release

1. Bump `version:` in `mobile/pubspec.yaml` (`1.0.1+2`: name + build number; the build number must always increase).
2. Add the changes to `CHANGELOG.md`.
3. Tag and push: `git tag v1.0.1 && git push origin v1.0.1`.

The `release` workflow builds the signed `.aab` (for Play) and `.apk` (for direct download), and attaches both to a GitHub release.

## iOS

iOS needs a Mac, an Apple Developer account and signing in Xcode (`ios/Runner.xcworkspace`, bundle ID `com.kayiro.gymlicious`). Keep certificates and provisioning profiles out of git; `.gitignore` blocks `*.p12` and `*.mobileprovision`.

## Store listing checklist

- Icon: `docs/store/icon-512.png` (generated from `branding/gymlicious-logo.png`).
- Privacy policy URL: publish `docs/privacy-policy.md` (for example with GitHub Pages) and use that link.
- Data safety / App privacy: no data collected, no data shared. The app makes network requests only for quotes, which send no user data.
- Screenshots: take them on a phone and a tablet in light and dark.
