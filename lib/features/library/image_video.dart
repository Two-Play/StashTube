import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../../core/config/haptics.dart';
import '../../core/config/theme.dart';
import '../../core/pagination/paged_notifier.dart';
import '../../core/pagination/paging_mode.dart';
import '../../data/models/list_queries.dart';
import '../../core/utils/format.dart';
import '../../data/models/image_item.dart';
import '../../l10n/l10n.dart';
import '../../widgets/hold_detector.dart';
import '../../widgets/play_pause_icon.dart';
import '../player/seek_settings.dart';
import '../../widgets/stash_image.dart';
import '../shell/navigation.dart';
import '../shorts/shorts_feed.dart';
import '../shorts/shorts_page.dart';

/// Opens the video files of an image grid ([query], loaded as [state]) as
/// shorts, at [at] or the first one (#64).
void openImageClipsAsShorts(WidgetRef ref, ImageQuery query, PagedState<ImageItem> state, {ImageItem? at, String? title}) {
  Haptics.light();
  final index = at == null ? -1 : state.items.indexOf(at);
  final numbered = ref.read(pagingModeProvider) == PagingMode.pages;
  final start = index < 0
      ? (startPage: numbered ? state.page : 1, initialIndex: 0)
      : imageShortsStart(state.items, index, page: numbered ? state.page : null, perPage: state.perPage);
  openPage(
    ref,
    ShortsPage(
      source: ShortsSource.images(query, startPage: start.startPage, title: title),
      initialIndex: start.initialIndex,
    ),
  );
}

/// A gallery's video file (#64) on its page in the image viewer: the
/// thumbnail, and over it the video once [controller] plays it (only the
/// current page gets one; the viewer owns the player). Like the player:
/// pinch to zoom (up to 4×), double tap on the left or right third to skip
/// a step back or on ([seekSettingsProvider]), hold for 2× speed.
class ImageVideoPage extends ConsumerStatefulWidget {
  const ImageVideoPage({
    super.key,
    required this.image,
    this.controller,
    required this.onTap,
    required this.onZoomChanged,
  });

  final ImageItem image;
  final VideoController? controller;

  /// A single tap: the viewer toggles its overlay.
  final VoidCallback onTap;

  /// Zoomed in, horizontal and vertical drags pan instead of paging or
  /// closing.
  final ValueChanged<bool> onZoomChanged;

  @override
  ConsumerState<ImageVideoPage> createState() => _ImageVideoPageState();
}

class _ImageVideoPageState extends ConsumerState<ImageVideoPage> {
  final _transform = TransformationController();
  Offset _doubleTapAt = Offset.zero;

  /// The feedback of the last double tap: -1 back, 1 on; 0 none.
  int _skipped = 0;
  int _skipTick = 0;
  Timer? _skipTimer;

  /// The speed before holding for 2×; null while not holding.
  double? _rateBeforeHold;

  @override
  void dispose() {
    _skipTimer?.cancel();
    _transform.dispose();
    final rate = _rateBeforeHold;
    if (rate != null) widget.controller?.player.setRate(rate);
    super.dispose();
  }

  bool get _isZoomed => _transform.value.getMaxScaleOnAxis() > 1.01;

  void _onDoubleTap() {
    final player = widget.controller?.player;
    final width = context.size?.width ?? 0;
    if (player == null || width <= 0) return;
    final x = _doubleTapAt.dx;
    final direction = x < width / 3 ? -1 : (x > width * 2 / 3 ? 1 : 0);
    if (direction == 0) {
      Haptics.light();
      unawaited(player.playOrPause());
      return;
    }
    final step = ref.read(seekSettingsProvider).step;
    final state = player.state;
    var target = state.position + step * direction;
    if (target < Duration.zero) target = Duration.zero;
    if (state.duration > Duration.zero && target > state.duration) target = state.duration;
    unawaited(player.seek(target));
    Haptics.selection();
    _skipTimer?.cancel();
    _skipTimer = Timer(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _skipped = 0);
    });
    setState(() {
      _skipped = direction;
      _skipTick++;
    });
  }

  void _startHold() {
    final player = widget.controller?.player;
    if (player == null || _rateBeforeHold != null) return;
    Haptics.light();
    setState(() => _rateBeforeHold = player.state.rate);
    unawaited(player.setRate(2));
  }

  void _endHold() {
    final rate = _rateBeforeHold;
    if (rate == null) return;
    unawaited(widget.controller?.player.setRate(rate));
    setState(() => _rateBeforeHold = null);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final controller = widget.controller;
    final step = ref.watch(seekSettingsProvider.select((s) => s.step)).inSeconds;
    return Stack(
      fit: StackFit.expand,
      children: [
        HoldDetector(
          onHoldStart: _startHold,
          onHoldEnd: _endHold,
          child: GestureDetector(
            onTap: widget.onTap,
            onDoubleTapDown: (details) => _doubleTapAt = details.localPosition,
            onDoubleTap: controller == null ? null : _onDoubleTap,
            child: InteractiveViewer(
              transformationController: _transform,
              maxScale: 4,
              onInteractionEnd: (_) => widget.onZoomChanged(_isZoomed),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Center(
                    child: StashImage(widget.image.thumbnailUrl, fit: BoxFit.contain, fallbackIcon: Icons.movie_outlined),
                  ),
                  if (controller != null)
                    Video(controller: controller, fit: BoxFit.contain, fill: Colors.transparent, controls: _noControls)
                  else
                    const Center(child: Icon(Icons.play_circle_outline, color: Colors.white70, size: 64)),
                ],
              ),
            ),
          ),
        ),
        if (_skipped != 0)
          IgnorePointer(
            child: Align(
              alignment: _skipped < 0 ? const Alignment(-0.7, 0) : const Alignment(0.7, 0),
              child: _SkipLabel(
                key: ValueKey(_skipTick),
                text: _skipped < 0 ? l.seekBackSeconds(step) : l.seekForwardSeconds(step),
                icon: _skipped < 0 ? Icons.fast_rewind : Icons.fast_forward,
              ),
            ),
          ),
        if (_rateBeforeHold != null)
          IgnorePointer(
            child: Align(
              alignment: const Alignment(0, -0.75),
              child: _Pill(child: Text(l.fastForward2x, style: const TextStyle(color: Colors.white))),
            ),
          ),
      ],
    );
  }
}

