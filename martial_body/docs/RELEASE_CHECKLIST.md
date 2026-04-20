# Martial Body — Play Store Release Checklist

Everything below must be green before the first upload. Strike through items
as you go.

## 1. Signing

- [ ] Generate the upload keystore once and back it up off-device:

      keytool -genkey -v -keystore ~/martial-body-upload.jks \
        -keyalg RSA -keysize 2048 -validity 10000 -alias martial-body

- [ ] Copy `android/key.properties.template` → `android/key.properties`
      and fill in `storePassword`, `keyPassword`, `keyAlias`, `storeFile`.
- [ ] Confirm `android/key.properties` is listed in `.gitignore` and is NOT
      tracked by git (`git status` should show nothing).

## 2. Build

- [ ] `flutter clean && flutter pub get`
- [ ] `flutter build appbundle --release` completes without warnings.
- [ ] Sanity-check the bundle installs on a real device:
      `bundletool build-apks` → install the generated apks → smoke-test.

## 3. Play Console — Store listing

- [ ] App name: **Martial Body**
- [ ] Short description (≤80 chars): a one-liner.
- [ ] Full description: pull from the intro screen copy + features.
- [ ] Category: **Health & Fitness**.
- [ ] Privacy policy URL: host `docs/PRIVACY_POLICY.md` (e.g. on GitHub
      Pages) and paste the public URL. The same URL is referenced inside
      the app at `lib/features/profile/profile_screen.dart:kPrivacyPolicyUrl`.
      **Keep the two in sync.**

## 4. Data-safety form

Fill it in as follows (reflects the real behavior of the build):

- Data collection: **No data collected**.
- Data sharing: **No data shared**.
- Security practices:
  - Data encrypted in transit: N/A (no network).
  - User can request data deletion: Yes — uninstall removes all data, and
    Profile → Export CSV provides a portable copy beforehand.

## 5. Content rating

- Target audience: adults.
- Content rating questionnaire: no user-generated content, no ads, no
  location, no in-app purchases.

## 6. Target API / device

- Google Play requires the latest target API each August. Confirm
  `flutter.targetSdkVersion` in `android/app/build.gradle.kts` meets the
  current requirement before upload.
- Supported architectures: default Flutter (arm64-v8a, armeabi-v7a, x86_64).

## 7. Release-build sanity (manual pass on a real device)

- [ ] Intro → medical disclaimer → checkbox → "Begin program".
- [ ] Start a session, toggle a set on/off, verify:
    - Input formatters reject non-numeric chars.
    - Rest-timer countdown appears and can be skipped.
    - "Last: …" hint appears on the second run of the same exercise.
    - "Watch demo" opens YouTube in an external browser.
- [ ] Close mid-session → confirmation dialog → cancel keeps you in.
- [ ] Complete a session → Home reflects the updated count → Progress tab
      shows the new week's bar.
- [ ] Profile → Export CSV → share sheet opens with a valid `.csv`.
- [ ] Profile → Privacy policy opens the hosted URL.
- [ ] Force-stop + relaunch → state survives, week number unchanged.

## 8. Post-launch

- [ ] Back up the keystore again (off-device, encrypted).
- [ ] Tag the release commit: `git tag v1.0.0 && git push --tags`.
- [ ] Keep `pubspec.yaml` version / `versionCode` monotonically increasing
      on every subsequent upload.
