import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'animated_previews.dart';
import 'stash_image.dart';

/// Plays the animated preview of the first video fully shown in a list, a
/// few seconds after scrolling stopped, like YouTube. Wraps a scroll view;
/// the [AutoPreview]s of its thumbnails take part. Scrolling stops it.
class AutoPreviewScope extends StatefulWidget {
  const AutoPreviewScope({super.key, required this.child, this.delay = FeedPreviewDelayNotifier.standard});

  final Widget child;
  final Duration delay;

  @override
  State<AutoPreviewScope> createState() => _AutoPreviewScopeState();
}

class _AutoPreviewScopeState extends State<AutoPreviewScope> {
  final _active = ValueNotifier<_AutoPreviewState?>(null);
  final _tiles = <_AutoPreviewState>{};
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _schedule());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _active.dispose();
    super.dispose();
  }

  void _register(_AutoPreviewState tile) {
    _tiles.add(tile);
    // New tiles (a page loaded, the list built) can be the first shown.
    if (_active.value == null) _schedule();
  }

  void _unregister(_AutoPreviewState tile) {
    _tiles.remove(tile);
    if (_active.value == tile) _active.value = null;
  }

  void _schedule() {
    _timer?.cancel();
    _timer = Timer(widget.delay, _pick);
  }

  void _stop() {
    _timer?.cancel();
    _active.value = null;
  }

  /// The topmost (then leftmost) tile whose thumbnail is fully in view.
  void _pick() {
    if (!mounted) return;
    final scope = context.findRenderObject();
    if (scope is! RenderBox || !scope.hasSize) return;
    final view = (scope.localToGlobal(Offset.zero) & scope.size).inflate(1);
    _AutoPreviewState? best;
    Rect? bestRect;
    for (final tile in _tiles) {
      final rect = tile.rect;
      if (rect == null || !view.contains(rect.topLeft) || !view.contains(rect.bottomRight)) continue;
      if (bestRect == null ||
          rect.top < bestRect.top - 1 ||
          ((rect.top - bestRect.top).abs() <= 1 && rect.left < bestRect.left)) {
        best = tile;
        bestRect = rect;
      }
    }
    _active.value = best;
  }

  bool _onScroll(ScrollNotification n) {
    if (n.metrics.axis != Axis.vertical) return false;
    if (n is ScrollStartNotification || (n is ScrollUpdateNotification && n.dragDetails != null)) _stop();
    if (n is ScrollEndNotification) _schedule();
    return false;
  }

  @override
  Widget build(BuildContext context) => _AutoPreviewInherited(
        scope: this,
        child: NotificationListener<ScrollNotification>(onNotification: _onScroll, child: widget.child),
      );
}

class _AutoPreviewInherited extends InheritedWidget {
  const _AutoPreviewInherited({required this.scope, required super.child});

  final _AutoPreviewScopeState scope;

  @override
  bool updateShouldNotify(_AutoPreviewInherited old) => old.scope != scope;
}

/// A thumbnail that plays [url] (an animated WebP preview) over [child]
/// while it is the [AutoPreviewScope]'s pick. Just [child] without a scope,
/// without a preview, or when previews are off.
class AutoPreview extends ConsumerStatefulWidget {
  const AutoPreview({super.key, required this.url, required this.child});

  final String? url;
  final Widget child;

  @override
  ConsumerState<AutoPreview> createState() => _AutoPreviewState();
}

class _AutoPreviewState extends ConsumerState<AutoPreview> {
  _AutoPreviewScopeState? _scope;

  /// Where the thumbnail is on screen.
  Rect? get rect {
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.hasSize || !box.attached) return null;
    return box.localToGlobal(Offset.zero) & box.size;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scope = context.dependOnInheritedWidgetOfExactType<_AutoPreviewInherited>()?.scope;
    if (scope == _scope) return;
    _scope?._unregister(this);
    _scope = scope;
    if (widget.url != null) scope?._register(this);
  }

  @override
  void dispose() {
    _scope?._unregister(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scope = _scope;
    final url = widget.url;
    if (scope == null || url == null || !previewsPlay(context, ref, feedPreviewsProvider)) return widget.child;
    return ValueListenableBuilder<_AutoPreviewState?>(
      valueListenable: scope._active,
      child: widget.child,
      builder: (_, active, child) => Stack(
        fit: StackFit.expand,
        children: [
          child!,
          // Loops by itself; the thumbnail shows until it loaded, and if
          // it fails.
          if (active == this) StashImage(url, standIn: const SizedBox.shrink()),
        ],
      ),
    );
  }
}
