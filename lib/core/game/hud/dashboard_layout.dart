// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import '../../layout/responsive_layout_builder.dart';
import '../road/config/road_config.dart';

/// Sizes and positions of the dashboard and road for a screen.
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

  /// Returns the size tier for a screen.
  static ResponsiveLayoutSize tierOf(Vector2 screen) =>
      ResponsiveLayoutSize.fromDimensions(screen.x, screen.y);

  /// True when the screen is taller than wide.
  static bool isPortrait(Vector2 screen) => screen.x < screen.y;

  /// Returns the dashboard aspect ratio for a screen.
  static double aspectFor(Vector2 screen) {
    if (screen.x <= 0 || screen.y <= 0) return aspect;
    if (!isPortrait(screen)) {
      return tierOf(screen).pick(small: 0.245, medium: 0.225, large: aspect);
    }
    final ratio = screen.x / screen.y;
    return math.min(0.34, aspect * (1 + (1 - ratio) * 1.2));
  }

  /// Returns the largest share of the screen the dashboard may use.
  static double maxShareFor(Vector2 screen) {
    if (isPortrait(screen)) return 0.30;
    return tierOf(screen).pick(small: 0.38, medium: 0.34, large: 0.32);
  }

  /// Returns the dashboard height for a screen.
  static double heightFor(Vector2 screen) =>
      math.min(screen.x * aspectFor(screen), screen.y * maxShareFor(screen));

  /// Returns the part of the dashboard that is visible.
  static double visibleHeight(Vector2 screen) => heightFor(screen) * visibleShare;

  /// Returns the dashboard's rectangle on screen.
  static Rect footprint(Vector2 screen) {
    final height = heightFor(screen);
    final width = height / aspectFor(screen);
    final visible = height * visibleShare;
    return Rect.fromLTWH((screen.x - width) / 2, screen.y - visible, width, visible);
  }

  static const double _portraitReach = 0.4;
  static const double _roadFill = 0.62;
  static const double _maxSpread = 1.8;

  /// Returns the horizon's vertical position.
  static double horizonY(Vector2 screen) => screen.y * RoadConfig.horizonRatio;

  /// Returns where the rider's tyres touch the ground.
  static double riderTyresGround(Vector2 screen) {
    final ground = math.min(screen.y - heightFor(screen) * _tyreShare, screen.y * _tyreMaxY);
    if (!isPortrait(screen)) return ground;
    return math.min(ground, horizonY(screen) + screen.x * _portraitReach);
  }

  /// Returns how far the road is widened to fill the screen.
  static double roadSpread(Vector2 screen) {
    final below = riderTyresGround(screen) - horizonY(screen);
    if (below < 1) return 1;
    return (screen.x * _roadFill / (2 * below)).clamp(1.0, _maxSpread).toDouble();
  }

  /// Returns the camera distance for a screen.
  static double cameraDistance(Vector2 screen) {
    final base = RoadConfig.cameraHeight * RoadConfig.cameraDepth;
    final below = riderTyresGround(screen) - horizonY(screen);
    return below < 1 ? base : base * screen.y * 0.5 / below;
  }

  /// Returns the width in pixels of a lane.
  static double lanePx(Vector2 screen, int lanes) =>
      RoadConfig.cameraDepth /
      cameraDistance(screen) *
      RoadConfig.roadWidth *
      screen.y *
      roadSpread(screen) /
      lanes;

  /// Returns the point at an angle and radius from a center.
  static Offset polar(Offset centre, double angle, double radius) =>
      Offset(centre.dx + math.cos(angle) * radius, centre.dy + math.sin(angle) * radius);

  /// Returns the dial angle for a fraction of the range.
  static double dialAngle(double fraction) =>
      dialStart + dialSweep * math.min(1.0, math.max(0.0, fraction));
}
