import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/server_config.dart';
import '../../core/utils/format.dart';
import '../../data/models/scrub_thumbnails.dart';
import '../../data/providers.dart';
import 'player_providers.dart';

/// Seek bar that shows a preview frame above the finger while scrubbing
/// (from Stash's sprite thumbnails, if generated) plus the target time.
/// Seeks once on release, like YouTube.
class PreviewSeekBar extends ConsumerStatefulWidget {
  const PreviewSeekBar({super.key, required this.sceneId, this.onInteractionStart, this.onInteractionEnd});

  final String sceneId;

  /// While the user touches the bar, e.g. to keep the controls visible.
  final VoidCallback? onInteractionStart;
  final VoidCallback? onInteractionEnd;

  @override
  ConsumerState<PreviewSeekBar> createState() => _PreviewSeekBarState();
}

class _PreviewSeekBarState extends ConsumerState<PreviewSeekBar> {
  static const _previewWidth = 160.0;

  final _overlay = OverlayPortalController();
  final _link = LayerLink();
  final _subscriptions = <StreamSubscription<Object?>>[];

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  Duration _buffer = Duration.zero;

  /// Fraction 0..1 while the user drags; null otherwise.
  double? _drag;
  double _barWidth = 1;

  @override
  void initState() {
    super.initState();
    final player = ref.read(playerProvider);
    _position = player.state.position;
    _duration = player.state.duration;
    _buffer = player.state.buffer;
    _subscriptions.addAll([
      player.stream.position.listen((v) => setState(() => _position = v)),
      player.stream.duration.listen((v) => setState(() => _duration = v)),
      player.stream.buffer.listen((v) => setState(() => _buffer = v)),
    ]);
  }

  @override
  void dispose() {
    for (final s in _subscriptions) {
      s.cancel();
    }
    super.dispose();
  }

  double get _totalMs => _duration.inMilliseconds.toDouble();

  double _fractionOf(Duration d) => _totalMs <= 0 ? 0 : (d.inMilliseconds / _totalMs).clamp(0.0, 1.0);

  void _update(double dx) {
    if (_drag == null) widget.onInteractionStart?.call();
    setState(() => _drag = (dx / _barWidth).clamp(0.0, 1.0));
    if (!_overlay.isShowing) _overlay.show();
  }

  /// Seeks to the dragged position and ends the interaction.
  void _end() {
    final drag = _drag;
    if (drag != null && _totalMs > 0) {
      ref.read(playerProvider).seek(Duration(milliseconds: (drag * _totalMs).round()));
    }
    _reset();
  }

