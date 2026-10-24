import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/pagination/paged_notifier.dart';
import '../../data/models/list_queries.dart';
import '../../data/models/marker.dart';
import '../../data/models/page_result.dart';
import '../../data/models/scene_filter.dart';
import '../../data/repositories/stash_repository.dart';
import 'short.dart';
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

  final _preferred = Queue<Short>();
  final _others = Queue<Short>();
  final _seen = <String>{};
  int _taken = 0;

  bool preferredDone;
  bool othersDone;

  /// Whether a source should load its next page: it is low and has more.
  bool get needsPreferred => !preferredDone && _preferred.length < preferredRun * 2;
  bool get needsOthers => !othersDone && _others.length < 2;

  bool get isExhausted => preferredDone && othersDone && _preferred.isEmpty && _others.isEmpty;

  void addPreferred(Iterable<Short> shorts) => _preferred.addAll(shorts);

  void addOthers(Iterable<Short> shorts) => _others.addAll(shorts);

  /// Up to [count] new videos. Stops early when the source whose turn it is
  /// is empty but not done, so the pattern keeps up after the next load.
  List<Short> take(int count) {
    final result = <Short>[];
    while (result.length < count) {
      final preferredTurn = _taken % (preferredRun + 1) < preferredRun;
      final first = preferredTurn ? _preferred : _others;
      final firstDone = preferredTurn ? preferredDone : othersDone;
      final second = preferredTurn ? _others : _preferred;
      final short = _next(first) ?? (firstDone ? _next(second) : null);
      if (short == null) break;
      result.add(short);
      _taken++;
    }
    return result;
  }

  Short? _next(Queue<Short> queue) {
    while (queue.isNotEmpty) {
      final short = queue.removeFirst();
      if (_seen.add(short.key)) return short;
    }
    return null;
  }
}

@immutable
class ShortsFeedState {
  const ShortsFeedState({this.items = const [], this.isLoading = false, this.error, this.hasMore = true});

  final List<Short> items;
  final bool isLoading;
  final Object? error;
  final bool hasMore;

  ShortsFeedState copyWith({List<Short>? items, bool? isLoading, Object? error, bool? hasMore}) => ShortsFeedState(
        items: items ?? this.items,
        isLoading: isLoading ?? this.isLoading,
        error: error,
        hasMore: hasMore ?? this.hasMore,
      );
}

/// Where a shorts feed comes from: the mixed feed of the shorts tab, one
/// performer's or studio's short videos (their channel's shorts tab), or a
/// markers grid's markers.
@immutable
class ShortsSource {
  const ShortsSource.feed()
      : performerId = null,
        studioId = null,
        title = null,
        lane = null,
        markers = null,
        startPage = 1;

  const ShortsSource.performer(String this.performerId, {this.title})
      : studioId = null,
        lane = null,
        markers = null,
        startPage = 1;

  /// A studio's shorts, including its sub-studios'.
  const ShortsSource.studio(String this.studioId, {this.title})
      : performerId = null,
        lane = null,
        markers = null,
        startPage = 1;

  /// One of the home shelf's queues: mixed like the feed, but shuffled on
  /// its own, so every tile continues differently.
  const ShortsSource.lane(int this.lane)
      : performerId = null,
        studioId = null,
        title = null,
        markers = null,
        startPage = 1;

  /// Exactly the markers of a markers grid (the library's, a channel's), in
  /// its order, from its page [startPage] (of [PagedNotifier.pageSize]) on:
  /// the shorts settings' filters don't apply, the user picked these.
  const ShortsSource.markers(MarkerQuery this.markers, {this.startPage = 1, this.title})
      : performerId = null,
        studioId = null,
        lane = null;

  final String? performerId;
  final String? studioId;

  /// Which of the home shelf's queues (0–3).
  final int? lane;

  /// The markers grid's query, for [ShortsSource.markers].
  final MarkerQuery? markers;

  /// The first page of [markers] the feed plays.
  final int startPage;

  /// Shown in the top bar, e.g. the performer's name.
  final String? title;

  bool get isFeed => performerId == null && studioId == null && lane == null && markers == null;

