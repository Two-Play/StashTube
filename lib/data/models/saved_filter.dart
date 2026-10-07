import '../../core/api/documents/system.graphql.dart';
import '../../core/api/stash_schema.graphql.dart';
import 'json.dart';

/// A filter saved in Stash's web UI (5.5).
class SavedFilter {
  const SavedFilter({
    required this.id,
    required this.name,
    required this.sceneFilter,
    this.search,
    this.sort,
    this.direction,
    this.unsupportedCriteria = const [],
  });

  final String id;
  final String name;

  /// Converted to `SceneFilterType` form (see [convertSavedSceneFilter]).
  final Map<String, dynamic> sceneFilter;
  final String? search;
  final String? sort;
  final String? direction;

  /// Criteria that couldn't be converted and are ignored.
  final List<String> unsupportedCriteria;

  factory SavedFilter.fromGraphql(Query$SavedSceneFilters$findSavedFilters f) {
    final find = f.find_filter;
    final direction = find?.direction;
    final converted = convertSavedSceneFilter(f.object_filter ?? const {});
    return SavedFilter(
      id: f.id,
      name: nonEmpty(f.name) ?? 'Saved filter',
      sceneFilter: converted.filter,
      search: nonEmpty(find?.q),
      sort: nonEmpty(find?.sort),
      direction: direction == null ? null : toJson$Enum$SortDirectionEnum(direction),
      unsupportedCriteria: converted.unsupported,
    );
  }
}

/// Criteria that are plain booleans in `SceneFilterType` (the web UI stores
/// them as the strings "true"/"false").
const _booleanCriteria = {'organized', 'performer_favorite', 'interactive'};

/// Resolution labels the web UI stores, mapped to `ResolutionEnum`.
const _resolutions = {
  '144p': 'VERY_LOW',
  '240p': 'LOW',
  '360p': 'R360P',
  '480p': 'STANDARD',
  '540p': 'WEB_HD',
  '720p': 'STANDARD_HD',
  '1080p': 'FULL_HD',
  '1440p': 'QUAD_HD',
  '4k': 'FOUR_K',
  '5k': 'FIVE_K',
  '6k': 'SIX_K',
  '7k': 'SEVEN_K',
  '8k': 'EIGHT_K',
};

/// Converts a saved filter's `object_filter`, which uses the web UI's
/// criterion format, into `SceneFilterType`, best effort:
///
/// * `{"modifier": m, "value": {"items": [{id,label}], "excluded": [...], "depth": d}}`
///   → `{"value": [ids], "excludes": [ids], "modifier": m, "depth": d}`
/// * `{"modifier": m, "value": {"value": v, "value2": v2}}` → `{"value": v, "value2": v2, "modifier": m}`
/// * `{"modifier": m, "value": [{id,label}]}` → `{"value": [ids], "modifier": m}`
/// * `{"modifier": m, "value": "true"}` for boolean criteria → `true`
/// * other scalars → `{"value": v, "modifier": m}` (resolution labels mapped)
/// * `IS_NULL` / `NOT_NULL` without a value → a value of the criterion's
///   type, which Stash ignores but the schema requires
///
/// Every criterion is checked against the generated `SceneFilterType`;
/// anything that doesn't fit is reported in `unsupported` and left out.
({Map<String, dynamic> filter, List<String> unsupported}) convertSavedSceneFilter(Map<String, dynamic> objectFilter) {
  final filter = <String, dynamic>{};
  final unsupported = <String>[];

  List<String> ids(Object? items) =>
      items is List ? [for (final i in items) if (i is Map) i['id'].toString() else i.toString()] : const [];

  for (final MapEntry(:key, value: criterion) in objectFilter.entries) {
    if (criterion is! Map) {
      unsupported.add(key);
      continue;
    }
    final modifier = criterion['modifier'];
    final value = criterion['value'];

    if (value is Map && value.containsKey('items')) {
      filter[key] = {
        'value': ids(value['items']),
        if (ids(value['excluded']).isNotEmpty) 'excludes': ids(value['excluded']),
        'modifier': ?modifier,
        if (value['depth'] != null) 'depth': value['depth'],
      };
    } else if (value is Map && value.containsKey('value')) {
      filter[key] = {
        'value': value['value'],
        if (value['value2'] != null) 'value2': value['value2'],
        'modifier': ?modifier,
      };
    } else if (value is List) {
      filter[key] = {'value': ids(value), 'modifier': ?modifier};
    } else if (_booleanCriteria.contains(key) && (value == 'true' || value == 'false' || value is bool)) {
      filter[key] = value == true || value == 'true';
    } else if (value is String || value is num) {
      final mapped = key == 'resolution' ? _resolutions[value.toString().toLowerCase()] ?? value : value;
      filter[key] = {'value': mapped, 'modifier': ?modifier};
    } else if (value == null && (modifier == 'IS_NULL' || modifier == 'NOT_NULL')) {
      filter[key] = [
        for (final empty in const [<String>[], 0, ''])
          if (_fits(key, {'value': empty, 'modifier': modifier})) {'value': empty, 'modifier': modifier},
      ].firstOrNull;
    }
    if (!filter.containsKey(key) || filter[key] == null || !_fits(key, filter[key])) {
      filter.remove(key);
      unsupported.add(key);
    }
  }
  return (filter: filter, unsupported: unsupported);
}

bool _fits(String key, Object? criterion) =>
    fitsInput<Input$SceneFilterType>({key: criterion}, Input$SceneFilterType.fromJson, (i) => i.toJson());
