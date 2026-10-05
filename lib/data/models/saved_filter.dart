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

  factory SavedFilter.fromJson(Json json) {
    final find = readObject(json, 'find_filter') ?? const <String, dynamic>{};
    final converted = convertSavedSceneFilter(readObject(json, 'object_filter') ?? const {});
    return SavedFilter(
      id: readString(json, 'id'),
      name: readString(json, 'name', 'Saved filter'),
      sceneFilter: converted.filter,
      search: readNullableString(find, 'q'),
      sort: readNullableString(find, 'sort'),
      direction: readNullableString(find, 'direction'),
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
///
/// Anything else is reported in `unsupported` and left out.
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
        if (modifier != null) 'modifier': modifier,
        if (value['depth'] != null) 'depth': value['depth'],
      };
    } else if (value is Map && value.containsKey('value')) {
      filter[key] = {
        'value': value['value'],
        if (value['value2'] != null) 'value2': value['value2'],
        if (modifier != null) 'modifier': modifier,
      };
    } else if (value is List) {
      filter[key] = {'value': ids(value), if (modifier != null) 'modifier': modifier};
    } else if (_booleanCriteria.contains(key) && (value == 'true' || value == 'false' || value is bool)) {
      filter[key] = value == true || value == 'true';
    } else if (value is String || value is num) {
      final mapped = key == 'resolution' ? _resolutions[value.toString().toLowerCase()] ?? value : value;
      filter[key] = {'value': mapped, if (modifier != null) 'modifier': modifier};
    } else if (value == null && (modifier == 'IS_NULL' || modifier == 'NOT_NULL')) {
      filter[key] = {'value': '', 'modifier': modifier};
    } else {
      unsupported.add(key);
    }
  }
  return (filter: filter, unsupported: unsupported);
}
