import 'package:flutter/widgets.dart';

/// Slides its child down out of view (behind the bottom navigation) while
/// [closing], then calls [onClosed]. Used to animate the miniplayer away
/// when it is closed.
class ClosingSlide extends StatelessWidget {
  const ClosingSlide({
    super.key,
    required this.closing,
    required this.distance,
    required this.onClosed,
    required this.child,
    this.duration = const Duration(milliseconds: 250),
  });

  final bool closing;

  /// How far to slide down, in pixels (the collapsed bar's height).
  final double distance;
  final VoidCallback onClosed;
  final Duration duration;
  final Widget child;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
        tween: Tween(end: closing ? 1 : 0),
        duration: duration,
        curve: Curves.easeIn,
        onEnd: () {
          if (closing) onClosed();
        },
        builder: (_, t, child) => Transform.translate(
          offset: Offset(0, distance * t),
          child: Opacity(opacity: 1 - 0.7 * t, child: child),
        ),
        child: child,
      );
}
