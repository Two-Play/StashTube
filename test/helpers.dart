import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:stash_app_mobile/core/config/server_config.dart';

/// A server in use, for tests that don't care which one: per-server state
/// (watch later, caches) and the lists depend on it.
final List<Override> testServer = [
  activeServerIdProvider.overrideWithValue('test-server'),
  serverConfigProvider.overrideWithValue(const ServerConfig(baseUrl: 'http://test')),
];