  /// Ends the interaction without seeking.
  void _reset() {
    final wasActive = _drag != null;
    _overlay.hide();
    setState(() => _drag = null);
    if (wasActive) widget.onInteractionEnd?.call();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final played = _drag ?? _fractionOf(_position);
    final thumbs = ref.watch(scrubThumbnailsProvider(widget.sceneId)).value;
    final headers = ref.watch(authHeadersProvider);

    return OverlayPortal(
      controller: _overlay,
      overlayChildBuilder: (_) => _buildPreview(thumbs, headers),
      child: CompositedTransformTarget(
        link: _link,
        child: LayoutBuilder(
          builder: (context, constraints) {
            _barWidth = constraints.maxWidth;
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onHorizontalDragStart: (d) => _update(d.localPosition.dx),
              onHorizontalDragUpdate: (d) => _update(d.localPosition.dx),
              onHorizontalDragEnd: (_) => _end(),
              onHorizontalDragCancel: _reset,
              onTapDown: (d) => _update(d.localPosition.dx),
              onTapUp: (_) => _end(),
              // A drag winning over the tap cancels it: don't seek here, the
              // drag continues and seeks on release.
              onTapCancel: _reset,
              // Explicit full width: in a Column (loose constraints) a
              // childless CustomPaint would otherwise shrink to zero width.
              child: SizedBox(
                height: 28,
                width: double.infinity,
                child: CustomPaint(
                  painter: _SeekBarPainter(
                    played: played,
                    buffered: _fractionOf(_buffer),
                    dragging: _drag != null,
                    playedColor: colors.primary,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPreview(ScrubThumbnails? thumbs, Map<String, String> headers) {
    final drag = _drag ?? 0;
    final seconds = drag * _totalMs / 1000;
    final cue = thumbs?.cueAt(seconds);
    final previewHeight = cue == null ? 0.0 : _previewWidth * cue.height / cue.width;
    // Center the preview on the finger, but keep it within the bar.
    final left = (drag * _barWidth - _previewWidth / 2).clamp(0.0, (_barWidth - _previewWidth).clamp(0.0, double.infinity));

    return CompositedTransformFollower(
      link: _link,
      showWhenUnlinked: false,
      targetAnchor: Alignment.topLeft,
      followerAnchor: Alignment.bottomLeft,
      offset: Offset(left, -4),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: IgnorePointer(
          child: SizedBox(
            width: _previewWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (thumbs != null && cue != null)
                  DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 1.5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: SpriteFrame(
                        spriteUrl: thumbs.spriteUrl,
                        cue: cue,
                        width: _previewWidth,
                        height: previewHeight,
                        headers: headers,
                      ),
                    ),
                  ),
                const SizedBox(height: 4),
                DecoratedBox(
                  decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(4)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    child: Text(
                      formatDuration(seconds),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shows the [cue] region of the sprite image scaled to [width] × [height].
class SpriteFrame extends StatelessWidget {
  const SpriteFrame({
    super.key,
    required this.spriteUrl,
    required this.cue,
    required this.width,
    required this.height,
    this.headers = const {},
  });

  final String spriteUrl;
  final ScrubCue cue;
  final double width;
  final double height;
  final Map<String, String> headers;

  @override
  Widget build(BuildContext context) {
    final scale = width / cue.width;
    return SizedBox(
      width: width,
      height: height,
      child: ColoredBox(
        color: Colors.black,
        child: ClipRect(
          child: OverflowBox(
            alignment: Alignment.topLeft,
            minWidth: 0,
            minHeight: 0,
            maxWidth: double.infinity,
            maxHeight: double.infinity,
            child: Transform.scale(
              scale: scale,
              alignment: Alignment.topLeft,
              child: Transform.translate(
                offset: Offset(-cue.x, -cue.y),
                // Natural size: one logical pixel per sprite pixel, so the
                // cue's pixel coordinates apply directly.
                child: Image(
                  image: CachedNetworkImageProvider(spriteUrl, headers: headers),
                  filterQuality: FilterQuality.medium,
                  gaplessPlayback: true,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SeekBarPainter extends CustomPainter {
  _SeekBarPainter({required this.played, required this.buffered, required this.dragging, required this.playedColor});

  final double played;
  final double buffered;
  final bool dragging;
  final Color playedColor;

  @override
  void paint(Canvas canvas, Size size) {
    final trackHeight = dragging ? 5.0 : 3.0;
    final y = size.height / 2;
    final track = Rect.fromLTWH(0, y - trackHeight / 2, size.width, trackHeight);
    final radius = Radius.circular(trackHeight / 2);

    canvas.drawRRect(RRect.fromRectAndRadius(track, radius), Paint()..color = Colors.white24);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, track.top, size.width * buffered, trackHeight), radius),
      Paint()..color = Colors.white38,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, track.top, size.width * played, trackHeight), radius),
      Paint()..color = playedColor,
    );
    canvas.drawCircle(Offset(size.width * played, y), dragging ? 9 : 6, Paint()..color = playedColor);
  }

  @override
  bool shouldRepaint(_SeekBarPainter old) =>
      old.played != played || old.buffered != buffered || old.dragging != dragging || old.playedColor != playedColor;
}
