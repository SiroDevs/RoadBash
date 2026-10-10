// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import '../road/road_config.dart';

/// Main layout of the dashboard
class DashboardLayout {
  static const double aspect = 0.21;
  static const double dialStart = 0.75 * math.pi;
  static const double dialSweep = 1.5 * math.pi;

  late final double ph, pw, left, top, speedRadius, rpmRadius;
  late final Offset speedOffset, rpmOffset;
  late final Rect centre;

  DashboardLayout(Vector2 size) {
    ph = heightFor(size);
    pw = ph / aspect;
    left = (size.x - pw) / 2;
    top = (size.y - ph) * 1.125;
    speedOffset = Offset(left + pw * 0.31, top + ph * 0.5);
    speedRadius = ph * 0.35;
    rpmOffset = Offset(left + pw * 0.69, top + ph * 0.5);
    rpmRadius = ph * 0.35;
    centre = Rect.fromCenter(
      center: Offset(left + pw * 0.5, top + ph * 0.36),
      width: pw * 0.075,
      height: ph * 0.22,
    );
  }

  static double heightFor(Vector2 s) => math.min(s.x * aspect, s.y * 0.32);

  static double riderTyresGround(Vector2 s) => s.y - heightFor(s) * 0.86;

  static double cameraDistance(Vector2 s) {
    final base = RoadConfig.cameraHeight * RoadConfig.cameraDepth;
    final below = riderTyresGround(s) - s.y * RoadConfig.horizonRatio;
    return below < 1 ? base : base * s.y * 0.5 / below;
  }

  static double lanePx(Vector2 s, int lanes) =>
      RoadConfig.cameraDepth /
      cameraDistance(s) *
      RoadConfig.roadWidth *
      s.x /
      lanes;

  static Offset polar(Offset c, double angle, double radius) =>
      Offset(c.dx + math.cos(angle) * radius, c.dy + math.sin(angle) * radius);

  static double dialAngle(double fraction) =>
      dialStart + dialSweep * math.min(1.0, math.max(0.0, fraction));
}
