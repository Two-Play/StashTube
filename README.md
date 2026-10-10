<h1 align="center">
  <img src="assets/icons/stash.png" width="96" height="96" alt="Stashy app icon"><br>
  Stashy
</h1>

<p align="center">
  A YouTube-style mobile client for your own <a href="https://github.com/stashapp/stash">Stash</a> server, for Android and iOS.
</p>

<p align="center">
  <a href="https://github.com/Two-Play/StashAppMobile/releases"><img src="https://img.shields.io/github/v/release/Two-Play/StashAppMobile?include_prereleases&sort=semver&label=release" alt="Latest release"></a>
  <a href="https://github.com/Two-Play/StashAppMobile/actions/workflows/ci.yml"><img src="https://github.com/Two-Play/StashAppMobile/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
  <a href="https://github.com/Two-Play/StashAppMobile/releases"><img src="https://img.shields.io/github/downloads/Two-Play/StashAppMobile/total?label=downloads" alt="Downloads"></a>
  <img src="https://img.shields.io/badge/platform-Android%20%7C%20iOS-lightgrey" alt="Platforms: Android and iOS">
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.47-02569B?logo=flutter" alt="Flutter 3.47"></a>
  <a href="https://github.com/stashapp/stash"><img src="https://img.shields.io/badge/Stash-client-137CBD" alt="Stash client"></a>
</p>

<p align="center">
  <a href="https://apps.obtainium.imranr.dev/redirect?r=obtainium://add/https://github.com/Two-Play/StashAppMobile"><img src="https://raw.githubusercontent.com/ImranR98/Obtainium/main/assets/graphics/badge_obtainium.png" height="54" alt="Get it on Obtainium"></a>
</p>

Stashy feels like the YouTube app: a feed with large thumbnails, a miniplayer that keeps playing while you browse, performers and studios as "channels", and short portrait videos in a vertical Shorts feed. It talks to your own Stash server through its GraphQL API and plays the streams directly.

> [!NOTE]
> Stashy connects only to the Stash server you enter. It has no account, no analytics and no other services. It is not affiliated with the Stash project.

