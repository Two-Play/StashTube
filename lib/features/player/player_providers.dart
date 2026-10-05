import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:miniplayer/miniplayer.dart';

import '../../core/config/server_config.dart';
import '../../data/models/scene.dart';

const double kMiniPlayerHeight = 64;

/// One player for the whole app, so playback survives expanding/collapsing
/// the miniplayer and navigating between tabs.
final playerProvider = Provider<Player>((ref) {
  final player = Player();
  ref.onDispose(player.dispose);
  return player;
});

final videoControllerProvider = Provider<VideoController>(
  (ref) => VideoController(ref.watch(playerProvider)),
);

final miniplayerControllerProvider = Provider<MiniplayerController>((ref) {
  final controller = MiniplayerController();
  ref.onDispose(controller.dispose);
  return controller;
});

/// Current miniplayer height in pixels; drives the bottom navigation bar.
final miniplayerHeightProvider = Provider<ValueNotifier<double>>((ref) {
  final notifier = ValueNotifier<double>(kMiniPlayerHeight);
  ref.onDispose(notifier.dispose);
  return notifier;
});

/// The scene in the player, or null when the player is closed.
class NowPlayingNotifier extends Notifier<Scene?> {
  @override
  Scene? build() => null;

  void play(Scene scene) {
    final url = scene.streamUrl;
    if (url == null) return;

    if (state == null) ref.read(miniplayerHeightProvider).value = kMiniPlayerHeight;
    if (state?.id != scene.id) {
      ref.read(playerProvider).open(Media(url, httpHeaders: ref.read(authHeadersProvider)));
    }
    state = scene;
    // On first play the miniplayer is only mounted in the next frame.
    WidgetsBinding.instance.addPostFrameCallback((_) => expand());
  }

  void expand() => ref.read(miniplayerControllerProvider).animateToHeight(state: PanelState.MAX);

  void collapse() => ref.read(miniplayerControllerProvider).animateToHeight(state: PanelState.MIN);

  void close() {
    ref.read(playerProvider).stop();
    state = null;
  }
}

final nowPlayingProvider = NotifierProvider<NowPlayingNotifier, Scene?>(NowPlayingNotifier.new);
