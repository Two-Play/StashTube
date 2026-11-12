import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/scene.dart';
import 'player_controls.dart' show videoAspect;
import 'player_providers.dart';

/// Pinch zoom of the player's video (4.22, 4.31): a scale plus a pan, drawn
/// by [ZoomedVideo] as a transform of the video's box. The video grows
/// continuously from "fits inside" (1×) up to 4× and snaps briefly where it
/// fills the whole box ([fill]: no black bars, whatever the box is), like
/// YouTube's. The controls inside the box are counter-transformed
/// ([ZoomCounter]) so they keep their size.
@immutable
class VideoZoom {
  const VideoZoom({this.scale = 1, this.panX = 0, this.panY = 0, this.fill = false});

  static const none = VideoZoom();
  static const maxScale = 4.0;

  /// Below this a pinch snaps back to no zoom.
  static const snapBack = 1.05;

  /// A pinch within this share of the fit scale (1: the video's height or
  /// width fills the box) or the fill scale (both do) sticks to it.
  static const fillSnap = 0.07;

  /// The pan sticks to the center and to the edges within this many pixels.
  static const panSnap = 14.0;

  final double scale;

  /// Shift of the video in fractions of the box.
  final double panX;
  final double panY;

  /// At the scale where the video covers the whole box (worked out again
  /// for every box: inline, fullscreen, turned screen).
  final bool fill;

  bool get isZoomed => scale > 1 || fill;

  /// The scale at which a video of [aspect] (width / height) covers [box].
  static double coverScale(Size box, double? aspect) {
    if (aspect == null || aspect <= 0 || box.isEmpty) return 1;
    final boxAspect = box.width / box.height;
    return math.min(maxScale, boxAspect > aspect ? boxAspect / aspect : aspect / boxAspect);
  }

  /// The scale shown in [box].
  double scaleIn(Size box, double? aspect) => fill ? math.max(1, coverScale(box, aspect)) : scale;

  /// How far the video, fitted into [box], may be moved at [scale] before
  /// the box shows empty space (none while it is smaller than the box).
  static Offset panLimit(Size box, double? aspect, double scale) {
    final boxAspect = box.width / box.height;
    final fitted = aspect == null || aspect <= 0
        ? box
        : (boxAspect > aspect ? Size(box.height * aspect, box.height) : Size(box.width, box.width / aspect));
    return Offset(
      math.max(0, (fitted.width * scale - box.width) / 2),
      math.max(0, (fitted.height * scale - box.height) / 2),
    );
  }

  /// The transform that draws the zoomed video in a box of [box].
  Matrix4 matrixIn(Size box, double? aspect) {
    final s = scaleIn(box, aspect);
    final limit = panLimit(box, aspect, s);
    final center = box.center(Offset.zero);
    final dx = (panX * box.width * s).clamp(-limit.dx, limit.dx);
    final dy = (panY * box.height * s).clamp(-limit.dy, limit.dy);
    return Matrix4.identity()
      ..translateByDouble(center.dx + dx, center.dy + dy, 0, 1)
      ..scaleByDouble(s, s, 1, 1)
      ..translateByDouble(-center.dx, -center.dy, 0, 1);
  }

  /// The zoom after a pinch that started at [startFocal] with this zoom and
  /// is now at [focal] with the fingers [factor] times as far apart, in a
  /// video box of [box]. The point under the fingers stays under them; near
  /// the scale that fills the box it sticks to it.
  VideoZoom pinch({
    required double factor,
    required Offset startFocal,
    required Offset focal,
    required Size box,
    double? aspect,
  }) {
    final center = box.center(Offset.zero);
    final startScale = scaleIn(box, aspect);
    final cover = coverScale(box, aspect);
    final raw = (startScale * factor).clamp(1.0, maxScale);
    final snapped = cover > 1.02 && (raw - cover).abs() <= cover * fillSnap;
    final newScale = snapped ? cover : (raw <= 1 + fillSnap ? 1.0 : raw);
    final startLimit = panLimit(box, aspect, startScale);
    final start = Offset(
      (panX * box.width * startScale).clamp(-startLimit.dx, startLimit.dx),
      (panY * box.height * startScale).clamp(-startLimit.dy, startLimit.dy),
    );
    // The video point under the fingers when the pinch started...
    final point = (startFocal - center - start) / startScale;
    // ...is moved to where the fingers are now.
    final translation = focal - center - point * newScale;
    final limit = panLimit(box, aspect, newScale);
    return VideoZoom(
      scale: newScale,
      panX: _snapPan(translation.dx, limit.dx) / (box.width * newScale),
      panY: _snapPan(translation.dy, limit.dy) / (box.height * newScale),
      fill: snapped,
    );
  }

