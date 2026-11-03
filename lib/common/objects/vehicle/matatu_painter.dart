// Dart imports:
import 'dart:ui';

// Project imports:
import '../../../core/game/utils/paint_utils.dart';
import 'vehicle_canvas.dart';

/// Paints a matatu minibus seen from behind.
class MatatuPainter {
  /// Paints the vehicle in [color], with [accent] for any trim.
  void paint(VehicleCanvas v, Color color, Color accent) {
    final dark = shade(color, -0.35);
    v.wheels(0.17);
    v.box(-0.5, 0.10, 0.5, 0.93, color, radius: v.width * 0.08);
    v.box(-0.46, 0.91, 0.46, 1.0, shade(color, 0.22),
        radius: v.width * 0.05);
    v.box(-0.5, 0.10, 0.5, 0.22, dark, radius: v.width * 0.03);
    v.box(-0.5, 0.36, 0.5, 0.46, accent);
    v.box(-0.5, 0.40, 0.5, 0.42, shade(accent, -0.3));
    v.box(-0.36, 0.56, 0.36, 0.84, VehicleCanvas.glass, radius: v.width * 0.03);
    v.quad(const [
      (-0.30, 0.60),
      (-0.14, 0.60),
      (-0.06, 0.80),
      (-0.22, 0.80),
    ], VehicleCanvas.glassShine);
    v.box(-0.49, 0.28, -0.39, 0.70, VehicleCanvas.tail, radius: v.width * 0.02);
    v.box(0.39, 0.28, 0.49, 0.70, VehicleCanvas.tail, radius: v.width * 0.02);
    v.box(-0.12, 0.25, 0.12, 0.34, VehicleCanvas.plate, radius: v.width * 0.015);
  }
}
