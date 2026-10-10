import '../../core/config/haptics.dart';
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';

import '../../core/utils/format.dart';
import '../../data/models/scene_details.dart';
import '../../data/models/scrub_thumbnails.dart';
import '../../data/providers.dart';
import '../../data/repositories/stash_session.dart';
import 'player_providers.dart';

/// Seek bar that shows a preview frame above the finger while scrubbing
/// (from Stash's sprite thumbnails, if generated) plus the target time and
/// chapter. Chapters (scene markers) split the bar into segments and are
/// marked with dots; scrubbing near one snaps onto it. Seeks
/// once on release, like YouTube.
///
/// The thumbnails load lazily: the WebVTT once the bar is [visible] or
/// touched, then the sprite is precached so the first scrub shows frames.
class PreviewSeekBar extends ConsumerStatefulWidget {
  const PreviewSeekBar({
    super.key,
    required this.sceneId,
    this.player,
    this.visible = true,
    this.onInteractionStart,
    this.onInteractionEnd,
    this.remote,
  });

  final String sceneId;

  /// While casting: the TV's playback, shown and seeked instead of the
  /// [player]'s.
  final RemoteSeek? remote;

  /// The player to show and seek; defaults to the app's main player
  /// (the shorts pass one of theirs).
  final Player? player;

  /// Whether the bar is shown. The controls stay mounted while hidden, so
  /// this keeps a hidden bar from loading the thumbnails.
  final bool visible;

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

  /// Scene markers as fractions of the duration, from the last build.
  List<double> _markerFractions = const [];

  /// The marker the drag currently snaps to.
  double? _snappedTo;

  /// Within this distance of a marker, scrubbing snaps onto it.
  static const _snapDistance = 10.0;

  double? _markerNear(double fraction) {
    double? best;
    for (final m in _markerFractions) {
      final distance = (m - fraction).abs() * _barWidth;
      if (distance <= _snapDistance && (best == null || distance < (best - fraction).abs() * _barWidth)) best = m;
    }
    return best;
  }

  /// Set once the user may seek; stays set for this scene.
  late bool _loadThumbnails = widget.visible;
  String? _precachedSprite;

  Player get _player => widget.player ?? ref.read(playerProvider);

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  void _subscribe() {
    for (final s in _subscriptions) {
      s.cancel();
    }
    _subscriptions.clear();
    if (widget.remote != null) return;
    final player = _player;
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
  void didUpdateWidget(PreviewSeekBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.player != widget.player || (oldWidget.remote == null) != (widget.remote == null)) _subscribe();
    if (oldWidget.sceneId != widget.sceneId) _loadThumbnails = false;
    if (widget.visible) _loadThumbnails = true;
  }

  @override
  void dispose() {
    for (final s in _subscriptions) {
      s.cancel();
    }
    super.dispose();
  }

  double get _totalMs => (widget.remote?.duration ?? _duration).inMilliseconds.toDouble();

  double _fractionOf(Duration d) => _totalMs <= 0 ? 0 : (d.inMilliseconds / _totalMs).clamp(0.0, 1.0);

  void _update(double dx) {
    if (_drag == null) widget.onInteractionStart?.call();
    final fraction = (dx / _barWidth).clamp(0.0, 1.0);
    final snapped = _markerNear(fraction);
    if (snapped != null && snapped != _snappedTo) Haptics.selection();
    _snappedTo = snapped;
    setState(() {
      _loadThumbnails = true;
      _drag = snapped ?? fraction;
    });
    if (!_overlay.isShowing) _overlay.show();
  }

  /// Seeks to the dragged position and ends the interaction.
  void _end() {
    final drag = _drag;
    if (drag != null && _totalMs > 0) {
      final target = Duration(milliseconds: (drag * _totalMs).round());
      final remote = widget.remote;
      remote == null ? _player.seek(target) : remote.seek(target);
    }
    _reset();
  }

