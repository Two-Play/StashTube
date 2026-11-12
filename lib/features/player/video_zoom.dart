import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
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

  /// Set by the "fill" button: the video covers whatever box it is shown
  /// in, so the scale is worked out again for every box (inline, fullscreen,
  /// turned screen) by the controls ([VideoZoomNotifier.fitTo]). A pinch
  /// ends it.
  final bool fill;

  bool get isZoomed => scale > 1;

  /// The zoom that makes a video of [aspect] (width / height) cover a [box]
  /// completely, cutting off what sticks out (at most [maxScale]; 1 when it
  /// fills the box already).
  static VideoZoom covering({required Size box, required double aspect}) {
    if (box.isEmpty || aspect <= 0) return const VideoZoom(fill: true);
    final boxAspect = box.width / box.height;
    final scale = boxAspect > aspect ? boxAspect / aspect : aspect / boxAspect;
    return VideoZoom(scale: scale < 1.02 ? 1 : math.min(scale, maxScale), fill: true);
  }

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
    );
  }

  /// What a pinch ends with: no zoom when barely zoomed.
  VideoZoom settled() => scale < snapBack ? none : this;

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

  /// The fill button: off when on or zoomed, else covers the [box].
  void toggleFill({required Size box, required double? aspect}) {
    if (state.fill || state.isZoomed) {
      reset();
    } else {
      set(aspect == null ? const VideoZoom(fill: true) : VideoZoom.covering(box: box, aspect: aspect));
    }
  }

  /// Works the fill zoom out again for the box the video is shown in now
  /// (fullscreen, a turned screen); does nothing unless the fill is on.
  void syncFill({required Size box, required double? aspect}) {
    if (!state.fill || aspect == null) return;
    set(VideoZoom.covering(box: box, aspect: aspect));
  }

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
