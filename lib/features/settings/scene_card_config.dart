import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/server_config.dart';

/// Who a scene card names as its "channel".
enum CardChannel {
  /// The studio, else the performers.
  studio,

  /// The performers, else the studio.
  performers,
}

/// What scene cards show under the thumbnail (13.8).
@immutable
class SceneCardConfig {
  const SceneCardConfig({this.channel = CardChannel.studio, this.showPlays = true, this.showRating = true});

  final CardChannel channel;
  final bool showPlays;
  final bool showRating;

  SceneCardConfig copyWith({CardChannel? channel, bool? showPlays, bool? showRating}) => SceneCardConfig(
        channel: channel ?? this.channel,
        showPlays: showPlays ?? this.showPlays,
        showRating: showRating ?? this.showRating,
      );

  @override
  bool operator ==(Object other) =>
      other is SceneCardConfig &&
      other.channel == channel &&
      other.showPlays == showPlays &&
      other.showRating == showRating;

  @override
  int get hashCode => Object.hash(channel, showPlays, showRating);
}

/// Stored on the device for all servers.
class SceneCardConfigNotifier extends Notifier<SceneCardConfig> {
  static const _channelKey = 'scene_card_channel';
  static const _playsKey = 'scene_card_plays';
  static const _ratingKey = 'scene_card_rating';

  @override
  SceneCardConfig build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    const defaults = SceneCardConfig();
    return SceneCardConfig(
      channel: CardChannel.values.asNameMap()[prefs.getString(_channelKey)] ?? defaults.channel,
      showPlays: prefs.getBool(_playsKey) ?? defaults.showPlays,
      showRating: prefs.getBool(_ratingKey) ?? defaults.showRating,
    );
  }

  Future<void> set(SceneCardConfig config) async {
    state = config;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_channelKey, config.channel.name);
    await prefs.setBool(_playsKey, config.showPlays);
    await prefs.setBool(_ratingKey, config.showRating);
  }
}

final sceneCardConfigProvider =
    NotifierProvider<SceneCardConfigNotifier, SceneCardConfig>(SceneCardConfigNotifier.new);
