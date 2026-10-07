import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';

import '../../l10n/l10n.dart';
import '../home/home_page.dart';
import '../library/library_page.dart';
import '../performers/performers_page.dart';
import '../player/closing_slide.dart';
import '../player/player_providers.dart';
import '../player/player_view.dart';
import '../shorts/shorts_page.dart';
import '../search/search_page.dart';
import '../studios/studios_page.dart';
import '../tags/tags_page.dart';
import 'all_views_page.dart';
import 'nav_bar_config.dart';
import 'navigation.dart';

/// Root layout after login: per-tab navigators, the miniplayer on top of
/// them and a bottom navigation bar that slides away as the player expands.
class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  /// The page a tab starts with; also opened from the "all views" menu.
  static Widget rootPage(AppTab tab) => switch (tab) {
        AppTab(:final section?) => LibrarySectionPage(section: section),
        AppTab.home => const HomePage(),
        AppTab.all => const AllViewsPage(),
        AppTab.shorts => const ShortsPage(),
        AppTab.performers => const PerformersPage(),
        AppTab.studios => const StudiosPage(),
        AppTab.library => const LibraryPage(),
        AppTab.tags => const TagsPage(),
        AppTab.search => const SearchPage(autofocus: false),
        _ => throw StateError('No page for $tab'),
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(currentTabProvider);
    final tabs = ref.watch(navBarConfigProvider).visible;
    final navigatorKeys = ref.watch(tabNavigatorKeysProvider);
    final scene = ref.watch(nowPlayingProvider);
    // No miniplayer in the shorts (they pause the main player meanwhile).
    final hidePlayer = ref.watch(shortsActiveProvider);
    final hideNavBar = ref.watch(shortsFullscreenProvider);
    final playerHeight = ref.watch(miniplayerHeightProvider);
    final maxPlayerHeight = MediaQuery.sizeOf(context).height;

    void selectTab(AppTab tab) {
      if (tab == currentTab) {
        // Re-selecting a tab pops back to its root, like YouTube.
        navigatorKeys[tab]!.currentState?.popUntil((r) => r.isFirst);
      } else {
        HapticFeedback.selectionClick();
        ref.read(currentTabProvider.notifier).select(tab);
      }
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        final navigator = navigatorKeys[currentTab]!.currentState;
        if (navigator != null && navigator.canPop()) {
          navigator.pop();
        } else if (currentTab != tabs.first) {
          ref.read(currentTabProvider.notifier).select(tabs.first);
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Padding(
              // Keep the end of every list visible above the collapsed player.
              padding: EdgeInsets.only(bottom: scene == null || hidePlayer ? 0 : kMiniPlayerHeight),
              // Only the tabs in the bar; the GlobalKeys keep each navigator's
              // pages when the tabs are reordered.
              child: IndexedStack(
                index: tabs.indexOf(currentTab).clamp(0, tabs.length - 1),
                children: [
                  for (final tab in tabs)
                    Navigator(
                      key: navigatorKeys[tab],
                      onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => rootPage(tab)),
                    ),
                ],
              ),
            ),
            if (scene != null)
              Offstage(
                offstage: hidePlayer,
                child: ClosingSlide(
                  closing: ref.watch(playerClosingProvider),
                  distance: kMiniPlayerHeight,
                  onClosed: () => ref.read(nowPlayingProvider.notifier).close(),
                  child: Miniplayer(
                    controller: ref.watch(miniplayerControllerProvider),
                    valueNotifier: playerHeight,
                    minHeight: kMiniPlayerHeight,
                    maxHeight: maxPlayerHeight,
                    onDismissed: () => ref.read(nowPlayingProvider.notifier).close(),
                    builder: (height, _) => PlayerPanel(scene: scene, height: height, maxHeight: maxPlayerHeight),
                  ),
                ),
              ),
          ],
        ),
        bottomNavigationBar: hideNavBar
            ? null
            : ValueListenableBuilder<double>(
                valueListenable: playerHeight,
                builder: (context, height, child) {
                  final expanded = scene == null
                      ? 0.0
                      : ((height - kMiniPlayerHeight) / (maxPlayerHeight - kMiniPlayerHeight)).clamp(0.0, 1.0);
                  return ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      heightFactor: 1 - expanded,
                      child: child,
                    ),
                  );
                },
                child: NavigationBar(
                  selectedIndex: tabs.indexOf(currentTab).clamp(0, tabs.length - 1),
                  onDestinationSelected: (i) => selectTab(tabs[i]),
                  destinations: [
                    for (final tab in tabs)
                      NavigationDestination(
                        icon: Icon(tab.icon),
                        selectedIcon: Icon(tab.selectedIcon),
                        label: tab.label(context.l10n),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
