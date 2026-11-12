import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart' show BoxFit;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';

import 'player_providers.dart';

/// Pinch zoom of the player's video (4.22): a scale plus a pan, both
/// relative to the video, so it looks the same in the small player and in
/// fullscreen. Rendered by mpv (`video-zoom`, `video-pan-x/y`), so the
/// controls on top keep their size.
@immutable
class VideoZoom {
  const VideoZoom({this.scale = 1, this.panX = 0, this.panY = 0, this.fill = false});

  static const none = VideoZoom();
  static const maxScale = 4.0;

  /// Below this a pinch snaps back to no zoom.
  static const snapBack = 1.05;

  final double scale;

  /// Shift of the video in fractions of its scaled size (mpv's unit).
  final double panX;
  final double panY;

  /// Set by the "fill" button: the video covers its whole box (the `Video`
  /// widget's `BoxFit.cover`, [fillFit]) instead of fitting inside it, so the
  /// black bars go. Kept across fullscreen, turning and other scenes; the
  /// pinch zoom works on top of it.
  final bool fill;

  /// The `Video` widget's fit for a [fill] setting.
  static BoxFit fillFit(bool fill) => fill ? BoxFit.cover : BoxFit.contain;

  bool get isZoomed => scale > 1;

  /// The zoom after a pinch that started at [startFocal] with this zoom and
  /// is now at [focal] with the fingers [factor] times as far apart, in a
  /// video box of [box]. The point under the fingers stays under them, and
  /// the video always covers the box.
  VideoZoom pinch({required double factor, required Offset startFocal, required Offset focal, required Size box}) {
    final center = box.center(Offset.zero);
    final newScale = (scale * factor).clamp(1.0, maxScale);
    // Pan as a translation of the video's center, in box pixels.
    final start = Offset(panX * box.width * scale, panY * box.height * scale);
    // The video point under the fingers when the pinch started...
    final point = (startFocal - center - start) / scale;
    // ...is moved to where the fingers are now.
    final translation = focal - center - point * newScale;
    final maxX = box.width * (newScale - 1) / 2;
    final maxY = box.height * (newScale - 1) / 2;
    return VideoZoom(
      scale: newScale,
      panX: translation.dx.clamp(-maxX, maxX) / (box.width * newScale),
      panY: translation.dy.clamp(-maxY, maxY) / (box.height * newScale),
      fill: fill,
    );
  }

  /// What a pinch ends with: no zoom when barely zoomed.
  VideoZoom settled() => scale < snapBack ? VideoZoom(fill: fill) : this;

  @override
  bool operator ==(Object other) =>
      other is VideoZoom && other.scale == scale && other.panX == panX && other.panY == panY && other.fill == fill;

  @override
  int get hashCode => Object.hash(scale, panX, panY, fill);
}

/// The current zoom; kept until the user zooms out or another scene starts
/// (`NowPlayingNotifier.play` resets it, as mpv keeps it across files).
class VideoZoomNotifier extends Notifier<VideoZoom> {
  @override
  VideoZoom build() => VideoZoom.none;

  void set(VideoZoom zoom) {
    if (zoom == state) return;
    state = zoom;
    _apply(ref.read(playerProvider), zoom);
  }

  void reset() => set(VideoZoom.none);

  /// The fill button: the video covers its box, or fits inside it again.
  void toggleFill() => set(VideoZoom(scale: state.scale, panX: state.panX, panY: state.panY, fill: !state.fill));

  /// Another scene: no pinch zoom, but the fill stays.
  void resetZoom() => set(VideoZoom(fill: state.fill));

  static void _apply(Player player, VideoZoom zoom) {
    final platform = player.platform;
    if (platform is! NativePlayer) return;
    // mpv's zoom is a power of two.
    platform.setProperty('video-zoom', '${math.log(zoom.scale) / math.ln2}');
    platform.setProperty('video-pan-x', '${zoom.panX}');
    platform.setProperty('video-pan-y', '${zoom.panY}');
  }
}

final videoZoomProvider = NotifierProvider<VideoZoomNotifier, VideoZoom>(VideoZoomNotifier.new);
