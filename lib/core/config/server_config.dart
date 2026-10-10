import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'image_cache.dart';
import 'secret_store.dart';

/// Overridden in `main()` with the instance loaded before `runApp`.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('sharedPreferencesProvider must be overridden'),
);

class ServerConfig {
  const ServerConfig({required this.baseUrl, this.apiKey, this.username, this.password});

  /// Server root without trailing slash, e.g. `http://192.168.1.5:9999`.
  final String baseUrl;
  final String? apiKey;

  /// Stash login (2.7), as an alternative to the API key: the app signs in
  /// for a session cookie (`StashSession`).
  final String? username;
  final String? password;

  bool get hasCredentials => (username?.isNotEmpty ?? false) && (password?.isNotEmpty ?? false);

  /// Signs in for a session cookie: with a login and no API key, which
  /// would be enough on its own.
  bool get usesSession => hasCredentials && (apiKey?.isEmpty ?? true);

  String get graphqlEndpoint => '$baseUrl/graphql';

  // Value equality: an unchanged config must not rebuild the API client.
  @override
  bool operator ==(Object other) =>
      other is ServerConfig &&
      other.baseUrl == baseUrl &&
      other.apiKey == apiKey &&
      other.username == username &&
      other.password == password;

  @override
  int get hashCode => Object.hash(baseUrl, apiKey, username, password);

  /// The API key header for every request to the server: GraphQL, images,
  /// streams. A login's session cookie comes from `authHeadersProvider`.
  Map<String, String> get authHeaders {
    final key = apiKey;
    return key == null || key.isEmpty ? const {} : {'ApiKey': key};
  }

  /// True for plain HTTP to a server outside the home network: the API key
  /// and everything watched would cross the internet unencrypted.
  bool get isUnencryptedOverInternet {
    final uri = Uri.tryParse(baseUrl);
    return uri != null && uri.scheme == 'http' && !isLocalHost(uri.host);
  }

  /// The port Stash listens on unless configured otherwise.
  static const stashPort = 9999;

  /// The addresses to try for [input], best guess first: without a port,
  /// also with Stash's default [stashPort] (first for http://, as Stash
  /// usually runs there; second for https://, usually a proxy on 443).
  /// Empty if [input] is no usable address.
  static List<String> candidateUrls(String input) {
    final url = normalizeUrl(input);
    if (url == null) return const [];
    final uri = Uri.parse(url);
    if (uri.hasPort) return [url];
    final withPort = uri.replace(port: stashPort).toString();
    return uri.scheme == 'http' ? [withPort, url] : [url, withPort];
  }

  /// Normalizes user input. Returns null when [input] is not an http(s) URL.
  /// Without a scheme it gets `http://`; query and fragment are dropped.
  static String? normalizeUrl(String input) {
    var url = input.trim();
    if (url.isEmpty) return null;
    if (!url.contains('://')) url = 'http://$url';
    final parsed = Uri.tryParse(url);
    if (parsed == null || !parsed.hasScheme || parsed.host.isEmpty) return null;
    if (parsed.scheme != 'http' && parsed.scheme != 'https') return null;
    url = Uri(
      scheme: parsed.scheme,
      userInfo: parsed.userInfo,
      host: parsed.host,
      port: parsed.hasPort ? parsed.port : null,
      path: parsed.path,
    ).toString();
    while (url.endsWith('/')) {
      url = url.substring(0, url.length - 1);
    }
    if (url.endsWith('/graphql')) url = url.substring(0, url.length - '/graphql'.length);
    return url;
  }

