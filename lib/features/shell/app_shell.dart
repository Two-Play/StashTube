import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';

import '../../core/config/haptics.dart';
import '../../l10n/l10n.dart';
import '../../widgets/connection_banner.dart';
import '../home/home_page.dart';
import '../library/library_page.dart';
import '../performers/performers_page.dart';
import '../player/player_providers.dart';
import '../player/player_view.dart';
import '../shorts/shorts_page.dart';
import '../search/search_page.dart';
import '../server_tasks/server_tasks_page.dart';
import '../settings/theme_welcome.dart';
import '../studios/studios_page.dart';
import '../subscriptions/last_visit.dart';
import '../subscriptions/subscriptions_page.dart';
import '../tags/tags_page.dart';
import '../you/you_page.dart';
import 'nav_bar_config.dart';
import 'navigation.dart';
import 'shell_layout.dart';

/// Root layout after login: per-tab navigators, the miniplayer on top of
/// them and a bottom navigation bar that slides away as the player expands,
/// or a navigation rail on wide windows ([ShellLayout], NAV-4).
class AppShell extends ConsumerWidget {
  const AppShell({super.key, @visibleForTesting this.pageBuilder});

  /// Replaces [rootPage] in tests.
  final Widget Function(AppTab tab)? pageBuilder;

  /// The page a tab starts with; also opened from the "You" page.
  static Widget rootPage(AppTab tab) => switch (tab) {
        AppTab(:final section?) => LibrarySectionPage(section: section),
        AppTab.home => const HomePage(),
        AppTab.you => const YouPage(),
        AppTab.shorts => const ShortsPage(),
        AppTab.performers => const PerformersPage(),
        AppTab.studios => const StudiosPage(),
        AppTab.subscriptions => const SubscriptionsPage(),
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
    final closing = ref.watch(playerClosingProvider);
    final playerHeight = ref.watch(miniplayerHeightProvider);
    final maxPlayerHeight = MediaQuery.sizeOf(context).height;
    // After the first login: pick a theme (once).
    if (ref.watch(themeWelcomeProvider)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) showThemeWelcomeIfPending(context, ref);
      });
    }

    final scrollControllers = ref.watch(tabScrollControllersProvider);
    final selected = tabs.indexOf(currentTab).clamp(0, tabs.length - 1);

    void selectTab(AppTab tab) {
      if (tab == currentTab) {
        reselectTab(navigatorKeys[tab]!.currentState, scrollControllers[tab]!);
        Haptics.selection();
      } else {
        Haptics.selection();
        ref.read(currentTabProvider.notifier).select(tab);
      }
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        final navigator = navigatorKeys[currentTab]!.currentState;
        if (navigator != null && navigator.canPop()) {
          // maybePop: a page may ask to stay (e.g. while it saves).
          navigator.maybePop();
        } else if (currentTab != tabs.first) {
          ref.read(currentTabProvider.notifier).select(tabs.first);
        } else {
          SystemNavigator.pop();
        }
      },
      // The end of a visit (NOTIF-1) and finished server tasks.
      child: LastVisitRecorder(
        child: JobFinishedListener(
          child: ShellLayout(
            destinations: [
              for (final tab in tabs) (icon: tab.icon, selectedIcon: tab.selectedIcon, label: tab.label(context.l10n)),
            ],
            selectedIndex: selected,
            onSelect: (i) => selectTab(tabs[i]),
            playerHeight: playerHeight,
            hidePlayer: hidePlayer,
            hideNavigation: hideNavBar,
            closing: closing,
            onClosed: () => ref.read(nowPlayingProvider.notifier).close(),
            // The connection banner (STATE-1) sits above the tabs, below the
            // player, which covers it when expanded.
            content: ConnectionBannerScope(
              // Only the tabs in the bar; the GlobalKeys keep each navigator's
              // pages when the tabs are reordered.
              child: IndexedStack(
                index: selected,
                children: [
                  for (final tab in tabs)
                    Navigator(
                      key: navigatorKeys[tab],
                      onGenerateRoute: (_) => MaterialPageRoute(
                        builder: (_) => PrimaryScrollController(
                          controller: scrollControllers[tab]!,
                          child: (pageBuilder ?? rootPage)(tab),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            miniplayer: scene == null
                ? null
                : Miniplayer(
                    controller: ref.watch(miniplayerControllerProvider),
                    valueNotifier: playerHeight,
                    minHeight: kMiniPlayerHeight,
                    maxHeight: maxPlayerHeight,
                    onDismissed: () => ref.read(nowPlayingProvider.notifier).close(),
                    builder: (height, _) => PlayerPanel(scene: scene, height: height, maxHeight: maxPlayerHeight),
                  ),
          ),
        ),
      ),
    );
  }
}
