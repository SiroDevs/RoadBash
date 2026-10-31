// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../utils/paint_utils.dart';
import '../../utils/pseudo_random.dart';
import '../road_projection.dart';
import '../scene_theme.dart';
import '../terrain/terrain.dart';

/// Paints the loose soil, stones, potholes and mud pools on the road.
class TerrainPainter {
  TerrainPainter(SceneTheme theme)
    : _soil = fogRamp(shade(theme.roadLight, 0.16), theme.fog),
      _stone = fogRamp(const Color(0xFF9A9288), theme.fog),
      _stoneShade = fogRamp(const Color(0xFF5E5850), theme.fog),
      _pothole = fogRamp(const Color(0xFF3A2616), theme.fog),
      _rim = fogRamp(shade(theme.roadLight, 0.14), theme.fog),
      _mud = fogRamp(const Color(0xFF58391F), theme.fog),
      _shine = fogRamp(const Color(0xFF93704D), theme.fog);

  final List<Paint> _soil, _stone, _stoneShade, _pothole, _rim, _mud, _shine;
  final Path _path = Path();

  static const double _detailCutoff = 0.75;
  static const double _poolCutoff = 0.92;

  /// Draws the ground marks of one segment.
  void draw(Canvas canvas, VisionSeg vision, double fog) {
    final ground = vision.seg.ground;
    switch (ground.terrain) {
      case Terrain.firm:
        return;
      case Terrain.loose:
        if (fog < _detailCutoff) _drifts(canvas, vision, fog);
      case Terrain.stony:
        if (fog < _detailCutoff) _stones(canvas, vision, fog);
      case Terrain.potholed:
        if (fog < _detailCutoff) _potholes(canvas, vision, fog, ground);
      case Terrain.muddy:
        if (fog < _poolCutoff) _pool(canvas, vision, fog, ground);
    }
  }

  /// Draws streaks of loose soil lying across the road.
  void _drifts(Canvas canvas, VisionSeg vision, double fog) {
    final seed = vision.seg.index * 5;
    _path.reset();
    for (var streak = 0; streak < 3; streak++) {
      final at = pseudoRandom(seed + streak) * 1.7 - 0.85;
      final width = 0.04 + 0.07 * pseudoRandom(seed + streak + 40);
      _band(vision, at - width, at + width);
    }
    canvas.drawPath(_path, fogged(_soil, fog));
  }

  /// Draws a scatter of stones.
  void _stones(Canvas canvas, VisionSeg vision, double fog) {
    final seed = vision.seg.index * 7 + 3;
    final count = 2 + (pseudoRandom(seed) * 3).floor();
    for (var stone = 0; stone < count; stone++) {
      final base = seed + stone * 3;
      final lateral = pseudoRandom(base + 1) * 1.7 - 0.85;
      final along = pseudoRandom(base + 2);
      final radius = 0.012 + 0.03 * pseudoRandom(base + 3);
      _spot(canvas, vision, _stoneShade, fog, lateral + radius * 0.3, along, radius * 1.1, 0.4);
      _spot(canvas, vision, _stone, fog, lateral, along, radius, 0.32);
    }
  }

  /// Draws one or two potholes inside the patch.
  void _potholes(Canvas canvas, VisionSeg vision, double fog, Ground ground) {
    final seed = vision.seg.index * 11 + 5;
    final count = 1 + (pseudoRandom(seed) * 2).floor();
    for (var hole = 0; hole < count; hole++) {
      final base = seed + hole * 3;
      final lateral = ground.center + (pseudoRandom(base + 1) * 2 - 1) * ground.half;
      final along = 0.2 + 0.6 * pseudoRandom(base + 2);
      final radius = 0.05 + 0.06 * pseudoRandom(base + 3);
      _spot(canvas, vision, _rim, fog, lateral, along, radius * 1.25, 0.55);
      _spot(canvas, vision, _pothole, fog, lateral, along, radius, 0.44);
    }
  }

  /// Draws a mud pool whose width follows the patch.
  void _pool(Canvas canvas, VisionSeg vision, double fog, Ground ground) {
    if (ground.half < 0.02) return;
    _path.reset();
    _band(vision, ground.center - ground.half, ground.center + ground.half);
    canvas.drawPath(_path, fogged(_mud, fog));
    if (vision.seg.index.isEven) {
      final lateral = ground.center - ground.half * 0.35;
      _spot(canvas, vision, _shine, fog, lateral, 0.5, ground.half * 0.28, 0.22);
    }
  }

  /// Draws an oval of [radius] road widths on a segment at [along] (0 to 1).
  void _spot(
    Canvas canvas,
    VisionSeg vision,
    List<Paint> ramp,
    double fog,
    double lateral,
    double along,
    double radius,
    double rise,
  ) {
    final width = vision.w1 + (vision.w2 - vision.w1) * along;
    final x = vision.x1 + (vision.x2 - vision.x1) * along + width * lateral;
    final y = vision.y1 + (vision.y2 - vision.y1) * along;
    final halfWidth = width * radius;
    if (halfWidth < 0.8) return;
    final halfHeight = math.max(0.6, (vision.y1 - vision.y2) * rise);
    canvas.drawOval(
      Rect.fromLTRB(x - halfWidth, y - halfHeight, x + halfWidth, y + halfHeight),
      fogged(ramp, fog),
    );
  }

  /// Adds a quad between two lateral offsets.
  void _band(VisionSeg vision, double offset, double outer) {
    addQuad(
      _path,
      vision.x1 + vision.w1 * offset,
      vision.y1,
      vision.x1 + vision.w1 * outer,
      vision.y1,
      vision.x2 + vision.w2 * outer,
      vision.y2,
      vision.x2 + vision.w2 * offset,
      vision.y2,
    );
  }
}