class _SkipLabel extends StatelessWidget {
  const _SkipLabel({super.key, required this.text, required this.icon});

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
        tween: Tween(begin: MediaQuery.disableAnimationsOf(context) ? 1 : 0.85, end: 1),
        duration: const Duration(milliseconds: 150),
        builder: (_, scale, child) => Transform.scale(scale: scale, child: child),
        child: _Pill(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: AppSpacing.xs),
              Text(text, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      );
}

class _Pill extends StatelessWidget {
  const _Pill({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(color: AppColors.of(context).videoScrimSoft, borderRadius: AppRadius.pillBorder),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.xs),
          child: child,
        ),
      );
}

/// media_kit's `NoVideoControls` is `null`, which `Video` ignores.
Widget _noControls(VideoState state) => const SizedBox.shrink();

/// Play/pause, the position as a slider, the times and mute, for the video
/// in the image viewer's bottom overlay.
class ImageVideoBar extends StatefulWidget {
  const ImageVideoBar({super.key, required this.player});

  final Player player;

  @override
  State<ImageVideoBar> createState() => _ImageVideoBarState();
}

class _ImageVideoBarState extends State<ImageVideoBar> {
  final _subscriptions = <StreamSubscription<Object?>>[];
  late bool _playing;
  late Duration _position;
  late Duration _duration;
  late double _volume;

  /// The slider's value while it is dragged, in seconds.
  double? _dragging;

  @override
  void initState() {
    super.initState();
    _listen();
  }

  @override
  void didUpdateWidget(ImageVideoBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.player != widget.player) {
      _cancel();
      _listen();
    }
  }

  void _listen() {
    final player = widget.player;
    final state = player.state;
    _playing = state.playing;
    _position = state.position;
    _duration = state.duration;
    _volume = state.volume;
    void update(VoidCallback change) {
      if (mounted) setState(change);
    }

    _subscriptions.addAll([
      player.stream.playing.listen((v) => update(() => _playing = v)),
      player.stream.position.listen((v) => update(() => _position = v)),
      player.stream.duration.listen((v) => update(() => _duration = v)),
      player.stream.volume.listen((v) => update(() => _volume = v)),
    ]);
  }

  void _cancel() {
    for (final s in _subscriptions) {
      unawaited(s.cancel());
    }
    _subscriptions.clear();
  }

  @override
  void dispose() {
    _cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final player = widget.player;
    final total = _duration.inMilliseconds / 1000;
    final position = (_dragging ?? _position.inMilliseconds / 1000).clamp(0.0, total > 0 ? total : 0.0);
    final muted = _volume == 0;
    const text = TextStyle(color: Colors.white, fontFeatures: [FontFeature.tabularFigures()]);
    return Row(
      children: [
        IconButton(
          tooltip: _playing ? l.imageVideoPause : l.imageVideoPlay,
          onPressed: () => unawaited(player.playOrPause()),
          icon: PlayPauseIcon(playing: _playing, color: Colors.white),
        ),
        Text(formatDuration(position), style: text),
        Expanded(
          child: Slider(
            value: position,
            max: total > 0 ? total : 1,
            onChanged: total > 0 ? (v) => setState(() => _dragging = v) : null,
            onChangeEnd: (v) {
              unawaited(player.seek(Duration(milliseconds: (v * 1000).round())));
              setState(() => _dragging = null);
            },
            semanticFormatterCallback: (v) => formatDuration(v),
          ),
        ),
        Text(formatDuration(total), style: text),
        const SizedBox(width: AppSpacing.xs),
        IconButton(
          tooltip: muted ? l.imageVideoUnmute : l.imageVideoMute,
          onPressed: () => unawaited(player.setVolume(muted ? 100 : 0)),
          icon: Icon(muted ? Icons.volume_off : Icons.volume_up, color: Colors.white),
        ),
      ],
    );
  }
}

/// The play symbol and length on a video's grid tile.
class VideoBadge extends StatelessWidget {
  const VideoBadge({super.key, required this.seconds});

  final double seconds;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 1),
      decoration: BoxDecoration(color: colors.badgeBackground, borderRadius: AppRadius.badgeBorder),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.play_arrow, size: 14, color: colors.onBadge),
          Text(
            formatDuration(seconds),
            style: TextStyle(color: colors.onBadge, fontSize: AppTextSize.overlayLabel, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
