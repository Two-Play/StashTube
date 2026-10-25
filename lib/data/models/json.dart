/// Helpers for turning the generated GraphQL types (1.8) into the app's
/// models: Stash returns empty strings for unset text and dates as strings.
typedef Json = Map<String, dynamic>;

/// [value], or null when it is null or blank.
String? nonEmpty(String? value) => value == null || value.trim().isEmpty ? null : value;

/// A performer's, studio's or tag's image, or null when Stash only has its
/// placeholder: Stash marks those URLs with `default=true` and serves an SVG,
/// which the image decoder can't read (Android logs every failed attempt).
String? stashImageUrl(String? path) {
  final url = nonEmpty(path);
  if (url == null) return null;
  return Uri.tryParse(url)?.queryParameters['default'] == 'true' ? null : url;
}

DateTime? parseDate(String? value) => value == null || value.isEmpty ? null : DateTime.tryParse(value);

/// Whether [a] and [b] are the same JSON value (maps, lists, numbers
/// compared by value).
bool sameJson(Object? a, Object? b) {
  if (a is Map && b is Map) {
    return a.length == b.length && a.keys.every((k) => b.containsKey(k) && sameJson(a[k], b[k]));
  }
  if (a is List && b is List) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (!sameJson(a[i], b[i])) return false;
    }
    return true;
  }
  return a == b;
}

/// Whether [map] is a valid value of a generated input type: its parser
/// accepts it and nothing gets lost (the parser ignores unknown keys).
bool fitsInput<T>(Json map, T Function(Json) fromJson, Json Function(T) toJson) {
  try {
    return sameJson(toJson(fromJson(map)), map);
  } catch (_) {
    return false;
  }
}
