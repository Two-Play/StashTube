import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Builds the panel's content for its current height.
typedef SlidingPanelBuilder = Widget Function(BuildContext context, double height);

/// Where a drag on the collapsed panel ends up.
enum PanelSnap { expand, collapse, dismiss }

/// Drives a [SlidingPanel] from code: [NowPlayingNotifier.expand] and
/// `collapse`, and [DragToMinimize], which follows the finger with [jumpTo].
///
/// Calls while no panel is attached (nothing plays) do nothing.
class SlidingPanelController {
  _SlidingPanelState? _panel;

  bool get isAttached => _panel != null;

  /// Animates to the full height.
  void expand({Duration? duration}) {
    final panel = _panel;
    panel?._animateTo(panel.widget.maxHeight, duration: duration);
  }

  /// Animates down to the mini bar.
  void collapse({Duration? duration}) {
    final panel = _panel;
    panel?._animateTo(panel.widget.minHeight, duration: duration);
  }

  /// Sets the height right away (between the mini bar's and the full
  /// height), stopping a running animation.
  void jumpTo(double height) => _panel?._jumpTo(height);
}

/// The player's panel: a mini bar at the bottom that expands to
/// [maxHeight], like YouTube's player (replaces the unmaintained
/// `miniplayer` package).
///
/// * Collapsed (or on the way), a tap expands it, and a vertical drag
///   follows the finger and snaps to expanded or collapsed on release; a
///   drag below the bar dismisses it ([onDismissed]).
/// * Expanded, the panel takes no gestures itself: taps belong to the video
///   controls and the details, and swiping down is [DragToMinimize]'s, which
///   moves the panel through the [controller].
/// * [height] always holds the current height (at least [minHeight]), so the
///   shell can shrink the navigation bar along.
///
/// Back while expanded is handled by `AppShell`, which collapses the panel.
class SlidingPanel extends StatefulWidget {
  const SlidingPanel({
    super.key,
    required this.controller,
    required this.height,
    required this.minHeight,
    required this.maxHeight,
    required this.builder,
    this.onDismissed,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOut,
  });

  final SlidingPanelController controller;

  /// The current height; written by the panel.
  final ValueNotifier<double> height;
  final double minHeight;
  final double maxHeight;
  final SlidingPanelBuilder builder;

  /// Called once a drag down below the bar has slid it out; without it the
  /// bar can't be dismissed by dragging.
  final VoidCallback? onDismissed;
  final Duration duration;
  final Curve curve;

  /// Release decision for a drag on the panel. [progress]: 0 = collapsed,
  /// 1 = expanded; [dismissed]: how far below the bar (0–1); [velocity] in
  /// px/s, positive downwards.
  static PanelSnap snapAfterDrag({
    required double progress,
    required double dismissed,
    required double velocity,
    required bool canDismiss,
  }) {
    if (dismissed > 0) {
      return canDismiss && (velocity > 300 || (dismissed > 0.3 && velocity > -300))
          ? PanelSnap.dismiss
          : PanelSnap.collapse;
    }
    if (velocity < -300) return PanelSnap.expand;
    if (velocity > 300) return PanelSnap.collapse;
    return progress > 0.2 ? PanelSnap.expand : PanelSnap.collapse;
  }

  @override
  State<SlidingPanel> createState() => _SlidingPanelState();
}

class _SlidingPanelState extends State<SlidingPanel> with SingleTickerProviderStateMixin {
  late final AnimationController _animation = AnimationController(vsync: this)
    ..addListener(_onTick)
    ..addStatusListener(_onStatus);
  Animatable<double>? _tween;
  double? _target;

  /// Height including the part below the bar while dragging it out:
  /// 0 – [SlidingPanel.maxHeight]. [SlidingPanel.height] is this, but at
  /// least the bar's height.
  late double _extent = widget.height.value;

  /// How far the bar is dragged out below its place, 0–1.
  final _dismissed = ValueNotifier<double>(0);

  bool get _expanded => widget.height.value >= widget.maxHeight - 0.5;

  /// A drag on the panel itself is running; it keeps its gestures even once
  /// it reaches the top.
  bool _dragging = false;

  @override
  void initState() {
    super.initState();
    widget.controller._panel = this;
  }

