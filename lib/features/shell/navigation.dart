import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../performers/performer_page.dart';
import '../player/player_providers.dart';
import '../search/search_page.dart';
import '../studios/studio_page.dart';

enum AppTab {
  home('Home', Icons.home_outlined, Icons.home),
  performers('Performers', Icons.people_outline, Icons.people),
  studios('Studios', Icons.subscriptions_outlined, Icons.subscriptions),
  settings('Settings', Icons.settings_outlined, Icons.settings);

  const AppTab(this.label, this.icon, this.selectedIcon);

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

final currentTabProvider = StateProvider<AppTab>((ref) => AppTab.home);

/// Each tab has its own navigator so pushed pages keep the bottom bar and the
/// miniplayer visible, like YouTube.
final tabNavigatorKeysProvider = Provider<Map<AppTab, GlobalKey<NavigatorState>>>(
  (ref) => {for (final tab in AppTab.values) tab: GlobalKey<NavigatorState>(debugLabel: tab.name)},
);

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
