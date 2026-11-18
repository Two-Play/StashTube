import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Headers that carry the server's credentials: never sent to another
/// origin (another scheme, host or port), e.g. a media URL the server
/// returned that points elsewhere, or a redirect away from the server.
const credentialHeaders = {'apikey', 'cookie', 'authorization', 'proxy-authorization'};

/// Whether [a] and [b] have the same scheme, host and port (the port
/// counts with its default, so `https://s` and `https://s:443` match).
bool sameOrigin(Uri a, Uri b) =>
    a.scheme.toLowerCase() == b.scheme.toLowerCase() &&
    a.host.toLowerCase() == b.host.toLowerCase() &&
    a.port == b.port;

/// The URL mpv actually fetches for [url]: an EDL clip (`edl://%<len>%<url>,…`,
/// see `Short.playbackUrl`) wraps the stream's URL.
@visibleForTesting
Uri? fetchedUri(String url) {
  final edl = RegExp(r'^edl://%(\d+)%').firstMatch(url);
  if (edl == null) return Uri.tryParse(url);
  final bytes = utf8.encode(url.substring(edl.end));
  final length = int.parse(edl.group(1)!);
  if (length > bytes.length) return null;
  return Uri.tryParse(utf8.decode(bytes.sublist(0, length), allowMalformed: true));
}

/// The active server's credential headers (API key or session cookie),
/// bound to the server's origin: [forUrl] gives them only for URLs on the
/// server itself, so a scene, image or stream URL pointing elsewhere never
/// gets them.
@immutable
class AuthHeaders {
  const AuthHeaders(this.origin, this.headers);

  /// No server, or no credentials.
  static const none = AuthHeaders(null, {});

  final Uri? origin;
  final Map<String, String> headers;

  /// The headers to send with a request to [url]: all of them on the
  /// server's origin, none elsewhere.
  Map<String, String> forUrl(String url) {
    final origin = this.origin;
    if (headers.isEmpty || origin == null) return const {};
    final uri = fetchedUri(url);
    return uri != null && sameOrigin(uri, origin) ? headers : const {};
  }

  @override
  bool operator ==(Object other) => other is AuthHeaders && other.origin == origin && mapEquals(other.headers, headers);

  @override
  int get hashCode => Object.hash(origin, Object.hashAllUnordered(headers.entries.map((e) => (e.key, e.value))));
}

/// Keeps credentials on their origin: drops the [credentialHeaders] of a
/// request that doesn't go to [origin] (when given), and follows redirects
/// itself, dropping them as soon as a redirect leaves the origin the request
/// started on. `dart:io` would forward a custom header such as `ApiKey` to
/// whatever host a redirect names.
class OriginGuardClient extends http.BaseClient {
  OriginGuardClient(this._inner, {this.origin});

  final http.Client _inner;

  /// The only origin credentials may go to; null: the request's own.
  final Uri? origin;

  static const _redirects = {301, 302, 303, 307, 308};

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final allowed = origin ?? request.url;
    if (!sameOrigin(request.url, allowed)) _strip(request.headers);
    // Only plain requests can be sent again; others don't follow redirects.
    if (request is! http.Request || !request.followRedirects) {
      request.followRedirects = false;
      return _inner.send(request);
    }

    var current = request;
    for (var hops = 0;; hops++) {
      final next = _copy(current)..followRedirects = false;
      final response = await _inner.send(next);
      final location = response.headers['location'];
      if (!_redirects.contains(response.statusCode) || location == null) return response;
      if (hops >= request.maxRedirects) {
        await response.stream.drain<void>();
        throw http.ClientException('Redirect limit exceeded', request.url);
      }
      await response.stream.drain<void>();
      final target = current.url.resolve(location);
      // 303, and 301/302 after a POST, continue as GET without a body, like browsers.
      final keepMethod = response.statusCode == 307 ||
          response.statusCode == 308 ||
          (current.method == 'GET' || current.method == 'HEAD');
      final redirected = http.Request(keepMethod ? current.method : 'GET', target)
        ..headers.addAll(current.headers)
        ..maxRedirects = request.maxRedirects
        ..persistentConnection = request.persistentConnection;
      if (keepMethod) {
        redirected.bodyBytes = current.bodyBytes;
      } else {
        redirected.headers.removeWhere((k, _) => k.toLowerCase() == 'content-type');
      }
      if (!sameOrigin(target, allowed)) _strip(redirected.headers);
      current = redirected;
    }
  }

  static void _strip(Map<String, String> headers) =>
      headers.removeWhere((key, _) => credentialHeaders.contains(key.toLowerCase()));

  static http.Request _copy(http.Request request) => http.Request(request.method, request.url)
    ..headers.addAll(request.headers)
    ..bodyBytes = request.bodyBytes
    ..maxRedirects = request.maxRedirects
    ..persistentConnection = request.persistentConnection;

  @override
  void close() => _inner.close();
}
