import 'package:flutter/foundation.dart';

import 'tag.dart';

enum DurationFilter {
  any('Any length'),
  short('Under 10 min'),
  medium('10–30 min'),
  long('Over 30 min');

  const DurationFilter(this.label);

  final String label;

  Map<String, dynamic>? toCriterion() => switch (this) {
        DurationFilter.any => null,
        DurationFilter.short => {'value': 600, 'modifier': 'LESS_THAN'},
        DurationFilter.medium => {'value': 600, 'value2': 1800, 'modifier': 'BETWEEN'},
        DurationFilter.long => {'value': 1800, 'modifier': 'GREATER_THAN'},
      };
}

/// Minimum resolution. Stash compares resolutions by category, so "at least
/// 720p" is "greater than" the category just below it.
enum ResolutionFilter {
  any('Any quality', null),
  hd('720p+', 'WEB_HD'),
  fullHd('1080p+', 'STANDARD_HD'),
  uhd('4K+', 'QUAD_HD');

  const ResolutionFilter(this.label, this._above);

  final String label;
  final String? _above;

  Map<String, dynamic>? toCriterion() => _above == null ? null : {'value': _above, 'modifier': 'GREATER_THAN'};
}

/// User-chosen scene filters (5.4) and tag pages (8.1), mapped to Stash's
/// `SceneFilterType`. Value equality, as it is part of provider keys.
@immutable
class SceneFilter {
  const SceneFilter({
    this.tags = const [],
    this.minStars = 0,
    this.duration = DurationFilter.any,
    this.resolution = ResolutionFilter.any,
    this.savedFilter,
  });

  static const none = SceneFilter();

  /// Scenes must have all of these tags.
  final List<Tag> tags;

  /// 0 = any rating; 1–5 = at least this many stars.
  final int minStars;
  final DurationFilter duration;
  final ResolutionFilter resolution;

  /// A Stash saved filter's scene filter (5.5), already converted to
  /// `SceneFilterType` form. Combined with the other fields. Compared
  /// shallowly: the map instance comes from the loaded saved filter.
  final Map<String, dynamic>? savedFilter;

  bool get isEmpty =>
      tags.isEmpty &&
      minStars == 0 &&
      duration == DurationFilter.any &&
      resolution == ResolutionFilter.any &&
      savedFilter == null;

  /// Number of active criteria, for the filter button badge (saved filters
  /// are shown as their own chip).
  int get activeCount =>
      (tags.isEmpty ? 0 : 1) +
      (minStars == 0 ? 0 : 1) +
      (duration == DurationFilter.any ? 0 : 1) +
      (resolution == ResolutionFilter.any ? 0 : 1);

  Map<String, dynamic> toCriteria() => {
        ...?savedFilter,
        if (tags.isNotEmpty)
          'tags': {
            'value': [for (final t in tags) t.id],
            'modifier': 'INCLUDES_ALL',
            'depth': 0,
          },
        if (minStars > 0) 'rating100': {'value': minStars * 20 - 1, 'modifier': 'GREATER_THAN'},
        'duration': ?duration.toCriterion(),
        'resolution': ?resolution.toCriterion(),
      };

  SceneFilter copyWith({
    List<Tag>? tags,
    int? minStars,
    DurationFilter? duration,
    ResolutionFilter? resolution,
    Map<String, dynamic>? savedFilter,
    bool clearSavedFilter = false,
  }) =>
      SceneFilter(
        tags: tags ?? this.tags,
        minStars: minStars ?? this.minStars,
        duration: duration ?? this.duration,
        resolution: resolution ?? this.resolution,
        savedFilter: clearSavedFilter ? null : (savedFilter ?? this.savedFilter),
      );

  @override
  bool operator ==(Object other) =>
      other is SceneFilter &&
      listEquals([for (final t in tags) t.id], [for (final t in other.tags) t.id]) &&
      other.minStars == minStars &&
      other.duration == duration &&
      other.resolution == resolution &&
      mapEquals(other.savedFilter, savedFilter);

  @override
  int get hashCode => Object.hash(
        Object.hashAll([for (final t in tags) t.id]),
        minStars,
        duration,
        resolution,
        savedFilter == null ? null : Object.hashAllUnordered(savedFilter!.keys),
      );
}
