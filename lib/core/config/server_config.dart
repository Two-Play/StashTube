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

class ServerConfigNotifier extends Notifier<ServerConfig?> {
  // `url` is the key used by earlier versions of the app, kept so existing
  // installs stay logged in.
  static const _urlKey = 'url';
  static const _apiKeyKey = 'api_key';

  @override
  ServerConfig? build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final url = prefs.getString(_urlKey);
    if (url == null || url.isEmpty) return null;
    return ServerConfig(baseUrl: url, apiKey: prefs.getString(_apiKeyKey));
  }

  Future<void> save(ServerConfig config) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_urlKey, config.baseUrl);
    final key = config.apiKey;
    if (key == null || key.isEmpty) {
      await prefs.remove(_apiKeyKey);
    } else {
      await prefs.setString(_apiKeyKey, key);
    }
    state = config;
  }

  Future<void> clear() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.remove(_urlKey);
    await prefs.remove(_apiKeyKey);
    state = null;
  }
}

final serverConfigProvider =
    NotifierProvider<ServerConfigNotifier, ServerConfig?>(ServerConfigNotifier.new);

/// Auth headers for the current server, for image and video requests.
final authHeadersProvider = Provider<Map<String, String>>(
  (ref) => ref.watch(serverConfigProvider)?.authHeaders ?? const {},
);