  @override
  void didUpdateWidget(SlidingPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      if (oldWidget.controller._panel == this) oldWidget.controller._panel = null;
      widget.controller._panel = this;
    }
    if (oldWidget.maxHeight != widget.maxHeight) {
      // The window changed (the phone turned): an expanded panel stays
      // expanded. Later, since the height's listeners are being built.
      final oldMax = oldWidget.maxHeight;
      final wasExpanded = _animation.isAnimating ? _target == oldMax : _extent >= oldMax - 0.5;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (wasExpanded) {
          _animation.isAnimating ? _animateTo(widget.maxHeight) : _setExtent(widget.maxHeight);
        } else if (!_animation.isAnimating) {
          _setExtent(_extent);
        }
      });
    }
  }

  @override
  void dispose() {
    if (widget.controller._panel == this) widget.controller._panel = null;
    _animation.dispose();
    _dismissed.dispose();
    super.dispose();
  }

  bool get _canDismiss => widget.onDismissed != null;

  void _setExtent(double value) {
    _extent = value.clamp(_canDismiss ? 0.0 : widget.minHeight, widget.maxHeight);
    final height = math.max(_extent, widget.minHeight);
    if (widget.height.value != height) widget.height.value = height;
    final dismissed = ((widget.minHeight - _extent) / widget.minHeight).clamp(0.0, 1.0);
    if (_dismissed.value != dismissed) _dismissed.value = dismissed;
  }

  void _jumpTo(double height) {
    _animation.stop();
    _setExtent(height.clamp(widget.minHeight, widget.maxHeight));
  }

  void _animateTo(double target, {Duration? duration}) {
    _animation.stop();
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final length = reduceMotion ? Duration.zero : duration ?? widget.duration;
    if (_extent == target || length == Duration.zero) {
      _setExtent(target);
      _onArrived();
      return;
    }
    _target = target;
    _tween = Tween<double>(begin: _extent, end: target).chain(CurveTween(curve: widget.curve));
    _animation
      ..duration = length
      ..forward(from: 0);
  }

  void _onTick() {
    final tween = _tween;
    if (tween != null) _setExtent(tween.transform(_animation.value));
  }

  void _onStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) _onArrived();
  }

  void _onArrived() {
    if (_canDismiss && _extent <= 0) widget.onDismissed!();
  }

  void _onDragStart(DragStartDetails _) {
    _animation.stop();
    _dragging = true;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    _animation.stop();
    _setExtent(_extent - details.delta.dy);
  }

  void _onDragEnd(DragEndDetails details) {
    _dragging = false;
    final range = widget.maxHeight - widget.minHeight;
    final snap = SlidingPanel.snapAfterDrag(
      progress: range <= 0 ? 1 : (_extent - widget.minHeight) / range,
      dismissed: _dismissed.value,
      velocity: details.primaryVelocity ?? 0,
      canDismiss: _canDismiss,
    );
    _animateTo(switch (snap) {
      PanelSnap.expand => widget.maxHeight,
      PanelSnap.collapse => widget.minHeight,
      PanelSnap.dismiss => 0,
    });
  }

  @override
  Widget build(BuildContext context) {
    final scrim = Theme.of(context).colorScheme.scrim;
    return ValueListenableBuilder<double>(
      valueListenable: widget.height,
      builder: (context, value, _) {
        final height = math.min(value, widget.maxHeight);
        final range = widget.maxHeight - widget.minHeight;
        final progress = range <= 0 ? 1.0 : ((height - widget.minHeight) / range).clamp(0.0, 1.0);
        // Expanded, gestures belong to the content (see the class comment).
        final own = !_expanded || _dragging;
        return Stack(
          children: [
            // Dims the page above the panel while it grows; a tap there
            // collapses it again.
            if (progress > 0)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: widget.controller.collapse,
                  child: ColoredBox(color: scrim.withValues(alpha: 0.44 * progress)),
                ),
              ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: height,
                width: double.infinity,
                // Always the same wrappers (only values change), so the
                // content, and with it the video, is never remounted.
                child: ValueListenableBuilder<double>(
                  valueListenable: _dismissed,
                  builder: (context, dismissed, child) => Opacity(
                    opacity: 1 - dismissed * 0.8,
                    child: Transform.translate(offset: Offset(0, widget.minHeight * dismissed * 0.5), child: child),
                  ),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: own ? widget.controller.expand : null,
                    onVerticalDragStart: own ? _onDragStart : null,
                    onVerticalDragUpdate: own ? _onDragUpdate : null,
                    onVerticalDragEnd: own ? _onDragEnd : null,
                    onVerticalDragCancel: own ? () => _dragging = false : null,
                    child: Material(child: widget.builder(context, height)),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
