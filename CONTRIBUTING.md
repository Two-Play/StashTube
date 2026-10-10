# Contributing to Stashy

Thanks for helping! Bug reports, ideas, translations and pull requests are all welcome.

> [!IMPORTANT]
> Found a security problem? Please don't open an issue; report it privately as described in [`SECURITY.md`](SECURITY.md).

## Contents

- [Reporting bugs and ideas](#reporting-bugs-and-ideas)
- [Setting up](#setting-up)
- [Making a change](#making-a-change)
- [Code conventions](#code-conventions)
- [Tests](#tests)
- [Commits and pull requests](#commits-and-pull-requests)

## Reporting bugs and ideas

Open an [issue](https://github.com/Two-Play/StashAppMobile/issues) and include:

- the app version (*Settings → About*) and your platform (Android or iOS, with version)
- your Stash version (*Settings → Server*)
- what you did, what you expected and what happened instead; screenshots or a screen recording help a lot

> [!TIP]
> Many features depend on what your Stash server has generated (sprites, previews, markers). If something is missing, check the server's *Tasks → Generate* first.

Ideas fit best as an issue first, so we can talk about them before you spend time on code. The planned work is in [`docs/BACKLOG.md`](docs/BACKLOG.md) (German).

## Setting up

You need Flutter **3.47.6** (the version CI uses), a current JDK and the Android SDK, and for iOS a Mac with Xcode and CocoaPods.

```bash
git clone https://github.com/Two-Play/StashAppMobile.git
cd StashAppMobile
flutter pub get --enforce-lockfile
flutter run
```

You also need a Stash server to try things with. A local one with a few test scenes is easiest.

> [!NOTE]
> Your Android release builds are signed with the debug key, since `android/key.properties` is only on the maintainers' machines. That's fine for development; they just can't update the official releases.

## Making a change

1. Fork the repository and create a branch **from `develop`**: `feature/<what>` for features, `fix/<what>` for bug fixes, `docs/<what>` for documentation.
2. Make the change, with tests.
3. Run the same checks as CI:

   ```bash
   dart analyze      # flutter_lints + riverpod_lint; flutter analyze doesn't run the plugins
   flutter test
   ```

4. If you changed `lib/l10n/*.arb`, run `flutter gen-l10n`. If you changed a `.graphql` file, run `flutter pub run build_runner build --delete-conflicting-outputs`. Commit the generated files too.
5. If you changed dependencies, commit `pubspec.lock` (and `ios/Podfile.lock` after an iOS build).
6. If your change implements a story from [`docs/BACKLOG.md`](docs/BACKLOG.md), update its status there.

## Code conventions

[`CLAUDE.md`](CLAUDE.md) describes the architecture in detail; read the part about the area you're changing. The most important rules:

- **State:** Riverpod 3 with hand-written providers; no `@riverpod` code generation, no `StateProvider` (use a `Notifier` with methods). Check `ref.mounted` after an `await` before touching `state`.
- **Data:** only `StashRepository` talks GraphQL. UI code watches providers from `lib/data/providers.dart`.
- **Texts:** never as string literals in the UI. Add the key to both `lib/l10n/app_en.arb` and `app_de.arb` and use `context.l10n.<key>`; counts are plural messages.
- **Images from the server:** always through `StashImage` or `ChannelAvatar`, which send the authentication.
- **Colors:** from the theme's color scheme (`colorScheme.primary`, …), not hard-coded, so the user's accent applies.
- **Haptics:** through `Haptics` (`lib/core/config/haptics.dart`), never `HapticFeedback` directly; wrap the `onChanged` of switches in `withHaptic`.
- **Navigation:** `openPage`, `openPerformer`, `openStudio`, `openSearch`; edit forms open with `openEditor`.
- **Style:** lines up to 120 characters; comments explain *why*, in full sentences, as in the surrounding code.

> [!WARNING]
> Never commit secrets: no API keys, server addresses or `android/key.properties`. Secret scanning blocks pushes with known secret formats, but not everything.

## Tests

Every change comes with tests. The existing ones show the patterns:

- providers and models: plain `test()`s with a `ProviderContainer` and fake repositories (`test/helpers.dart`, `test/fixtures.dart`)
- widgets: `testWidgets()` with `UncontrolledProviderScope` or `ProviderScope` overrides
- the GraphQL layer: `test/data/repository_graphql_test.dart` runs the repository through a real client and cache

Native code (media_kit's players, picture-in-picture, the lock screen) can't run in tests; keep the logic around it in Dart where it can be tested, and describe in the pull request what you checked on a device.

## Commits and pull requests

- Write commit messages in English: a short summary line, then a blank line and what changed and why.
- Keep a pull request to one topic. Describe what changed, how you tested it, and on which devices.
- CI (analysis, tests, Android and iOS builds) and Codacy must pass before a pull request is merged.
- Open pull requests against **`develop`**, where all work comes together. `main` only changes with a release.
- Releases are made by the maintainers: a pull request from `develop` to `main` with the new version, then a tag on `main`.

> [!NOTE]
> Stashy is licensed under the [AGPL-3.0](LICENSE). By contributing, you agree that your contribution is published under the same license.
