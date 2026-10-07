import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/server_config.dart';
import 'navigation.dart';

/// Which tabs the bottom navigation bar shows, and in which order (13.7).
///
/// [order] contains every [AppTab] exactly once, so a tab that is shown
/// again comes back at the place the user gave it. [alwaysShown] ("all
/// views") can't be hidden.
@immutable
class NavBarConfig {
  NavBarConfig({required List<AppTab> order, Set<AppTab> hidden = const {}})
      : order = List.unmodifiable(_complete(order)),
        hidden = Set.unmodifiable(hidden.difference({alwaysShown}));

  static const alwaysShown = AppTab.all;

  /// The bar as it ships: home, performers, library, stats and "all views",
  /// which has everything else.
  static final standard = NavBarConfig(
    order: AppTab.values,
    hidden: {
      for (final tab in AppTab.values)
        if (tab != alwaysShown &&
            tab != AppTab.stats &&
            (tab.section != null ||
                tab == AppTab.studios ||
                tab == AppTab.tags ||
                tab == AppTab.search ||
                tab == AppTab.shorts))
          tab,
    },
  );

  /// Material's navigation bar is meant for 3 to 5 destinations.
  static const maxVisible = 5;
  static const minVisible = 2;

  final List<AppTab> order;
  final Set<AppTab> hidden;

  List<AppTab> get visible => [for (final tab in order) if (!hidden.contains(tab)) tab];

  bool isVisible(AppTab tab) => !hidden.contains(tab);

  /// Whether the user may switch [tab] on or off right now.
  bool canToggle(AppTab tab) {
    if (tab == alwaysShown) return false;
    final count = visible.length;
    return isVisible(tab) ? count > minVisible : count < maxVisible;
  }

  NavBarConfig toggle(AppTab tab) {
    if (!canToggle(tab)) return this;
    return NavBarConfig(
      order: order,
      hidden: isVisible(tab) ? {...hidden, tab} : hidden.difference({tab}),
    );
  }

  /// Hides the last visible tabs (except [alwaysShown]) beyond [maxVisible],
  /// e.g. for a bar stored before "all views" was added.
  NavBarConfig fitted() {
    final extra = visible.length - maxVisible;
    if (extra <= 0) return this;
    final drop = visible.reversed.where((tab) => tab != alwaysShown).take(extra);
    return NavBarConfig(order: order, hidden: {...hidden, ...drop});
  }

  /// Moves the tab at [from] so it ends up at index [to] (as
  /// `ReorderableListView.onReorderItem` reports it).
  NavBarConfig move(int from, int to) {
    final next = [...order];
    next.insert(to, next.removeAt(from));
    return NavBarConfig(order: next, hidden: hidden);
  }

  /// Appends tabs missing from a stored order (e.g. added in an update) and
  /// drops duplicates.
  static List<AppTab> _complete(List<AppTab> order) => {...order, ...AppTab.values}.toList();

  @override
  bool operator ==(Object other) =>
      other is NavBarConfig && listEquals(other.order, order) && setEquals(other.hidden, hidden);

  @override
  int get hashCode => Object.hash(Object.hashAll(order), Object.hashAllUnordered(hidden));
}

/// Stored on the device for all servers.
class NavBarConfigNotifier extends Notifier<NavBarConfig> {
  static const _orderKey = 'nav_bar_order';
  static const _hiddenKey = 'nav_bar_hidden';

  @override
  NavBarConfig build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    var order = prefs.getStringList(_orderKey);
    var hidden = prefs.getStringList(_hiddenKey);
    if (order == null || hidden == null) return NavBarConfig.standard;
    // The settings tab moved to the app bars: stats takes its place.
    if (order.contains('settings')) {
      order = [
        for (final name in order)
          if (name == 'settings') AppTab.stats.name else if (name != AppTab.stats.name) name,
      ];
      hidden = hidden.where((name) => name != 'settings' && name != AppTab.stats.name).toList();
    }
    final known = _parse(order);
    // Tabs added in an update start hidden, so the user's bar stays as it was.
    final added = AppTab.values.where((tab) => !known.contains(tab));
    final config = NavBarConfig(order: known, hidden: {..._parse(hidden), ...added}).fitted();
    // A config that no longer fits the rules (e.g. edited by hand) falls back.
    return config.visible.length < NavBarConfig.minVisible ? NavBarConfig.standard : config;
  }

  static List<AppTab> _parse(List<String> names) => [
        for (final name in names) ?AppTab.values.asNameMap()[name],
      ];

  Future<void> toggle(AppTab tab) => _save(state.toggle(tab));

  Future<void> move(int from, int to) => _save(state.move(from, to));

  Future<void> reset() async {
    state = NavBarConfig.standard;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.remove(_orderKey);
    await prefs.remove(_hiddenKey);
  }

  Future<void> _save(NavBarConfig config) async {
    if (config == state) return;
    state = config;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setStringList(_orderKey, [for (final tab in config.order) tab.name]);
    await prefs.setStringList(_hiddenKey, [for (final tab in config.hidden) tab.name]);
  }
}

final navBarConfigProvider = NotifierProvider<NavBarConfigNotifier, NavBarConfig>(NavBarConfigNotifier.new);
