import 'package:flutter/widgets.dart';

/// Spacing on a 4 dp grid. Use these for paddings and gaps instead of
/// literals, so the rhythm stays the same everywhere.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double s = 8;
  static const double m = 12;
  static const double l = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

/// Corner radii. Thumbnails and chips are slightly rounded, cards a bit
/// more, sheets follow Material 3, and pills are fully rounded.
abstract final class AppRadius {
  /// Duration, resolution and count badges on thumbnails.
  static const double badge = 4;

  /// Scene thumbnails and the tiles built around them.
  static const double thumbnail = 8;

  /// Chips (YouTube-style rounded rectangles, not pills).
  static const double chip = 8;

  /// Cards and portrait tiles (performers, galleries, tags).
  static const double card = 12;

  /// Top corners of bottom sheets (Material 3's default).
  static const double sheet = 28;

  /// Fully rounded ends; for borders use `StadiumBorder`.
  static const double pill = 999;

  static const badgeBorder = BorderRadius.all(Radius.circular(badge));
  static const thumbnailBorder = BorderRadius.all(Radius.circular(thumbnail));
  static const cardBorder = BorderRadius.all(Radius.circular(card));
  static const pillBorder = BorderRadius.all(Radius.circular(pill));
}

/// Font sizes for text drawn over video and images (player controls, shorts,
/// thumbnail badges, the image viewer). Everywhere else text comes from the
/// theme's `textTheme`; over video it is always white on a scrim and has to
/// stay the same size whatever the text theme says, so it has its own small
/// set.
abstract final class AppTextSize {
  /// Secondary lines on small overlays (a shorts tile's view count).
  static const double overlayCaption = 11;

  /// Badges and small labels (duration, resolution, counts, shorts meta).
  static const double overlayLabel = 12;

  /// Times and the scrub label in the player.
  static const double overlayBody = 13;

  /// Titles over video (a short's title, an image's title).
  static const double overlayTitle = 15;
}
