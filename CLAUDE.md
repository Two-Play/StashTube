# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

A YouTube-style Flutter client (iOS/Android) for a self-hosted [Stash](https://github.com/stashapp/stash) server. It talks to the server's GraphQL API (`<server-url>/graphql`, optional `ApiKey` header) and plays scene streams in-app. Product backlog (epics and user stories, in German) is in `docs/BACKLOG.md`. Keep its status column up to date when implementing stories.

## Commands

```bash
flutter pub get
flutter run
dart analyze                    # flutter_lints + riverpod_lint (flutter analyze does NOT run analyzer plugins)
flutter test                    # all tests
flutter test test/core/paged_notifier_test.dart --plain-name "loads pages"   # single test
flutter build ios --simulator --debug
flutter build apk --debug
```

- `pubspec.lock` is git-ignored (`*.lock`), so check resolved versions with `flutter pub deps`. Older transitive versions (`archive` 3.4, `win32` 5.4) don't compile on the current Dart SDK.
- Android uses Gradle 9.3.1 / AGP 9.1.0 / Kotlin 2.4.0 with Kotlin DSL, matching the current Flutter template. `android.builtInKotlin=false` and `android.newDsl=false` in `gradle.properties` keep older plugins such as media_kit working.
- Riverpod 3. All providers are written by hand: there is no codegen and no `@riverpod`. riverpod_lint 3 is enabled under `plugins:` in `analysis_options.yaml` (analysis_server_plugin, no custom_lint).
- Family notifiers get their argument through the constructor (see `PagedNotifier`). `AsyncValue.value` is null while loading or on error (there is no `valueOrNull`). Use `Notifier` classes with methods instead of `StateProvider`. Check `ref.mounted` after `await` before touching `state`.
- Riverpod 3 retries failed providers automatically. `main()` sets `retry: stashRetry`, which retries only network errors, at most 3 times; server-reported errors show immediately.
- `flutter_chrome_cast` is pinned below 1.5. Version 1.5 pulls in permission_handler 13, which needs compileSdk 37, and AGP 9.1 only supports up to 36.

## Architecture

```
lib/
  main.dart, app.dart     bootstrap; StashApp shows LoginPage or AppShell based on serverConfigProvider
  core/api/queries.dart   all GraphQL documents (with fragments)
  core/config/            ServerConfig + persistence (SharedPreferences), theme + ThemeMode provider
  core/pagination/        PagedNotifier / PagedState: generic infinite-list notifier
  data/models/            typed models with defensive fromJson; list query args (SceneQuery, ...)
  data/repositories/      StashRepository: the only place that talks GraphQL
  data/providers.dart     list/detail providers built on the repository
  features/<feature>/     screens (auth, shell, home, player, search, performers, studios, settings)
  widgets/                shared UI (SceneCard, PagedSliver, SceneFeedView, StashImage, ...)
```

**Server config and data flow.** `main()` overrides `sharedPreferencesProvider`. `serverConfigProvider` reads the URL (key `url`, kept from older versions) and the API key from it, and `graphQLClientProvider` and `stashRepositoryProvider` derive from that config. Login and logout only change `serverConfigProvider`. `StashApp` keys `AppShell` by URL, so per-server state is rebuilt. UI code never builds GraphQL queries itself; it watches providers from `data/providers.dart`.

**Paginated lists.** `sceneListProvider`, `performerListProvider` and `studioListProvider` are auto-dispose family `PagedNotifier`s keyed by query objects (`SceneQuery`, `PerformerQuery`, `StudioQuery`). These query objects must keep value equality. The random sort uses a `random_<seed>` sort field so pages stay stable, and the seed is 0 for every other sort. To get an infinite, refreshable list with sort chips, use `SceneFeedView`, or compose `RefreshIndicator`, `LoadMoreListener`, `CustomScrollView` and `PagedSliver` yourself.

**Shell and navigation.** `AppShell` holds an `IndexedStack` with one nested `Navigator` per `AppTab`, with the `Miniplayer` on top. The bottom `NavigationBar` collapses as the player expands, driven by `miniplayerHeightProvider`. To navigate, use `openPage`, `openPerformer`, `openStudio` or `openSearch` from `features/shell/navigation.dart`. They push onto the current tab's navigator and collapse the player, and they also work from inside the player, which sits outside the tab navigators.

**Player.** There is a single media_kit `Player` in `playerProvider`. `nowPlayingProvider.play(scene)` opens the stream with the auth headers, starting at the resume position, and expands the panel. `PlayerPanel` is a single layout that `PlayerTransition` interpolates between the mini bar and the expanded page (video, details, "Up next") based on the panel height. The one `PlayerVideo` instance stays in place, so it is never rebuilt mid-transition. Keep the panel's widget tree structurally stable and toggle behavior with flags. With `showControls`, `PlayerVideo` (`player_controls.dart`) wraps media_kit's `MaterialVideoControls` on both platforms, with double-tap seeking, the collapse button and the quality sheet. `sceneDetailsProvider` loads `sceneStreams` and scene markers lazily per scene. `preferredStreamProvider` stores the chosen stream label, and `play` only waits for the stream list when a preference is set.

**Player gestures.** media_kit's controls and the details list both claim vertical drags, so the miniplayer package can't drag the expanded panel itself. `DragToMinimize` reads raw pointer events and drives the panel through `MiniplayerController.animateToHeight(height:, duration: Duration.zero)`. That's also why the player's details have no pull-to-refresh. The player uses its own `StashVideoControls` instead of media_kit's, because media_kit's hide timer removed our seek bar mid-scrub. The controls take the fullscreen state and a toggle callback from media_kit's `VideoState`; buttons sit above the tap/double-tap gesture layer so they react without waiting for a double tap. Their `PreviewSeekBar` shows sprite thumbnails (`scrubThumbnailsProvider`, parsed from Stash's WebVTT) while scrubbing.

