import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Bursts confetti out of [child] each time [trigger] changes, e.g. when a
/// performer becomes a favorite. The pieces fly up and out, fall with
/// gravity, spin and fade; they are drawn outside the child's bounds and
/// never take taps. Nothing happens with reduced motion.
class ConfettiBurst extends StatefulWidget {
  const ConfettiBurst({
    super.key,
    required this.trigger,
    required this.child,
    this.pieces = 32,
    this.power = 1,
  });

  /// Change it (e.g. count up) to start a burst.
  final int trigger;
  final Widget child;
  final int pieces;

  /// Scales speed and size; below 1 for small buttons.
  final double power;

  @override
  State<ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends State<ConfettiBurst> with SingleTickerProviderStateMixin {
  static const _duration = Duration(milliseconds: 1400);

  late final _controller = AnimationController(vsync: this, duration: _duration);
  final _random = math.Random();
  List<_Piece> _pieces = const [];

  @override
  void didUpdateWidget(ConfettiBurst oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.trigger != widget.trigger && !MediaQuery.disableAnimationsOf(context)) _burst();
  }

  void _burst() {
    final colors = Theme.of(context).colorScheme;
    final palette = [
      colors.primary,
      colors.secondary,
      colors.tertiary,
      Colors.redAccent,
      Colors.pinkAccent,
      Colors.amber,
      Colors.lightBlueAccent,
    ];
    final power = widget.power;
    _pieces = [
      for (var i = 0; i < widget.pieces; i++)
        _Piece(
          // Mostly upwards, fanning out to both sides.
          angle: -math.pi / 2 + (_random.nextDouble() - 0.5) * math.pi * 0.95,
          speed: (380 + _random.nextDouble() * 420) * power,
          // Somewhere along the child's width, so it bursts from all of it.
          start: _random.nextDouble() - 0.5,
          size: (5 + _random.nextDouble() * 5) * power,
          spin: (_random.nextDouble() - 0.5) * 16,
          color: palette[_random.nextInt(palette.length)],
          round: _random.nextInt(3) == 0,
        ),
    ];
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
        clipBehavior: Clip.none,
        children: [
          widget.child,
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _ConfettiPainter(_controller, () => _pieces)),
            ),
          ),
        ],
      );
}

class _Piece {
  const _Piece({
    required this.angle,
    required this.speed,
    required this.start,
    required this.size,
    required this.spin,
    required this.color,
    required this.round,
  });

  final double angle;
  final double speed;

  /// Where along the child's width it starts, -0.5 to 0.5.
  final double start;
  final double size;
  final double spin;
  final Color color;
  final bool round;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.animation, this.pieces) : super(repaint: animation);

  final Animation<double> animation;
  final List<_Piece> Function() pieces;

  static const _gravity = 420.0;

  @override
  void paint(Canvas canvas, Size size) {
    final progress = animation.value;
    if (progress == 0 || progress == 1) return;
    // Seconds since the burst; air drag slows the pieces down over time.
    final t = progress * 1.4;
    final drag = (1 - math.exp(-3.2 * t)) / 3.2;
    final opacity = progress < 0.65 ? 1.0 : 1 - (progress - 0.65) / 0.35;
    final center = size.center(Offset.zero);
    final paint = Paint();
    for (final piece in pieces()) {
      final position = center +
          Offset(
            piece.start * size.width * 0.8 + math.cos(piece.angle) * piece.speed * drag,
            math.sin(piece.angle) * piece.speed * drag + 0.5 * _gravity * t * t,
          );
      paint.color = piece.color.withValues(alpha: opacity.clamp(0, 1));
      canvas.save();
      canvas.translate(position.dx, position.dy);
      canvas.rotate(piece.spin * t);
      if (piece.round) {
        canvas.drawCircle(Offset.zero, piece.size / 2, paint);
      } else {
        // Paper strips flutter: their width follows the spin.
        final width = piece.size * (0.35 + 0.65 * math.cos(piece.spin * t * 1.7).abs());
        canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: width, height: piece.size * 0.6), paint);
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) => oldDelegate.animation != animation;
}
