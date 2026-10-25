import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart' show kDoubleTapSlop, kDoubleTapTimeout, kTouchSlop;
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
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
import 'seek_settings.dart';
import 'touch_lock.dart';
import 'video_zoom.dart';
import '../../l10n/l10n.dart';

/// The player's own controls, used instead of media_kit's so that we decide
/// when they hide: never while the user scrubs (media_kit's hide timer
/// removed our seek bar mid-drag).
///
/// * tap: show/hide; auto-hide after [hideAfter] while playing
/// * double tap on the left/right third: seek ∓/± the step of
///   [seekSettingsProvider] (5 s by default), and every further tap on that
///   side within [seekSequenceWindow] skips further, like YouTube: 5, 10,
///   20, 30 s … in total ([SeekSettings.total]); also while casting, where
///   the TV seeks. With double-tap seeking off, a tap toggles the controls
///   right away instead of waiting for a second one.
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

  /// How long a seek sequence waits for the next tap on its side.
  static const seekSequenceWindow = Duration(milliseconds: 700);

  @override
  ConsumerState<StashVideoControls> createState() => _StashVideoControlsState();
}

class _StashVideoControlsState extends ConsumerState<StashVideoControls> {
  bool _visible = false;
  bool _interacting = false;
  Timer? _hideTimer;

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

  // The raw pointer handlers below keep getting a gesture's events after
  // the controls were removed mid-gesture (a swipe down collapses the
  // player and with it the controls), so each checks [mounted] first.

