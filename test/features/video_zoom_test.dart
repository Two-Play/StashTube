import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/features/player/video_zoom.dart';

void main() {
  const box = Size(400, 225);
  const center = Offset(200, 112.5);
  const wide = 16 / 9;

  test('pinching at the center zooms without panning', () {
    final z = VideoZoom.none.pinch(factor: 2, startFocal: center, focal: center, box: box, aspect: wide);
    expect(z.scale, 2);
    expect(z.panX, 0);
    expect(z.panY, 0);
  });

  test('the point under the fingers stays under them', () {
    const focal = Offset(300, 112.5); // 100 px right of the center
    final z = VideoZoom.none.pinch(factor: 2, startFocal: focal, focal: focal, box: box, aspect: wide);
    // The video moves 100 px left, so its point at +100 px is now at +100 px.
    expect(z.panX * box.width * z.scale, closeTo(-100, 0.001));
  });

  test('the video always covers the box and zoom stays between 1x and 4x', () {
    final far = VideoZoom.none.pinch(
        factor: 2, startFocal: center, focal: center + const Offset(1000, 0), box: box, aspect: wide);
    expect(far.panX * box.width * far.scale, closeTo(box.width / 2, 0.001), reason: 'at most half the overflow');
    expect(VideoZoom.none.pinch(factor: 10, startFocal: center, focal: center, box: box, aspect: wide).scale,
        VideoZoom.maxScale);
    expect(VideoZoom.none.pinch(factor: 0.5, startFocal: center, focal: center, box: box, aspect: wide).scale, 1);
  });

  test('a pinch continues from the current zoom and snaps back when barely zoomed', () {
    final twice = VideoZoom.none.pinch(factor: 2, startFocal: center, focal: center, box: box, aspect: wide);
    expect(twice.pinch(factor: 1.5, startFocal: center, focal: center, box: box, aspect: wide).scale, 3);
    expect(const VideoZoom(scale: 1.03).settled(), VideoZoom.none);
    expect(twice.settled(), twice);
  });

  group('fill: the whole box without black bars', () {
    // A 16:9 video on a 20:9 screen: it covers the box at 20/16 = 1.25x.
    const screen = Size(2000, 900);

    test('the cover scale depends on the box, in both directions', () {
      expect(VideoZoom.coverScale(screen, wide), closeTo((20 / 9) / (16 / 9), 0.001));
      expect(VideoZoom.coverScale(const Size(1600, 900), 9 / 16), closeTo(3.16, 0.01));
      expect(VideoZoom.coverScale(const Size(2400, 900), 9 / 16), VideoZoom.maxScale);
      expect(VideoZoom.coverScale(const Size(1600, 900), wide), closeTo(1, 0.001));
    });

    test('the width grows continuously with the pinch and sticks to the full width', () {
      final cover = VideoZoom.coverScale(screen, wide);
      VideoZoom pinch(double factor) =>
          VideoZoom.none.pinch(factor: factor, startFocal: screen.center(Offset.zero), focal: screen.center(Offset.zero), box: screen, aspect: wide);
      expect(pinch(1.1).scale, closeTo(1.1, 0.001));
      expect(pinch(1.1).fill, isFalse);
      // Within a few percent of the full width it snaps to it...
      expect(pinch(cover * 0.97).scale, closeTo(cover, 0.001));
      expect(pinch(cover * 0.97).fill, isTrue);
      expect(pinch(cover * 1.03).fill, isTrue);
      // ...and zooms on beyond.
      expect(pinch(cover * 1.5).scale, closeTo(cover * 1.5, 0.001));
      expect(pinch(cover * 1.5).fill, isFalse);
    });

    test('it also sticks to the fitted size, and the pan to the center and the edges', () {
      VideoZoom pinch(double factor, {Offset shift = Offset.zero}) => VideoZoom.none.pinch(
          factor: factor, startFocal: screen.center(Offset.zero), focal: screen.center(Offset.zero) + shift, box: screen, aspect: wide);
      expect(pinch(1.05).scale, 1, reason: 'full height: back to the fitted size');
      expect(pinch(1.15).scale, closeTo(1.15, 0.001));
      // Fingers that drift a few pixels up or down don't move the picture...
      expect(pinch(2, shift: const Offset(0, 9)).panY, 0);
      expect(pinch(2, shift: const Offset(9, 0)).panX, 0);
      // ...but a real move does, and sticks to the edge when close to it.
      final moved = pinch(2, shift: const Offset(0, 100));
      expect(moved.panY * screen.height * moved.scale, closeTo(100, 0.001));
      final limit = VideoZoom.panLimit(screen, wide, 2);
      final nearEdge = pinch(2, shift: Offset(0, limit.dy - 8));
      expect(nearEdge.panY * screen.height * 2, closeTo(limit.dy, 0.001));
    });

    test('it reports what it sticks to, for the haptic tick', () {
      VideoZoom pinch(double factor, {Offset shift = Offset.zero}) => VideoZoom.none.pinch(
          factor: factor, startFocal: screen.center(Offset.zero), focal: screen.center(Offset.zero) + shift, box: screen, aspect: wide);
      expect(pinch(1.05).snaps & VideoZoom.snapScale, isNonZero, reason: 'the fitted size');
      expect(pinch(1.24).snaps & VideoZoom.snapScale, isNonZero, reason: 'the full width');
      expect(pinch(1.15).snaps & VideoZoom.snapScale, isZero);
      expect(pinch(2, shift: const Offset(0, 9)).snaps & VideoZoom.snapPanY, isNonZero);
      expect(pinch(2, shift: const Offset(0, 100)).snaps & VideoZoom.snapPanY, isZero);
    });

    test('a fill is worked out again for another box', () {
      const filled = VideoZoom(scale: 1.25, fill: true);
      expect(filled.scaleIn(screen, wide), closeTo(1.25, 0.001));
      expect(filled.scaleIn(const Size(1600, 900), wide), closeTo(1, 0.001), reason: 'it fills that box already');
      expect(filled.scaleIn(const Size(900, 1600), wide), closeTo(3.16, 0.01));
    });

    test('a new scene keeps the fill but not a pinch zoom', () {
      final container = _container();
      container.read(videoZoomProvider.notifier).set(const VideoZoom(scale: 2, panX: 0.1));
      container.read(videoZoomProvider.notifier).resetZoom();
      expect(container.read(videoZoomProvider), VideoZoom.none);
      container.read(videoZoomProvider.notifier).set(const VideoZoom(scale: 1.25, fill: true));
      container.read(videoZoomProvider.notifier).resetZoom();
      expect(container.read(videoZoomProvider), const VideoZoom(fill: true));
    });
  });
}

ProviderContainer _container() {
  final c = ProviderContainer();
  addTearDown(c.dispose);
  return c;
}
