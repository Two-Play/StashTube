import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/server_config.dart';
import '../core/network/origin_guard.dart';
import 'models/list_queries.dart';
import 'repositories/stash_repository.dart';

/// The server hands out media URLs (screenshots, streams) on another origin
/// than the one the app connects to, typically Stash behind a reverse proxy
/// that doesn't forward the `Host` header or `X-Forwarded-Proto` (Stash
/// builds its URLs from them). Credentials only go to the configured origin
/// (`AuthHeaders.forUrl`), so such images and videos load without them and
/// fail on a server that needs a login.
@immutable
class MediaOriginMismatch {
  const MediaOriginMismatch({required this.server, required this.media});

  /// Where the app connects to, e.g. `https://stash.example`.
  final String server;

  /// Where the server's media URLs point, e.g. `http://stash.example`.
  final String media;

  @override
  bool operator ==(Object other) => other is MediaOriginMismatch && other.server == server && other.media == media;

  @override
  int get hashCode => Object.hash(server, media);
}

/// `scheme://host[:port]`, the port only when it isn't the scheme's default.
String originOf(Uri uri) => Uri(scheme: uri.scheme, host: uri.host, port: uri.hasPort ? uri.port : null).toString();

/// The mismatch between [baseUrl] and [mediaUrl], or null when they share
/// an origin (or either can't be read).
MediaOriginMismatch? mediaOriginMismatch(String baseUrl, String? mediaUrl) {
  final server = Uri.tryParse(baseUrl);
  final media = mediaUrl == null ? null : Uri.tryParse(mediaUrl);
  if (server == null || media == null || !media.hasScheme || media.host.isEmpty) return null;
  if (sameOrigin(server, media)) return null;
  return MediaOriginMismatch(server: originOf(server), media: originOf(media));
}

/// Checks one scene's media URLs against the active server's address; null
/// when they match, without credentials (nothing to lose) or when the check
/// fails (the lists show those errors). Once per server and session.
final mediaOriginMismatchProvider = FutureProvider<MediaOriginMismatch?>((ref) async {
  final config = ref.watch(serverConfigProvider);
  if (config == null || (config.authHeaders.isEmpty && !config.usesSession)) return null;
  final repo = ref.watch(stashRepositoryProvider);
  try {
    final scene = (await repo.findScenes(SceneQuery(), perPage: 1)).items.firstOrNull;
    if (scene == null) return null;
    return mediaOriginMismatch(config.baseUrl, scene.screenshotUrl ?? scene.streamUrl);
  } catch (_) {
    return null;
  }
}, retry: (_, _) => null);

/// The mismatch the user hid for the active server (stored per server as
/// its media origin): the hint shows again only for another mismatch.
class MediaOriginHintNotifier extends Notifier<String?> {
  static String _key(String serverId) => 'media_origin_hint_hidden:$serverId';

  @override
  String? build() {
    final id = ref.watch(activeServerIdProvider);
    return id == null ? null : ref.watch(sharedPreferencesProvider).getString(_key(id));
  }

  Future<void> hide(MediaOriginMismatch mismatch) async {
    final id = ref.read(activeServerIdProvider);
    if (id == null) return;
    state = mismatch.media;
    await ref.read(sharedPreferencesProvider).setString(_key(id), mismatch.media);
  }
}

final mediaOriginHintHiddenProvider =
    NotifierProvider<MediaOriginHintNotifier, String?>(MediaOriginHintNotifier.new);

/// The mismatch to warn about: found and not hidden by the user.
final mediaOriginWarningProvider = Provider<MediaOriginMismatch?>((ref) {
  final mismatch = ref.watch(mediaOriginMismatchProvider).value;
  if (mismatch == null || ref.watch(mediaOriginHintHiddenProvider) == mismatch.media) return null;
  return mismatch;
});
