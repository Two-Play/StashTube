import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../widgets/sliver_columns.dart';
import '../player/closing_slide.dart';
import '../player/player_providers.dart' show kMiniPlayerHeight;

/// From this width the navigation rail shows its labels beside the icons
/// (Material 3's "expanded" window class and up).
const double kExtendedRailBreakpoint = 1240;

/// How the shell offers its tabs (NAV-4, Material 3 adaptive navigation).
enum ShellNavigation {
  /// Bottom navigation bar: phones in portrait (below
  /// [kWideLayoutBreakpoint]).
  bar,

  /// Navigation rail on the left with labels under the icons: tablets and
  /// phones in landscape, where a bottom bar would take scarce height.
  rail,

  /// The rail with labels beside the icons, on large windows.
  extendedRail;

  static ShellNavigation forWidth(double width) => width >= kExtendedRailBreakpoint
      ? extendedRail
      : width >= kWideLayoutBreakpoint
          ? rail
          : bar;

  bool get isRail => this != bar;

  /// The rail's width without the safe area beside it.
  double get railWidth => switch (this) {
        bar => 0,
        rail => ShellNavigationRail.width,
        extendedRail => ShellNavigationRail.extendedWidth,
      };
}

/// One tab in the bar or rail.
typedef ShellDestination = ({IconData icon, IconData selectedIcon, String label});

/// The shell's layout: the tab content, the miniplayer above it and the
/// navigation ([ShellNavigation]) for the window's width.
///
/// * Narrow windows: the bottom bar, which shrinks away as the player
///   expands (as before NAV-4).
/// * From [kWideLayoutBreakpoint]: a rail on the left. The content sits
///   right of it, the collapsed miniplayer at the bottom of the content.
///   While expanding, the panel's left edge slides over the rail, so the
///   expanded player covers the whole window like it covers the bar, and the
///   content never changes its size meanwhile.
///
/// [hideNavigation] (the shorts' fullscreen) hides the bar or the rail.
class ShellLayout extends StatelessWidget {
  const ShellLayout({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onSelect,
    required this.content,
    required this.playerHeight,
    this.miniplayer,
    this.hidePlayer = false,
    this.closing = false,
    this.onClosed,
    this.hideNavigation = false,
  });

  final List<ShellDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  /// The tab navigators (with the connection banner above them).
  final Widget content;

  /// The miniplayer's current height ([miniplayerHeightProvider]).
  final ValueListenable<double> playerHeight;

  /// The miniplayer, built for the window's full height; null while nothing
  /// plays.
  final Widget? miniplayer;

  /// Keeps the miniplayer in the tree but hidden (the shorts).
  final bool hidePlayer;

  /// The miniplayer slides away ([ClosingSlide]), then [onClosed] is called.
  final bool closing;
  final VoidCallback? onClosed;
  final bool hideNavigation;

