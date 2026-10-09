import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';

import '../../core/utils/format.dart';
import '../../data/models/scene.dart';
import '../../widgets/hold_detector.dart';
import '../../widgets/play_pause_icon.dart';
import '../cast/cast_providers.dart';
import '../cast/cast_ui.dart';
import '../pip/pip.dart';
import 'player_controls.dart' show fullscreenByRotation, playerVideoKey;
import 'player_providers.dart';
import 'preview_seek_bar.dart';
import 'video_zoom.dart';
import '../../l10n/l10n.dart';

/// The player's own controls, used instead of media_kit's so that we decide
/// when they hide: never while the user scrubs (media_kit's hide timer
/// removed our seek bar mid-drag).
///
/// * tap: show/hide; auto-hide after [hideAfter] while playing
/// * double tap on the left/right third: seek ∓/± 10 s
/// * hold: double speed until released
/// * pinch with two fingers: zoom into the video ([videoZoomProvider]); it
///   stays until zoomed out or another scene starts
/// * top: collapse (outside fullscreen), [topActions], speed, quality
/// * center: play/pause or a buffering spinner
/// * bottom: time, fullscreen toggle, [PreviewSeekBar]
class StashVideoControls extends ConsumerStatefulWidget {
  const StashVideoControls({
    super.key,
    required this.fullscreen,
    required this.onToggleFullscreen,
    required this.scene,
    required this.onQuality,
    this.topActions = const [],
    this.hideAfter = const Duration(seconds: 3),
  });

  /// From media_kit's `VideoState`, which hosts these controls.
  final bool fullscreen;
  final VoidCallback onToggleFullscreen;
  final Scene scene;
  final VoidCallback onQuality;

  /// Extra buttons in the top bar, e.g. the cast button.
  final List<Widget> topActions;
  final Duration hideAfter;

  static const seekStep = Duration(seconds: 10);

  @override
  ConsumerState<StashVideoControls> createState() => _StashVideoControlsState();
}

class _StashVideoControlsState extends ConsumerState<StashVideoControls> {
  bool _visible = false;
  bool _interacting = false;
  Timer? _hideTimer;
  Offset? _doubleTapPosition;

  /// The speed before holding for 2×; null while not holding.
  double? _rateBeforeHold;

  /// Fingers on the video, for pinch zoom.
  final _pointers = <int, Offset>{};
  VideoZoom? _pinchStartZoom;
  double _pinchStartDistance = 1;
  Offset _pinchStartFocal = Offset.zero;

  bool get _pinching => _pinchStartZoom != null;

  Offset get _focal {
    final points = _pointers.values.take(2).toList();
    return (points[0] + points[1]) / 2;
  }

  double get _distance {
    final points = _pointers.values.take(2).toList();
    return (points[0] - points[1]).distance;
  }

  void _onPointerDown(PointerDownEvent e) {
    _pointers[e.pointer] = e.localPosition;
    if (_pointers.length == 2) {
      _endHold();
      setState(() {
        _pinchStartZoom = ref.read(videoZoomProvider);
        _pinchStartDistance = math.max(_distance, 1);
        _pinchStartFocal = _focal;
      });
    }
  }

  void _onPointerMove(PointerMoveEvent e) {
    if (!_pointers.containsKey(e.pointer)) return;
    _pointers[e.pointer] = e.localPosition;
    final start = _pinchStartZoom;
    final box = context.size;
    if (start == null || _pointers.length < 2 || box == null) return;
    ref.read(videoZoomProvider.notifier).set(start.pinch(
          factor: _distance / _pinchStartDistance,
          startFocal: _pinchStartFocal,
          focal: _focal,
          box: box,
        ));
  }

  void _onPointerEnd(PointerEvent e) {
    _pointers.remove(e.pointer);
    if (_pinching && _pointers.length < 2) {
      final notifier = ref.read(videoZoomProvider.notifier);
      notifier.set(ref.read(videoZoomProvider).settled());
      setState(() => _pinchStartZoom = null);
    }
  }

  /// -1 = rewound, 1 = skipped forward; shown briefly as feedback.
  int _seekFeedback = 0;
  Timer? _feedbackTimer;

  @override
  void dispose() {
    _hideTimer?.cancel();
    _feedbackTimer?.cancel();
    super.dispose();
  }

  void _show() {
    setState(() => _visible = true);
    _scheduleHide();
  }

  void _hide() {
    _hideTimer?.cancel();
    setState(() => _visible = false);
  }

