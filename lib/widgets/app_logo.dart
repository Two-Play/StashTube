import 'package:flutter/material.dart';

import '../core/config/theme.dart';

/// Stashy's logo: two cards behind a front card with a play button, drawn
/// from the same shapes as the app icon (`tool/generate_app_icon.py`), so it
/// needs no image asset and stays sharp at any size. With [background] it
/// sits on the app icon's dark rounded tile.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 28, this.background});

  /// The cards' blue (CARD in the icon script), also the default accent.
  static const blue = stashyBlue;

  /// The app icon's background (BACKGROUND in the icon script).
  static const tile = Color(0xFF111111);

  final double size;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final background = this.background;
    if (background == null) return CustomPaint(size: Size.square(size), painter: const _CardsPainter());
    return DecoratedBox(
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(size * 0.22)),
      child: Padding(
        padding: EdgeInsets.all(size * 0.1),
        child: CustomPaint(size: Size.square(size * 0.8), painter: const _CardsPainter()),
      ),
    );
  }
}

class _CardsPainter extends CustomPainter {
  const _CardsPainter();

  // The mark in a 100 × 100 box, as in the icon script; its visible part
  // spans y 20–84, so it is moved up by 2 to sit in the middle.
  static const _back = (rect: Rect.fromLTWH(28, 18, 44, 12), radius: 4.0);
  static const _middle = (rect: Rect.fromLTWH(21, 26, 58, 12), radius: 5.0);
  static const _front = (rect: Rect.fromLTWH(14, 34, 72, 48), radius: 10.0);

  /// The gap each card keeps to the one in front of it.
  static const _gap = 1.5;

  static Path _card(({Rect rect, double radius}) card, {double grow = 0}) => Path()
    ..addRRect(RRect.fromRectAndRadius(card.rect.inflate(grow), Radius.circular(card.radius + grow)));

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 100, size.height / 100);
    final front = _card(_front);
    final middle = Path.combine(PathOperation.difference, _card(_middle), _card(_front, grow: _gap));
    final back = Path.combine(PathOperation.difference, _card(_back), _card(_middle, grow: _gap));
    canvas
      ..drawPath(back, Paint()..color = AppLogo.blue.withValues(alpha: 0.45))
      ..drawPath(middle, Paint()..color = AppLogo.blue.withValues(alpha: 0.75))
      ..drawPath(front, Paint()..color = AppLogo.blue);
    final play = Path()
      ..moveTo(44, 49)
      ..lineTo(44, 67)
      ..lineTo(59, 58)
      ..close();
    canvas.drawPath(
      play,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );
    // Rounded corners like the icon's stroke-linejoin="round".
    canvas.drawPath(
      play,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_CardsPainter oldDelegate) => false;
}
