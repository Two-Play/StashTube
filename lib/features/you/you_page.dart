import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/haptics.dart';
import '../../core/config/theme.dart';
import '../../data/models/list_queries.dart';
import '../../data/providers.dart';
import '../../l10n/l10n.dart';
import '../../widgets/scene_shelf.dart';
import '../../widgets/skeleton.dart';
import '../auth/server_avatar.dart';
import '../library/groups.dart';
import '../library/library_page.dart';
import '../library/markers_tab.dart';
import '../library/watch_later.dart';
import '../library/watch_later_tab.dart';
import '../player/player_providers.dart';
import '../server_tasks/server_tasks_page.dart';
import '../settings/settings_button.dart';
import '../shell/app_shell.dart';
import '../shell/nav_bar_config.dart';
import '../shell/navigation.dart';

/// The "You" tab (NAV-1/3, wireframe 3.3): the user's own lists as shelves
/// (history, watch later, groups, markers), then the stats, the channel
/// lists, every view that isn't in the navigation bar, the server tasks
/// and the settings. Everything picked here opens inside this tab.
class YouPage extends ConsumerWidget {
  const YouPage({super.key});

  /// The same query as the history section, so both share one list.
  static final history = SceneQuery(sort: SceneSort.lastPlayed, playedOnly: true);
  static const groups = GroupQuery();
  static final markers = MarkerQuery();

  /// Views that have a place of their own on this page, so they aren't
  /// repeated under "More views".
  static const _ownPlace = {
    AppTab.you,
    AppTab.history,
    AppTab.watchLater,
    AppTab.groups,
    AppTab.markers,
    AppTab.stats,
    AppTab.performers,
    AppTab.studios,
    AppTab.tags,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final config = ref.watch(navBarConfigProvider);
    final moreViews = [
      for (final tab in AppTab.values)
        if (!config.isVisible(tab) && !_ownPlace.contains(tab)) tab,
    ];

    void open(Widget page) {
      Haptics.selection();
      openPage(ref, page);
    }

    void openSection(LibrarySection section) => open(LibrarySectionPage(section: section));

    Widget tile(AppTab tab, {String? title}) => ListTile(
          leading: Icon(tab.icon),
          title: Text(title ?? tab.title(l), maxLines: 2, overflow: TextOverflow.ellipsis),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => open(AppShell.rootPage(tab)),
        );

    return Scaffold(
      appBar: AppBar(
        title: Text(l.tabYou),
        actions: [
          IconButton(tooltip: l.search, icon: const Icon(Icons.search), onPressed: () => openSearch(ref)),
          const ServerAvatarButton(),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(sceneListProvider(history));
          ref.invalidate(watchLaterScenesProvider);
          ref.invalidate(groupListProvider(groups));
          ref.invalidate(markerListProvider(markers));
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: SceneShelf(
                title: l.libraryHistory,
                icon: AppTab.history.icon,
                query: history,
                onSeeAll: () => openSection(LibrarySection.history),
              ),
            ),
            SliverToBoxAdapter(child: _WatchLaterShelf(onSeeAll: () => openSection(LibrarySection.watchLater))),
            SliverToBoxAdapter(child: _GroupsShelf(onSeeAll: () => openSection(LibrarySection.groups))),
            SliverToBoxAdapter(child: _MarkersShelf(onSeeAll: () => openSection(LibrarySection.markers))),
            SliverList.list(
              children: [
                tile(AppTab.stats, title: l.libraryStats),
                tile(AppTab.performers),
                tile(AppTab.studios),
                tile(AppTab.tags),
                if (moreViews.isNotEmpty) ...[
                  const Divider(),
                  _SectionTitle(l.moreViews),
                  for (final tab in moreViews) tile(tab),
                ],
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.task_alt),
                  title: Text(l.serverTasks),
                  subtitle: Text(l.serverTasksSubtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => openSettings(context, ref, initialPage: const ServerTasksPage()),
                ),
                ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: Text(l.settingsTitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => openSettings(context, ref),
                ),
                const SizedBox(height: AppSpacing.l),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.l, AppSpacing.s, AppSpacing.l, AppSpacing.xs),
      child: Semantics(
        header: true,
        child: Text(text, style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary)),
      ),
    );
  }
}

