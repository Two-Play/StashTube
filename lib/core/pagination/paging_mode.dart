import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/server_config.dart';

/// How the paged lists load further items: by scrolling to the end, or as
/// numbered pages with a page bar at the end.
enum PagingMode { infinite, pages }

/// Chosen in the settings, stored for all servers.
class PagingModeNotifier extends Notifier<PagingMode> {
  static const _key = 'paging_mode';

  @override
  PagingMode build() {
    final SharedPreferences prefs;
    try {
      prefs = ref.watch(sharedPreferencesProvider);
    } catch (_) {
      // Tests of single lists don't provide preferences.
      return PagingMode.infinite;
    }
    return PagingMode.values.asNameMap()[prefs.getString(_key)] ?? PagingMode.infinite;
  }

  Future<void> set(PagingMode mode) async {
    state = mode;
    await ref.read(sharedPreferencesProvider).setString(_key, mode.name);
  }
}

final pagingModeProvider = NotifierProvider<PagingModeNotifier, PagingMode>(PagingModeNotifier.new);
