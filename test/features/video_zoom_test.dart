import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/features/player/video_zoom.dart';

void main() {
  const box = Size(400, 225);
  const center = Offset(200, 112.5);

  test('pinching at the center zooms without panning', () {
    final z = VideoZoom.none.pinch(factor: 2, startFocal: center, focal: center, box: box);
    expect(z.scale, 2);
    expect(z.panX, 0);
    expect(z.panY, 0);
  });

  test('the point under the fingers stays under them', () {
    const focal = Offset(300, 112.5); // 100 px right of the center
    final z = VideoZoom.none.pinch(factor: 2, startFocal: focal, focal: focal, box: box);
    // The video moves 100 px left, so its point at +100 px is now at +100 px.
    expect(z.panX * box.width * z.scale, closeTo(-100, 0.001));
  });

  test('the video always covers the box and zoom stays between 1x and 4x', () {
    final far = VideoZoom.none.pinch(factor: 2, startFocal: center, focal: center + const Offset(1000, 0), box: box);
    expect(far.panX * box.width * far.scale, closeTo(box.width / 2, 0.001), reason: 'at most half the overflow');
    expect(VideoZoom.none.pinch(factor: 10, startFocal: center, focal: center, box: box).scale, VideoZoom.maxScale);
    expect(VideoZoom.none.pinch(factor: 0.5, startFocal: center, focal: center, box: box).scale, 1);
  });

  test('a pinch continues from the current zoom and snaps back when barely zoomed', () {
    final twice = VideoZoom.none.pinch(factor: 2, startFocal: center, focal: center, box: box);
    expect(twice.pinch(factor: 1.5, startFocal: center, focal: center, box: box).scale, 3);
    expect(const VideoZoom(scale: 1.03).settled(), VideoZoom.none);
    expect(twice.settled(), twice);
  });

  test('covering zooms a 16:9 video to fill a 20:9 screen, and nothing that fits', () {
    final z = VideoZoom.covering(box: const Size(2000, 900), aspect: 16 / 9);
    expect(z.scale, closeTo((20 / 9) / (16 / 9), 0.001));
    expect(z.fill, isTrue);
    // A portrait video in a landscape box needs the other ratio.
    expect(VideoZoom.covering(box: const Size(1600, 900), aspect: 9 / 16).scale, closeTo(3.16, 0.01));
    expect(VideoZoom.covering(box: const Size(2400, 900), aspect: 9 / 16).scale, VideoZoom.maxScale);
    // Already filling: the fill stays on (for the next box) without zooming.
    final fits = VideoZoom.covering(box: const Size(1600, 900), aspect: 16 / 9);
    expect((fits.scale, fits.fill), (1.0, true));
    // A pinch ends the fill.
    expect(z.pinch(factor: 1.1, startFocal: center, focal: center, box: box).fill, isFalse);
  });
}
