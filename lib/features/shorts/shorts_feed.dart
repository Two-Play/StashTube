import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/list_queries.dart';
import '../../data/models/scene.dart';
import '../../data/repositories/stash_repository.dart';
import 'shorts_settings.dart';

/// Interleaves two shuffled sources: [preferredRun] videos with the chosen
/// tags, then one other video. Skips videos already shown, and when one
/// source runs out it continues with the other.
///
/// Free of Riverpod so the mixing can be unit tested.
class ShortsMixer {
  ShortsMixer({required this.hasPreferred, required this.hasOthers, this.preferredRun = 3})
      : preferredDone = !hasPreferred,
        othersDone = !hasOthers;

  final bool hasPreferred;
  final bool hasOthers;
  final int preferredRun;

  final _preferred = Queue<Scene>();
  final _others = Queue<Scene>();
  final _seen = <String>{};
  int _taken = 0;

  bool preferredDone;
  bool othersDone;

  /// Whether a source should load its next page: it is low and has more.
  bool get needsPreferred => !preferredDone && _preferred.length < preferredRun * 2;
  bool get needsOthers => !othersDone && _others.length < 2;

  bool get isExhausted => preferredDone && othersDone && _preferred.isEmpty && _others.isEmpty;

  void addPreferred(Iterable<Scene> scenes) => _preferred.addAll(scenes);

  void addOthers(Iterable<Scene> scenes) => _others.addAll(scenes);

  /// Up to [count] new videos. Stops early when the source whose turn it is
  /// is empty but not done, so the pattern keeps up after the next load.
  List<Scene> take(int count) {
    final result = <Scene>[];
    while (result.length < count) {
      final preferredTurn = _taken % (preferredRun + 1) < preferredRun;
      final first = preferredTurn ? _preferred : _others;
      final firstDone = preferredTurn ? preferredDone : othersDone;
      final second = preferredTurn ? _others : _preferred;
      final scene = _next(first) ?? (firstDone ? _next(second) : null);
      if (scene == null) break;
      result.add(scene);
      _taken++;
    }
    return result;
  }

  Scene? _next(Queue<Scene> queue) {
    while (queue.isNotEmpty) {
      final scene = queue.removeFirst();
      if (_seen.add(scene.id)) return scene;
    }
    return null;
  }
}

@immutable
class ShortsFeedState {
  const ShortsFeedState({this.items = const [], this.isLoading = false, this.error, this.hasMore = true});

  final List<Scene> items;
  final bool isLoading;
  final Object? error;
  final bool hasMore;

  ShortsFeedState copyWith({List<Scene>? items, bool? isLoading, Object? error, bool? hasMore}) => ShortsFeedState(
        items: items ?? this.items,
        isLoading: isLoading ?? this.isLoading,
        error: error,
        hasMore: hasMore ?? this.hasMore,
      );
}

/// Where a shorts feed comes from: the mixed feed of the shorts tab, or one
/// performer's short videos (their channel's "Shorts" button).
@immutable
class ShortsSource {
  const ShortsSource.feed()
      : performerId = null,
        title = null,
        lane = null;

  const ShortsSource.performer(String this.performerId, {this.title}) : lane = null;

  /// One of the home shelf's queues: mixed like the feed, but shuffled on
  /// its own, so every tile continues differently.
  const ShortsSource.lane(int this.lane)
      : performerId = null,
        title = null;

  final String? performerId;

  /// Which of the home shelf's queues (0–3).
  final int? lane;

  /// Shown in the top bar, e.g. the performer's name.
  final String? title;

  bool get isFeed => performerId == null && lane == null;

  @override
  bool operator ==(Object other) => other is ShortsSource && other.performerId == performerId && other.lane == lane;

  @override
  int get hashCode => Object.hash(performerId, lane);
}

/// Endless, shuffled feed of shorts built from [shortsSettingsProvider]:
/// the length and orientation always apply, the preferred tags only to the
/// mixed feed. Rebuilding (settings change, server switch, [refresh])
/// reshuffles.
class ShortsFeedNotifier extends Notifier<ShortsFeedState> {
  ShortsFeedNotifier(this.source);

  final ShortsSource source;

  static const _pageSize = 24;

