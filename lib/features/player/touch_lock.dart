import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import '../../core/config/theme.dart';
import '../../l10n/l10n.dart';

/// The touch lock in fullscreen (CTRL-3), above everything else in
/// `StashVideoControls`: while [locked] it takes every touch on the video,
/// so nothing seeks, pauses, zooms or shows the controls. A tap only shows
/// a lock icon for [iconDuration]; holding that icon for [unlockHold]
/// calls [onUnlock]. Screen readers get an "Unlock" action instead.
/// Empty and not hit-testable while unlocked.
class TouchLockLayer extends StatefulWidget {
  const TouchLockLayer({
    super.key,
    required this.locked,
    required this.onUnlock,
    this.iconDuration = const Duration(seconds: 2),
    this.unlockHold = const Duration(seconds: 1),
  });

  final bool locked;
  final VoidCallback onUnlock;
  final Duration iconDuration;
  final Duration unlockHold;

  @override
  State<TouchLockLayer> createState() => _TouchLockLayerState();
}

class _TouchLockLayerState extends State<TouchLockLayer> {
  bool _iconVisible = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.locked) _flash();
  }

  @override
  void didUpdateWidget(TouchLockLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.locked && !oldWidget.locked) {
      // Just locked: show where the lock went.
      _flash();
    } else if (!widget.locked && oldWidget.locked) {
      _timer?.cancel();
      _iconVisible = false;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Shows the lock icon and hides it again after [TouchLockLayer.iconDuration].
  void _flash() {
    _timer?.cancel();
    if (!_iconVisible) setState(() => _iconVisible = true);
    _timer = Timer(widget.iconDuration, () {
      if (mounted) setState(() => _iconVisible = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.locked) return const SizedBox.shrink();
    final l = context.l10n;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return Semantics(
      container: true,
      label: l.touchLocked,
      hint: l.holdToUnlock,
      onLongPress: widget.onUnlock,
      onLongPressHint: l.unlockTouch,
      customSemanticsActions: {CustomSemanticsAction(label: l.unlockTouch): widget.onUnlock},
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _flash,
          // Claimed so a swipe neither moves the panel nor reaches anything
          // below; they just do nothing.
          onVerticalDragStart: (_) {},
          onHorizontalDragStart: (_) {},
          child: Align(
            alignment: const Alignment(0, -0.6),
            child: IgnorePointer(
              ignoring: !_iconVisible,
              child: AnimatedOpacity(
                opacity: _iconVisible ? 1 : 0,
                duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 200),
                child: RawGestureDetector(
                  gestures: {
                    LongPressGestureRecognizer: GestureRecognizerFactoryWithHandlers<LongPressGestureRecognizer>(
                      () => LongPressGestureRecognizer(duration: widget.unlockHold),
                      (recognizer) => recognizer
                        // Keep the icon while the finger rests on it.
                        ..onLongPressDown = ((_) => _timer?.cancel())
                        ..onLongPressCancel = _flash
                        ..onLongPress = widget.onUnlock,
                    ),
                  },
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.of(context).videoScrimSoft,
                      borderRadius: AppRadius.pillBorder,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.s),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.lock_outline, color: Colors.white),
                          const SizedBox(width: AppSpacing.s),
                          Text(l.holdToUnlock, style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
