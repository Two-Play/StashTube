import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';

import 'held_orientation.dart';

/// The [FullscreenMorph] over the whole app.
final fullscreenMorphKey = GlobalKey<FullscreenMorphState>();

/// What the morph shows: the video of [controller], whose frames are
/// [aspect] wide, between its place in the player ([inline], read every
/// frame since the player moves while the screen turns) and the fullscreen
/// pose. [held] is how the phone is held in that pose: in a portrait window
/// the video then lies turned, as it will stand once the screen has turned.
typedef FullscreenMorphSpec = ({
  VideoController controller,
  double aspect,
  HeldOrientation? held,
  Rect? Function() inline,
});

/// Above the whole app: carries the player's video between its place in
/// the expanded player and fullscreen, YouTube style. Going in, the video
/// lifts off, grows and turns with the phone while the app behind it goes
/// black; the screen then turns underneath, where nothing changes because
/// the pose already matched. Coming out runs the other way. Takes no
/// touches meanwhile. Without animations (reduced motion) it only hides
/// the screen's turn.
class FullscreenMorph extends StatefulWidget {
  const FullscreenMorph({super.key, required this.child});

  final Widget child;

  static const duration = Duration(milliseconds: 420);

  /// The app only fades to black around the turn ([FullscreenMorphState.cover])
  /// instead of moving the video: on iOS the turn still showed, and the
  /// plain fade read best on both platforms. The moving video stays
  /// available (tests) should it come back.
  static bool get curtainOnly => curtainOnlyOverride ?? true;

  @visibleForTesting
  static bool? curtainOnlyOverride;

  static const coverDuration = Duration(milliseconds: 120);
  static const uncoverDuration = Duration(milliseconds: 200);

  /// The black of [FullscreenMorphState.cover], while it shows.
  @visibleForTesting
  static const curtainKey = ValueKey('fullscreenCurtain');

  /// The moving video, while the morph shows.
  @visibleForTesting
  static const videoKey = ValueKey('fullscreenMorph');

  @override
  State<FullscreenMorph> createState() => FullscreenMorphState();
}

class FullscreenMorphState extends State<FullscreenMorph> with TickerProviderStateMixin {
  /// 0: the video in its place in the player; 1: the fullscreen pose.
  late final _progress = AnimationController(vsync: this, duration: FullscreenMorph.duration);
  FullscreenMorphSpec? _spec;

  /// Shows the video at [at] (0 in place, 1 in fullscreen) over the app.
  void show(FullscreenMorphSpec spec, {required double at}) {
    _progress.value = at;
    setState(() => _spec = spec);
  }

  /// How the phone is held now (it may turn over while in fullscreen).
  set held(HeldOrientation? held) {
    final spec = _spec;
    if (spec == null || spec.held == held) return;
    setState(() => _spec = (controller: spec.controller, aspect: spec.aspect, held: held, inline: spec.inline));
  }

  Future<void> animateTo(double target) {
    if (_spec == null) return Future.value();
    if (MediaQuery.disableAnimationsOf(context)) {
      _progress.value = target;
      return Future.value();
    }
    return _progress
        .animateTo(target, curve: Curves.easeInOutCubic)
        .orCancel
        // Cut short by the next one.
        .catchError((Object _) {});
  }

  void hide() {
    if (_spec != null && mounted) setState(() => _spec = null);
  }

  /// The black over the whole app of [FullscreenMorph.curtainOnly].
  late final _black = AnimationController(vsync: this);

  bool get _animate => !MediaQuery.disableAnimationsOf(context);

  /// Fades the app to black ([instantly]: at once, e.g. after the system's
  /// back, when the fullscreen is already gone).
  Future<void> cover({bool instantly = false}) {
    if (instantly || !_animate) {
      _black.value = 1;
      return Future.value();
    }
    return _fade(_black.animateTo(1, duration: FullscreenMorph.coverDuration, curve: Curves.easeOut));
  }

  Future<void> uncover() {
    if (!_animate) {
      _black.value = 0;
      return Future.value();
    }
    return _fade(_black.animateTo(0, duration: FullscreenMorph.uncoverDuration, curve: Curves.easeIn));
  }

  /// A fade cut short by the next one just ends.
  Future<void> _fade(TickerFuture fade) => fade.orCancel.catchError((Object _) {});

  @override
  void dispose() {
    _progress.dispose();
    _black.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spec = _spec;
    return Stack(
      fit: StackFit.passthrough,
      children: [
        widget.child,
        if (spec != null)
          Positioned.fill(
            child: AbsorbPointer(
              child: AnimatedBuilder(
                animation: _progress,
                builder: (context, _) => _morph(context, spec, _progress.value),
              ),
            ),
          ),
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _black,
            builder: (_, _) => _black.value == 0
                ? const SizedBox.shrink()
                : AbsorbPointer(
                    child: Opacity(
                      key: FullscreenMorph.curtainKey,
                      opacity: _black.value,
                      child: const ColoredBox(color: Colors.black),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _morph(BuildContext context, FullscreenMorphSpec spec, double t) {
    final screen = MediaQuery.sizeOf(context);
    // In a portrait window the pose lies turned the way the phone is held;
    // once the window has turned it stands upright.
    final held = spec.held;
    final turned = held != null && held.isLandscape && screen.width < screen.height;
    final angle = turned ? held.uprightAngle : 0.0;
    final box = turned ? screen.flipped : screen;
    final pose = _contain(spec.aspect, box);
    final center = screen.center(Offset.zero);
    final place = spec.inline();
    final from = place == null ? pose : _contain(spec.aspect, place.size);
    final fromCenter = place?.center ?? center;
    final width = lerpDouble(from.width, pose.width, t)!;
    final height = lerpDouble(from.height, pose.height, t)!;
    final at = Offset.lerp(fromCenter, center, t)!;
    return Stack(
      children: [
        // The app goes black a little ahead of the video's move.
        Positioned.fill(
          child: ColoredBox(color: Colors.black.withValues(alpha: Curves.easeOut.transform(t))),
        ),
        // The player's own video stays behind: its place is black at once,
        // so the video doesn't show twice.
        if (place != null && t > 0) Positioned.fromRect(rect: place, child: const ColoredBox(color: Colors.black)),
        Positioned(
          left: at.dx - width / 2,
          top: at.dy - height / 2,
          width: width,
          height: height,
          child: Transform.rotate(
            angle: angle * t,
            child: Video(
              key: FullscreenMorph.videoKey,
              controller: spec.controller,
              // Not from the video surface's size, which lags while the
              // screen turns and stretched the picture.
              aspectRatio: spec.aspect,
              controls: (_) => const SizedBox.shrink(),
              fill: Colors.black,
              wakelock: false,
              pauseUponEnteringBackgroundMode: false,
            ),
          ),
        ),
      ],
    );
  }

  /// The largest size of [aspect] inside [box].
  static Size _contain(double aspect, Size box) =>
      box.width / box.height > aspect ? Size(box.height * aspect, box.height) : Size(box.width, box.width / aspect);
}
