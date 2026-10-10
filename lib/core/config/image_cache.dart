import 'dart:async';

import 'package:flutter/painting.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Empties the image cache, e.g. when a server is removed: its thumbnails
/// must not stay on the device. Overridden in `main()` with
/// [clearDeviceImageCache]; does nothing elsewhere (tests have no cache).
final clearImageCacheProvider = Provider<void Function()>((ref) => () {});

/// Clears the images held in memory and the files `CachedNetworkImage`
/// keeps in the default cache manager. Best effort, and not awaited.
void clearDeviceImageCache() {
  PaintingBinding.instance.imageCache
    ..clear()
    ..clearLiveImages();
  unawaited(DefaultCacheManager().emptyCache().catchError((Object _) {}));
}