**Watch progress and play count.** `playbackTrackerProvider` feeds the player streams into `PlaybackTracker`. That class has no widget or media_kit dependencies and is unit-tested. It calls `sceneSaveActivity` and `sceneAddPlay` through the `PlaybackActivityApi` interface that `StashRepository` implements. Saved positions also go into `resumeTimesProvider`, so thumbnails show current progress without refetching. Read a scene's position with `effectiveResumeTime`.

**Library.** The `library` tab (`features/library/`) has four sub-tabs. All scenes uses `SceneFeedView` with `SceneFeedLayout.grid`. Images and galleries share `ImageGridView`, which takes an `ImageQuery` (optionally with a `galleryId`); tapping an image opens `ImageViewerPage` on the root navigator, so it covers the shell and the player. The fourth sub-tab is stats (`libraryStatsProvider` plus the optional `activityStatsProvider`, which returns null on Stash versions without those fields).

**Errors.** `StashRepository._run` maps failures to `StashApiException`. Stash answers invalid queries with HTTP 422 plus GraphQL errors, which gql_http_link raises as `HttpLinkServerException`; these count as query errors (`isNetworkError == false`), and 401/403 become "check the API key". Fields that only newer Stash versions have should go into a separate, optional query (see `activityStats`).

**Theme.** `accentColorProvider` (persisted) feeds `AppTheme.light/dark(accent)`. Use `colorScheme.primary` and the other scheme colors instead of hard-coded colors, so the user's accent applies everywhere.

**Cast (Chromecast).** `features/cast/`. `CastService` wraps `flutter_chrome_cast` (Default Media Receiver). It is an interface so tests can use a fake, and on desktop/tests it falls back to `UnsupportedCastService`. `NowPlayingNotifier` listens to `isCastingProvider`. On connect it pauses locally and loads the scene on the TV at the current position. While casting, `play()` prepares the scene locally (paused) and casts it. On disconnect it seeks locally to the last TV position. Cast devices can't send headers, so `castMediaFor` adds the API key as `?apikey=` and prefers MP4/WebM originals, then HLS. While casting, `StashVideoControls` shows `CastingControls`.

**Images and auth.** Always load server images through `StashImage` or `ChannelAvatar`, which add the `ApiKey` header. Stash serves SVG placeholders for missing images, which fall back to an icon or the name's initial.
