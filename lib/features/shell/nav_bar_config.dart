import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/server_config.dart';
import 'navigation.dart';

/// Which tabs the bottom navigation bar shows, and in which order (13.7).
///
/// [order] contains every [AppTab] exactly once, so a tab that is shown
/// again comes back at the place the user gave it. Settings can't be
/// hidden, otherwise the configuration couldn't be undone.
@immutable
class NavBarConfig {
  NavBarConfig({required List<AppTab> order, Set<AppTab> hidden = const {}})
      : order = List.unmodifiable(_complete(order)),
        hidden = Set.unmodifiable(hidden.difference({AppTab.settings}));

  /// The bar as it ships: the tabs the app had before 13.7.
  static final standard = NavBarConfig(
    order: AppTab.values,
    hidden: {
      for (final tab in AppTab.values)
        if (tab.section != null || tab == AppTab.tags || tab == AppTab.search || tab == AppTab.shorts) tab,
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
    if (tab == AppTab.settings) return false;
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
    final order = prefs.getStringList(_orderKey);
    final hidden = prefs.getStringList(_hiddenKey);
    if (order == null || hidden == null) return NavBarConfig.standard;
    final known = _parse(order);
    // Tabs added in an update start hidden, so the user's bar stays as it was.
    final added = AppTab.values.where((tab) => !known.contains(tab));
    final config = NavBarConfig(order: known, hidden: {..._parse(hidden), ...added});
    // A config that no longer fits the rules (e.g. edited by hand) falls back.
    final count = config.visible.length;
    return count < NavBarConfig.minVisible || count > NavBarConfig.maxVisible ? NavBarConfig.standard : config;
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
