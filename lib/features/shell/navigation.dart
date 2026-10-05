import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/server_config.dart';

import '../../l10n/l10n.dart';
import '../library/library_page.dart';
import '../performers/performer_page.dart';
import '../player/player_providers.dart';
import '../search/search_page.dart';
import '../studios/studio_page.dart';
import '../tags/tag_page.dart';
import '../tags/tags_page.dart';
import 'nav_bar_config.dart';

/// A destination of the bottom navigation bar. Which ones are shown, and in
/// which order, is configured in the settings ([navBarConfigProvider]).
/// Tabs with a [section] show that part of the library on its own.
enum AppTab {
  home(Icons.home_outlined, Icons.home),
  performers(Icons.people_outline, Icons.people),
  studios(Icons.subscriptions_outlined, Icons.subscriptions),
  library(Icons.video_library_outlined, Icons.video_library),
  scenes(Icons.movie_outlined, Icons.movie, LibrarySection.scenes),
  history(Icons.history, Icons.history, LibrarySection.history),
  watchLater(Icons.watch_later_outlined, Icons.watch_later, LibrarySection.watchLater),
  groups(Icons.playlist_play, Icons.playlist_play, LibrarySection.groups),
  images(Icons.image_outlined, Icons.image, LibrarySection.images),
  galleries(Icons.photo_library_outlined, Icons.photo_library, LibrarySection.galleries),
  stats(Icons.insights_outlined, Icons.insights, LibrarySection.stats),
  tags(Icons.sell_outlined, Icons.sell),
  search(Icons.search, Icons.saved_search),
  settings(Icons.settings_outlined, Icons.settings);

  const AppTab(this.icon, this.selectedIcon, [this.section]);

  final IconData icon;
  final IconData selectedIcon;
  final LibrarySection? section;

  /// Short label under the icon in the bar.
  String label(AppLocalizations l) => switch (this) {
        home => l.tabHome,
        performers => l.tabPerformers,
        studios => l.tabStudios,
        library => l.tabLibrary,
        watchLater => l.tabWatchLater,
        tags => l.tabTags,
        search => l.tabSearch,
        settings => l.tabSettings,
        _ => section!.label(l),
      };

  /// Full name in the settings list.
  String title(AppLocalizations l) => section?.label(l) ?? label(l);
}

/// The selected tab. Starts on the first tab of the bar, and moves there
/// when the selected tab is hidden in the settings.
class CurrentTabNotifier extends Notifier<AppTab> {
  @override
  AppTab build() {
    ref.listen(navBarConfigProvider, (_, config) {
      if (!config.isVisible(state)) state = config.visible.first;
    });
    return ref.read(navBarConfigProvider).visible.first;
  }

  void select(AppTab tab) => state = tab;
}

final currentTabProvider = NotifierProvider<CurrentTabNotifier, AppTab>(CurrentTabNotifier.new);

/// Each tab has its own navigator so pushed pages keep the bottom bar and the
/// miniplayer visible, like YouTube.
///
/// New keys per server: with the same GlobalKeys, the shell rebuilt for a
/// new server would take over the old navigators, including pages opened on
/// the old server (a studio, a performer, ...).
final tabNavigatorKeysProvider = Provider<Map<AppTab, GlobalKey<NavigatorState>>>((ref) {
  final server = ref.watch(activeServerIdProvider);
  return {for (final tab in AppTab.values) tab: GlobalKey<NavigatorState>(debugLabel: '${tab.name}@$server')};
});

/// Pushes [page] onto the current tab. Works from anywhere, including the
/// expanded player (which lives above the tab navigators).
void openPage(WidgetRef ref, Widget page) {
  if (ref.read(nowPlayingProvider) != null) ref.read(nowPlayingProvider.notifier).collapse();
  final navigator = ref.read(tabNavigatorKeysProvider)[ref.read(currentTabProvider)]!.currentState;
  navigator?.push(MaterialPageRoute(builder: (_) => page));
}

void openPerformer(WidgetRef ref, String id) => openPage(ref, PerformerPage(performerId: id));

void openStudio(WidgetRef ref, String id) => openPage(ref, StudioPage(studioId: id));

void openSearch(WidgetRef ref) => openPage(ref, const SearchPage());

void openTag(WidgetRef ref, String id) => openPage(ref, TagPage(tagId: id));

void openTags(WidgetRef ref) => openPage(ref, const TagsPage());
