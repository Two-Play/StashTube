import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/server_config.dart';

/// Recent search terms (5.3), most recent first, stored on the device.
class SearchHistoryNotifier extends Notifier<List<String>> {
  static const _key = 'search_history';
  static const maxEntries = 20;

  String? get _serverKey {
    final server = ref.read(activeServerIdProvider);
    return server == null ? null : '$_key:$server';
  }

  @override
  List<String> build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    ref.watch(activeServerIdProvider);
    final key = _serverKey;
    if (key == null) return const [];
    // Lists of the single-server versions are moved to the first server
    // (ServerProfilesNotifier).
    return prefs.getStringList(key) ?? const [];
  }

  Future<void> add(String term) async {
    final t = term.trim();
    if (t.isEmpty) return;
    // Case-insensitive de-duplication; the newest spelling wins.
    final next = [t, ...state.where((e) => e.toLowerCase() != t.toLowerCase())].take(maxEntries).toList();
    await _save(next);
  }

  Future<void> remove(String term) => _save(state.where((e) => e != term).toList());

  Future<void> clear() => _save(const []);

  Future<void> _save(List<String> terms) async {
    state = terms;
    final key = _serverKey;
    if (key != null) await ref.read(sharedPreferencesProvider).setStringList(key, terms);
  }
}

final searchHistoryProvider = NotifierProvider<SearchHistoryNotifier, List<String>>(SearchHistoryNotifier.new);
