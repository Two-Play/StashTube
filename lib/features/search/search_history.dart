import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/server_config.dart';

/// Recent search terms (5.3), most recent first, stored on the device.
class SearchHistoryNotifier extends Notifier<List<String>> {
  static const _key = 'search_history';
  static const maxEntries = 20;

  @override
  List<String> build() => ref.watch(sharedPreferencesProvider).getStringList(_key) ?? const [];

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
    await ref.read(sharedPreferencesProvider).setStringList(_key, terms);
  }
}

final searchHistoryProvider = NotifierProvider<SearchHistoryNotifier, List<String>>(SearchHistoryNotifier.new);
