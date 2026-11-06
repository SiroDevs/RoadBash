// Dart imports:
import 'dart:ui';

// Project imports:
import '../../../core/game/utils/paint_utils.dart';
import 'civilian_kind.dart';
import 'vehicle_canvas.dart';

/// Paints a civilian vehicle seen from the front, driving toward the camera.
class OncomingPainter {
  /// Paints a vehicle of [kind] in [color], with [accent] for any trim.
  void paint(VehicleCanvas vehicle, CivilianKind kind, Color color, Color accent) {
    switch (kind) {
      case CivilianKind.sedan:
        _sedan(vehicle, color);
      case CivilianKind.matatu:
        _matatu(vehicle, color, accent);
      case CivilianKind.truck:
        _truck(vehicle, color);
    }
  }

  void _sedan(VehicleCanvas vehicle, Color color) {
    final dark = shade(color, -0.35);
    vehicle.wheels(0.22);
    vehicle.box(-0.5, 0.12, 0.5, 0.54, color, radius: vehicle.width * 0.07);
    vehicle.box(-0.5, 0.12, 0.5, 0.26, dark, radius: vehicle.width * 0.04);
    vehicle.quad(const [
      (-0.41, 0.52),
      (0.41, 0.52),
      (0.31, 0.98),
      (-0.31, 0.98),
    ], shade(color, 0.08));
    vehicle.quad(const [
      (-0.35, 0.56),
      (0.35, 0.56),
      (0.26, 0.90),
      (-0.26, 0.90),
    ], VehicleCanvas.glass);
    vehicle.quad(const [
      (0.06, 0.60),
      (0.20, 0.60),
      (0.12, 0.88),
      (0.02, 0.88),
    ], VehicleCanvas.glassShine);
    _headlights(vehicle, 0.34, 0.47, 0.30);
    vehicle.box(-0.20, 0.30, 0.20, 0.44, dark, radius: vehicle.width * 0.02);
    vehicle.box(-0.13, 0.15, 0.13, 0.25, VehicleCanvas.plate, radius: vehicle.width * 0.015);
  }

  void _matatu(VehicleCanvas vehicle, Color color, Color accent) {
    final dark = shade(color, -0.35);
    vehicle.wheels(0.17);
    vehicle.box(-0.5, 0.10, 0.5, 0.93, color, radius: vehicle.width * 0.08);
    vehicle.box(-0.46, 0.91, 0.46, 1.0, shade(color, 0.22), radius: vehicle.width * 0.05);
    vehicle.box(-0.5, 0.10, 0.5, 0.22, dark, radius: vehicle.width * 0.03);
    vehicle.box(-0.5, 0.44, 0.5, 0.49, accent);
    vehicle.box(-0.42, 0.53, 0.42, 0.87, VehicleCanvas.glass, radius: vehicle.width * 0.03);
    vehicle.quad(const [
      (0.10, 0.58),
      (0.28, 0.58),
      (0.20, 0.82),
      (0.02, 0.82),
    ], VehicleCanvas.glassShine);
    _headlights(vehicle, 0.26, 0.40, 0.36);
    vehicle.box(-0.20, 0.26, 0.20, 0.40, dark, radius: vehicle.width * 0.02);
    vehicle.box(-0.12, 0.12, 0.12, 0.21, VehicleCanvas.plate, radius: vehicle.width * 0.015);
  }

  void _truck(VehicleCanvas vehicle, Color color) {
    final dark = shade(color, -0.4);
    vehicle.wheels(0.17);
    vehicle.box(-0.5, 0.21, 0.5, 0.98, shade(color, -0.15), radius: vehicle.width * 0.025);
    vehicle.box(-0.48, 0.14, 0.48, 0.80, color, radius: vehicle.width * 0.04);
    vehicle.box(-0.48, 0.76, 0.48, 0.82, shade(color, 0.2), radius: vehicle.width * 0.03);
    vehicle.box(-0.40, 0.46, 0.40, 0.74, VehicleCanvas.glass, radius: vehicle.width * 0.02);
    vehicle.quad(const [
      (0.08, 0.50),
      (0.26, 0.50),
      (0.18, 0.70),
      (0.02, 0.70),
    ], VehicleCanvas.glassShine);
    vehicle.box(-0.30, 0.24, 0.30, 0.40, dark, radius: vehicle.width * 0.02);
    _headlights(vehicle, 0.26, 0.40, 0.46);
    vehicle.box(-0.5, 0.08, 0.5, 0.18, const Color(0xFF23252C));
    vehicle.box(-0.10, 0.09, 0.10, 0.17, VehicleCanvas.plate, radius: vehicle.width * 0.01);
  }

  // Paints the two headlights, [outer] being how far out they reach.
  void _headlights(VehicleCanvas vehicle, double bottom, double top, double inner) {
    vehicle.box(-0.48, bottom, -inner, top, VehicleCanvas.headlight, radius: vehicle.width * 0.02);
    vehicle.box(inner, bottom, 0.48, top, VehicleCanvas.headlight, radius: vehicle.width * 0.02);
  }
}
