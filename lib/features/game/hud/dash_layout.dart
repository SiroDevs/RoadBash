// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import '../road/road_config.dart';

/// Where everything sits on the bike dashboard, plus the helpers that keep
/// the rider and the road lined up with it.
class DashLayout {
  DashLayout(Vector2 s) {
    ph = heightFor(s);
    pw = ph / aspect;
    left = (s.x - pw) / 2;
    top = s.y - ph;
    speedC = Offset(left + pw * 0.31, top + ph * 0.62);
    speedR = ph * 0.43;
    rpmC = Offset(left + pw * 0.69, top + ph * 0.64);
    rpmR = ph * 0.37;
    centre = Rect.fromCenter(
      center: Offset(left + pw * 0.5, top + ph * 0.50),
      width: pw * 0.13,
      height: ph * 0.30,
    );
  }

  static const double aspect = 0.36;
  static const double dialStart = 0.75 * math.pi;
  static const double dialSweep = 1.5 * math.pi;

  late final double ph, pw, left, top, speedR, rpmR;
  late final Offset speedC, rpmC;
  late final Rect centre;

  static double heightFor(Vector2 s) => math.min(s.x * aspect, s.y * 0.32);

  /// Screen y where the rider's tyres touch the road.
  static double groundY(Vector2 s) => s.y - heightFor(s) * 0.86;

  /// Camera distance whose road lands on [groundY].
  static double playerZ(Vector2 s) {
    final base = RoadConfig.cameraHeight * RoadConfig.cameraDepth;
    final below = groundY(s) - s.y * RoadConfig.horizonRatio;
    return below < 1 ? base : base * s.y * 0.5 / below;
  }

  static double lanePx(Vector2 s, int lanes) =>
      RoadConfig.cameraDepth / playerZ(s) * RoadConfig.roadWidth * s.x / lanes;

  static Offset polar(Offset c, double angle, double radius) =>
      Offset(c.dx + math.cos(angle) * radius, c.dy + math.sin(angle) * radius);

  static double dialAngle(double fraction) =>
      dialStart + dialSweep * math.min(1.0, math.max(0.0, fraction));
}