  void _onPointerDown(PointerDownEvent e) {
    if (!mounted) return;
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
    if (!mounted || !_pointers.containsKey(e.pointer)) return;
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
    if (!mounted) return;
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

  /// The running seek sequence: -1 = back, 1 = forward, 0 = none. Its
  /// [_seekTaps] taps jump [_seekTotal] ([SeekSettings.total]) from
  /// [_seekBase], the position when it started.
  int _seekDirection = 0;
  int _seekTaps = 0;
  Duration _seekTotal = Duration.zero;
  Duration _seekBase = Duration.zero;
  Duration? _lastSeekTarget;
  Timer? _seekTimer;

  /// Taps are tracked from raw pointers, so a tap that extends a sequence
  /// counts right away instead of after the double-tap timeout.
  int? _tapPointer;
  Offset _tapDownPosition = Offset.zero;
  Timer? _tapHoldTimer;

  /// The previous tap while it can still become a double tap.
  ({int side, Offset position})? _lastTap;
  Timer? _lastTapTimer;

  @override
  void dispose() {
    _hideTimer?.cancel();
    _seekTimer?.cancel();
    _tapHoldTimer?.cancel();
    _lastTapTimer?.cancel();
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
    _endSeekSequence();
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

  void _onTapPointerDown(PointerDownEvent e) {
    if (!mounted) return;
    if (_tapPointer != null) {
      // A second finger: no tap.
      _cancelTapPointer();
      return;
    }
    _tapPointer = e.pointer;
    _tapDownPosition = e.localPosition;
    // Held this long, it is a hold, not a tap.
    _tapHoldTimer = Timer(kHoldDelay, _cancelTapPointer);
  }

  void _onTapPointerMove(PointerMoveEvent e) {
    if (e.pointer == _tapPointer && (e.localPosition - _tapDownPosition).distance > kTouchSlop) _cancelTapPointer();
  }

  void _cancelTapPointer() {
    _tapHoldTimer?.cancel();
    _tapPointer = null;
  }

  /// A tap on the video ([side] -1 = left third, 1 = right third, 0 = the
  /// middle); null for a pointer that wasn't a tap.
  int? _tapSide(PointerUpEvent e, {int? side}) {
    if (e.pointer != _tapPointer) return null;
    _cancelTapPointer();
    if (!mounted) return null;
    if (_pinching) return null;
    if (side != null) return side;
    final width = context.size?.width ?? 0;
    final dx = e.localPosition.dx;
    return dx < width / 3 ? -1 : (dx > width * 2 / 3 ? 1 : 0);
  }

  /// Double tap on a side starts a seek sequence; while it runs, every
  /// single tap on that side extends it, a tap on the other side starts a
  /// new one there, and a tap in the middle ends it (and toggles the
  /// controls as usual).
  void _onSeekTap(int side, Offset position) {
    if (_locked || _tipsShowing || !ref.read(seekSettingsProvider).enabled) return;
    if (_seekDirection != 0) {
      _clearLastTap();
      if (side == 0) {
        _endSeekSequence();
      } else if (side == _seekDirection) {
        _extendSeekSequence();
      } else {
        _startSeekSequence(side);
      }
      return;
    }
    final last = _lastTap;
    if (side != 0 && last != null && last.side == side && (position - last.position).distance <= kDoubleTapSlop) {
      _clearLastTap();
      _startSeekSequence(side);
      return;
    }
    _lastTap = (side: side, position: position);
    _lastTapTimer?.cancel();
    _lastTapTimer = Timer(kDoubleTapTimeout, _clearLastTap);
  }

  void _clearLastTap() {
    _lastTapTimer?.cancel();
    _lastTap = null;
  }

  bool get _casting => ref.read(castConnectionProvider).value != null;

  void _startSeekSequence(int direction) {
    _seekBase = _casting
        ? ref.read(castPlaybackProvider).value?.position ?? Duration.zero
        : ref.read(playerProvider).state.position;
    _seekDirection = direction;
    _seekTaps = 0;
    _lastSeekTarget = null;
    _extendSeekSequence();
  }

  void _extendSeekSequence() {
    final l = context.l10n;
    _seekTaps++;
    final total = _seekTotal = ref.read(seekSettingsProvider).total(_seekTaps);
    final casting = _casting;
    final player = ref.read(playerProvider);
    // While casting, the player doesn't know the length: take the scene's.
    final max = casting ? Duration(milliseconds: (widget.scene.duration * 1000).round()) : player.state.duration;
    var target = _seekBase + total * _seekDirection;
    if (target < Duration.zero) target = Duration.zero;
    if (max > Duration.zero && target > max) target = max;
    // Seeks right away, so the picture follows every tap; from the start
    // position, so mpv's lagging position doesn't add up errors.
    if (target != _lastSeekTarget) {
      _lastSeekTarget = target;
      if (casting) {
        unawaited(ref.read(castServiceProvider).seek(target));
      } else {
        unawaited(player.seek(target));
      }
    }
    Haptics.selection();
    final seconds = total.inSeconds;
    unawaited(SemanticsService.sendAnnouncement(
      View.of(context),
      _seekDirection > 0 ? l.seekForwardSeconds(seconds) : l.seekBackSeconds(seconds),
      Directionality.of(context),
    ));
    _seekTimer?.cancel();
    _seekTimer = Timer(StashVideoControls.seekSequenceWindow, _endSeekSequence);
    setState(() {});
  }

  void _endSeekSequence() {
    _seekTimer?.cancel();
    if (_seekDirection == 0) return;
    if (mounted) setState(() => _seekDirection = 0);
  }

  /// The bubble of the running seek sequence, on its side.
  Widget _seekFeedback() => IgnorePointer(
        child: ExcludeSemantics(
          child: Align(
            alignment: _seekDirection < 0 ? const Alignment(-0.6, 0) : const Alignment(0.6, 0),
            child: _SeekFeedback(
              forward: _seekDirection > 0,
              seconds: _seekTotal.inSeconds,
              taps: _seekTaps,
            ),
          ),
        ),
      );

  /// While casting: tap areas left and right of [CastingControls]' buttons,
  /// so double taps seek on the TV as well.
  Widget _castSeekZones() => LayoutBuilder(builder: (context, constraints) {
        // CastingControls' middle row: two 48 dp buttons, the 64 dp play
        // button and two gaps; the zones stay clear of it, of the top bar
        // and of the timeline.
        const buttonRow = 48 * 2 + 64 + AppSpacing.l * 2;
        final width = math.max(0.0, math.min(constraints.maxWidth / 3, (constraints.maxWidth - buttonRow) / 2 - AppSpacing.s));
        Widget zone(int side) => Listener(
              behavior: HitTestBehavior.opaque,
              onPointerDown: _onTapPointerDown,
              onPointerMove: _onTapPointerMove,
              onPointerCancel: (_) => _cancelTapPointer(),
              onPointerUp: (e) {
                final tapped = _tapSide(e, side: side);
                if (tapped != null) _onSeekTap(tapped, e.localPosition);
              },
            );
        return Stack(
          children: [
            Positioned(left: 0, top: 56, bottom: 88, width: width, child: zone(-1)),
            Positioned(right: 0, top: 56, bottom: 88, width: width, child: zone(1)),
          ],
        );
      });

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
    final seek = ref.watch(seekSettingsProvider);

    // While casting, the video plays on the TV: show remote controls instead.
    final casting = ref.watch(castConnectionProvider).value;
    if (casting != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          CastingControls(connection: casting, showMinimize: !fullscreen),
          if (seek.enabled) _castSeekZones(),
          if (_seekDirection != 0) _seekFeedback(),
        ],
      );
    }
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
            // Seek taps from raw pointers (see _onSeekTap); only taps that
            // reach the gesture layer, not the buttons above it.
            child: Listener(
              onPointerDown: _onTapPointerDown,
              onPointerMove: _onTapPointerMove,
              onPointerCancel: (_) => _cancelTapPointer(),
              onPointerUp: (e) {
                final side = _tapSide(e);
                if (side != null) _onSeekTap(side, e.localPosition);
              },
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                // Taps of a seek sequence don't toggle the controls.
                onTap: () {
                  if (_seekDirection != 0) return;
                  _visible ? _hide() : _show();
                },
                // Seeking is handled by _onSeekTap; this only makes a single
                // tap wait, so the first tap of a double tap doesn't toggle.
                // Without double-tap seeking, taps toggle right away.
                onDoubleTap: seek.enabled ? () {} : null,
                // Claim vertical drags so nothing above takes them;
                // DragToMinimize handles the swipe-down from raw pointer
                // events.
                onVerticalDragStart: (_) {},
                onVerticalDragUpdate: (_) {},
              ),
            ),
          ),
          if (_seekDirection != 0) _seekFeedback(),
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
                          // Back to the video left in the player (also the
                          // system back); iOS has no back button.
                          if (!fullscreen && ref.watch(playerHistoryProvider).isNotEmpty)
                            IconButton(
                              tooltip: context.l10n.backToPreviousVideo,
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () => ref.read(nowPlayingProvider.notifier).goBack(),
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
            GestureTipsOverlay(seekSeconds: seek.enabled ? seek.step.inSeconds : null, onDismiss: _dismissTips),
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

/// The bubble of a seek sequence: the total jump, with a ripple and arrows
/// that run again on every tap ([taps]); still with reduced motion.
class _SeekFeedback extends StatelessWidget {
  const _SeekFeedback({required this.forward, required this.seconds, required this.taps});

  final bool forward;
  final int seconds;
  final int taps;

  @override
  Widget build(BuildContext context) {
    final animate = !MediaQuery.disableAnimationsOf(context);
    final scrim = AppColors.of(context).videoScrimSoft;
    return TweenAnimationBuilder<double>(
      key: ValueKey(taps),
      tween: Tween(begin: animate ? 0 : 1, end: 1),
      duration: animate ? const Duration(milliseconds: 500) : Duration.zero,
      builder: (context, t, _) {
        // Each arrow lights up in turn, in the seek direction.
        Widget arrow(int i) {
          final lit = animate ? (1 - ((t * 3) - i - 0.5).abs()).clamp(0.0, 1.0) : 1.0;
          return Opacity(
            opacity: 0.35 + 0.65 * lit,
            child: const Icon(Icons.play_arrow, color: Colors.white, size: 18),
          );
        }

        final arrows = [for (var i = 0; i < 3; i++) arrow(i)];
        return Stack(
          alignment: Alignment.center,
          children: [
            if (animate)
              Opacity(
                opacity: (1 - t) * 0.6,
                child: Transform.scale(
                  scale: 1 + t * 0.6,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: scrim, shape: BoxShape.circle),
                    child: const SizedBox.square(dimension: 96),
                  ),
                ),
              ),
            DecoratedBox(
              decoration: BoxDecoration(color: scrim, shape: BoxShape.circle),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.l),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Back: the arrows point left and run right to left.
                    Transform.flip(
                      flipX: !forward,
                      child: Row(mainAxisSize: MainAxisSize.min, children: arrows),
                    ),
                    Text(
                      context.l10n.durationSeconds(seconds),
                      style: const TextStyle(color: Colors.white, fontSize: AppTextSize.overlayLabel),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
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