> [!IMPORTANT]
> Stashy is in beta. Signed Android builds are on the releases page; there is no iOS download yet (see [iOS](#ios)).

## Contents

- [Features](#features)
- [Installation](#installation)
  - [Android with Obtainium (recommended)](#android-with-obtainium-recommended)
  - [Android with an APK](#android-with-an-apk)
  - [iOS](#ios)
- [First start](#first-start)
- [Privacy and discretion](#privacy-and-discretion)
- [Building from source](#building-from-source)
- [Development](#development)
- [Credits](#credits)

## Features

### Watching

- Feed with sort chips, filters (tags, rating, length, resolution) and Stash's saved filters
- Animated previews: the first fully shown video in a list plays its preview after a moment
- Miniplayer that turns into the full player as you drag; swipe down to minimize
- Controls:
  - seek bar with sprite thumbnails and chapter markers
  - double tap to skip 10 s, hold for 2× speed, plus a speed menu
  - quality and transcode choice (HD)
  - pinch to zoom
- Fullscreen in the video's orientation; turning the phone to landscape enters it
- Picture-in-picture, background playback, and optional lock screen controls
- Resume position and play count are saved back to Stash
- Chromecast, and AirPlay on iOS

### Shorts

- Vertical, looping feed of short portrait videos, with the next one preloaded
- Your chosen tags show up more often, or exclusively
- A performer's own shorts from their channel page
- Four shorts on the home page, each with a queue of its own

### Library

- History, Watch later and groups, each played as a queue with autoplay
- Markers: every marked moment, with a looping preview, played from the marker
- Images and galleries, with a zoomable viewer
- Performers (favorites), studios (with sub-studios) and tags
- One search for scenes, images, galleries, performers and studios
- Library and watch statistics

### Editing

- Edit scenes, performers, studios, tags and galleries, including images and URLs
- Rate scenes, count O's and add markers right from the player

### App

- Several Stash servers to switch between, signed in with an API key or username and password
- Configurable bottom bar, plus an "All" tab for everything else
- Light and dark mode, accent colors, and the Stash blue/brown theme
- Layouts with several columns on tablets and in landscape
- Haptic feedback (off, light, normal)
- English and German

The backlog with every user story and its status is in [`docs/BACKLOG.md`](docs/BACKLOG.md) (German).

## Installation

### Android with Obtainium (recommended)

[Obtainium](https://github.com/ImranR98/Obtainium) installs apps straight from their GitHub releases and keeps them up to date.

1. Install Obtainium.
2. Tap the **Get it on Obtainium** badge above on your phone, or add the app in Obtainium by its URL: `https://github.com/Two-Play/StashAppMobile`.
3. While Stashy is in beta, turn on **Include prereleases** in the app's settings in Obtainium.
4. Install. Obtainium picks the right APK for your phone and notifies you of updates.

> [!TIP]
> Obtainium also shows the release notes of each update before you install it.

### Android with an APK

1. Open the [latest release](https://github.com/Two-Play/StashAppMobile/releases) on your phone.
2. Download the APK for your phone:

   | File | For |
   | --- | --- |
   | `stashy-…-arm64-v8a.apk` | almost all phones of the last years |
   | `stashy-…-armeabi-v7a.apk` | older 32-bit phones |
   | `stashy-…-x86_64.apk` | emulators and x86 devices |
   | `stashy-…-universal.apk` | any device, but larger |

3. Open the file and allow your browser or file manager to install apps when Android asks.
4. To update later, install the newer APK over the old one; your servers and settings stay.

> [!WARNING]
> Only install APKs from this repository's releases. Every release is signed with the same key, and Android refuses an update signed with another one, so nothing else can replace Stashy.

<details>
<summary>Checking a download</summary>

Every release has a `SHA256SUMS` file. Compare it with the APK you downloaded, for example on a computer:

```bash
sha256sum -c SHA256SUMS --ignore-missing
```

The signing certificate's SHA-256 fingerprint starts with `F0:19:71:FF:8A:13:80:A8`.

</details>

### iOS

There is no iOS download yet: TestFlight and the App Store need a paid Apple developer account. You can build Stashy yourself and install it with Xcode (see [Building from source](#building-from-source)).

> [!NOTE]
> With a free Apple ID, apps installed from Xcode stop opening after 7 days and have to be installed again.

## First start

1. Enter your server's address, for example `http://192.168.1.10:9999`.
2. If your Stash has a password, either enter an **API key** (create one in Stash under *Settings → Security*) or sign in with your **username and password**.
3. Pick a theme and an accent color. You can change them, and everything else, in the settings (the gear at the top).

> [!TIP]
> Plain `http://` works on your home network: Android allows cleartext traffic, and iOS has an exception for local servers and media.

> [!CAUTION]
> Use `https://` when your server is reachable from the internet. Over `http://` your API key or password travels unencrypted. Casting always puts the API key into the stream URL, because cast devices can't send headers.

## Privacy and discretion

Stashy has a few settings for keeping things private, under *Settings → Privacy & security*:

- **App lock** with a PIN and optionally Face ID or fingerprint, right away or after 1, 5 or 15 minutes in the background
- **Hide in app switcher**: covers the app in the recent apps view (always on with the app lock; on Android it also blocks screenshots)
- **Disguised app icon**: Notes or Calculator instead of the Stashy icon
- **Lock screen controls** (under *Playback*) are off by default, so titles and thumbnails don't show on the lock screen

> [!NOTE]
> The PIN is stored only as a salted hash. API keys and passwords are kept in the system's secure storage (Keychain on iOS, Keystore on Android).

Found a security problem? Please report it privately, as described in [`SECURITY.md`](SECURITY.md).

## Building from source

You need:

- Flutter 3.47 or newer (Dart 3.12)
- for Android: a current JDK and the Android SDK (compile SDK 37)
- for iOS: a Mac with Xcode and CocoaPods
- a Stash server reachable from the device; a recent Stash release is recommended (features whose GraphQL fields an older server lacks are hidden)

```bash
git clone https://github.com/Two-Play/StashAppMobile.git
cd StashAppMobile
flutter pub get
flutter run            # on a connected phone or a simulator
```

To install on an iPhone, open `ios/Runner.xcworkspace` in Xcode, choose your Apple ID as the team under *Signing & Capabilities*, and run it on your phone.

> [!NOTE]
> Without `android/key.properties`, which only the maintainers have, Android release builds are signed with the debug key. They install fine, but can't update the official releases, and the other way round.

## Development

```bash
dart analyze      # flutter_lints + riverpod_lint (flutter analyze doesn't run analyzer plugins)
flutter test      # unit and widget tests
flutter gen-l10n  # after changing lib/l10n/*.arb
flutter pub run build_runner build --delete-conflicting-outputs   # after changing a .graphql file
```

- **State:** Riverpod 3 with hand-written providers; there is no code generation for providers.
- **Data:** `StashRepository` (`lib/data/repositories/`) is the only place that talks GraphQL. The documents are in `lib/core/api/documents/*.graphql`, checked against Stash's schema (`lib/core/api/stash_schema.graphql`) and generated into typed Dart classes.
- **Video:** playback uses [media_kit](https://github.com/media-kit/media-kit) (mpv).
- **Texts:** live in `lib/l10n/app_en.arb` and `app_de.arb`, never as string literals in the code.
- **Dependencies:** `pubspec.lock` and `ios/Podfile.lock` are committed; CI runs `flutter pub get --enforce-lockfile`.
- **Releases:** pushing a tag `vX.Y.Z` that matches `version:` in `pubspec.yaml` builds signed APKs and an AAB and publishes a GitHub release (`.github/workflows/release.yml`). Tags with a `-` become pre-releases.

[`CLAUDE.md`](CLAUDE.md) describes the architecture in detail: the server config and data flow, paginated lists, the shell and navigation, the player, Shorts, casting, privacy, theming and localization.

```text
lib/
  core/       API documents, server config, theme, haptics, pagination
  data/       models, StashRepository, list and detail providers
  features/   screens: home, player, shorts, library, performers, studios, tags,
              search, edit, settings, cast, pip, security
  widgets/    shared UI: scene cards, feeds, previews, images, logo
  l10n/       ARB files and generated localizations
```

## Credits

- [Stash](https://github.com/stashapp/stash) is the server this app is a client for. The Stash logo (the open box) and its colors come from the Stash project, which is licensed under AGPL-3.0.
- This app is not affiliated with the Stash project.