  /// Whether [host] is in the local network or a VPN: a private or loopback
  /// address, or a name that only resolves there (`nas`, `stash.local`,
  /// Tailscale's `*.ts.net`, ...).
  static bool isLocalHost(String host) {
    final h = host.toLowerCase();
    try {
      final ip = Uri.parseIPv4Address(h);
      return ip[0] == 10 ||
          ip[0] == 127 ||
          (ip[0] == 169 && ip[1] == 254) ||
          (ip[0] == 172 && ip[1] >= 16 && ip[1] <= 31) ||
          (ip[0] == 192 && ip[1] == 168) ||
          // Carrier-grade NAT range, used by VPNs such as Tailscale.
          (ip[0] == 100 && ip[1] >= 64 && ip[1] <= 127);
    } on FormatException {
      // Not an IPv4 address.
    }
    if (h.contains(':')) {
      try {
        final ip = Uri.parseIPv6Address(h);
        final loopback = ip.take(15).every((b) => b == 0) && ip[15] == 1;
        final uniqueLocal = ip[0] & 0xfe == 0xfc;
        final linkLocal = ip[0] == 0xfe && ip[1] & 0xc0 == 0x80;
        return loopback || uniqueLocal || linkLocal;
      } on FormatException {
        return false;
      }
    }
    if (!h.contains('.')) return true;
    const localSuffixes = ['.local', '.lan', '.home', '.internal', '.home.arpa', '.localhost', '.ts.net'];
    return localSuffixes.any(h.endsWith);
  }
}

/// A saved Stash server (2.6). Its API key and password live in the
/// [SecretStore] (2.5), not in the stored JSON.
@immutable
class ServerProfile {
  const ServerProfile({
    required this.id,
    required this.name,
    required this.baseUrl,
    this.apiKey,
    this.username,
    this.password,
  });

  final String id;
  final String name;
  final String baseUrl;
  final String? apiKey;
  final String? username;
  final String? password;

  ServerConfig get config => ServerConfig(baseUrl: baseUrl, apiKey: apiKey, username: username, password: password);

  /// A readable default name: host and port of the URL.
  static String defaultName(String baseUrl) {
    final uri = Uri.tryParse(baseUrl);
    if (uri == null || uri.host.isEmpty) return baseUrl;
    return uri.hasPort ? '${uri.host}:${uri.port}' : uri.host;
  }

  ServerProfile copyWith({String? name, String? baseUrl}) => ServerProfile(
        id: id,
        name: name ?? this.name,
        baseUrl: baseUrl ?? this.baseUrl,
        apiKey: apiKey,
        username: username,
        password: password,
      );

  /// This profile with the credentials of [config].
  ServerProfile withAuth(ServerConfig config) => ServerProfile(
        id: id,
        name: name,
        baseUrl: config.baseUrl,
        apiKey: config.apiKey,
        username: config.username,
        password: config.password,
      );

  static String apiKeySecret(String id) => 'api_key:$id';
  static String passwordSecret(String id) => 'password:$id';

