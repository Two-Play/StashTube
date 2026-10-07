# Stash Mobile

A mobile client for [Stash](https://github.com/stashapp/stash) on iOS and Android, built with Flutter. It feels like the YouTube app: a feed with large thumbnails, a miniplayer that keeps playing while you browse, performers and studios as "channels", and short portrait videos in a vertical Shorts feed.

The app talks to your own Stash server through its GraphQL API and plays the streams directly. It doesn't use any other services.

## Features

**Watching**
- Feed with sort chips, filters (tags, rating, length, resolution) and Stash's saved filters
- Miniplayer that turns into the full player as you drag; swipe down to minimize
- Controls:
  - seek bar with sprite thumbnails and chapter markers
  - double tap to skip 10 s
  - hold for 2× speed, plus a speed menu
  - quality and transcode choice
  - pinch to zoom
- Fullscreen in the video's orientation. Turning the phone to landscape enters it.
- Resume position and play count are saved back to Stash
- Chromecast, and AirPlay on iOS

**Shorts**
- Vertical, looping feed of short portrait videos, with the next one preloaded
- Your chosen tags show up more often, or exclusively
- Rating, O-counter, watch later, and the full video in the player

**Library**
- History, Watch later and groups, each played as a queue with autoplay
- Images and galleries, with a zoomable viewer
- Performers (favorites), studios (with sub-studios) and tags
- Search with history
- Library and watch statistics

**Editing**
- Edit scenes, performers, studios, tags and galleries, including images and URLs
- Rate scenes, count O's and add markers right from the player

**App**
- Several Stash servers to switch between, with editable URL and API key
- Configurable bottom bar, plus an "All" tab for everything else
- Light and dark mode, accent colors, and a Stash blue/brown theme
- English and German
- App lock with PIN or biometrics, a hidden app-switcher preview, and disguised app icons

The backlog with every user story and its status is in [`docs/BACKLOG.md`](docs/BACKLOG.md) (German).

## Requirements

- A Stash server reachable from the phone. A recent Stash release is recommended; on older servers, features whose GraphQL fields are missing are hidden.
- Flutter 3.47 or newer (Dart 3.12).
- For iOS: Xcode and CocoaPods. For Android: a current JDK and the Android SDK (compile SDK 37).

## Getting started

```bash
flutter pub get
flutter run
```

On the first start, enter your server's address, for example `http://192.168.1.10:9999`. If your Stash has a password, also enter an API key, which you create in Stash under *Settings → Security*. Plain `http://` works on the home network: Android allows cleartext traffic, and iOS has an ATS exception for media and local servers.

## Development

```bash
dart analyze      # flutter_lints + riverpod_lint (flutter analyze doesn't run analyzer plugins)
flutter test      # unit and widget tests
flutter gen-l10n  # after changing lib/l10n/*.arb
flutter build apk --debug
flutter build ios --simulator --debug
```

- **State:** Riverpod 3 with hand-written providers; there is no code generation.
- **Data:** `StashRepository` (`lib/data/repositories/`) is the only place that talks GraphQL. All queries are in `lib/core/api/queries.dart`, and the Stash schema they're written against is in `lib/core/graphql/schema/`.
- **Video:** playback uses [media_kit](https://github.com/media-kit/media-kit) (mpv).
- **Texts:** live in `lib/l10n/app_en.arb` and `app_de.arb`, never as string literals in the code.

[`CLAUDE.md`](CLAUDE.md) describes the architecture in detail: the server config and data flow, paginated lists, the shell and navigation, the player, Shorts, casting, theming and localization.

```
lib/
  core/       API documents, server config, theme, pagination
  data/       models, StashRepository, list and detail providers
  features/   screens: home, player, shorts, library, performers, studios, tags, search, edit, settings, cast, security
  widgets/    shared UI: scene cards, feeds, images, logo
  l10n/       ARB files and generated localizations
```

## Credits

- [Stash](https://github.com/stashapp/stash) is the server this app is a client for. The Stash logo (the open box) and its colors come from the Stash project, which is licensed under AGPL-3.0.
- This app is not affiliated with the Stash project.