  late ShortsMixer _mixer;
  late SceneQuery? _preferredQuery;
  late SceneQuery? _othersQuery;
  int _preferredPage = 0;
  int _othersPage = 0;

  /// Bumped on every build, so loads of a previous build are dropped.
  int _generation = 0;
  bool _loading = false;

  @override
  ShortsFeedState build() {
    final settings = ref.watch(shortsSettingsProvider);
    ref.watch(stashRepositoryProvider);
    final performerId = source.performerId;
    if (performerId != null) {
      _preferredQuery = null;
      _othersQuery = SceneQuery(sort: SceneSort.random, performerId: performerId, filter: settings.baseFilter);
    } else {
      final tagFilter = settings.tagFilter;
      _preferredQuery = tagFilter == null ? null : SceneQuery(sort: SceneSort.random, filter: tagFilter);
      _othersQuery = settings.mixesOthers ? SceneQuery(sort: SceneSort.random, filter: settings.baseFilter) : null;
    }
    _mixer = ShortsMixer(hasPreferred: _preferredQuery != null, hasOthers: _othersQuery != null);
    _preferredPage = 0;
    _othersPage = 0;
    _loading = false;
    final generation = ++_generation;
    Future.microtask(() {
      if (ref.mounted && generation == _generation) loadMore();
    });
    return const ShortsFeedState(isLoading: true);
  }

  void refresh() => ref.invalidateSelf();

  Future<void> loadMore() async {
    final generation = _generation;
    if (_loading || !state.hasMore) return;
    _loading = true;
    state = state.copyWith(isLoading: true);
    try {
      final added = <Scene>[];
      // Load until a page is filled or both sources are done.
      while (added.length < _pageSize && !_mixer.isExhausted) {
        await Future.wait([
          if (_mixer.needsPreferred) _load(preferred: true),
          if (_mixer.needsOthers) _load(preferred: false),
        ]);
        if (!ref.mounted || generation != _generation) return;
        final taken = _mixer.take(_pageSize - added.length);
        if (taken.isEmpty && !_mixer.needsPreferred && !_mixer.needsOthers) break;
        added.addAll(taken);
      }
      state = ShortsFeedState(items: [...state.items, ...added], hasMore: !_mixer.isExhausted);
    } catch (e) {
      if (!ref.mounted || generation != _generation) return;
      state = state.copyWith(isLoading: false, error: e);
    } finally {
      if (generation == _generation) _loading = false;
    }
  }

  Future<void> _load({required bool preferred}) async {
    final generation = _generation;
    final query = preferred ? _preferredQuery! : _othersQuery!;
    final page = (preferred ? _preferredPage : _othersPage) + 1;
    final result = await ref.read(stashRepositoryProvider).findScenes(query, page: page, perPage: _pageSize);
    // Rebuilt meanwhile: the result belongs to the previous feed.
    if (!ref.mounted || generation != _generation) return;
    // Only now, so a failed page is loaded again instead of skipped.
    if (preferred) {
      _preferredPage = page;
    } else {
      _othersPage = page;
    }
    final playable = result.items.where((s) => s.streamUrl != null);
    final done = result.items.isEmpty || page * _pageSize >= result.totalCount;
    if (preferred) {
      _mixer.addPreferred(playable);
      _mixer.preferredDone = done;
    } else {
      _mixer.addOthers(playable);
      _mixer.othersDone = done;
    }
  }
}

final shortsFeedFamily =
    NotifierProvider.autoDispose.family<ShortsFeedNotifier, ShortsFeedState, ShortsSource>(ShortsFeedNotifier.new);

/// The mixed feed of the shorts tab.
final shortsFeedProvider = shortsFeedFamily(const ShortsSource.feed());

/// How many of a performer's videos fit the shorts settings; the channel
/// shows its "Shorts" button only when there are any.
final performerShortsCountProvider = FutureProvider.autoDispose.family<int, String>((ref, performerId) async {
  final filter = ref.watch(shortsSettingsProvider).baseFilter;
  final result = await ref
      .watch(stashRepositoryProvider)
      .findScenes(SceneQuery(performerId: performerId, filter: filter), perPage: 1);
  return result.totalCount;
});