  /// (Re)starts the auto-hide countdown; never hides during interaction or
  /// while paused.
  void _scheduleHide() {
    _hideTimer?.cancel();
    if (_interacting || !ref.read(playerProvider).state.playing) return;
    _hideTimer = Timer(widget.hideAfter, () {
      if (mounted && !_interacting) setState(() => _visible = false);
    });
  }

  /// Picture-in-picture (4.12); on iOS its window grows out of the video.
  Future<void> _enterPip() async {
    final l = context.l10n;
    final messenger = ScaffoldMessenger.maybeOf(context);
    final box = playerVideoKey.currentContext?.findRenderObject() as RenderBox?;
    final from = box == null || !box.hasSize ? null : box.localToGlobal(Offset.zero) & box.size;
    final started = await ref.read(pipProvider.notifier).enter(from: from);
    if (!started) messenger?.showSnackBar(SnackBar(content: Text(l.pipUnavailable)));
  }

  /// Runs a control action and keeps the controls visible a bit longer.
  void _act(VoidCallback action) {
    action();
    _scheduleHide();
  }

  void _onDoubleTap() {
    final position = _doubleTapPosition;
    if (position == null) return;
    final width = context.size?.width ?? 0;
    final player = ref.read(playerProvider);
    final int direction;
    if (position.dx < width / 3) {
      direction = -1;
    } else if (position.dx > width * 2 / 3) {
      direction = 1;
    } else {
      return;
    }
    final target = player.state.position + StashVideoControls.seekStep * direction;
    final max = player.state.duration;
    player.seek(target < Duration.zero ? Duration.zero : (max > Duration.zero && target > max ? max : target));

    _feedbackTimer?.cancel();
    setState(() => _seekFeedback = direction);
    _feedbackTimer = Timer(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _seekFeedback = 0);
    });
  }

  void _startHold() {
    final player = ref.read(playerProvider);
    if (_rateBeforeHold != null || !player.state.playing || _pointers.length > 1) return;
    HapticFeedback.lightImpact();
    setState(() => _rateBeforeHold = player.state.rate);
    player.setRate(2);
  }

  void _endHold() {
    final rate = _rateBeforeHold;
    if (rate == null) return;
    setState(() => _rateBeforeHold = null);
    ref.read(playerProvider).setRate(rate);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fullscreen entered by turning the phone ends when it is turned back.
    if (widget.fullscreen &&
        fullscreenByRotation.value &&
        MediaQuery.orientationOf(context) == Orientation.portrait) {
      fullscreenByRotation.value = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onToggleFullscreen();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final player = ref.watch(playerProvider);
    final fullscreen = widget.fullscreen;

    // While casting, the video plays on the TV: show remote controls instead.
    final casting = ref.watch(castConnectionProvider).value;
    if (casting != null) return CastingControls(connection: casting, showMinimize: !fullscreen);

    // Layers: gestures at the bottom, a purely visual scrim, buttons on top.
    // Buttons must not sit inside the double-tap detector, or every button
    // tap would wait for the double-tap timeout. Empty areas of the button
    // layer aren't hit-testable, so taps there fall through to the gestures.
    // Raw pointers for the pinch, so it doesn't compete with tap, double
    // tap, hold and the swipe down in the gesture arena.
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerMove: _onPointerMove,
      onPointerUp: _onPointerEnd,
      onPointerCancel: _onPointerEnd,
      child: Stack(
        fit: StackFit.expand,
        children: [
          HoldDetector(
            onHoldStart: _startHold,
            onHoldEnd: _endHold,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _visible ? _hide() : _show(),
              onDoubleTapDown: (d) => _doubleTapPosition = d.localPosition,
              onDoubleTap: _onDoubleTap,
              // Claim vertical drags so the miniplayer's own pan doesn't fight
              // with DragToMinimize, which handles the swipe-down from raw
              // pointer events.
              onVerticalDragStart: (_) {},
              onVerticalDragUpdate: (_) {},
            ),
          ),
          if (_seekFeedback != 0)
            IgnorePointer(
              child: Align(
                alignment: _seekFeedback < 0 ? const Alignment(-0.6, 0) : const Alignment(0.6, 0),
                child: _SeekFeedback(forward: _seekFeedback > 0),
              ),
            ),
          if (_rateBeforeHold != null)
            IgnorePointer(
              child: Align(
                alignment: const Alignment(0, -0.75),
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.fast_forward, color: Colors.white, size: 18),
                        const SizedBox(width: 4),
                        Text(context.l10n.fastForward2x, style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          IgnorePointer(
            child: AnimatedOpacity(
              opacity: _visible ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: const ColoredBox(color: Colors.black38),
            ),
          ),
          IgnorePointer(
            ignoring: !_visible,
            child: AnimatedOpacity(
              opacity: _visible ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: SafeArea(
                top: fullscreen,
                bottom: fullscreen,
                child: IconTheme(
                  data: const IconThemeData(color: Colors.white),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          if (!fullscreen)
                            IconButton(
                              tooltip: context.l10n.minimize,
                              icon: const Icon(Icons.keyboard_arrow_down, size: 30),
                              onPressed: () => ref.read(nowPlayingProvider.notifier).collapse(),
                            ),
                          const Spacer(),
                          const CastButton(color: Colors.white),
                          if (ref.watch(pipServiceProvider).isSupported)
                            IconButton(
                              tooltip: context.l10n.pictureInPicture,
                              icon: const Icon(Icons.picture_in_picture_alt_outlined),
                              onPressed: () => _act(() => unawaited(_enterPip())),
                            ),
                          ...widget.topActions,
                          StreamBuilder<double>(
                            stream: player.stream.rate,
                            initialData: player.state.rate,
                            builder: (_, rate) => TextButton(
                              style: TextButton.styleFrom(foregroundColor: Colors.white),
                              onPressed: () => _act(() => showSpeedSheet(context, player)),
                              child: Tooltip(
                                message: context.l10n.playbackSpeed,
                                child: Text(context.l10n.speedValue(rate.data ?? 1)),
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: context.l10n.quality,
                            icon: const Icon(Icons.settings_outlined),
                            onPressed: () => _act(widget.onQuality),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Center(
                          child: StreamBuilder<bool>(
                            stream: player.stream.buffering,
                            initialData: player.state.buffering,
                            builder: (_, buffering) => buffering.data == true
                                ? const SizedBox.square(
                                    dimension: 48,
                                    child: CircularProgressIndicator(color: Colors.white),
                                  )
                                : StreamBuilder<bool>(
                                    stream: player.stream.playing,
                                    initialData: player.state.playing,
                                    builder: (_, playing) => IconButton(
                                      iconSize: 56,
                                      tooltip: playing.data == true ? context.l10n.pause : context.l10n.play,
                                      icon: PlayPauseIcon(playing: playing.data == true),
                                      onPressed: () => _act(player.playOrPause),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            IgnorePointer(child: _TimeLabel(player: player)),
                            const Spacer(),
                            IconButton(
                              tooltip: fullscreen ? context.l10n.exitFullscreen : context.l10n.fullscreen,
                              icon: Icon(fullscreen ? Icons.fullscreen_exit : Icons.fullscreen),
                              onPressed: () => _act(widget.onToggleFullscreen),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: PreviewSeekBar(
                          sceneId: widget.scene.id,
                          visible: _visible,
                          onInteractionStart: () {
                            _interacting = true;
                            _hideTimer?.cancel();
                          },
                          onInteractionEnd: () {
                            _interacting = false;
                            _scheduleHide();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_pinching)
            IgnorePointer(
              child: Align(
                alignment: const Alignment(0, -0.75),
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Text(
                      context.l10n.speedValue(double.parse(ref.watch(videoZoomProvider).scale.toStringAsFixed(1))),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TimeLabel extends StatelessWidget {
  const _TimeLabel({required this.player});

  final Player player;

  @override
  Widget build(BuildContext context) => StreamBuilder<Duration>(
        stream: player.stream.position,
        initialData: player.state.position,
        builder: (_, position) {
          final total = player.state.duration.inMilliseconds / 1000;
          return Text(
            '${formatDuration(position.data!.inMilliseconds / 1000)} / ${formatDuration(total)}',
            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
          );
        },
      );
}

class _SeekFeedback extends StatelessWidget {
  const _SeekFeedback({required this.forward});

  final bool forward;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: const BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(forward ? Icons.fast_forward : Icons.fast_rewind, color: Colors.white),
              Text(
                '${StashVideoControls.seekStep.inSeconds} s',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      );
}

/// Playback speeds offered in [showSpeedSheet].
const playbackSpeeds = [0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0];

/// Bottom sheet to pick the playback speed. mpv keeps the speed across
/// files, so it stays for the next scenes.
Future<void> showSpeedSheet(BuildContext context, Player player) => showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      builder: (sheetContext) {
        final l = sheetContext.l10n;
        final current = player.state.rate;
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(l.playbackSpeed, style: Theme.of(sheetContext).textTheme.titleMedium),
              ),
              for (final speed in playbackSpeeds)
                ListTile(
                  leading: Icon((speed - current).abs() < 0.01 ? Icons.check : null),
                  title: Text(speed == 1 ? l.speedNormal : l.speedValue(speed)),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    player.setRate(speed);
                  },
                ),
            ],
          ),
        );
      },
    );
