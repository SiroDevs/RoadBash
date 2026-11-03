// Dart imports:
import 'dart:ui';

// Project imports:
import '../../../core/game/utils/paint_utils.dart';
import 'vehicle_canvas.dart';

/// Paints a truck seen from behind.
class TruckPainter {
  /// Paints the vehicle in [color], with [accent] for any trim.
  void paint(VehicleCanvas v, Color color, Color accent) {
    final dark = shade(color, -0.4);
    v.wheels(0.17);
    v.box(-0.48, 0.10, 0.48, 0.21, const Color(0xFF23252C));
    v.box(-0.10, 0.11, 0.10, 0.19, VehicleCanvas.plate, radius: v.width * 0.01);
    v.box(-0.5, 0.21, 0.5, 0.96, color, radius: v.width * 0.025);
    v.box(-0.5, 0.94, 0.5, 1.0, shade(color, 0.2),
        radius: v.width * 0.02);
    for (final y in const [0.40, 0.58, 0.76]) {
      v.box(-0.5, y, 0.5, y + 0.012, dark);
    }
    v.box(-0.012, 0.21, 0.012, 0.94, dark);
    v.box(-0.49, 0.22, -0.39, 0.34, VehicleCanvas.tail, radius: v.width * 0.02);
    v.box(0.39, 0.22, 0.49, 0.34, VehicleCanvas.tail, radius: v.width * 0.02);
    v.box(-0.44, 0.0, -0.34, 0.12, VehicleCanvas.tyre);
    v.box(0.34, 0.0, 0.44, 0.12, VehicleCanvas.tyre);
  }
}