  /// Without the secrets.
  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'url': baseUrl, if (username != null) 'username': username};

  /// Null for an entry that can't be read. Versions before 2.5 stored the
  /// API key in the JSON; it is moved to the secret store on load.
  static ServerProfile? tryFromJson(Map<String, dynamic> json, SecretStore secrets) {
    final id = json['id'];
    final url = json['url'];
    final name = json['name'];
    final legacyKey = json['apiKey'];
    final username = json['username'];
    if (id is! String || id.isEmpty || url is! String || url.isEmpty) return null;
    return ServerProfile(
      id: id,
      name: name is String && name.isNotEmpty ? name : defaultName(url),
      baseUrl: url,
      apiKey: secrets.read(apiKeySecret(id)) ?? (legacyKey is String ? legacyKey : null),
      username: username is String ? username : null,
      password: secrets.read(passwordSecret(id)),
    );
  }
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

  /// Lists that were stored for the one server of older versions, now kept
  /// per server as `<key>:<serverId>`.
  static const _legacyListKeys = ['watch_later', 'search_history'];

  SecretStore get _secrets => ref.read(secretStoreProvider);

  @override
  ServerProfiles build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final raw = prefs.getString(_profilesKey);
    if (raw != null) {
      final json = _decode(raw);
      final profiles = ServerProfiles(
        profiles: [for (final p in json) ?ServerProfile.tryFromJson(p, _secrets)],
        activeId: prefs.getString(_activeKey),
      );
      // Move API keys of older versions out of the preferences.
      if (json.any((p) => p.containsKey('apiKey'))) _persist(profiles);
      _moveLegacyLists(prefs, profiles.profiles.firstOrNull?.id);
      return profiles;
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
    _moveLegacyLists(prefs, profile.id);
    return migrated;
  }

  /// The stored profiles; empty when the JSON is damaged, which leads back
  /// to the login instead of crashing at every start.
  static List<Map<String, dynamic>> _decode(String raw) {
    try {
      final json = jsonDecode(raw);
      return json is List ? json.whereType<Map<String, dynamic>>().toList() : const [];
    } on FormatException {
      return const [];
    }
  }

  /// Gives the lists of the single-server versions to [serverId] (unless it
  /// already has its own) and removes the old keys, so they don't show up
  /// on every other server.
  ///
  /// The writes start right away (SharedPreferences updates its cache
  /// synchronously), so providers built next already see the moved lists.
  static Future<void> _moveLegacyLists(SharedPreferences prefs, String? serverId) {
    final writes = <Future<bool>>[];
    for (final key in _legacyListKeys) {
      final list = prefs.getStringList(key);
      if (list == null) continue;
      if (serverId != null && prefs.getStringList('$key:$serverId') == null) {
        writes.add(prefs.setStringList('$key:$serverId', list));
      }
      writes.add(prefs.remove(key));
    }
    return Future.wait(writes);
  }

  static String _newId() => '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(1 << 20)}';

  Future<void> _persist(ServerProfiles value) async {
    final prefs = ref.read(sharedPreferencesProvider);
    // Secrets first: the JSON without them must not be stored before them.
    for (final p in value.profiles) {
      await _secrets.write(ServerProfile.apiKeySecret(p.id), p.apiKey);
      await _secrets.write(ServerProfile.passwordSecret(p.id), p.password);
    }
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
            username: config.username,
            password: config.password,
          )
        : existing.withAuth(config).copyWith(name: (name == null || name.trim().isEmpty) ? null : name.trim());
    await _set(ServerProfiles(
      profiles: [for (final p in state.profiles) if (p.id != profile.id) p, profile],
      activeId: profile.id,
    ));
    return profile;
  }

  /// Changes a saved server's URL, credentials and name. Keeps its id, so
  /// the data stored for it (watch later, settings) stays.
  Future<void> update(String id, ServerConfig config, {String? name}) => _set(ServerProfiles(
        profiles: [
          for (final p in state.profiles)
            p.id == id ? p.withAuth(config).copyWith(name: (name == null || name.trim().isEmpty) ? null : name.trim()) : p,
        ],
        activeId: state.activeId,
      ));

  Future<void> activate(String id) => _set(ServerProfiles(profiles: state.profiles, activeId: id));

  Future<void> rename(String id, String name) => _set(ServerProfiles(
        profiles: [for (final p in state.profiles) p.id == id && name.trim().isNotEmpty ? p.copyWith(name: name.trim()) : p],
        activeId: state.activeId,
      ));

  /// Removes a server and the data stored for it on the device (keys ending
  /// in `:<id>`, e.g. its watch later list, its secrets and the cached
  /// images); if it was in use, the app goes back to server choice.
  Future<void> remove(String id) async {
    final clearImages = ref.read(clearImageCacheProvider);
    await _set(ServerProfiles(
      profiles: [for (final p in state.profiles) if (p.id != id) p],
      activeId: state.activeId == id ? null : state.activeId,
    ));
    final prefs = ref.read(sharedPreferencesProvider);
    for (final key in prefs.getKeys().where((k) => k.endsWith(':$id')).toList()) {
      await prefs.remove(key);
    }
    await _secrets.deleteWhere((k) => k.endsWith(':$id'));
    clearImages();
  }

  /// Leaves the current server without deleting it (back to server choice).
  Future<void> deactivate() => _set(ServerProfiles(profiles: state.profiles));
}

final serverProfilesProvider = NotifierProvider<ServerProfilesNotifier, ServerProfiles>(ServerProfilesNotifier.new);

/// The server in use, or null when none is chosen.
final serverConfigProvider = Provider<ServerConfig?>((ref) => ref.watch(serverProfilesProvider).active?.config);

/// Id of the server in use; per-server data (watch later, caches) keys on it.
final activeServerIdProvider = Provider<String?>((ref) => ref.watch(serverProfilesProvider).activeId);

