// Dart imports:
import 'dart:ui';

/// Paints the moving clouds above the road horizon.
abstract final class BackdropClouds {
  static const List<double> _cloudX = [0.05, 0.28, 0.52, 0.74, 0.93];
  static const List<double> _cloudY = [0.20, 0.45, 0.15, 0.38, 0.25];
  static final Paint _paint = Paint()..color = const Color(0xB3FFFFFF);

  /// Draws a cloud band scaled to the available sky.
  static void draw(
    Canvas canvas,
    double viewWidth,
    double horizon,
    double scroll, {
    bool big = false,
  }) {
    final span = viewWidth * 1.4;
    final grow = big ? 1.9 : 1.0;
    for (var index = 0; index < _cloudX.length; index++) {
      final cloudX =
          (_cloudX[index] * span - scroll * 0.2) % span - viewWidth * 0.2;
      final cloudY = horizon * _cloudY[index];
      final cloudSize = horizon * (0.10 + 0.02 * (index % 3)) * grow;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cloudX, cloudY),
          width: cloudSize * 3.2,
          height: cloudSize,
        ),
        _paint,
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cloudX + cloudSize * 0.7, cloudY - cloudSize * 0.25),
          width: cloudSize * 2.0,
          height: cloudSize * 0.9,
        ),
        _paint,
      );
    }
  }
}
