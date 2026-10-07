import 'package:flutter/material.dart';

/// Stash's logo: the open box from the Stash project
/// (github.com/stashapp/stash, `ui/v2.5/public/stash_icon.svg`, AGPL-3.0),
/// drawn from its outline so it needs no image asset. [color] defaults to
/// the logo's brown; with [background] it sits on Stash's dark rounded tile.
class StashLogo extends StatelessWidget {
  const StashLogo({super.key, this.size = 28, this.color = brown, this.background});

  /// The brown of the logo.
  static const brown = Color(0xFFA08069);

  /// The dark tile of the app icon.
  static const tile = Color(0xFF242424);

  final double size;
  final Color color;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final background = this.background;
    final logo = CustomPaint(size: Size.square(size), painter: _BoxPainter(color));
    if (background == null) return logo;
    return DecoratedBox(
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(size * 0.18)),
      child: Padding(
        padding: EdgeInsets.all(size * 0.12),
        child: CustomPaint(size: Size.square(size * 0.76), painter: _BoxPainter(color)),
      ),
    );
  }
}

class _BoxPainter extends CustomPainter {
  _BoxPainter(this.color);

  final Color color;

  /// Size of the outline below.
  static const _width = 153.400;
  static const _height = 107.041;

  /// The lid with its opening (a hole, filled even-odd) and the two sides.
  static const _outlines = <List<Offset>>[
    [
      Offset(76.784, 0.000),
      Offset(12.347, 19.312),
      Offset(0.000, 35.402),
      Offset(56.077, 55.550),
      Offset(72.342, 35.229),
      Offset(76.617, 37.099),
      Offset(80.892, 35.229),
      Offset(97.825, 56.067),
      Offset(153.400, 35.746),
      Offset(140.408, 18.303),
    ],
    [Offset(76.784, 5.265), Offset(121.851, 18.968), Offset(76.784, 32.007), Offset(31.239, 18.451)],
    [
      Offset(80.318, 45.562),
      Offset(80.151, 106.869),
      Offset(140.002, 81.628),
      Offset(140.169, 47.259),
      Offset(95.293, 62.488),
      Offset(82.134, 45.562),
    ],
    [
      Offset(71.697, 45.734),
      Offset(58.537, 62.660),
      Offset(13.661, 47.432),
      Offset(13.828, 81.800),
      Offset(73.679, 107.041),
      Offset(73.512, 45.734),
    ],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final scale = (size.width / _width).clamp(0.0, size.height / _height);
    canvas
      ..save()
      ..translate((size.width - _width * scale) / 2, (size.height - _height * scale) / 2)
      ..scale(scale);
    final path = Path()..fillType = PathFillType.evenOdd;
    for (final outline in _outlines) {
      path.addPolygon(outline, true);
    }
    canvas
      ..drawPath(path, Paint()..color = color)
      ..restore();
  }

  @override
  bool shouldRepaint(_BoxPainter old) => old.color != color;
}