  /// [value] kept within ±[limit], sticking to the center and to the edges.
  static double _snapPan(double value, double limit) {
    final v = value.clamp(-limit, limit);
    if (v.abs() <= panSnap) return 0;
    if ((v - limit).abs() <= panSnap) return limit;
    if ((v + limit).abs() <= panSnap) return -limit;
    return v;
  }

  /// What a pinch ends with: no zoom when barely zoomed.
  VideoZoom settled() => scale < snapBack && !fill ? none : this;

  @override
  bool operator ==(Object other) =>
      other is VideoZoom && other.scale == scale && other.panX == panX && other.panY == panY && other.fill == fill;

  @override
  int get hashCode => Object.hash(scale, panX, panY, fill);
}

/// The current zoom; kept until the user zooms out or another scene starts
/// (`NowPlayingNotifier.play` resets the pinch zoom, the fill stays).
class VideoZoomNotifier extends Notifier<VideoZoom> {
  @override
  VideoZoom build() => VideoZoom.none;

  void set(VideoZoom zoom) {
    if (zoom != state) state = zoom;
  }

  void reset() => set(VideoZoom.none);

  /// Another scene: no pinch zoom, but a fill stays.
  void resetZoom() => set(state.fill ? const VideoZoom(fill: true) : VideoZoom.none);
}

final videoZoomProvider = NotifierProvider<VideoZoomNotifier, VideoZoom>(VideoZoomNotifier.new);

/// Width / height of the playing video, updated once the player knows the
/// decoded size; null without a scene.
final videoAspectProvider = Provider.autoDispose<double?>((ref) {
  final scene = ref.watch(nowPlayingProvider);
  if (scene == null) return null;
  return _aspectOf(ref, scene);
});

/// The same for a given [scene].
final sceneVideoAspectProvider = Provider.autoDispose.family<double?, Scene>(_aspectOf);

double? _aspectOf(Ref ref, Scene scene) {
  final player = ref.watch(playerProvider);
  final subscriptions = [
    player.stream.width.listen((_) => ref.invalidateSelf()),
    player.stream.height.listen((_) => ref.invalidateSelf()),
  ];
  ref.onDispose(() {
    for (final s in subscriptions) {
      s.cancel();
    }
  });
  return videoAspect(player.state, scene, sceneFirst: true);
}

/// Draws [child] (the `Video`) zoomed by [videoZoomProvider], clipped to
/// its box.
class ZoomedVideo extends ConsumerWidget {
  const ZoomedVideo({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zoom = ref.watch(videoZoomProvider);
    final aspect = ref.watch(videoAspectProvider);
    return LayoutBuilder(
      // Always the same widgets, so the Video underneath is never rebuilt
      // from scratch when a zoom starts or ends.
      builder: (context, constraints) =>
          ClipRect(child: Transform(transform: zoom.matrixIn(constraints.biggest, aspect), child: child)),
    );
  }
}

/// Inside a [ZoomedVideo]'s `Video`: undoes the zoom for the controls, so
/// they keep their size and place.
class ZoomCounter extends ConsumerWidget {
  const ZoomCounter({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zoom = ref.watch(videoZoomProvider);
    final aspect = ref.watch(videoAspectProvider);
    return LayoutBuilder(
      builder: (context, constraints) =>
          Transform(transform: Matrix4.inverted(zoom.matrixIn(constraints.biggest, aspect)), child: child),
    );
  }
}