  /// A channel's videos that fit the shorts settings' [filter] (length and
  /// orientation); null for the mixed feeds.
  SceneQuery? channelQuery(SceneFilter filter, {SceneSort sort = SceneSort.random}) {
    if (performerId case final id?) return SceneQuery(sort: sort, performerId: id, filter: filter);
    if (studioId case final id?) {
      return SceneQuery(sort: sort, studioId: id, includeSubStudios: true, filter: filter);
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      other is ShortsSource &&
      other.performerId == performerId &&
      other.studioId == studioId &&
      other.lane == lane &&
      other.markers == markers &&
      other.startPage == startPage;

  @override
  int get hashCode => Object.hash(performerId, studioId, lane, markers, startPage);
}

/// Where a tapped marker is in the shorts of [ShortsSource.markers]: the
/// feed starts at the page holding [index] of the grid's [items] (all pages
/// loaded so far, or the one page shown with numbered pages, [page]) and
/// leaves out markers it can't play.
({int startPage, int initialIndex}) markerShortsStart(
  List<Marker> items,
  int index, {
  int? page,
  int perPage = PagedNotifier.pageSize,
}) {
  final startPage = page ?? index ~/ perPage + 1;
  final first = page == null ? (startPage - 1) * perPage : 0;
  var initialIndex = 0;
  for (var i = first; i < index && i < items.length; i++) {
    if (items[i].scene.streamUrl != null) initialIndex++;
  }
  return (startPage: startPage, initialIndex: initialIndex);
}

/// Endless, shuffled feed of shorts built from [shortsSettingsProvider]:
/// the length and orientation always apply, the preferred tags only to the
/// mixed feed. Following [ShortsSettings.markers] the mixed feed also plays
/// scene markers, taking turns with the videos. Rebuilding (settings change,
/// server switch, [refresh]) reshuffles.
class ShortsFeedNotifier extends Notifier<ShortsFeedState> {
  ShortsFeedNotifier(this.source);

  final ShortsSource source;

  /// The same as the markers grid's, so [ShortsSource.startPage] matches.
  static const _pageSize = PagedNotifier.pageSize;

  late ShortsMixer _mixer;
  late SceneQuery? _preferredQuery;
  late SceneQuery? _othersQuery;
  int _preferredPage = 0;
  int _othersPage = 0;

  late MarkerQuery? _markerQuery;
  final _markers = Queue<Short>();
  bool _markersDone = true;
  int _markersPage = 0;

  /// Whether the next short is a video (else a marker), while both last.
  bool _videoTurn = true;

  /// Bumped on every build, so loads of a previous build are dropped.
  int _generation = 0;
  bool _loading = false;

  @override
  ShortsFeedState build() {
    ref.watch(stashRepositoryProvider);
    // A markers grid's markers: no settings apply.
    final settings = source.markers == null ? ref.watch(shortsSettingsProvider) : const ShortsSettings();
    final channelQuery = source.channelQuery(settings.baseFilter);
    if (source.markers case final markers?) {
      _preferredQuery = null;
      _othersQuery = null;
      _markerQuery = markers;
    } else if (channelQuery != null) {
      _preferredQuery = null;
      _othersQuery = channelQuery;
      _markerQuery = null;
    } else {
      final tagFilter = settings.tagFilter;
      final videos = settings.showsVideos;
      _preferredQuery = !videos || tagFilter == null ? null : SceneQuery(sort: SceneSort.random, filter: tagFilter);
      _othersQuery =
          videos && settings.mixesOthers ? SceneQuery(sort: SceneSort.random, filter: settings.baseFilter) : null;
      _markerQuery = settings.markerQuery;
    }
    _mixer = ShortsMixer(hasPreferred: _preferredQuery != null, hasOthers: _othersQuery != null);
    _preferredPage = 0;
    _othersPage = 0;
    _markers.clear();
    _markersDone = _markerQuery == null;
    _markersPage = source.startPage - 1;
    _videoTurn = true;
    _loading = false;
    final generation = ++_generation;
    Future.microtask(() {
      if (ref.mounted && generation == _generation) loadMore();
    });
    return const ShortsFeedState(isLoading: true);
  }

  void refresh() => ref.invalidateSelf();

  bool get _needsMarkers => !_markersDone && _markers.length < 2;

  bool get _isExhausted => _mixer.isExhausted && _markersDone && _markers.isEmpty;

  Future<void> loadMore() async {
    final generation = _generation;
    if (_loading || !state.hasMore) return;
    _loading = true;
    state = state.copyWith(isLoading: true);
    try {
      final added = <Short>[];
      // Load until a page is filled or all sources are done.
      while (added.length < _pageSize && !_isExhausted) {
        await Future.wait([
          if (_mixer.needsPreferred) _load(preferred: true),
          if (_mixer.needsOthers) _load(preferred: false),
          if (_needsMarkers) _loadMarkers(),
        ]);
        if (!ref.mounted || generation != _generation) return;
        final taken = _take(_pageSize - added.length);
        if (taken.isEmpty && !_mixer.needsPreferred && !_mixer.needsOthers && !_needsMarkers) break;
        added.addAll(taken);
      }
      state = ShortsFeedState(items: [...state.items, ...added], hasMore: !_isExhausted);
    } catch (e) {
      if (!ref.mounted || generation != _generation) return;
      state = state.copyWith(isLoading: false, error: e);
    } finally {
      if (generation == _generation) _loading = false;
    }
  }

  /// Up to [count] shorts, videos and markers taking turns. Stops early when
  /// the source whose turn it is waits for its next page.
  List<Short> _take(int count) {
    final result = <Short>[];
    while (result.length < count) {
      final videosLeft = !_mixer.isExhausted;
      final markersLeft = !_markersDone || _markers.isNotEmpty;
      if (!videosLeft && !markersLeft) break;
      final videoTurn = videosLeft && (_videoTurn || !markersLeft);
      final short = videoTurn ? _mixer.take(1).firstOrNull : (_markers.isEmpty ? null : _markers.removeFirst());
      if (short == null) break;
      result.add(short);
      _videoTurn = !videoTurn;
    }
    return result;
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
    final playable = [for (final s in result.items) if (s.streamUrl != null) Short.video(s)];
    final done = result.items.isEmpty || page * _pageSize >= result.totalCount;
    if (preferred) {
      _mixer.addPreferred(playable);
      _mixer.preferredDone = done;
    } else {
      _mixer.addOthers(playable);
      _mixer.othersDone = done;
    }
  }

  Future<void> _loadMarkers() async {
    final generation = _generation;
    final page = _markersPage + 1;
    final PageResult<Marker> result;
    try {
      result = await ref.read(stashRepositoryProvider).findMarkers(_markerQuery!, page: page, perPage: _pageSize);
    } on StashApiException catch (e) {
      // The server rejected the marker query (an older Stash without e.g.
      // the scene's orientation for markers): the mixed feed goes on with
      // its videos. Only markers, or no connection: the feed shows the error.
      if (e.isNetworkError || !(_mixer.hasPreferred || _mixer.hasOthers)) rethrow;
      if (!ref.mounted || generation != _generation) return;
      _markersDone = true;
      return;
    }
    if (!ref.mounted || generation != _generation) return;
    _markersPage = page;
    _markers.addAll([for (final m in result.items) if (m.scene.streamUrl != null) Short.marker(m)]);
    _markersDone = result.items.isEmpty || page * _pageSize >= result.totalCount;
  }
}

final shortsFeedFamily =
    NotifierProvider.autoDispose.family<ShortsFeedNotifier, ShortsFeedState, ShortsSource>(ShortsFeedNotifier.new);

/// The mixed feed of the shorts tab.
final shortsFeedProvider = shortsFeedFamily(const ShortsSource.feed());

/// How many of a performer's videos fit the shorts settings; the channel
/// shows its shorts tab only when there are any.
final performerShortsCountProvider = FutureProvider.autoDispose.family<int, String>(
  (ref, performerId) => ref.watch(channelShortsCountProvider(ShortsSource.performer(performerId)).future),
);

/// How many videos of a channel ([ShortsSource.performer] or
/// [ShortsSource.studio]) fit the shorts settings; 0 for the mixed feeds.
final channelShortsCountProvider = FutureProvider.autoDispose.family<int, ShortsSource>((ref, source) async {
  final query = source.channelQuery(ref.watch(shortsSettingsProvider).baseFilter, sort: SceneSort.recentlyAdded);
  if (query == null) return 0;
  final result = await ref.watch(stashRepositoryProvider).findScenes(query, perPage: 1);
  return result.totalCount;
});

