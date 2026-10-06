import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/features/player/player_transition.dart';

void main() {
  const minHeight = 64.0;
  const maxHeight = 844.0;
  const width = 390.0;
  const topInset = 47.0;

  PlayerTransition at(double height, {double screenWidth = width, double max = maxHeight}) => PlayerTransition(
        height: height,
        minHeight: minHeight,
        maxHeight: max,
        screenWidth: screenWidth,
        topInset: topInset,
      );

  test('collapsed: small 16:9 tile, mini bar visible, no details', () {
    final t = at(minHeight);
    expect(t.isCollapsed, isTrue);
    expect(t.videoHeight, 62);
    expect(t.videoWidth, closeTo(62 * 16 / 9, 0.01));
    expect(t.miniBarOpacity, 1);
    expect(t.detailsOpacity, 0);
    expect(t.showDetails, isFalse);
    expect(t.topPadding, 0);
  });

  test('expanded: full-width 16:9 video below the status bar, details visible', () {
    final t = at(maxHeight);
    expect(t.isExpanded, isTrue);
    expect(t.videoWidth, width);
    expect(t.videoHeight, closeTo(width * 9 / 16, 0.01));
    expect(t.topPadding, topInset);
    expect(t.miniBarOpacity, 0);
    expect(t.detailsOpacity, 1);
  });

  test('every value changes continuously and monotonically while dragging up', () {
    PlayerTransition? previous;
    for (var h = minHeight; h <= maxHeight; h += 1) {
      final t = at(h);
      if (previous != null) {
        expect(t.videoWidth, greaterThanOrEqualTo(previous.videoWidth - 1e-9));
        expect(t.videoHeight, greaterThanOrEqualTo(previous.videoHeight - 1e-9));
        expect(t.detailsOpacity, greaterThanOrEqualTo(previous.detailsOpacity));
        expect(t.miniBarOpacity, lessThanOrEqualTo(previous.miniBarOpacity));
        // No jumps: a 1 px drag moves the video by only a few px.
        expect(t.videoWidth - previous.videoWidth, lessThan(8));
        expect(t.videoHeight - previous.videoHeight, lessThan(8));
      }
      previous = t;
    }
  });

  test('the fixed part of the layout always fits into the panel', () {
    for (final screen in [(width, maxHeight), (1024.0, 700.0), (844.0, 390.0)]) {
      for (var h = minHeight; h <= screen.$2; h += 3) {
        final t = at(h, screenWidth: screen.$1, max: screen.$2);
        expect(t.topPadding + t.videoHeight + 2, lessThanOrEqualTo(h + 1e-9), reason: 'height $h on $screen');
      }
    }
  });

  test('controls only once fully open', () {
    expect(at(maxHeight - 5).isExpanded, isFalse);
    expect(at(maxHeight).isExpanded, isTrue);
  });

  test('portrait videos get a taller video area, capped so details stay visible', () {
    PlayerTransition expanded(double aspect) => PlayerTransition(
          height: maxHeight,
          minHeight: minHeight,
          maxHeight: maxHeight,
          screenWidth: width,
          topInset: topInset,
          videoAspect: aspect,
        );
    expect(expanded(16 / 9).videoHeight, closeTo(width * 9 / 16, 0.01));
    expect(expanded(4 / 3).videoHeight, closeTo(width * 3 / 4, 0.01));
    expect(expanded(9 / 16).videoHeight, closeTo(maxHeight * PlayerTransition.maxVideoShare, 0.01));
    expect(expanded(2.39).videoHeight, closeTo(width * 9 / 16, 0.01), reason: 'wide videos keep the 16:9 box');
    // Collapsed it is the same small tile for every video.
    expect(at(minHeight).videoHeight, 62);
  });
}
