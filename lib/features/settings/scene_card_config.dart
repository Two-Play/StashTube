import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/server_config.dart';
import '../../core/utils/picture_fit.dart';

/// Who a scene card names as its "channel".
enum CardChannel {
  /// The studio, else the performers.
  studio,

  /// The performers, else the studio.
  performers,
}

/// How a thumbnail shows a picture of another shape (a portrait scene in a
/// 16:9 card, a landscape scene in a 9:16 short tile).
enum ThumbnailFit {
  /// Whole on black, unless only a little would be cut off (pictureFit).
  whole,

  /// Always filled, cutting off what doesn't fit.
  fill,
}

/// What scene cards show under the thumbnail (13.8), and how thumbnails fit.
@immutable
class SceneCardConfig {
  const SceneCardConfig({
    this.channel = CardChannel.studio,
    this.showPlays = true,
    this.showRating = true,
    this.thumbnailFit = ThumbnailFit.whole,
  });

  final CardChannel channel;
  final bool showPlays;
  final bool showRating;
  final ThumbnailFit thumbnailFit;

  SceneCardConfig copyWith({CardChannel? channel, bool? showPlays, bool? showRating, ThumbnailFit? thumbnailFit}) =>
      SceneCardConfig(
        channel: channel ?? this.channel,
        showPlays: showPlays ?? this.showPlays,
        showRating: showRating ?? this.showRating,
        thumbnailFit: thumbnailFit ?? this.thumbnailFit,
      );

  @override
  bool operator ==(Object other) =>
      other is SceneCardConfig &&
      other.channel == channel &&
      other.showPlays == showPlays &&
      other.showRating == showRating &&
      other.thumbnailFit == thumbnailFit;

  @override
  int get hashCode => Object.hash(channel, showPlays, showRating, thumbnailFit);
}

/// Stored on the device for all servers.
class SceneCardConfigNotifier extends Notifier<SceneCardConfig> {
  static const _channelKey = 'scene_card_channel';
  static const _playsKey = 'scene_card_plays';
  static const _ratingKey = 'scene_card_rating';
  static const _fitKey = 'thumbnail_fit';

  @override
  SceneCardConfig build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    const defaults = SceneCardConfig();
    return SceneCardConfig(
      channel: CardChannel.values.asNameMap()[prefs.getString(_channelKey)] ?? defaults.channel,
      showPlays: prefs.getBool(_playsKey) ?? defaults.showPlays,
      showRating: prefs.getBool(_ratingKey) ?? defaults.showRating,
      thumbnailFit: ThumbnailFit.values.asNameMap()[prefs.getString(_fitKey)] ?? defaults.thumbnailFit,
    );
  }

  Future<void> set(SceneCardConfig config) async {
    state = config;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_channelKey, config.channel.name);
    await prefs.setBool(_playsKey, config.showPlays);
    await prefs.setBool(_ratingKey, config.showRating);
    await prefs.setString(_fitKey, config.thumbnailFit.name);
  }
}

final sceneCardConfigProvider =
    NotifierProvider<SceneCardConfigNotifier, SceneCardConfig>(SceneCardConfigNotifier.new);

/// How a thumbnail box of [boxAspect] shows a picture of [aspect],
/// following the setting ([ThumbnailFit]).
BoxFit thumbnailFit(WidgetRef ref, double? aspect, double boxAspect) =>
    ref.watch(sceneCardConfigProvider.select((c) => c.thumbnailFit)) == ThumbnailFit.fill
        ? BoxFit.cover
        : pictureFit(aspect, boxAspect);
