import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// True while the player's fullscreen is open or the screen is still turning
/// back from it: the app behind it keeps its layout ([LayoutFreeze]).
final shellLayoutHold = LayoutHold();

/// A hold for [LayoutFreeze], with a fallback release that a real one
/// cancels.
class LayoutHold extends ValueNotifier<bool> {
  LayoutHold() : super(false);

  Timer? _fallback;

  void hold() {
    _fallback?.cancel();
    value = true;
  }

  void release() {
    _fallback?.cancel();
    _fallback = null;
    value = false;
  }

  /// Releases after [after] unless [hold] or [release] come first.
  void releaseLater(Duration after) {
    if (!value) return;
    _fallback?.cancel();
    _fallback = Timer(after, release);
  }
}

/// Keeps [child]'s layout (its constraints and the [MediaQuery]) as it was
/// while [hold] is true, so a turn of the window it doesn't show doesn't
/// lay it out anew.
///
/// The player's fullscreen turns a phone's window to landscape. The lists
/// behind it then got the rail and more columns (`kWideLayoutBreakpoint`),
/// became much shorter, and their scroll offset (in pixels) was clamped to
/// the new end; back in portrait the list showed items far above the one
/// that was opened. Frozen, the lists never see the landscape window.
///
/// After [hold] goes false the layout stays frozen until the constraints are
/// back to the frozen ones (the screen has turned back), at most [settle]:
/// a tablet may stay sideways, and then gets its new layout.
///
/// The tree is the same frozen or not, so nothing below is remounted.
class LayoutFreeze extends StatefulWidget {
  const LayoutFreeze({
    super.key,
    required this.hold,
    required this.child,
    this.settle = const Duration(milliseconds: 800),
  });

  final ValueListenable<bool> hold;
  final Duration settle;
  final Widget child;

  @override
  State<LayoutFreeze> createState() => _LayoutFreezeState();
}

class _LayoutFreezeState extends State<LayoutFreeze> {
  BoxConstraints? _constraints;
  MediaQueryData? _data;
  bool _frozen = false;
  Timer? _release;

  @override
  void initState() {
    super.initState();
    widget.hold.addListener(_onHold);
  }

  @override
  void didUpdateWidget(LayoutFreeze oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hold != widget.hold) {
      oldWidget.hold.removeListener(_onHold);
      widget.hold.addListener(_onHold);
      _onHold();
    }
  }

  @override
  void dispose() {
    widget.hold.removeListener(_onHold);
    _release?.cancel();
    super.dispose();
  }

  void _onHold() {
    if (widget.hold.value) {
      _release?.cancel();
      // Nothing to keep before the first layout.
      if (_constraints != null && !_frozen) setState(() => _frozen = true);
    } else if (_frozen) {
      _release?.cancel();
      _release = Timer(widget.settle, () {
        if (mounted && !widget.hold.value) setState(() => _frozen = false);
      });
      // The builder unfreezes at once when the constraints already match.
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final data = MediaQuery.of(context);
          if (_frozen && !widget.hold.value && constraints == _constraints) {
            _frozen = false;
            _release?.cancel();
          }
          if (!_frozen) {
            _constraints = constraints;
            _data = data;
          }
          final kept = _frozen ? _constraints! : constraints;
          return ClipRect(
            clipBehavior: _frozen ? Clip.hardEdge : Clip.none,
            child: OverflowBox(
              alignment: Alignment.topLeft,
              minWidth: kept.minWidth,
              maxWidth: kept.maxWidth,
              minHeight: kept.minHeight,
              maxHeight: kept.maxHeight,
              child: MediaQuery(data: _frozen ? _data! : data, child: widget.child),
            ),
          );
        },
      );
}
