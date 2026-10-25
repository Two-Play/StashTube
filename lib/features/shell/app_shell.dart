import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/haptics.dart';
import '../../l10n/l10n.dart';
import '../../widgets/connection_banner.dart';
import '../home/home_page.dart';
import '../library/library_page.dart';
import '../performers/performers_page.dart';
import '../player/player_providers.dart';
import '../player/player_view.dart';
import '../player/sliding_panel.dart';
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
  const AppShell({super.key, @visibleForTesting this.pageBuilder, @visibleForTesting this.panelBuilder});

  /// Replaces [rootPage] in tests.
  final Widget Function(AppTab tab)? pageBuilder;

  /// Replaces the [PlayerPanel] in tests (it needs the native player).
  final Widget Function(double height)? panelBuilder;

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
        // Back first collapses the expanded player.
        if (scene != null && !hidePlayer && playerHeight.value > kMiniPlayerHeight) {
          ref.read(nowPlayingProvider.notifier).collapse();
          return;
        }
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
                    _TabTickers(
                      shown: tab == tabs[selected],
                      playerHeight: playerHeight,
                      maxPlayerHeight: maxPlayerHeight,
                      child: Navigator(
                        key: navigatorKeys[tab],
                        onGenerateRoute: (_) => MaterialPageRoute(
                          builder: (_) => PrimaryScrollController(
                            controller: scrollControllers[tab]!,
                            child: (pageBuilder ?? rootPage)(tab),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            miniplayer: scene == null
                ? null
                : SlidingPanel(
                    controller: ref.watch(miniplayerControllerProvider),
                    height: playerHeight,
                    minHeight: kMiniPlayerHeight,
                    maxHeight: maxPlayerHeight,
                    onDismissed: () => ref.read(nowPlayingProvider.notifier).close(),
                    builder: (_, height) =>
                        panelBuilder?.call(height) ??
                        PlayerPanel(scene: scene, height: height, maxHeight: maxPlayerHeight),
                  ),
          ),
        ),
      ),
    );
  }
}

/// Stops a tab's animations (shimmers, animated previews, spinners) while
/// nobody sees it: [IndexedStack] keeps hidden tabs ticking, which cost
/// frames in the shorts and behind the expanded player.
class _TabTickers extends StatefulWidget {
  const _TabTickers({
    required this.shown,
    required this.playerHeight,
    required this.maxPlayerHeight,
    required this.child,
  });

  /// The selected tab.
  final bool shown;
  final ValueListenable<double> playerHeight;
  final double maxPlayerHeight;
  final Widget child;

  @override
  State<_TabTickers> createState() => _TabTickersState();
}

class _TabTickersState extends State<_TabTickers> {
  late bool _covered = _isCovered;

  bool get _isCovered => widget.playerHeight.value >= widget.maxPlayerHeight - 0.5;

  @override
  void initState() {
    super.initState();
    widget.playerHeight.addListener(_onPlayerHeight);
  }

  @override
  void didUpdateWidget(_TabTickers oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.playerHeight != widget.playerHeight) {
      oldWidget.playerHeight.removeListener(_onPlayerHeight);
      widget.playerHeight.addListener(_onPlayerHeight);
    }
    _covered = _isCovered;
  }

  @override
  void dispose() {
    widget.playerHeight.removeListener(_onPlayerHeight);
    super.dispose();
  }

  // Only a change of covered/uncovered rebuilds, not every frame of the
  // player's transition.
  void _onPlayerHeight() {
    if (_isCovered != _covered) setState(() => _covered = _isCovered);
  }

  @override
  Widget build(BuildContext context) => TickerMode(enabled: widget.shown && !_covered, child: widget.child);
}
