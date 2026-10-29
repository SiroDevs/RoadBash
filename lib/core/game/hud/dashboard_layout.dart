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

  static ResponsiveLayoutSize tierOf(Vector2 screen) =>
      ResponsiveLayoutSize.fromDimensions(screen.x, screen.y);

  static bool isPortrait(Vector2 screen) => screen.x < screen.y;

  static double aspectFor(Vector2 screen) {
    if (screen.x <= 0 || screen.y <= 0) return aspect;
    if (!isPortrait(screen)) {
      return tierOf(screen).pick(small: 0.245, medium: 0.225, large: aspect);
    }
    final ratio = screen.x / screen.y;
    return math.min(0.34, aspect * (1 + (1 - ratio) * 1.2));
  }

  static double maxShareFor(Vector2 screen) {
    if (isPortrait(screen)) return 0.30;
    return tierOf(screen).pick(small: 0.38, medium: 0.34, large: 0.32);
  }

  static double heightFor(Vector2 screen) =>
      math.min(screen.x * aspectFor(screen), screen.y * maxShareFor(screen));

  static double visibleHeight(Vector2 screen) => heightFor(screen) * visibleShare;

  static Rect footprint(Vector2 screen) {
    final height = heightFor(screen);
    final width = height / aspectFor(screen);
    final visible = height * visibleShare;
    return Rect.fromLTWH((screen.x - width) / 2, screen.y - visible, width, visible);
  }

  static const double _portraitReach = 0.4;
  static const double _roadFill = 0.62;
  static const double _maxSpread = 1.8;

  static double horizonY(Vector2 screen) => screen.y * RoadConfig.horizonRatio;

  static double riderTyresGround(Vector2 screen) {
    final ground = math.min(screen.y - heightFor(screen) * _tyreShare, screen.y * _tyreMaxY);
    if (!isPortrait(screen)) return ground;
    return math.min(ground, horizonY(screen) + screen.x * _portraitReach);
  }

  static double roadSpread(Vector2 screen) {
    final below = riderTyresGround(screen) - horizonY(screen);
    if (below < 1) return 1;
    return (screen.x * _roadFill / (2 * below)).clamp(1.0, _maxSpread).toDouble();
  }

  static double cameraDistance(Vector2 screen) {
    final base = RoadConfig.cameraHeight * RoadConfig.cameraDepth;
    final below = riderTyresGround(screen) - horizonY(screen);
    return below < 1 ? base : base * screen.y * 0.5 / below;
  }

  static double lanePx(Vector2 screen, int lanes) =>
      RoadConfig.cameraDepth /
      cameraDistance(screen) *
      RoadConfig.roadWidth *
      screen.y *
      roadSpread(screen) /
      lanes;

  static Offset polar(Offset centre, double angle, double radius) =>
      Offset(centre.dx + math.cos(angle) * radius, centre.dy + math.sin(angle) * radius);

  static double dialAngle(double fraction) =>
      dialStart + dialSweep * math.min(1.0, math.max(0.0, fraction));
}
