import 'dart:ui' show lerpDouble;

import 'package:flutter/animation.dart';

/// Geometry and opacities of the player panel for a given panel height, so
/// the miniplayer morphs continuously into the full player (YouTube-style):
///
/// * the video grows from the small tile on the left to full width during
///   the first [growPhase] of the way up; expanded it is 16:9, or taller for
///   portrait videos (at most [maxVideoShare] of the panel),
/// * the mini bar's title and buttons fade out early,
/// * details fade in during the second half,
/// * controls appear only once the panel is fully open.
class PlayerTransition {
  factory PlayerTransition({
    required double height,
    required double minHeight,
    required double maxHeight,
    required double screenWidth,
    required double topInset,
    double videoAspect = 16 / 9,
    double progressBarHeight = 2,
  }) {
    final range = maxHeight - minHeight;
    final progress = range <= 0 ? 1.0 : ((height - minHeight) / range).clamp(0.0, 1.0);
    final grow = Curves.easeOut.transform((progress / growPhase).clamp(0.0, 1.0));

    final miniVideoHeight = minHeight - progressBarHeight;
    final miniVideoWidth = miniVideoHeight * 16 / 9;
    // Wider than 16:9 keeps the 16:9 box (letterboxed), portrait videos get
    // more height.
    final expandedVideoHeight = (screenWidth / videoAspect)
        .clamp(screenWidth * 9 / 16, (maxHeight * maxVideoShare).clamp(screenWidth * 9 / 16, double.infinity));

    final topPadding = topInset * grow;
    // Never taller than the space the panel currently has.
    final maxVideoHeight = (height - topPadding - progressBarHeight).clamp(0.0, double.infinity);
    final videoHeight = lerpDouble(miniVideoHeight, expandedVideoHeight, grow)!.clamp(0.0, maxVideoHeight);
    final videoWidth = lerpDouble(miniVideoWidth, screenWidth, grow)!.clamp(0.0, screenWidth);

    return PlayerTransition._(
      progress: progress,
      topPadding: topPadding,
      videoWidth: videoWidth,
      videoHeight: videoHeight,
      miniBarOpacity: (1 - progress / 0.15).clamp(0.0, 1.0),
      detailsOpacity: ((progress - 0.3) / 0.7).clamp(0.0, 1.0),
    );
  }

  const PlayerTransition._({
    required this.progress,
    required this.topPadding,
    required this.videoWidth,
    required this.videoHeight,
    required this.miniBarOpacity,
    required this.detailsOpacity,
  });

  /// Share of the drag distance after which the video has its full size.
  static const growPhase = 0.4;

  /// The most of the expanded panel a portrait video takes, so the details
  /// stay reachable.
  static const maxVideoShare = 0.6;

  /// 0 = collapsed miniplayer, 1 = fully expanded.
  final double progress;

  /// Status bar inset, faded in as the panel grows.
  final double topPadding;
  final double videoWidth;
  final double videoHeight;

  /// Title, play/pause and close of the collapsed bar, plus its progress line.
  final double miniBarOpacity;
  final double detailsOpacity;

  bool get isExpanded => progress >= 0.999;
  bool get isCollapsed => progress <= 0.001;

  /// Whether details exist at all; skipped while collapsed so the "Up next"
  /// list isn't loaded for a closed player.
  bool get showDetails => progress > 0.01;
}
