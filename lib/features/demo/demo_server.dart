import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../core/config/server_config.dart';
import 'demo_library.dart';

/// A response of the demo server.
class DemoResponse {
  const DemoResponse(this.status, {this.body, this.contentType, this.headers = const {}});

  final int status;
  final Uint8List? body;
  final String? contentType;
  final Map<String, String> headers;
}

/// Answers requests like a Stash server, from the [DemoLibrary] and the
/// bundled media: `POST /graphql`, `/demo/<kind>/<file>` with byte ranges
/// (the player seeks), and the seek sprites' WebVTT under `/demo/vtt/`.
/// Independent of sockets, so tests can call it directly.
class DemoHandler {
  DemoHandler(this.library, this._load);

  final DemoLibrary library;

  /// Loads a file below `assets/demo/`, null when it doesn't exist.
  final Future<Uint8List?> Function(String path) _load;

  final _files = <String, Future<Uint8List?>>{};

  static const _types = {
    'mp4': 'video/mp4',
    'jpg': 'image/jpeg',
    'webp': 'image/webp',
    'vtt': 'text/vtt; charset=utf-8',
  };

  Future<DemoResponse> handle(String method, Uri uri, {String body = '', String? range}) async {
    final path = uri.path;
    if (path == '/graphql' && method == 'POST') {
      final Map<String, dynamic> request;
      try {
        request = jsonDecode(body) as Map<String, dynamic>;
      } on FormatException {
        return const DemoResponse(HttpStatus.badRequest);
      }
      final result = library.graphql.execute(
        request['query'] as String? ?? '',
        variables: request['variables'] as Map<String, dynamic>?,
        operationName: request['operationName'] as String?,
      );
      return DemoResponse(
        result.containsKey('errors') ? HttpStatus.unprocessableEntity : HttpStatus.ok,
        body: utf8.encode(jsonEncode(result)),
        contentType: 'application/json',
      );
    }
    if (method != 'GET' && method != 'HEAD') return const DemoResponse(HttpStatus.methodNotAllowed);
    if (!path.startsWith('/demo/') || path.contains('..')) return const DemoResponse(HttpStatus.notFound);
    final file = path.substring('/demo/'.length);
    final type = _types[file.split('.').last];

    if (file.startsWith('vtt/')) {
      final vtt = library.spriteVtt(file.substring('vtt/'.length).replaceAll(RegExp(r'\.vtt$'), ''));
      if (vtt == null) return const DemoResponse(HttpStatus.notFound);
      return DemoResponse(HttpStatus.ok, body: utf8.encode(vtt), contentType: type);
    }
    final bytes = await (_files[file] ??= _load(file));
    if (bytes == null) return const DemoResponse(HttpStatus.notFound);
    return _ranged(bytes, type, range);
  }

  /// The whole file, or the byte range a player asked for.
  static DemoResponse _ranged(Uint8List bytes, String? type, String? range) {
    final match = RegExp(r'^bytes=(\d*)-(\d*)$').firstMatch(range?.trim() ?? '');
    final headers = {'Accept-Ranges': 'bytes', 'Cache-Control': 'no-cache'};
    if (match == null) return DemoResponse(HttpStatus.ok, body: bytes, contentType: type, headers: headers);
    final length = bytes.length;
    final (from, to) = switch ((int.tryParse(match[1]!), int.tryParse(match[2]!))) {
      (null, final int suffix) => (length - suffix.clamp(0, length), length - 1),
      (final int start, final int? end) => (start, (end ?? length - 1).clamp(0, length - 1)),
      _ => (0, -1),
    };
    if (from >= length || from > to) {
      return DemoResponse(HttpStatus.requestedRangeNotSatisfiable, headers: {'Content-Range': 'bytes */$length'});
    }
    return DemoResponse(
      HttpStatus.partialContent,
      body: Uint8List.sublistView(bytes, from, to + 1),
      contentType: type,
      headers: {...headers, 'Content-Range': 'bytes $from-$to/$length'},
    );
  }
}

/// The built-in demo: a Stash look-alike on [ServerConfig.demoUrl] (the
/// loopback interface only) that serves [DemoLibrary], so the whole app
/// can be tried without a server, e.g. for the App Store review. Started
/// by the login's demo button, and in `main()` when a demo server is
/// saved. The app talks to it like to any Stash server.
class DemoServer {
  DemoServer._();

  static final instance = DemoServer._();

  HttpServer? _server;
  DemoHandler? _handler;
  Future<void>? _starting;
  AppLifecycleListener? _lifecycle;

  bool get isRunning => _server != null;

  /// Starts the server unless it runs already.
  Future<void> start() => _starting ??= _start().whenComplete(() => _starting = null);

  Future<void> _start() async {
    if (_server != null) return;
    _handler ??= await _createHandler();
    final uri = Uri.parse(ServerConfig.demoUrl);
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, uri.port);
    _server = server;
    server.listen(
      _serve,
      // iOS can take the socket away while the app is suspended.
      onError: (Object _) => _closed(server),
      onDone: () => _closed(server),
    );
    _lifecycle ??= AppLifecycleListener(onResume: () => unawaited(start().catchError((Object _) {})));
  }

  void _closed(HttpServer server) {
    if (_server == server) _server = null;
  }

  static Future<DemoHandler> _createHandler() async {
    final manifest = jsonDecode(await rootBundle.loadString('assets/demo/manifest.json')) as Map<String, dynamic>;
    final library = DemoLibrary(DemoMedia.fromJson(manifest))..baseUrl = ServerConfig.demoUrl;
    return DemoHandler(library, (path) async {
      try {
        final data = await rootBundle.load('assets/demo/$path');
        return Uint8List.sublistView(data);
      } catch (_) {
        return null;
      }
    });
  }

  Future<void> _serve(HttpRequest request) async {
    final response = request.response;
    try {
      final body = request.method == 'POST' ? await utf8.decodeStream(request) : '';
      final result = await _handler!.handle(
        request.method,
        request.uri,
        body: body,
        range: request.headers.value(HttpHeaders.rangeHeader),
      );
      response.statusCode = result.status;
      result.headers.forEach(response.headers.set);
      if (result.contentType case final type?) response.headers.set(HttpHeaders.contentTypeHeader, type);
      final bytes = result.body;
      response.contentLength = bytes?.length ?? 0;
      if (bytes != null && request.method != 'HEAD') response.add(bytes);
    } catch (_) {
      try {
        response.statusCode = HttpStatus.internalServerError;
      } on StateError {
        // Headers already sent.
      }
    }
    try {
      await response.close();
    } catch (_) {
      // The player hung up (it often does while seeking).
    }
  }
}
