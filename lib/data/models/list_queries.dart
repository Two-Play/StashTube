import 'dart:math';

import 'scene_filter.dart';

/// Sort orders offered for scene lists, mapped to Stash `FindFilterType.sort`.
enum SceneSort {
  recentlyAdded('created_at'),
  newest('date'),
  random('random'),
  topRated('rating'),
  mostPlayed('play_count'),
  lastPlayed('last_played_at'),
  title('title'),

  /// Order within a group (playlist); only meaningful with a group filter.
  groupOrder('group_scene_number');

  const SceneSort(this.field);

  final String field;

  /// Sorts offered in general scene feeds.
  static const feed = [recentlyAdded, newest, random, topRated, mostPlayed, lastPlayed, title];
}

enum PerformerSort {
  name('name'),
  mostScenes('scenes_count'),
  favorites('name'),
  random('random');

  const PerformerSort(this.field);

  final String field;
}

enum ImageSort {
  recentlyAdded('created_at'),
  newest('date'),
  random('random'),
  topRated('rating'),
  title('title'),

  /// File order, used inside galleries.
  path('path');

  const ImageSort(this.field);

  final String field;
}

enum GallerySort {
  recentlyAdded('created_at'),
  newest('date'),
  random('random'),
  mostImages('images_count'),
  title('title');

  const GallerySort(this.field);

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
    this.includeSubStudios = false,
    this.filter = SceneFilter.none,
    this.groupId,
    this.playedOnly = false,
    int? seed,
  }) : seed = seed ?? (sort == SceneSort.random ? newRandomSeed() : 0);

  /// Home shelf "New from favorites"; shared so it can be invalidated after
  /// favorites change.
  factory SceneQuery.newFromFavorites() =>
      SceneQuery(sort: SceneSort.recentlyAdded, favoritePerformersOnly: true);

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

  /// With [studioId]: also scenes of its sub-studios (at any depth).
  final bool includeSubStudios;

  /// Tags, rating, duration, resolution and saved filters.
  final SceneFilter filter;

  /// Only scenes of this group (playlist).
  final String? groupId;

  /// Only scenes that were played at least once (history).
  final bool playedOnly;

  /// Seed for [SceneSort.random] so that pages are stable while scrolling.
  /// Always 0 for other sorts, so equal queries map to the same provider.
  final int seed;

  String get sortField => sort == SceneSort.random ? 'random_$seed' : sort.field;

  /// A-Z and group order read naturally ascending; every other sort shows
  /// the "most" first.
  String get direction => sort == SceneSort.title || sort == SceneSort.groupOrder ? 'ASC' : 'DESC';

  Map<String, dynamic>? toSceneFilter() {
    final criteria = <String, dynamic>{
      ...filter.toCriteria(),
      if (performerId != null) 'performers': {'value': [performerId], 'modifier': 'INCLUDES'},
      if (studioId != null)
        'studios': {
          'value': [studioId],
          'modifier': 'INCLUDES',
          'depth': includeSubStudios ? -1 : 0,
        },
      if (inProgressOnly) 'resume_time': {'value': 0, 'modifier': 'GREATER_THAN'},
      if (favoritePerformersOnly) 'performer_favorite': true,
      if (groupId != null) 'groups': {'value': [groupId], 'modifier': 'INCLUDES'},
      if (playedOnly) 'play_count': {'value': 0, 'modifier': 'GREATER_THAN'},
    };
    return criteria.isEmpty ? null : criteria;
  }

  SceneQuery copyWith({SceneSort? sort, SceneFilter? filter, String? search, bool clearSearch = false}) => SceneQuery(
        sort: sort ?? this.sort,
        search: clearSearch ? null : (search ?? this.search),
        performerId: performerId,
        studioId: studioId,
        excludeSceneId: excludeSceneId,
        inProgressOnly: inProgressOnly,
        favoritePerformersOnly: favoritePerformersOnly,
        includeSubStudios: includeSubStudios,
        filter: filter ?? this.filter,
        groupId: groupId,
        playedOnly: playedOnly,
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
      other.includeSubStudios == includeSubStudios &&
      other.filter == filter &&
      other.groupId == groupId &&
      other.playedOnly == playedOnly &&
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
        includeSubStudios,
        filter,
        groupId,
        playedOnly,
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

enum TagSort {
  mostScenes('scenes_count'),
  name('name'),
  recentlyAdded('created_at');

  const TagSort(this.field);

  final String field;
}

class TagQuery {
  const TagQuery({this.sort = TagSort.mostScenes, this.search});

  final TagSort sort;
  final String? search;

  String get direction => sort == TagSort.name ? 'ASC' : 'DESC';

  @override
  bool operator ==(Object other) => other is TagQuery && other.sort == sort && other.search == search;

  @override
  int get hashCode => Object.hash(sort, search);
}

class GroupQuery {
  const GroupQuery({this.search});

  final String? search;

  @override
  bool operator ==(Object other) => other is GroupQuery && other.search == search;

  @override
  int get hashCode => search.hashCode;
}

class StudioQuery {
  const StudioQuery({this.search});

  final String? search;

  @override
  bool operator ==(Object other) => other is StudioQuery && other.search == search;

  @override
  int get hashCode => search.hashCode;
}

class ImageQuery {
  ImageQuery({
    this.sort = ImageSort.recentlyAdded,
    this.galleryId,
    this.search,
    this.filter = SceneFilter.none,
    int? seed,
  }) : seed = seed ?? (sort == ImageSort.random ? newRandomSeed() : 0);

  final ImageSort sort;

  /// Only images of this gallery.
  final String? galleryId;

  /// Free text (Stash's `q`: title, path, ...).
  final String? search;

  /// Tags, minimum rating and resolution (15.4); the duration doesn't apply
  /// to images and isn't offered for them.
  final SceneFilter filter;
  final int seed;

  String get sortField => sort == ImageSort.random ? 'random_$seed' : sort.field;
  String get direction => sort == ImageSort.title || sort == ImageSort.path ? 'ASC' : 'DESC';

  Map<String, dynamic>? toImageFilter() {
    final criteria = {
      ...filter.toCriteria(),
      if (galleryId != null)
        'galleries': {
          'value': [galleryId],
          'modifier': 'INCLUDES',
        },
    };
    return criteria.isEmpty ? null : criteria;
  }

  ImageQuery copyWith({ImageSort? sort, String? search, bool clearSearch = false, SceneFilter? filter}) => ImageQuery(
        sort: sort ?? this.sort,
        galleryId: galleryId,
        search: clearSearch ? null : (search ?? this.search),
        filter: filter ?? this.filter,
        // Picking a sort again (e.g. "Shuffle") starts a fresh shuffle.
        seed: sort == null ? seed : null,
      );

  @override
  bool operator ==(Object other) =>
      other is ImageQuery &&
      other.sort == sort &&
      other.galleryId == galleryId &&
      other.search == search &&
      other.filter == filter &&
      other.seed == seed;

  @override
  int get hashCode => Object.hash(sort, galleryId, search, filter, seed);
}

class GalleryQuery {
  GalleryQuery({this.sort = GallerySort.recentlyAdded, int? seed})
      : seed = seed ?? (sort == GallerySort.random ? newRandomSeed() : 0);

  final GallerySort sort;
  final int seed;

  String get sortField => sort == GallerySort.random ? 'random_$seed' : sort.field;
  String get direction => sort == GallerySort.title ? 'ASC' : 'DESC';

  @override
  bool operator ==(Object other) => other is GalleryQuery && other.sort == sort && other.seed == seed;

  @override
  int get hashCode => Object.hash(sort, seed);
}
