import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

/// How long a finger rests before "hold for 2×" starts. Shorter than
/// Flutter's long press (500 ms), but still longer than a tap.
const kHoldDelay = Duration(milliseconds: 250);

/// Reports holding a finger on [child], e.g. to play at double speed while
/// held. Sits around other gesture detectors: once the hold is recognized,
/// their tap and double tap lose.
class HoldDetector extends StatelessWidget {
  const HoldDetector({
    super.key,
    required this.onHoldStart,
    required this.onHoldEnd,
    required this.child,
    this.delay = kHoldDelay,
  });

  final VoidCallback onHoldStart;

  /// Also called when the hold is cancelled.
  final VoidCallback onHoldEnd;
  final Widget child;
  final Duration delay;

  @override
  Widget build(BuildContext context) => RawGestureDetector(
        gestures: {
          LongPressGestureRecognizer: GestureRecognizerFactoryWithHandlers<LongPressGestureRecognizer>(
            () => LongPressGestureRecognizer(duration: delay),
            (recognizer) => recognizer
              ..onLongPressStart = ((_) {
                onHoldStart();
              })
              ..onLongPressEnd = ((_) {
                onHoldEnd();
              })
              ..onLongPressCancel = onHoldEnd,
          ),
        },
        child: child,
      );
}
