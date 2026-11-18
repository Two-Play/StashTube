import 'dart:async';

import 'package:flutter/painting.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../network/origin_guard.dart';

/// The cache behind every `CachedNetworkImage` of server images: the
/// default cache's files and limits, but its downloads go through an
/// [OriginGuardClient], so a redirect away from the server doesn't take
/// the API key or session cookie along. Pass it as `cacheManager` to every
/// cached image; `DefaultCacheManager` itself must not be used next to it
/// (same key, same files).
final stashImageCacheManager = CacheManager(
  Config(DefaultCacheManager.key, fileService: HttpFileService(httpClient: OriginGuardClient(http.Client()))),
);

/// Empties the image cache, e.g. when a server is removed: its thumbnails
/// must not stay on the device. Overridden in `main()` with
/// [clearDeviceImageCache]; does nothing elsewhere (tests have no cache).
final clearImageCacheProvider = Provider<void Function()>((ref) => () {});

/// Clears the images held in memory and the files of
/// [stashImageCacheManager]. Best effort, and not awaited.
void clearDeviceImageCache() {
  PaintingBinding.instance.imageCache
    ..clear()
    ..clearLiveImages();
  unawaited(stashImageCacheManager.emptyCache().catchError((Object _) {}));
}
