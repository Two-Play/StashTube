import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/features/settings/scene_card_config.dart';

/// A server in use, for tests that don't care which one: per-server state
/// (watch later, caches) and the lists depend on it. Scene cards get the
/// default card settings, so these tests don't need SharedPreferences.
final List<Override> testServer = [
  ...testServerOnly,
  sceneCardConfigProvider.overrideWith(_DefaultCardConfig.new),
];

/// [testServer] without the card settings, for tests that set their own.
final List<Override> testServerOnly = [
  activeServerIdProvider.overrideWithValue('test-server'),
  serverConfigProvider.overrideWithValue(const ServerConfig(baseUrl: 'http://test')),
];

class _DefaultCardConfig extends SceneCardConfigNotifier {
  @override
  SceneCardConfig build() => const SceneCardConfig();
}
