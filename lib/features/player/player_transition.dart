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
    double? expandedWidth,
  }) {
    // The video's column when expanded: the whole width, or its share on
    // wide windows ([splitShare]).
    final width = expandedWidth ?? screenWidth;
    final range = maxHeight - minHeight;
    final progress = range <= 0 ? 1.0 : ((height - minHeight) / range).clamp(0.0, 1.0);
    final grow = Curves.easeOut.transform((progress / growPhase).clamp(0.0, 1.0));

    final miniVideoHeight = minHeight - progressBarHeight;
    final miniVideoWidth = miniVideoHeight * 16 / 9;
    // Wider than 16:9 keeps the 16:9 box (letterboxed), portrait videos get
    // more height.
    final expandedVideoHeight =
        (width / videoAspect).clamp(width * 9 / 16, (maxHeight * maxVideoShare).clamp(width * 9 / 16, double.infinity));

    final topPadding = topInset * grow;
    // Never taller than the space the panel currently has.
    final maxVideoHeight = (height - topPadding - progressBarHeight).clamp(0.0, double.infinity);
    final videoHeight = lerpDouble(miniVideoHeight, expandedVideoHeight, grow)!.clamp(0.0, maxVideoHeight);
    final baseVideoHeight = lerpDouble(miniVideoHeight, width * 9 / 16, grow)!.clamp(0.0, videoHeight);
    final videoWidth = lerpDouble(miniVideoWidth, width, grow)!.clamp(0.0, width);

    return PlayerTransition._(
      progress: progress,
      topPadding: topPadding,
      videoWidth: videoWidth,
      videoHeight: videoHeight,
      baseVideoHeight: baseVideoHeight,
      miniBarOpacity: (1 - progress / 0.15).clamp(0.0, 1.0),
      detailsOpacity: ((progress - 0.3) / 0.7).clamp(0.0, 1.0),
    );
  }

  const PlayerTransition._({
    required this.progress,
    required this.topPadding,
    required this.videoWidth,
    required this.videoHeight,
    required this.baseVideoHeight,
    required this.miniBarOpacity,
    required this.detailsOpacity,
  });

  /// From this window width the expanded player puts the video and its
  /// details in a column on the left and "Up next" on the right (tablets).
  static const splitBreakpoint = 840.0;

  /// The left column's share of the width in that layout: half the width,
  /// so the video takes a quarter of a 16:9 screen instead of all of it.
  static const splitShare = 0.5;

  /// The width of the expanded video's column for a window [width].
  static double columnWidth(double width) => width >= splitBreakpoint ? width * splitShare : width;

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

  /// The height a 16:9 video would have; a portrait video's extra height
  /// ([extraVideoHeight]) shrinks away as the details scroll.
  final double baseVideoHeight;

  double get extraVideoHeight => videoHeight - baseVideoHeight;

  /// Title, play/pause and close of the collapsed bar, plus its progress line.
  final double miniBarOpacity;
  final double detailsOpacity;

  bool get isExpanded => progress >= 0.999;
  bool get isCollapsed => progress <= 0.001;

  /// Whether the details are shown (they stay built but hidden while
  /// collapsed, see `PlayerPanel`).
  bool get showDetails => progress > 0.01;
}
