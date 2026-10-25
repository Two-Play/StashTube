import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';

import '../../core/config/haptics.dart';
import '../../core/config/theme.dart';
import '../../core/utils/format.dart';
import '../../data/models/scene_details.dart';
import '../../data/models/scrub_thumbnails.dart';
import '../../data/providers.dart';
import '../../data/repositories/stash_session.dart';
import '../../l10n/l10n.dart';
import '../../widgets/scene_card.dart';
import 'player_providers.dart';

/// A part of the video the seek bar covers instead of the whole, e.g. a
/// marker short's clip.
typedef SeekWindow = ({Duration start, Duration end});

/// Seek bar that shows a preview frame above the finger while scrubbing
/// (from Stash's sprite thumbnails, if generated) plus the target time and
/// chapter. Chapters (scene markers) split the bar into segments and are
/// marked with dots; ranged markers (newer Stash) tint their part of the
/// track. Scrubbing near a marker's start or end snaps onto it. Seeks
/// once on release, like YouTube.
///
/// The thumbnails load lazily: the WebVTT once the bar is [visible] or
/// touched, then the sprite is precached so the first scrub shows frames.
///
/// With a [window] the bar covers only that part of the video: its ends are
/// the window's, times read relative to its start, seeking stays inside it
/// and markers outside it aren't drawn. The preview frame is still the one
/// at the absolute time.
class PreviewSeekBar extends ConsumerStatefulWidget {
  const PreviewSeekBar({
    super.key,
    required this.sceneId,
    this.player,
    this.visible = true,
    this.onInteractionStart,
    this.onInteractionEnd,
    this.remote,
    this.window,
    this.windowRelative = false,
  });

  final String sceneId;

  /// The part of the video the bar covers; null for the whole video.
  final SeekWindow? window;

  /// The [player] plays only the [window] (a marker loop's clip): its
  /// position 0 is the window's start, and so are its seeks.
  final bool windowRelative;

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

  /// [_position] as a fraction of the bar, for the painter: mpv reports the
  /// position every frame, which repaints the bar without rebuilding it.
  final _played = ValueNotifier<double>(0);
  Duration _duration = Duration.zero;
  Duration _buffer = Duration.zero;

  /// Fraction 0..1 while the user drags; null otherwise.
  double? _drag;
  double _barWidth = 1;

