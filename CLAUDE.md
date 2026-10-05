# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

A YouTube-style Flutter client (iOS/Android) for a self-hosted [Stash](https://github.com/stashapp/stash) server. It talks to the server's GraphQL API (`<server-url>/graphql`, optional `ApiKey` header) and plays scene streams in-app. Product backlog (epics and user stories, in German) is in `docs/BACKLOG.md`. Keep its status column up to date when implementing stories.

## Commands

```bash
flutter pub get
flutter run
flutter analyze                 # flutter_lints
dart run custom_lint            # riverpod_lint rules
flutter test                    # all tests
flutter test test/core/paged_notifier_test.dart --plain-name "loads pages"   # single test
flutter build ios --simulator --debug
flutter build apk --debug
```

- `pubspec.lock` is git-ignored (`*.lock`), so check resolved versions with `flutter pub deps`. Older transitive versions (`archive` 3.4, `win32` 5.4) don't compile on the current Dart SDK.
- Android uses Gradle 9.3.1 / AGP 9.1.0 / Kotlin 2.4.0 with Kotlin DSL, matching the current Flutter template. `android.builtInKotlin=false` and `android.newDsl=false` in `gradle.properties` keep older plugins such as media_kit working.
- `riverpod_generator`/`build_runner` are dev dependencies, but all providers are written by hand. Nothing uses `@riverpod`.

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

**Player.** There is a single media_kit `Player` in `playerProvider`. `nowPlayingProvider.play(scene)` opens the stream with the auth headers, starting at the resume position, and expands the panel. `PlayerPanel` renders the mini bar or the expanded page (video, details, "Up next") based on the panel height. `ExpandedVideo` (`player_controls.dart`) wraps media_kit's `MaterialVideoControls` on both platforms, with double-tap seeking, the collapse button and the quality sheet. `sceneDetailsProvider` loads `sceneStreams` and scene markers lazily per scene. `preferredStreamProvider` stores the chosen stream label, and `play` only waits for the stream list when a preference is set.

**Watch progress and play count.** `playbackTrackerProvider` feeds the player streams into `PlaybackTracker`. That class has no widget or media_kit dependencies and is unit-tested. It calls `sceneSaveActivity` and `sceneAddPlay` through the `PlaybackActivityApi` interface that `StashRepository` implements. Saved positions also go into `resumeTimesProvider`, so thumbnails show current progress without refetching. Read a scene's position with `effectiveResumeTime`.

**Library.** The `library` tab (`features/library/`) has three sub-tabs: all scenes (`SceneFeedView` with `SceneFeedLayout.grid`), images (`imageListProvider`, `ImageViewerPage` pushed on the root navigator so it covers the shell and the player), and stats (`libraryStatsProvider` plus the optional `activityStatsProvider`, which returns null on Stash versions without those fields).

**Errors.** `StashRepository._run` maps failures to `StashApiException`. Stash answers invalid queries with HTTP 422 plus GraphQL errors, which gql_http_link raises as `HttpLinkServerException`; these count as query errors (`isNetworkError == false`), and 401/403 become "check the API key". Fields that only newer Stash versions have should go into a separate, optional query (see `activityStats`).

**Theme.** `accentColorProvider` (persisted) feeds `AppTheme.light/dark(accent)`. Use `colorScheme.primary` and the other scheme colors instead of hard-coded colors, so the user's accent applies everywhere.

**Images and auth.** Always load server images through `StashImage` or `ChannelAvatar`, which add the `ApiKey` header. Stash serves SVG placeholders for missing images, which fall back to an icon or the name's initial.
