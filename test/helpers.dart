import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:stash_app_mobile/core/config/server_config.dart';

/// Per-server state (watch later, caches) needs a server in use; tests that
/// don't care which one use this.
final Override testServer = activeServerIdProvider.overrideWithValue('test-server');
