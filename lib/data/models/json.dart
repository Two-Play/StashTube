/// Small helpers for defensively reading Stash GraphQL responses, where most
/// fields are nullable and IDs are returned as strings.
typedef Json = Map<String, dynamic>;

String readString(Json json, String key, [String fallback = '']) {
  final value = json[key];
  return value == null ? fallback : value.toString();
}

String? readNullableString(Json json, String key) {
  final value = json[key];
  if (value == null) return null;
  final s = value.toString();
  return s.isEmpty ? null : s;
}

int readInt(Json json, String key, [int fallback = 0]) {
  final value = json[key];
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? fallback;
  return fallback;
}

int? readNullableInt(Json json, String key) {
  final value = json[key];
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

double readDouble(Json json, String key, [double fallback = 0]) {
  final value = json[key];
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? fallback;
  return fallback;
}

bool readBool(Json json, String key, [bool fallback = false]) {
  final value = json[key];
  return value is bool ? value : fallback;
}

DateTime? readDate(Json json, String key) {
  final value = json[key];
  if (value is! String || value.isEmpty) return null;
  return DateTime.tryParse(value);
}

Json? readObject(Json json, String key) {
  final value = json[key];
  return value is Map ? Map<String, dynamic>.from(value) : null;
}

List<Json> readList(Json json, String key) {
  final value = json[key];
  if (value is! List) return const [];
  return value.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
}
