// Dart imports:
import 'dart:ui';

/// Basic shape drawing shared by the side-view painters.
abstract class ProfileInk {
  final Paint _ink = Paint()..isAntiAlias = true;
  final Path _path = Path();

  /// Fills a polygon through the given points.
  void fill(Canvas canvas, Color color, List<Offset> points) {
    _path
      ..reset()
      ..addPolygon(points, true);
    _ink
      ..style = PaintingStyle.fill
      ..color = color;
    canvas.drawPath(_path, _ink);
  }

  /// Draws a round-capped line between two points.
  void stroke(
    Canvas canvas,
    Color color,
    double width,
    Offset from,
    Offset to,
  ) {
    _ink
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = width
      ..color = color;
    canvas.drawLine(from, to, _ink);
  }

  /// Fills a circle.
  void disc(Canvas canvas, Color color, Offset center, double radius) {
    _ink
      ..style = PaintingStyle.fill
      ..color = color;
    canvas.drawCircle(center, radius, _ink);
  }
}
