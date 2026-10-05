import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/server_config.dart';

import '../performers/performer_page.dart';
import '../player/player_providers.dart';
import '../search/search_page.dart';
import '../studios/studio_page.dart';
import '../tags/tag_page.dart';
import '../tags/tags_page.dart';
import 'nav_bar_config.dart';

enum AppTab {
  home('Home', Icons.home_outlined, Icons.home),
  performers('Performers', Icons.people_outline, Icons.people),
  studios('Studios', Icons.subscriptions_outlined, Icons.subscriptions),
  library('Library', Icons.video_library_outlined, Icons.video_library),
  tags('Tags', Icons.sell_outlined, Icons.sell),
  search('Search', Icons.search, Icons.saved_search),
  watchLater('Later', Icons.watch_later_outlined, Icons.watch_later),
  settings('Settings', Icons.settings_outlined, Icons.settings);

  const AppTab(this.label, this.icon, this.selectedIcon);

  final String label;
  final IconData icon;
  final IconData selectedIcon;
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
