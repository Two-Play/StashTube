import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../core/config/server_config.dart';
import 'stash_repository.dart';

/// Stash's session cookie after signing in (2.7).
class StashSessionCookie {
  const StashSessionCookie(this.value, {this.expires});

  final String value;

  /// From the cookie's `Max-Age`; null when the server sent none.
  final DateTime? expires;

  String get header => 'session=$value';
}

/// Signs in with [config]'s username and password the way Stash's login
/// page does (`POST /login`). Stash answers a valid login with a redirect
/// and a `session` cookie, a wrong one with the login page again.
Future<StashSessionCookie> stashLogin(http.Client client, ServerConfig config, {DateTime Function()? now}) async {
  final request = http.Request('POST', Uri.parse('${config.baseUrl}/login'))
    ..followRedirects = false
    ..bodyFields = {'username': config.username ?? '', 'password': config.password ?? ''};
  final http.StreamedResponse response;
  try {
    response = await client.send(request);
    await response.stream.drain<void>();
  } catch (e) {
    throw StashApiException('Could not reach the server: $e',
        isNetworkError: true, kind: StashErrorKind.unreachable, detail: '$e');
  }
  return parseSessionCookie(response.headers['set-cookie'] ?? '', now: now) ??
      (throw const StashApiException('Invalid username or password.', kind: StashErrorKind.invalidCredentials));
}

/// The `session` cookie in a `Set-Cookie` header (several cookies are
/// joined by commas), or null.
StashSessionCookie? parseSessionCookie(String setCookie, {DateTime Function()? now}) {
  final match = RegExp(r'(?:^|[,\s])session=([^;,\s]+)').firstMatch(setCookie);
  if (match == null) return null;
  // The attributes of this cookie: up to the next cookie ("…, name=").
  final rest = setCookie.substring(match.end);
  final end = RegExp(r',\s*[^\s;=,]+=').firstMatch(rest)?.start ?? rest.length;
  final maxAge = RegExp(r'Max-Age=(\d+)', caseSensitive: false).firstMatch(rest.substring(0, end));
  return StashSessionCookie(
    match.group(1)!,
    expires: maxAge == null ? null : (now ?? DateTime.now)().add(Duration(seconds: int.parse(maxAge.group(1)!))),
  );
}

/// The session cookie of the active server, when it signs in with a
/// username and password instead of an API key; null otherwise or before
/// the first request.
class StashSessionNotifier extends Notifier<StashSessionCookie?> {
  /// Renewed this long before it expires, so a stream opened with it
  /// doesn't lose it right away.
  static const renewBefore = Duration(minutes: 10);

  Future<StashSessionCookie?>? _pending;

  /// Injectable for tests.
  @visibleForTesting
  http.Client Function() createClient = http.Client.new;
  @visibleForTesting
  DateTime Function() now = DateTime.now;

  @override
  StashSessionCookie? build() {
    ref.watch(serverConfigProvider);
    _pending = null;
    return null;
  }

  /// A valid cookie, signing in first when there is none or it is about to
  /// expire; null when the server doesn't use a session.
  Future<StashSessionCookie?> ensure() async {
    final config = ref.read(serverConfigProvider);
    if (config == null || !config.usesSession) return null;
    final cookie = state;
    final expires = cookie?.expires;
    if (cookie != null && (expires == null || expires.isAfter(now().add(renewBefore)))) return cookie;
    return renew();
  }

  /// Signs in again, e.g. after the server rejected the cookie. Concurrent
  /// calls share one login.
  Future<StashSessionCookie?> renew() => _pending ??= _login().whenComplete(() => _pending = null);

  Future<StashSessionCookie?> _login() async {
    final config = ref.read(serverConfigProvider);
    if (config == null || !config.usesSession) return null;
    final client = createClient();
    try {
      final cookie = await stashLogin(client, config, now: now);
      // Another server or changed credentials meanwhile.
      if (!ref.mounted || ref.read(serverConfigProvider) != config) return null;
      state = cookie;
      return cookie;
    } finally {
      client.close();
    }
  }
}

final stashSessionProvider = NotifierProvider<StashSessionNotifier, StashSessionCookie?>(StashSessionNotifier.new);

/// Sends the session cookie with every request and, when the server
/// answers 401, signs in again and repeats the request once.
class StashSessionClient extends http.BaseClient {
  StashSessionClient(this._inner, {required this.ensure, required this.renew});

  final http.Client _inner;
  final Future<StashSessionCookie?> Function() ensure;
  final Future<StashSessionCookie?> Function() renew;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final cookie = await ensure();
    if (cookie == null) return _inner.send(request);

    // Copied before sending: a sent request can't be sent again.
    final retry = request is http.Request ? _copy(request) : null;
    request.headers['Cookie'] = cookie.header;
    final response = await _inner.send(request);
    if (response.statusCode != 401 || retry == null) return response;

    await response.stream.drain<void>();
    final renewed = await renew();
    if (renewed == null) return _inner.send(retry);
    retry.headers['Cookie'] = renewed.header;
    return _inner.send(retry);
  }

  static http.Request _copy(http.Request request) => http.Request(request.method, request.url)
    ..headers.addAll(request.headers)
    ..bodyBytes = request.bodyBytes
    ..followRedirects = request.followRedirects
    ..maxRedirects = request.maxRedirects
    ..persistentConnection = request.persistentConnection;

  @override
  void close() => _inner.close();
}

/// The HTTP client for the active server's GraphQL API and files: adds the
/// session cookie where needed (the API key is a default header).
final stashHttpClientProvider = Provider<http.Client>((ref) {
  ref.watch(serverConfigProvider);
  final client = StashSessionClient(
    http.Client(),
    ensure: () => ref.read(stashSessionProvider.notifier).ensure(),
    renew: () => ref.read(stashSessionProvider.notifier).renew(),
  );
  ref.onDispose(client.close);
  return client;
});

/// Auth headers for the current server, for image and video requests:
/// the API key, or the session cookie once signed in.
final authHeadersProvider = Provider<Map<String, String>>((ref) {
  final headers = ref.watch(serverConfigProvider)?.authHeaders ?? const {};
  final cookie = ref.watch(stashSessionProvider);
  return cookie == null ? headers : {...headers, 'Cookie': cookie.header};
});
