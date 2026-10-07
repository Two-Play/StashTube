import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:miniplayer/miniplayer.dart';

/// Lets a downward swipe on the expanded player minimize it, following the
/// finger and snapping on release, like YouTube.
///
/// The miniplayer package only drags the panel when no inner widget claims
/// the gesture, but the video controls and the details list both do. So this
/// watches raw pointer events (outside the gesture arena) and drives the
/// panel through its [controller]. A swipe starts the drag when it begins on
/// the video, or in the details while they are scrolled to the top.
class DragToMinimize extends StatefulWidget {
  const DragToMinimize({
    super.key,
    required this.enabled,
    required this.controller,
    required this.minHeight,
    required this.maxHeight,
    required this.videoBottom,
    required this.child,
  });

  /// Only start drags while the panel is fully expanded.
  final bool enabled;
  final MiniplayerController controller;
  final double minHeight;
  final double maxHeight;

  /// Y of the video's bottom edge inside this widget.
  final double videoBottom;
  final Widget child;

  /// Release decision: collapse after a long enough or fast enough swipe.
  static bool shouldCollapse({required double dragDistance, required double velocity, required double maxHeight}) =>
      velocity > 700 || (velocity > -300 && dragDistance > maxHeight * 0.2);

  @override
  State<DragToMinimize> createState() => _DragToMinimizeState();
}

class _DragToMinimizeState extends State<DragToMinimize> {
  static const _slop = 12.0;

  double _detailsOffset = 0;
  Offset? _start;
  bool _candidate = false;
  bool _dragging = false;
  VelocityTracker? _velocity;
  int _pointers = 0;

  void _onDown(PointerDownEvent e) {
    _pointers++;
    if (_pointers > 1) {
      // A second finger: a pinch on the video, not a swipe down.
      if (_dragging) widget.controller.animateToHeight(state: PanelState.MAX);
      _dragging = false;
      _candidate = false;
      return;
    }
    _start = e.localPosition;
    _dragging = false;
    _candidate = widget.enabled && (e.localPosition.dy <= widget.videoBottom || _detailsOffset <= 0);
    _velocity = VelocityTracker.withKind(e.kind)..addPosition(e.timeStamp, e.position);
  }

  void _onMove(PointerMoveEvent e) {
    final start = _start;
    if (start == null || !_candidate) return;
    _velocity?.addPosition(e.timeStamp, e.position);
    final delta = e.localPosition - start;

    if (!_dragging) {
      // Mostly-vertical downward movement past the slop starts the drag.
      if (delta.dy > _slop && delta.dy > delta.dx.abs() * 1.5) {
        _dragging = true;
      } else if (delta.dy < -_slop || delta.dx.abs() > _slop) {
        _candidate = false; // scrolling up or swiping sideways
        return;
      } else {
        return;
      }
    }
    final height = (widget.maxHeight - delta.dy).clamp(widget.minHeight, widget.maxHeight);
    widget.controller.animateToHeight(height: height.roundToDouble(), duration: Duration.zero);
  }

  void _onEnd(PointerEvent e) {
    _pointers = (_pointers - 1).clamp(0, 10);
    final start = _start;
    if (_dragging && start != null) {
      final velocity = _velocity?.getVelocity().pixelsPerSecond.dy ?? 0;
      final collapse = DragToMinimize.shouldCollapse(
        dragDistance: e.localPosition.dy - start.dy,
        velocity: velocity,
        maxHeight: widget.maxHeight,
      );
      widget.controller.animateToHeight(state: collapse ? PanelState.MIN : PanelState.MAX);
    }
    _start = null;
    _dragging = false;
    _candidate = false;
  }

  @override
  Widget build(BuildContext context) => NotificationListener<ScrollNotification>(
        onNotification: (n) {
          // Only the details list itself, not horizontal rows inside it.
          if (n.depth == 0 && n.metrics.axis == Axis.vertical) _detailsOffset = n.metrics.pixels;
          return false;
        },
        child: Listener(
          onPointerDown: _onDown,
          onPointerMove: _onMove,
          onPointerUp: _onEnd,
          onPointerCancel: _onEnd,
          child: widget.child,
        ),
      );
}
