// Dart imports:
import 'dart:ui';

/// Drawing helpers for painting a vehicle from fractions of its width and
/// height, with the origin at the bottom centre of the vehicle.
class VehicleCanvas {
  VehicleCanvas(this.canvas, this.ground, this.width, this.height);

  static const Color glass = Color(0xFF1E2733);
  static const Color glassShine = Color(0x33FFFFFF);
  static const Color tyre = Color(0xFF14151A);
  static const Color plate = Color(0xFFF3F0E0);
  static const Color tail = Color(0xFFD32A1F);

  static final Paint _paint = Paint()..isAntiAlias = true;

  final Canvas canvas;
  final Offset ground;
  final double width;
  final double height;

  /// Paints the soft shadow under the vehicle.
  void shadow() {
    _paint.color = const Color(0x55000000);
    canvas.drawOval(
      Rect.fromCenter(center: ground, width: width * 1.12, height: width * 0.14),
      _paint,
    );
  }

  /// Paints a box whose corners are fractions of the width and height.
  void box(double x1, double y1, double x2, double y2, Color fill, {double radius = 0}) {
    final rect = Rect.fromLTRB(
      ground.dx + width * x1,
      ground.dy - height * y2,
      ground.dx + width * x2,
      ground.dy - height * y1,
    );
    _paint.color = fill;
    if (radius > 0) {
      canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)), _paint);
    } else {
      canvas.drawRect(rect, _paint);
    }
  }

  /// Paints a polygon whose points are fractions of the width and height.
  void quad(List<(double, double)> points, Color fill) {
    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final x = ground.dx + width * points[i].$1;
      final y = ground.dy - height * points[i].$2;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    _paint.color = fill;
    canvas.drawPath(path, _paint);
  }

  /// Paints the two rear wheels, [top] being their height as a fraction.
  void wheels(double top) {
    box(-0.46, 0, -0.30, top, tyre, radius: width * 0.03);
    box(0.30, 0, 0.46, top, tyre, radius: width * 0.03);
  }
}
