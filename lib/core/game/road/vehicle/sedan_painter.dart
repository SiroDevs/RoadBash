// Dart imports:
import 'dart:ui';

// Project imports:
import '../../utils/paint_utils.dart';
import 'vehicle_canvas.dart';

/// Paints a sedan seen from behind.
class SedanPainter {
  /// Paints the vehicle in [color], with [accent] for any trim.
  void paint(VehicleCanvas v, Color color, Color accent) {
    final dark = shade(color, -0.35);
    v.wheels(0.22);
    v.box(-0.5, 0.12, 0.5, 0.54, color, radius: v.width * 0.07);
    v.box(-0.5, 0.12, 0.5, 0.26, dark, radius: v.width * 0.04);
    v.quad(const [
      (-0.41, 0.52),
      (0.41, 0.52),
      (0.31, 0.98),
      (-0.31, 0.98),
    ], shade(color, 0.08));
    v.quad(const [
      (-0.35, 0.56),
      (0.35, 0.56),
      (0.26, 0.90),
      (-0.26, 0.90),
    ], VehicleCanvas.glass);
    v.quad(const [
      (-0.20, 0.60),
      (-0.06, 0.60),
      (-0.02, 0.88),
      (-0.12, 0.88),
    ], VehicleCanvas.glassShine);
    v.box(-0.48, 0.34, -0.30, 0.47, VehicleCanvas.tail, radius: v.width * 0.02);
    v.box(0.30, 0.34, 0.48, 0.47, VehicleCanvas.tail, radius: v.width * 0.02);
    v.box(-0.13, 0.20, 0.13, 0.32, VehicleCanvas.plate, radius: v.width * 0.015);
  }
}
