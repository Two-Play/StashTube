import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/l10n.dart';

/// Opens a URL outside the app; true when it opened. Replaced in tests.
typedef UrlOpener = Future<bool> Function(Uri uri);

@visibleForTesting
UrlOpener urlOpener = (uri) => launchUrl(uri, mode: LaunchMode.externalApplication);

/// [url] as a web address to open: http(s) only, `https://` added when
/// it has no scheme (Stash keeps links as typed, e.g. `example.com/x`).
/// Null for anything else.
Uri? webUri(String url) {
  var text = url.trim();
  if (text.isEmpty) return null;
  if (!text.contains('://')) text = 'https://$text';
  final uri = Uri.tryParse(text);
  if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https') || uri.host.isEmpty) return null;
  return uri;
}

/// Opens [url] in the browser (or the app that handles it), outside
/// StashTube; shows a snack bar when that fails.
Future<bool> openExternalUrl(BuildContext context, String url) async {
  final l = context.l10n;
  final messenger = ScaffoldMessenger.maybeOf(context);
  final uri = webUri(url);
  var opened = false;
  if (uri != null) {
    try {
      opened = await urlOpener(uri);
    } catch (_) {
      opened = false;
    }
  }
  if (!opened) {
    messenger
      ?..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l.openLinkFailed(url))));
  }
  return opened;
}

/// The page of scene [sceneId] in Stash's web interface on the server at
/// [baseUrl]. Never carries the API key: the browser signs in by itself.
String stashSceneWebUrl(String baseUrl, String sceneId) {
  final base = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
  return '$base/scenes/${Uri.encodeComponent(sceneId)}';
}
