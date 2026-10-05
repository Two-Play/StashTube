import 'dart:math';

/// Sort orders offered for scene lists, mapped to Stash `FindFilterType.sort`.
enum SceneSort {
  recentlyAdded('Recently added', 'created_at'),
  newest('Newest', 'date'),
  random('Shuffle', 'random'),
  topRated('Top rated', 'rating'),
  mostPlayed('Most played', 'play_count'),
  lastPlayed('Recently watched', 'last_played_at'),
  title('A–Z', 'title');

  const SceneSort(this.label, this.field);

  final String label;
  final String field;
}

enum PerformerSort {
  name('Name', 'name'),
  mostScenes('Most scenes', 'scenes_count'),
  favorites('Favorites', 'name'),
  random('Shuffle', 'random');

  const PerformerSort(this.label, this.field);

  final String label;
  final String field;
}

int newRandomSeed() => Random().nextInt(1 << 30);

/// Arguments for a paginated scene list. Used as a provider family key, so it
/// implements value equality.
class SceneQuery {
  SceneQuery({
    this.sort = SceneSort.recentlyAdded,
    this.search,
    this.performerId,
    this.studioId,
    this.excludeSceneId,
    this.inProgressOnly = false,
    this.favoritePerformersOnly = false,
    int? seed,
  }) : seed = seed ?? (sort == SceneSort.random ? newRandomSeed() : 0);

  final SceneSort sort;
  final String? search;
  final String? performerId;
  final String? studioId;

  /// Filtered out client-side, e.g. the scene currently playing in "Up next".
  final String? excludeSceneId;

  /// Only scenes with a saved resume position ("Continue watching").
  final bool inProgressOnly;

  /// Only scenes with at least one favorite performer.
  final bool favoritePerformersOnly;

  /// Seed for [SceneSort.random] so that pages are stable while scrolling.
  /// Always 0 for other sorts, so equal queries map to the same provider.
  final int seed;

  String get sortField => sort == SceneSort.random ? 'random_$seed' : sort.field;

  /// A-Z reads naturally ascending; every other sort shows the "most" first.
  String get direction => sort == SceneSort.title ? 'ASC' : 'DESC';

  Map<String, dynamic>? toSceneFilter() {
    final filter = <String, dynamic>{
      if (performerId != null) 'performers': {'value': [performerId], 'modifier': 'INCLUDES'},
      if (studioId != null) 'studios': {'value': [studioId], 'modifier': 'INCLUDES', 'depth': 0},
      if (inProgressOnly) 'resume_time': {'value': 0, 'modifier': 'GREATER_THAN'},
      if (favoritePerformersOnly) 'performer_favorite': true,
    };
    return filter.isEmpty ? null : filter;
  }

  SceneQuery copyWith({SceneSort? sort}) => SceneQuery(
        sort: sort ?? this.sort,
        search: search,
        performerId: performerId,
        studioId: studioId,
        excludeSceneId: excludeSceneId,
        inProgressOnly: inProgressOnly,
        favoritePerformersOnly: favoritePerformersOnly,
        // Picking a sort again (e.g. "Shuffle") starts a fresh shuffle.
        seed: sort == null ? seed : null,
      );

  @override
  bool operator ==(Object other) =>
      other is SceneQuery &&
      other.sort == sort &&
      other.search == search &&
      other.performerId == performerId &&
      other.studioId == studioId &&
      other.excludeSceneId == excludeSceneId &&
      other.inProgressOnly == inProgressOnly &&
      other.favoritePerformersOnly == favoritePerformersOnly &&
      other.seed == seed;

  @override
  int get hashCode => Object.hash(
        sort,
        search,
        performerId,
        studioId,
        excludeSceneId,
        inProgressOnly,
        favoritePerformersOnly,
        seed,
      );
}

class PerformerQuery {
  PerformerQuery({this.sort = PerformerSort.name, this.search, int? seed})
      : seed = seed ?? (sort == PerformerSort.random ? newRandomSeed() : 0);

  final PerformerSort sort;
  final String? search;
  final int seed;

  String get sortField => sort == PerformerSort.random ? 'random_$seed' : sort.field;
  String get direction => sort == PerformerSort.mostScenes ? 'DESC' : 'ASC';

  Map<String, dynamic>? toPerformerFilter() =>
      sort == PerformerSort.favorites ? {'filter_favorites': true} : null;

  @override
  bool operator ==(Object other) =>
      other is PerformerQuery && other.sort == sort && other.search == search && other.seed == seed;

  @override
  int get hashCode => Object.hash(sort, search, seed);
}

class StudioQuery {
  const StudioQuery({this.search});

  final String? search;

  @override
  bool operator ==(Object other) => other is StudioQuery && other.search == search;

  @override
  int get hashCode => search.hashCode;
}