  /// Scene marker starts and range ends as fractions of the duration, from
  /// the last build: where scrubbing snaps.
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
    _position = player.state.position + _offset;
    _duration = player.state.duration + _offset;
    _buffer = player.state.buffer + _offset;
    _subscriptions.addAll([
      player.stream.position.listen(_onPosition),
      player.stream.duration.listen((v) => setState(() => _duration = v + _offset)),
      player.stream.buffer.listen((v) => setState(() => _buffer = v + _offset)),
    ]);
  }

  /// Added to the player's times: the window's start when it plays only
  /// the window ([PreviewSeekBar.windowRelative]).
  Duration get _offset => widget.windowRelative ? widget.window?.start ?? Duration.zero : Duration.zero;

  void _onPosition(Duration relative) {
    final position = relative + _offset;
    final second = _position.inSeconds;
    _position = position;
    _played.value = _fractionOf(position);
    // A rebuild only for the spoken value (screen readers), once a second.
    if (position.inSeconds != second) setState(() {});
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
    _played.dispose();
    super.dispose();
  }

  double get _totalMs => (widget.remote?.duration ?? _duration).inMilliseconds.toDouble();

  /// Where the bar starts, in milliseconds of the video.
  double get _startMs => (widget.window?.start.inMilliseconds ?? 0).toDouble();

  /// Where the bar ends: the window's end (within the video, once its
  /// length is known), else the video's length.
  double get _endMs {
    final window = widget.window;
    if (window == null) return _totalMs;
    final end = window.end.inMilliseconds.toDouble();
    return _totalMs > 0 && end > _totalMs ? _totalMs : end;
  }

  /// The length the bar covers.
  double get _spanMs => _endMs - _startMs;

  double _fractionOf(Duration d) => _spanMs <= 0 ? 0 : ((d.inMilliseconds - _startMs) / _spanMs).clamp(0.0, 1.0);

  /// The video's time at [fraction] of the bar, inside the window.
  Duration _timeAt(double fraction) =>
      Duration(milliseconds: (_startMs + fraction.clamp(0.0, 1.0) * _spanMs).round());

  void _seek(Duration target) {
    final remote = widget.remote;
    remote == null ? _player.seek(target - _offset) : remote.seek(target);
  }

  /// For screen readers: a step back or forward, kept inside the window.
  void _step(Duration by) {
    final position = widget.remote?.position ?? _position;
    final min = Duration(milliseconds: _startMs.round());
    final max = Duration(milliseconds: _endMs.round());
    final target = position + by;
    _seek(target < min ? min : (target > max ? max : target));
  }

  static const _semanticsStep = Duration(seconds: 10);

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
    if (drag != null && _spanMs > 0) _seek(_timeAt(drag));
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
    // The duration or the window may have changed since the last position.
    if (remote == null) _played.value = _fractionOf(_position);
    final headers = ref.watch(authHeadersProvider);
    final thumbs = _loadThumbnails ? ref.watch(scrubThumbnailsProvider(widget.sceneId)).value : null;
    if (thumbs != null && thumbs.spriteUrl != _precachedSprite) {
      _precachedSprite = thumbs.spriteUrl;
      // Errors are fine: the preview then shows only the time.
      unawaited(precacheImage(CachedNetworkImageProvider(thumbs.spriteUrl, headers: headers), context,
          onError: (_, _) {}));
    }
    // Like the thumbnails, only once the bar is shown or touched.
    final details = _loadThumbnails ? ref.watch(sceneDetailsProvider(widget.sceneId)).value : null;
    // With a window, only the markers inside it (ranges cut to it), and not
    // the one the window starts at: that is the clip itself.
    final windowed = widget.window != null;
    final startSeconds = _startMs / 1000;
    final endSeconds = _endMs / 1000;
    final markers = [
      for (final m in details?.markers ?? const <SceneMarker>[])
        if (!windowed ||
            (m.seconds != startSeconds && m.seconds < endSeconds && (m.endSeconds ?? m.seconds) >= startSeconds))
          m,
    ];
    double fraction(double seconds) => ((seconds * 1000 - _startMs) / _spanMs).clamp(0.0, 1.0);
    final points = [
      if (_spanMs > 0)
        for (final m in markers)
          if (!m.isRange) fraction(m.seconds),
    ];
    final ranges = [
      if (_spanMs > 0)
        for (final m in markers)
          if (m.endSeconds case final end?) (fraction(m.seconds), fraction(end)),
    ];
    _markerFractions = [...points, for (final (start, end) in ranges) ...[start, end]];

    return OverlayPortal(
      controller: _overlay,
      overlayChildBuilder: (_) => _buildPreview(thumbs, headers, details),
      child: CompositedTransformTarget(
        link: _link,
        child: LayoutBuilder(
          builder: (context, constraints) {
            _barWidth = constraints.maxWidth;
            final l = context.l10n;
            final position = remote?.position ?? _position;
            final span = _spanMs;
            // Relative to the window, like the bar.
            String? spoken(double offsetMs) => span <= 0
                ? null
                : l.seekBarValue(
                    spokenDuration(l, (position.inMilliseconds - _startMs + offsetMs).clamp(0.0, span) / 1000),
                    spokenDuration(l, span / 1000),
                  );
            final step = _semanticsStep.inMilliseconds.toDouble();
            return Semantics(
              slider: true,
              label: l.seekBar,
              value: spoken(0),
              increasedValue: spoken(step),
              decreasedValue: spoken(-step),
              onIncrease: span <= 0 ? null : () => _step(_semanticsStep),
              onDecrease: span <= 0 ? null : () => _step(-_semanticsStep),
              child: GestureDetector(
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
                    painter: SeekBarPainter(
                      played: played,
                      // Follows the player between rebuilds.
                      progress: _drag == null && remote == null ? _played : null,
                      buffered: remote == null ? _fractionOf(_buffer) : 0,
                      dragging: _drag != null,
                      playedColor: colors.primary,
                      rangeColor: colors.tertiary,
                      chapters: points,
                      ranges: ranges,
                    ),
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
    // The frame and chapter at the video's time; the label relative to the
    // window, like the bar.
    final seconds = _timeAt(drag).inMilliseconds / 1000;
    final label = seconds - _startMs / 1000;
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
                const SizedBox(height: AppSpacing.xs),
                DecoratedBox(
                  decoration: BoxDecoration(color: AppColors.of(context).videoScrimSoft, borderRadius: AppRadius.badgeBorder),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    child: Text(
                      chapter == null ? formatDuration(label) : '${formatDuration(label)} • $chapter',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: AppTextSize.overlayBody),
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

/// Paints [PreviewSeekBar]'s track; public for tests.
@visibleForTesting
class SeekBarPainter extends CustomPainter {
  SeekBarPainter({
    required this._played,
    required this.buffered,
    required this.dragging,
    required this.playedColor,
    Color? rangeColor,
    this.chapters = const [],
    this.ranges = const [],
    this.progress,
  })  : rangeColor = rangeColor ?? playedColor,
        super(repaint: progress);

  final double _played;

  /// When given, the played fraction is read from it at paint time, and a
  /// change repaints without a new painter.
  final ValueListenable<double>? progress;

  double get played => progress?.value ?? _played;
  final double buffered;
  final bool dragging;
  final Color playedColor;

  /// Tint of the ranged markers' parts of the track.
  final Color rangeColor;

  /// Moments (scene markers without an end) as fractions of the duration:
  /// gaps in the track plus a dot each.
  final List<double> chapters;

  /// Ranged markers as (start, end) fractions: a tinted segment of the track
  /// with a gap at either end and a dot at the start.
  final List<(double, double)> ranges;

  List<double> get markers => [
    for (final c in [...chapters, for (final (start, _) in ranges) start])
      if (c >= 0 && c <= 1) c,
  ];

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
    // Ranges over the track, slightly taller, translucent so played and
    // buffered still show through.
    final rangePaint = Paint()..color = rangeColor.withValues(alpha: 0.55);
    for (final (start, end) in ranges) {
      if (end <= start) continue;
      final rect = Rect.fromLTRB(size.width * start, track.top - 1, size.width * end, track.bottom + 1);
      canvas.drawRect(rect, rangePaint);
    }
    final gap = Paint()..blendMode = BlendMode.clear;
    for (final c in [...chapters, for (final (start, end) in ranges) ...[start, end]]) {
      if (c <= 0 || c >= 1) continue;
      canvas.drawRect(Rect.fromLTWH(size.width * c - _chapterGap / 2, track.top - 1, _chapterGap, trackHeight + 2), gap);
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
  bool shouldRepaint(SeekBarPainter old) =>
      old.progress != progress ||
      old.played != played ||
      old.buffered != buffered ||
      old.dragging != dragging ||
      old.playedColor != playedColor ||
      old.rangeColor != rangeColor ||
      !listEquals(old.chapters, chapters) ||
      !listEquals(old.ranges, ranges);
}
