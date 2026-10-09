import 'package:flutter/material.dart';

/// Play/pause icon that morphs from one into the other and pops a little
/// when the state changes. Without animations (reduced motion) it switches.
class PlayPauseIcon extends StatefulWidget {
  const PlayPauseIcon({super.key, required this.playing, this.size, this.color});

  final bool playing;
  final double? size;
  final Color? color;

  @override
  State<PlayPauseIcon> createState() => _PlayPauseIconState();
}

class _PlayPauseIconState extends State<PlayPauseIcon> with TickerProviderStateMixin {
  late final _morph = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 280),
    value: widget.playing ? 1 : 0,
  );
  late final _pop = AnimationController(vsync: this, duration: const Duration(milliseconds: 360));

  static final _popScale = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.78).chain(CurveTween(curve: Curves.easeOut)), weight: 30),
    TweenSequenceItem(tween: Tween(begin: 0.78, end: 1.0).chain(CurveTween(curve: Curves.elasticOut)), weight: 70),
  ]);

  @override
  void didUpdateWidget(PlayPauseIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.playing == widget.playing) return;
    if (MediaQuery.disableAnimationsOf(context)) {
      _morph.value = widget.playing ? 1 : 0;
      return;
    }
    // AnimatedIcons.play_pause: 0 shows play, 1 shows pause.
    widget.playing ? _morph.forward() : _morph.reverse();
    _pop.forward(from: 0);
  }

  @override
  void dispose() {
    _morph.dispose();
    _pop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaleTransition(
        scale: _popScale.animate(_pop),
        child: AnimatedIcon(
          icon: AnimatedIcons.play_pause,
          progress: _morph,
          size: widget.size,
          color: widget.color,
        ),
      );
}
