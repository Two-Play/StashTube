import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';

import '../home/home_page.dart';
import '../library/library_page.dart';
import '../performers/performers_page.dart';
import '../player/player_providers.dart';
import '../player/player_view.dart';
import '../settings/settings_page.dart';
import '../studios/studios_page.dart';
import 'navigation.dart';

/// Root layout after login: per-tab navigators, the miniplayer on top of
/// them and a bottom navigation bar that slides away as the player expands.
class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  static Widget _rootPage(AppTab tab) => switch (tab) {
        AppTab.home => const HomePage(),
        AppTab.performers => const PerformersPage(),
        AppTab.studios => const StudiosPage(),
        AppTab.library => const LibraryPage(),
        AppTab.settings => const SettingsPage(),
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(currentTabProvider);
    final navigatorKeys = ref.watch(tabNavigatorKeysProvider);
    final scene = ref.watch(nowPlayingProvider);
    final playerHeight = ref.watch(miniplayerHeightProvider);
    final maxPlayerHeight = MediaQuery.sizeOf(context).height;

    void selectTab(AppTab tab) {
      if (tab == currentTab) {
        // Re-selecting a tab pops back to its root, like YouTube.
        navigatorKeys[tab]!.currentState?.popUntil((r) => r.isFirst);
      } else {
        HapticFeedback.selectionClick();
        ref.read(currentTabProvider.notifier).state = tab;
      }
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        final navigator = navigatorKeys[currentTab]!.currentState;
        if (navigator != null && navigator.canPop()) {
          navigator.pop();
        } else if (currentTab != AppTab.home) {
          ref.read(currentTabProvider.notifier).state = AppTab.home;
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Padding(
              // Keep the end of every list visible above the collapsed player.
              padding: EdgeInsets.only(bottom: scene == null ? 0 : kMiniPlayerHeight),
              child: IndexedStack(
                index: currentTab.index,
                children: [
                  for (final tab in AppTab.values)
                    Navigator(
                      key: navigatorKeys[tab],
                      onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => _rootPage(tab)),
                    ),
                ],
              ),
            ),
            if (scene != null)
              Miniplayer(
                controller: ref.watch(miniplayerControllerProvider),
                valueNotifier: playerHeight,
                minHeight: kMiniPlayerHeight,
                maxHeight: maxPlayerHeight,
                onDismissed: () => ref.read(nowPlayingProvider.notifier).close(),
                builder: (height, _) => PlayerPanel(scene: scene, height: height, maxHeight: maxPlayerHeight),
              ),
          ],
        ),
        bottomNavigationBar: ValueListenableBuilder<double>(
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
            selectedIndex: currentTab.index,
            onDestinationSelected: (i) => selectTab(AppTab.values[i]),
            destinations: [
              for (final tab in AppTab.values)
                NavigationDestination(
                  icon: Icon(tab.icon),
                  selectedIcon: Icon(tab.selectedIcon),
                  label: tab.label,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
