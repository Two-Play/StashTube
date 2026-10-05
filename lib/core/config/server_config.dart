import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Overridden in `main()` with the instance loaded before `runApp`.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('sharedPreferencesProvider must be overridden'),
);

class ServerConfig {
  const ServerConfig({required this.baseUrl, this.apiKey});

  /// Server root without trailing slash, e.g. `http://192.168.1.5:9999`.
  final String baseUrl;
  final String? apiKey;

  String get graphqlEndpoint => '$baseUrl/graphql';

  // Value equality: an unchanged config must not rebuild the API client.
  @override
  bool operator ==(Object other) => other is ServerConfig && other.baseUrl == baseUrl && other.apiKey == apiKey;

  @override
  int get hashCode => Object.hash(baseUrl, apiKey);

  /// Headers needed for every request to the server: GraphQL, images, streams.
  Map<String, String> get authHeaders {
    final key = apiKey;
    return key == null || key.isEmpty ? const {} : {'ApiKey': key};
  }

  /// Normalizes user input. Returns null when [input] is not an absolute http(s) URL.
  static String? normalizeUrl(String input) {
    var url = input.trim();
    if (url.isEmpty) return null;
    if (!url.contains('://')) url = 'http://$url';
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.isAbsolute || uri.host.isEmpty) return null;
    if (uri.scheme != 'http' && uri.scheme != 'https') return null;
    url = uri.toString();
    while (url.endsWith('/')) {
      url = url.substring(0, url.length - 1);
    }
    if (url.endsWith('/graphql')) url = url.substring(0, url.length - '/graphql'.length);
    return url;
  }
}

/// A saved Stash server (2.6).
@immutable
class ServerProfile {
  const ServerProfile({required this.id, required this.name, required this.baseUrl, this.apiKey});

  final String id;
  final String name;
  final String baseUrl;
  final String? apiKey;

  ServerConfig get config => ServerConfig(baseUrl: baseUrl, apiKey: apiKey);

  /// A readable default name: host and port of the URL.
  static String defaultName(String baseUrl) {
    final uri = Uri.tryParse(baseUrl);
    if (uri == null || uri.host.isEmpty) return baseUrl;
    return uri.hasPort ? '${uri.host}:${uri.port}' : uri.host;
  }

  ServerProfile copyWith({String? name, String? apiKey, bool clearApiKey = false}) => ServerProfile(
        id: id,
        name: name ?? this.name,
        baseUrl: baseUrl,
        apiKey: clearApiKey ? null : (apiKey ?? this.apiKey),
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'url': baseUrl, if (apiKey != null) 'apiKey': apiKey};

  factory ServerProfile.fromJson(Map<String, dynamic> json) => ServerProfile(
        id: json['id'] as String,
        name: json['name'] as String,
        baseUrl: json['url'] as String,
        apiKey: json['apiKey'] as String?,
      );
}

@immutable
class ServerProfiles {
  const ServerProfiles({this.profiles = const [], this.activeId});

  final List<ServerProfile> profiles;
  final String? activeId;

  ServerProfile? get active => profiles.where((p) => p.id == activeId).firstOrNull;
}

/// All saved servers and which one is in use. Switching servers rebuilds
/// everything that depends on [serverConfigProvider].
class ServerProfilesNotifier extends Notifier<ServerProfiles> {
  static const _profilesKey = 'server_profiles';
  static const _activeKey = 'active_server';
  // Keys of the single-server versions of the app, migrated once.
  static const _legacyUrlKey = 'url';
  static const _legacyApiKey = 'api_key';

  @override
  ServerProfiles build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final raw = prefs.getString(_profilesKey);
    if (raw != null) {
      final list = [
        for (final p in (jsonDecode(raw) as List).whereType<Map<String, dynamic>>()) ServerProfile.fromJson(p),
      ];
      return ServerProfiles(profiles: list, activeId: prefs.getString(_activeKey));
    }

    // Migrate an existing single-server login into the first profile.
    final url = prefs.getString(_legacyUrlKey);
    if (url == null || url.isEmpty) return const ServerProfiles();
    final profile = ServerProfile(
      id: _newId(),
      name: ServerProfile.defaultName(url),
      baseUrl: url,
      apiKey: prefs.getString(_legacyApiKey),
    );
    final migrated = ServerProfiles(profiles: [profile], activeId: profile.id);
    _persist(migrated).then((_) async {
      await prefs.remove(_legacyUrlKey);
      await prefs.remove(_legacyApiKey);
    });
    return migrated;
  }

  static String _newId() => '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(1 << 20)}';

  Future<void> _persist(ServerProfiles value) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_profilesKey, jsonEncode([for (final p in value.profiles) p.toJson()]));
    if (value.activeId == null) {
      await prefs.remove(_activeKey);
    } else {
      await prefs.setString(_activeKey, value.activeId!);
    }
  }

  Future<void> _set(ServerProfiles value) async {
    state = value;
    await _persist(value);
  }

  /// Saves a server (updating one with the same URL) and switches to it.
  Future<ServerProfile> add(ServerConfig config, {String? name}) async {
    final existing = state.profiles.where((p) => p.baseUrl == config.baseUrl).firstOrNull;
    final profile = existing == null
        ? ServerProfile(
            id: _newId(),
            name: (name == null || name.trim().isEmpty) ? ServerProfile.defaultName(config.baseUrl) : name.trim(),
            baseUrl: config.baseUrl,
            apiKey: config.apiKey,
          )
        : existing.copyWith(
            name: (name == null || name.trim().isEmpty) ? null : name.trim(),
            apiKey: config.apiKey,
            clearApiKey: config.apiKey == null,
          );
    await _set(ServerProfiles(
      profiles: [for (final p in state.profiles) if (p.id != profile.id) p, profile],
      activeId: profile.id,
    ));
    return profile;
  }

  Future<void> activate(String id) => _set(ServerProfiles(profiles: state.profiles, activeId: id));

  Future<void> rename(String id, String name) => _set(ServerProfiles(
        profiles: [for (final p in state.profiles) p.id == id && name.trim().isNotEmpty ? p.copyWith(name: name.trim()) : p],
        activeId: state.activeId,
      ));

  /// Removes a server and the data stored for it on the device (keys ending
  /// in `:<id>`, e.g. its watch later list); if it was in use, the app goes
  /// back to server choice.
  Future<void> remove(String id) async {
    await _set(ServerProfiles(
      profiles: [for (final p in state.profiles) if (p.id != id) p],
      activeId: state.activeId == id ? null : state.activeId,
    ));
    final prefs = ref.read(sharedPreferencesProvider);
    for (final key in prefs.getKeys().where((k) => k.endsWith(':$id')).toList()) {
      await prefs.remove(key);
    }
  }

  /// Leaves the current server without deleting it (back to server choice).
  Future<void> deactivate() => _set(ServerProfiles(profiles: state.profiles));
}

final serverProfilesProvider = NotifierProvider<ServerProfilesNotifier, ServerProfiles>(ServerProfilesNotifier.new);

/// The server in use, or null when none is chosen.
final serverConfigProvider = Provider<ServerConfig?>((ref) => ref.watch(serverProfilesProvider).active?.config);

/// Id of the server in use; per-server data (watch later, caches) keys on it.
final activeServerIdProvider = Provider<String?>((ref) => ref.watch(serverProfilesProvider).activeId);

/// Auth headers for the current server, for image and video requests.
final authHeadersProvider = Provider<Map<String, String>>(
  (ref) => ref.watch(serverConfigProvider)?.authHeaders ?? const {},
);