  /// Ends the interaction without seeking.
  void _reset() {
    final wasActive = _drag != null;
    _overlay.hide();
    _snappedTo = null;
    setState(() => _drag = null);
    if (wasActive) widget.onInteractionEnd?.call();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final remote = widget.remote;
    final played = _drag ?? _fractionOf(remote?.position ?? _position);
    final headers = ref.watch(authHeadersProvider);
    final thumbs = _loadThumbnails ? ref.watch(scrubThumbnailsProvider(widget.sceneId)).value : null;
    if (thumbs != null && thumbs.spriteUrl != _precachedSprite) {
      _precachedSprite = thumbs.spriteUrl;
      // Errors are fine: the preview then shows only the time.
      unawaited(precacheImage(CachedNetworkImageProvider(thumbs.spriteUrl, headers: headers), context,
          onError: (_, _) {}));
    }
    final details = ref.watch(sceneDetailsProvider(widget.sceneId)).value;
    final markers = details?.markers ?? const <SceneMarker>[];
    _markerFractions = [
      if (_totalMs > 0)
        for (final m in markers) (m.seconds * 1000 / _totalMs).clamp(0.0, 1.0),
    ];

    return OverlayPortal(
      controller: _overlay,
      overlayChildBuilder: (_) => _buildPreview(thumbs, headers, details),
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
                    buffered: remote == null ? _fractionOf(_buffer) : 0,
                    dragging: _drag != null,
                    playedColor: colors.primary,
                    chapters: _markerFractions,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPreview(ScrubThumbnails? thumbs, Map<String, String> headers, SceneDetails? details) {
    final drag = _drag ?? 0;
    final seconds = drag * _totalMs / 1000;
    final cue = thumbs?.cueAt(seconds);
    final chapter = details?.markerAt(seconds)?.title;
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
                      chapter == null ? formatDuration(seconds) : '${formatDuration(seconds)} • $chapter',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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

/// Playback on a cast device for [PreviewSeekBar.remote].
@immutable
class RemoteSeek {
  const RemoteSeek({required this.position, required this.duration, required this.seek});

  final Duration position;
  final Duration duration;
  final ValueChanged<Duration> seek;
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
  _SeekBarPainter({
    required this.played,
    required this.buffered,
    required this.dragging,
    required this.playedColor,
    this.chapters = const [],
  });

  final double played;
  final double buffered;
  final bool dragging;
  final Color playedColor;

  /// Chapter starts (scene markers) as fractions of the duration: gaps in
  /// the track plus a dot each.
  final List<double> chapters;

  List<double> get markers => [for (final c in chapters) if (c >= 0 && c <= 1) c];

  static const _chapterGap = 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    final trackHeight = dragging ? 5.0 : 3.0;
    final y = size.height / 2;
    final track = Rect.fromLTWH(0, y - trackHeight / 2, size.width, trackHeight);
    final radius = Radius.circular(trackHeight / 2);

    // The track in a layer of its own, so chapter gaps can be cut out of it.
    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawRRect(RRect.fromRectAndRadius(track, radius), Paint()..color = Colors.white24);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, track.top, size.width * buffered, trackHeight), radius),
      Paint()..color = Colors.white38,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, track.top, size.width * played, trackHeight), radius),
      Paint()..color = playedColor,
    );
    final gap = Paint()..blendMode = BlendMode.clear;
    for (final c in chapters) {
      if (c <= 0 || c >= 1) continue;
      canvas.drawRect(Rect.fromLTWH(size.width * c - _chapterGap / 2, track.top, _chapterGap, trackHeight), gap);
    }
    canvas.restore();
    // Markers as dots on the track, so they can be found without scrubbing.
    final markerRadius = dragging ? 4.0 : 3.0;
    final outline = Paint()..color = Colors.black54;
    for (final m in markers) {
      final center = Offset(size.width * m, y);
      canvas.drawCircle(center, markerRadius + 1, outline);
      canvas.drawCircle(center, markerRadius, Paint()..color = Colors.white);
    }
    canvas.drawCircle(Offset(size.width * played, y), dragging ? 9 : 6, Paint()..color = playedColor);
  }

  @override
  bool shouldRepaint(_SeekBarPainter old) =>
      old.played != played ||
      old.buffered != buffered ||
      old.dragging != dragging ||
      old.playedColor != playedColor ||
      !listEquals(old.chapters, chapters);
}