/// Watch later as a shelf; tapping a scene plays the list from there. When
/// empty, a short hint instead (the list is the user's to fill).
class _WatchLaterShelf extends ConsumerWidget {
  const _WatchLaterShelf({required this.onSeeAll});

  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final scenes = ref.watch(watchLaterScenesProvider);
    final theme = Theme.of(context);
    final Widget body = switch (scenes) {
      _ when scenes.isReloading => ShelfSkeleton(height: SceneShelf.height(context), itemWidth: 240),
      AsyncError() => const SizedBox.shrink(),
      AsyncValue(:final value?) when value.isEmpty => Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l.watchLaterEmptyHint,
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const WatchLaterDeviceOnlyNote(),
            ],
          ),
        ),
      AsyncValue(:final value?) => SceneShelfRow(
          scenes: value,
          onTap: (i) => ref.read(nowPlayingProvider.notifier).playQueue(value, title: l.libraryWatchLater, start: i),
        ),
      _ => ShelfSkeleton(height: SceneShelf.height(context), itemWidth: 240),
    };
    final count = scenes.value?.length ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShelfHeader(
          title: count > 0 ? '${l.libraryWatchLater} ($count)' : l.libraryWatchLater,
          icon: AppTab.watchLater.icon,
          onSeeAll: count > 0 ? onSeeAll : null,
        ),
        body,
        const Divider(height: AppSpacing.l),
      ],
    );
  }
}

/// A horizontal row of [itemWidth] wide tiles from a paged list's first page,
/// with a heading. Hidden while the list is empty or failed (groups need
/// Stash v0.27+). The row is as tall as its tallest tile, so it fits any
/// text size; [placeholderHeight] is only for the loading placeholder.
class _PagedShelf<T> extends StatelessWidget {
  const _PagedShelf({
    required this.title,
    required this.icon,
    required this.value,
    required this.itemWidth,
    required this.placeholderHeight,
    required this.itemBuilder,
    required this.onSeeAll,
  });

  final String title;
  final IconData icon;
  final AsyncValue<PagedState<T>> value;
  final double itemWidth;
  final double placeholderHeight;
  final Widget Function(T item) itemBuilder;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    final loading = value.current == null && !value.hasError;
    final items = value.current?.items ?? <T>[];
    if (items.isEmpty && !loading) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShelfHeader(title: title, icon: icon, onSeeAll: onSeeAll),
        if (loading)
          ShelfSkeleton(height: placeholderHeight, itemWidth: itemWidth)
        else
          // Only the first page: built at once, unlike a lazy list.
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final (i, item) in items.indexed) ...[
                  if (i > 0) const SizedBox(width: AppSpacing.m),
                  SizedBox(width: itemWidth, child: itemBuilder(item)),
                ],
              ],
            ),
          ),
        const Divider(height: AppSpacing.l),
      ],
    );
  }
}

/// Group posters (2:3) with name and scene count.
class _GroupsShelf extends ConsumerWidget {
  const _GroupsShelf({required this.onSeeAll});

  final VoidCallback onSeeAll;

  static const _width = 120.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) => _PagedShelf(
        title: context.l10n.libraryGroups,
        icon: AppTab.groups.icon,
        value: ref.watch(groupListProvider(YouPage.groups)),
        itemWidth: _width,
        // Poster, gap, two lines of title and the count.
        placeholderHeight: _width * 3 / 2 + 6 + MediaQuery.textScalerOf(context).scale(56),
        itemBuilder: (group) => GroupTile(group: group),
        onSeeAll: onSeeAll,
      );
}

/// The latest markers, as in the markers section.
class _MarkersShelf extends ConsumerWidget {
  const _MarkersShelf({required this.onSeeAll});

  final VoidCallback onSeeAll;

  static const _width = 240.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) => _PagedShelf(
        title: context.l10n.libraryMarkers,
        icon: AppTab.markers.icon,
        value: ref.watch(markerListProvider(YouPage.markers)),
        itemWidth: _width,
        // Frame, gap, title, scene and tag.
        placeholderHeight: _width * 9 / 16 + 6 + MediaQuery.textScalerOf(context).scale(52),
        itemBuilder: (marker) => MarkerTile(marker: marker),
        onSeeAll: onSeeAll,
      );
}
