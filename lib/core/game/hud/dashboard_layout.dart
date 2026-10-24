// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import '../../../common/layout/responsive_layout_builder.dart';
import '../road/road_config.dart';

/// Where the dashboard sits and how big everything on it is.
///
/// The housing lives in a strip along the bottom edge of the screen, and its
/// size is chosen to *fit that strip* at any window size, using the same
/// small / medium / large tiers as the menu screens:
///
///  * landscape tiers pick how wide and how tall the strip may be;
///  * portrait screens get a taller housing so the dials stay readable;
///  * the housing is never wider than the screen and never taller than
///    [DashboardTier.maxShare] of its height.
///
/// Everything else (camera, rider, on-screen pedals) reads [footprint] from
/// here, so they always agree on where the dashboard ends.
class DashboardLayout {
  /// Width : height of the housing on a wide screen.
  static const double aspect = 0.21;
  static const double dialStart = 0.75 * math.pi;
  static const double dialSweep = 1.5 * math.pi;

  /// Share of the housing that shows above the bottom edge of the screen (the
  /// lower edge of the dials is tucked under it).
  static const double visibleShare = 0.734;

  /// The rider's tyres sit this far up the housing, as a share of its height.
  static const double _tyreShare = 0.86;

  /// ...but never lower than this share of the screen height. Tall screens
  /// would otherwise push the camera so close that the road spills far past
  /// both screen edges.
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

  /// Housing aspect for this screen.
  static double aspectFor(Vector2 s) {
    if (s.x <= 0 || s.y <= 0) return aspect;
    if (!isPortrait(s)) {
      // Short landscape windows (phones sideways) get a slightly taller
      // housing, so the dials do not shrink along with the window.
      return tierOf(s).pick(small: 0.245, medium: 0.225, large: aspect);
    }
    final ratio = s.x / s.y;
    return math.min(0.34, aspect * (1 + (1 - ratio) * 1.2));
  }

  /// The most of the screen height the housing may take.
  static double maxShareFor(Vector2 s) {
    if (isPortrait(s)) return 0.30;
    return tierOf(s).pick(small: 0.38, medium: 0.34, large: 0.32);
  }

  static double heightFor(Vector2 s) =>
      math.min(s.x * aspectFor(s), s.y * maxShareFor(s));

  /// Height of the dashboard that is actually on screen.
  static double visibleHeight(Vector2 s) => heightFor(s) * visibleShare;

  /// The part of the dashboard that is on screen: the area on-screen controls
  /// must stay above.
  static Rect footprint(Vector2 s) {
    final h = heightFor(s);
    final w = h / aspectFor(s);
    final visible = h * visibleShare;
    return Rect.fromLTWH((s.x - w) / 2, s.y - visible, w, visible);
  }

  static double riderTyresGround(Vector2 s) =>
      math.min(s.y - heightFor(s) * _tyreShare, s.y * _tyreMaxY);

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
