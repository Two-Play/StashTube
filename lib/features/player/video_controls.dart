import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';

import '../../core/config/haptics.dart';
import '../../core/config/theme.dart';
import '../../core/utils/format.dart';
import '../../data/models/scene.dart';
import '../../data/providers.dart';
import '../../widgets/hold_detector.dart';
import '../../widgets/play_pause_icon.dart';
import '../cast/cast_providers.dart';
import '../cast/cast_ui.dart';
import '../pip/pip.dart';
import 'gesture_hints.dart';
import 'player_controls.dart' show fullscreenByRotation, playerVideoKey;
import 'player_providers.dart';
import 'preview_seek_bar.dart';
import 'touch_lock.dart';
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
/// * bottom: time, touch lock (fullscreen), fullscreen toggle,
///   [PreviewSeekBar]
/// * the first time they show: [GestureTipsOverlay] (CTRL-2), once per
///   install ([gestureTipsSeenProvider])
/// * touch lock in fullscreen ([TouchLockLayer], CTRL-3): every touch is
///   ignored until the lock icon is held; leaving fullscreen unlocks
/// * after a playback error ([playbackErrorProvider]): a message with
///   "Retry" and "Other quality" in place of play/pause; the controls show
///   and don't hide by themselves while it is there. Here rather than in
///   the panel, so it also shows in media_kit's fullscreen route.
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

  /// The gesture tips cover the video (CTRL-2).
  bool _tipsShowing = false;

  /// Touch lock in fullscreen (CTRL-3).
  bool _locked = false;

  Offset get _focal {
    final points = _pointers.values.take(2).toList();
    return (points[0] + points[1]) / 2;
  }

  double get _distance {
    final points = _pointers.values.take(2).toList();
    return (points[0] - points[1]).distance;
  }

  void _onPointerDown(PointerDownEvent e) {
    // The lock and the tips take the touches; no pinch underneath.
    if (_locked || _tipsShowing) return;
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

  @override
  void initState() {
    super.initState();
    // A playback error brings the controls up and keeps them there, so the
    // top bar (collapse, quality, leaving fullscreen) stays reachable.
    ref.listenManual(playbackErrorProvider, (_, error) {
      if (!mounted) return;
      if (error != null) {
        _hideTimer?.cancel();
        // "Retry" and the top bar must be reachable: no lock, no tips.
        setState(() {
          _visible = true;
          _locked = false;
          _tipsShowing = false;
        });
      } else {
        _scheduleHide();
      }
    });
  }

  /// The player being held at 2×, kept for [dispose] (no `ref` there).
  Player? _heldPlayer;

  /// -1 = rewound, 1 = skipped forward; shown briefly as feedback.
  int _seekFeedback = 0;
  Timer? _feedbackTimer;

  @override
  void dispose() {
    _hideTimer?.cancel();
    _feedbackTimer?.cancel();
    // Minimized or closed while holding: the release never arrives here, and
    // mpv would keep 2× for every following scene.
    final rate = _rateBeforeHold;
    if (rate != null) _heldPlayer?.setRate(rate);
    super.dispose();
  }

  void _show() {
    // The first time: the gesture tips instead of the controls, but not over
    // a playback error.
    if (!ref.read(gestureTipsSeenProvider) && ref.read(playbackErrorProvider) == null) {
      _hideTimer?.cancel();
      setState(() => _tipsShowing = true);
      return;
    }
    setState(() => _visible = true);
    _scheduleHide();
  }

  void _dismissTips() {
    setState(() => _tipsShowing = false);
    unawaited(ref.read(gestureTipsSeenProvider.notifier).dismiss());
    _show();
  }

  void _lock() {
    Haptics.medium();
    _endHold();
    _pointers.clear();
    _hideTimer?.cancel();
    setState(() {
      _locked = true;
      _visible = false;
      _pinchStartZoom = null;
    });
  }

  void _unlock() {
    if (!_locked) return;
    Haptics.heavy();
    setState(() => _locked = false);
    _show();
  }

  void _hide() {
    _hideTimer?.cancel();
    setState(() => _visible = false);
  }

  /// (Re)starts the auto-hide countdown; never hides during interaction,
  /// while paused or while a playback error shows.
  void _scheduleHide() {
    _hideTimer?.cancel();
    if (_interacting || !ref.read(playerProvider).state.playing || ref.read(playbackErrorProvider) != null) return;
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
    Haptics.light();
    setState(() => _rateBeforeHold = player.state.rate);
    _heldPlayer = player;
    player.setRate(2);
  }

  void _endHold() {
    final rate = _rateBeforeHold;
    if (rate == null) return;
    setState(() => _rateBeforeHold = null);
    _heldPlayer = null;
    ref.read(playerProvider).setRate(rate);
  }

  @override
  void didUpdateWidget(StashVideoControls oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Leaving fullscreen unlocks (media_kit's fullscreen route usually has
    // its own controls, which go away with it).
    if (!widget.fullscreen && _locked) _locked = false;
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
    final error = ref.watch(playbackErrorProvider);

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
                  decoration: BoxDecoration(color: AppColors.of(context).videoScrimSoft, borderRadius: AppRadius.pillBorder),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.xs),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.fast_forward, color: Colors.white, size: 18),
                        const SizedBox(width: AppSpacing.xs),
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
              child: ColoredBox(color: AppColors.of(context).videoDim),
            ),
          ),
          IgnorePointer(
            ignoring: !_visible || _locked,
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
                            icon: const Icon(Icons.hd_outlined),
                            onPressed: () => _act(widget.onQuality),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Center(
                          // The error's buttons take the middle while it shows.
                          child: Visibility(
                            visible: error == null,
                            child: _QueueButtons(
                              act: _act,
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
                                          onPressed: () => _act(() {
                                            Haptics.light();
                                            player.playOrPause();
                                          }),
                                        ),
                                      ),
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
                            if (fullscreen)
                              IconButton(
                                tooltip: context.l10n.lockTouch,
                                icon: const Icon(Icons.lock_outline),
                                onPressed: _lock,
                              ),
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
          // Always there (empty without an error), so the tree stays the same.
          _PlaybackErrorOverlay(error: error, sceneId: widget.scene.id, onQuality: widget.onQuality),
          if (_tipsShowing)
            GestureTipsOverlay(seekSeconds: StashVideoControls.seekStep.inSeconds, onDismiss: _dismissTips),
          // Always there (empty while unlocked), above the gestures and buttons.
          TouchLockLayer(locked: _locked && fullscreen, onUnlock: _unlock),
          if (_pinching)
            IgnorePointer(
              child: Align(
                alignment: const Alignment(0, -0.75),
                child: DecoratedBox(
                  decoration: BoxDecoration(color: AppColors.of(context).videoScrimSoft, borderRadius: AppRadius.pillBorder),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.xs),
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

/// Over the video after a playback error: a short message, "Retry" and, if
/// the scene has other streams, "Other quality". Empty without [error];
/// taps outside its buttons reach the controls below.
class _PlaybackErrorOverlay extends ConsumerWidget {
  const _PlaybackErrorOverlay({required this.error, required this.sceneId, required this.onQuality});

  final PlaybackError? error;
  final String sceneId;
  final VoidCallback onQuality;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final error = this.error;
    if (error == null) return const SizedBox.shrink();
    final l = context.l10n;
    final theme = Theme.of(context);
    final streams = ref.watch(sceneDetailsProvider(sceneId)).value?.streams ?? const [];
    const onVideo = Colors.white;

    return Stack(
      fit: StackFit.expand,
      children: [
        const IgnorePointer(child: ColoredBox(color: Colors.black54)),
        // Scaled down rather than overflowing a small video at large text
        // sizes. No scroll view: it would take the taps around the buttons.
        LayoutBuilder(
          builder: (context, constraints) => FittedBox(
            fit: BoxFit.scaleDown,
            child: SizedBox(
              width: constraints.maxWidth,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.l),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, color: onVideo, size: 32),
                    const SizedBox(height: AppSpacing.s),
                    Semantics(
                      liveRegion: true,
                      child: Text(
                        l.playbackFailed,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleSmall?.copyWith(color: onVideo),
                      ),
                    ),
                    Text(
                      error.message,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: AppSpacing.s),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: AppSpacing.s,
                      children: [
                        FilledButton.icon(
                          icon: const Icon(Icons.refresh),
                          label: Text(l.retry),
                          onPressed: () {
                            Haptics.light();
                            ref.read(playbackErrorProvider.notifier).retry();
                          },
                        ),
                        if (streams.length > 1)
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: onVideo,
                              side: const BorderSide(color: Colors.white70),
                            ),
                            icon: const Icon(Icons.hd_outlined),
                            label: Text(l.otherQuality),
                            onPressed: onQuality,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Previous/next around [child] (play/pause) while a queue plays (9.3,
/// 9.4); just [child] otherwise. Disabled at the queue's ends.
class _QueueButtons extends ConsumerWidget {
  const _QueueButtons({required this.act, required this.child});

  final void Function(VoidCallback action) act;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queue = ref.watch(playQueueProvider);
    if (queue == null) return child;
    final l = context.l10n;
    final notifier = ref.read(nowPlayingProvider.notifier);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          iconSize: 36,
          disabledColor: Colors.white38,
          tooltip: l.previousScene,
          icon: const Icon(Icons.skip_previous_rounded),
          onPressed: queue.hasPrevious
              ? () => act(() {
                    Haptics.light();
                    notifier.playPrevious();
                  })
              : null,
        ),
        const SizedBox(width: AppSpacing.l),
        child,
        const SizedBox(width: AppSpacing.l),
        IconButton(
          iconSize: 36,
          disabledColor: Colors.white38,
          tooltip: l.nextScene,
          icon: const Icon(Icons.skip_next_rounded),
          onPressed: queue.hasNext
              ? () => act(() {
                    Haptics.light();
                    notifier.playNext();
                  })
              : null,
        ),
      ],
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
            style: const TextStyle(color: Colors.white, fontSize: AppTextSize.overlayBody, fontWeight: FontWeight.w500),
          );
        },
      );
}

class _SeekFeedback extends StatelessWidget {
  const _SeekFeedback({required this.forward});

  final bool forward;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(color: AppColors.of(context).videoScrimSoft, shape: BoxShape.circle),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.l),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(forward ? Icons.fast_forward : Icons.fast_rewind, color: Colors.white),
              Text(
                '${StashVideoControls.seekStep.inSeconds} s',
                style: const TextStyle(color: Colors.white, fontSize: AppTextSize.overlayLabel),
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
