// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import '../../layout/responsive_layout_builder.dart';
import '../road/config/road_config.dart';

class DashboardLayout {
  static const double aspect = 0.21;
  static const double dialStart = 0.75 * math.pi;
  static const double dialSweep = 1.5 * math.pi;

  static const double visibleShare = 0.734;

  static const double _tyreShare = 0.86;

  static const double _tyreMaxY = 0.76;

  late final double ph, pw, left, top, speedRadius, rpmRadius;
  late final Offset speedOffset, rpmOffset;
  late final Rect centre;
  late final ResponsiveLayoutSize tier;

  DashboardLayout(Vector2 size) {
    tier = tierOf(size);
    ph = heightFor(size);
    pw = ph / aspectFor(size);
    left = (size.x - pw) / 2;
    top = size.y - ph * visibleShare;
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

  static ResponsiveLayoutSize tierOf(Vector2 s) =>
      ResponsiveLayoutSize.fromDimensions(s.x, s.y);

  static bool isPortrait(Vector2 s) => s.x < s.y;

  static double aspectFor(Vector2 s) {
    if (s.x <= 0 || s.y <= 0) return aspect;
    if (!isPortrait(s)) {
      return tierOf(s).pick(small: 0.245, medium: 0.225, large: aspect);
    }
    final ratio = s.x / s.y;
    return math.min(0.34, aspect * (1 + (1 - ratio) * 1.2));
  }

  static double maxShareFor(Vector2 s) {
    if (isPortrait(s)) return 0.30;
    return tierOf(s).pick(small: 0.38, medium: 0.34, large: 0.32);
  }

  static double heightFor(Vector2 s) =>
      math.min(s.x * aspectFor(s), s.y * maxShareFor(s));

  static double visibleHeight(Vector2 s) => heightFor(s) * visibleShare;

  static Rect footprint(Vector2 s) {
    final h = heightFor(s);
    final w = h / aspectFor(s);
    final visible = h * visibleShare;
    return Rect.fromLTWH((s.x - w) / 2, s.y - visible, w, visible);
  }

  static const double _portraitReach = 0.4;
  static const double _roadFill = 0.62;
  static const double _maxSpread = 1.8;

  static double horizonY(Vector2 s) => s.y * RoadConfig.horizonRatio;

  static double riderTyresGround(Vector2 s) {
    final ground = math.min(s.y - heightFor(s) * _tyreShare, s.y * _tyreMaxY);
    if (!isPortrait(s)) return ground;
    return math.min(ground, horizonY(s) + s.x * _portraitReach);
  }

  static double roadSpread(Vector2 s) {
    final below = riderTyresGround(s) - horizonY(s);
    if (below < 1) return 1;
    return (s.x * _roadFill / (2 * below)).clamp(1.0, _maxSpread).toDouble();
  }

  static double cameraDistance(Vector2 s) {
    final base = RoadConfig.cameraHeight * RoadConfig.cameraDepth;
    final below = riderTyresGround(s) - horizonY(s);
    return below < 1 ? base : base * s.y * 0.5 / below;
  }

  static double lanePx(Vector2 s, int lanes) =>
      RoadConfig.cameraDepth /
      cameraDistance(s) *
      RoadConfig.roadWidth *
      s.y *
      roadSpread(s) /
      lanes;

  static Offset polar(Offset c, double angle, double radius) =>
      Offset(c.dx + math.cos(angle) * radius, c.dy + math.sin(angle) * radius);

  static double dialAngle(double fraction) =>
      dialStart + dialSweep * math.min(1.0, math.max(0.0, fraction));
}