  @override
  Widget build(BuildContext context) {
    final navigation = ShellNavigation.forWidth(MediaQuery.sizeOf(context).width);
    final maxPlayerHeight = MediaQuery.sizeOf(context).height;
    final showBar = navigation == ShellNavigation.bar && !hideNavigation;
    final showRail = navigation.isRail && !hideNavigation;

    /// 0 = collapsed (or no player), 1 = the player fills the window.
    double expandedAt(double height) => miniplayer == null || maxPlayerHeight <= kMiniPlayerHeight
        ? 0.0
        : ((height - kMiniPlayerHeight) / (maxPlayerHeight - kMiniPlayerHeight)).clamp(0.0, 1.0);

    return Scaffold(
      body: Builder(builder: (context) {
        final media = MediaQuery.of(context);
        final ltr = Directionality.of(context) == TextDirection.ltr;
        // The rail takes the safe area on its side (a notch in landscape).
        final railWidth = showRail ? navigation.railWidth + (ltr ? media.padding.left : media.padding.right) : 0.0;
        // Without a bottom bar the collapsed player keeps clear of the home
        // indicator; a strip in its color fills the space below it.
        final bottomInset = showRail ? media.padding.bottom : 0.0;
        final playerShown = miniplayer != null && !hidePlayer && !closing;
        return Stack(
          children: [
            Row(
              children: [
                if (showRail)
                  SizedBox(
                    width: railWidth,
                    child: ShellNavigationRail(
                      destinations: destinations,
                      selectedIndex: selectedIndex,
                      onSelect: onSelect,
                      extended: navigation == ShellNavigation.extendedRail,
                    ),
                  ),
                Expanded(
                  child: AnimatedPadding(
                    // Keep the end of every list visible above the collapsed
                    // player. Shrinks along with the closing slide, so no empty
                    // strip shows where the bar was.
                    padding: EdgeInsets.only(bottom: playerShown ? kMiniPlayerHeight + bottomInset : 0),
                    duration: ClosingSlide.defaultDuration,
                    curve: ClosingSlide.curve,
                    // The rail took the safe area on its side; below the
                    // player the padding takes the home indicator's.
                    child: MediaQuery.removePadding(
                      context: context,
                      removeLeft: showRail && ltr,
                      removeRight: showRail && !ltr,
                      removeBottom: showRail && playerShown,
                      child: content,
                    ),
                  ),
                ),
              ],
            ),
            if (miniplayer != null)
              Positioned.fill(
                child: Offstage(
                  offstage: hidePlayer,
                  child: ValueListenableBuilder<double>(
                    valueListenable: playerHeight,
                    builder: (context, height, child) {
                      final open = 1 - expandedAt(height);
                      final inset = railWidth * open;
                      final strip = bottomInset * open;
                      // The panel lays itself out by the screen's width: here
                      // the space right of the (covered part of the) rail.
                      final data = inset == 0
                          ? media
                          : media.copyWith(
                              size: Size(media.size.width - inset, media.size.height),
                              padding: ltr
                                  ? media.padding.copyWith(left: math.max(0.0, media.padding.left - inset))
                                  : media.padding.copyWith(right: math.max(0.0, media.padding.right - inset)),
                              viewPadding: ltr
                                  ? media.viewPadding.copyWith(left: math.max(0.0, media.viewPadding.left - inset))
                                  : media.viewPadding.copyWith(right: math.max(0.0, media.viewPadding.right - inset)),
                            );
                      return Padding(
                        padding: EdgeInsetsDirectional.only(start: inset),
                        child: MediaQuery(
                          data: data,
                          child: ClosingSlide(
                            closing: closing,
                            distance: kMiniPlayerHeight + strip,
                            onClosed: () => onClosed?.call(),
                            child: Column(
                              children: [
                                Expanded(child: child!),
                                SizedBox(
                                  height: strip,
                                  width: double.infinity,
                                  child: ColoredBox(color: Theme.of(context).colorScheme.surfaceContainer),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: miniplayer,
                  ),
                ),
              ),
          ],
        );
      }),
      bottomNavigationBar: !showBar
          ? null
          : ValueListenableBuilder<double>(
              valueListenable: playerHeight,
              builder: (context, height, child) => ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: 1 - expandedAt(height),
                  child: child,
                ),
              ),
              child: NavigationBar(
                selectedIndex: selectedIndex,
                onDestinationSelected: onSelect,
                destinations: [
                  for (final d in destinations)
                    NavigationDestination(icon: Icon(d.icon), selectedIcon: Icon(d.selectedIcon), label: d.label),
                ],
              ),
            ),
    );
  }
}

/// Material 3's navigation rail for the shell's tabs, with labels under the
/// icons, or beside them when [extended].
class ShellNavigationRail extends StatelessWidget {
  const ShellNavigationRail({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onSelect,
    this.extended = false,
  });

  /// Material 3's rail width.
  static const double width = 80;
  static const double extendedWidth = 240;

  /// Like [NavigationBar], labels grow with the text size only up to this
  /// factor; a label still too wide shrinks to fit.
  static const double maxTextScale = 1.3;

  final List<ShellDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final bool extended;

  @override
  Widget build(BuildContext context) {
    // On a phone in landscape the destinations sit in the middle, in reach
    // of the thumbs; on tablets at the top, as Material suggests.
    final short = MediaQuery.sizeOf(context).height < kWideLayoutBreakpoint;
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: maxTextScale,
      child: NavigationRail(
        extended: extended,
        minWidth: width,
        minExtendedWidth: extendedWidth,
        labelType: extended ? NavigationRailLabelType.none : NavigationRailLabelType.all,
        groupAlignment: short ? 0 : -1,
        // Five destinations need more height than a phone in landscape has.
        scrollable: true,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        selectedIndex: selectedIndex,
        onDestinationSelected: onSelect,
        destinations: [
          for (final d in destinations)
            NavigationRailDestination(
              icon: Icon(d.icon),
              selectedIcon: Icon(d.selectedIcon),
              label: extended
                  ? ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: extendedWidth - width - 16),
                      child: Text(d.label, maxLines: 1, overflow: TextOverflow.ellipsis),
                    )
                  : FittedBox(fit: BoxFit.scaleDown, child: Text(d.label, maxLines: 1)),
            ),
        ],
      ),
    );
  }
}
