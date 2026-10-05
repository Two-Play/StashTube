import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';

import '../../core/utils/format.dart';
import '../../data/models/scene.dart';
import '../cast/cast_providers.dart';
import '../cast/cast_ui.dart';
import 'player_providers.dart';
import 'preview_seek_bar.dart';
import '../../l10n/l10n.dart';

/// The player's own controls, used instead of media_kit's so that we decide
/// when they hide: never while the user scrubs (media_kit's hide timer
/// removed our seek bar mid-drag).
///
/// * tap: show/hide; auto-hide after [hideAfter] while playing
/// * double tap on the left/right third: seek ∓/± 10 s
/// * top: collapse (outside fullscreen), [topActions], quality
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
    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
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
        if (_seekFeedback != 0)
          IgnorePointer(
            child: Align(
              alignment: _seekFeedback < 0 ? const Alignment(-0.6, 0) : const Alignment(0.6, 0),
              child: _SeekFeedback(forward: _seekFeedback > 0),
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
                        ...widget.topActions,
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
                                    icon: Icon(playing.data == true ? Icons.pause : Icons.play_arrow),
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
