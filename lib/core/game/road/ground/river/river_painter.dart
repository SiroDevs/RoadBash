// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../../utils/paint_utils.dart';
import '../../../utils/pseudo_random.dart';
import '../../config/road_config.dart';
import '../../road_projection.dart';
import '../../scene_theme.dart';
import '../ground_marks.dart';
import '../terrain.dart';

/// Paints the river ford: shallow water across the road and out over both
/// banks, with the submerged road showing through, rocks, ripples and foam at
/// the entry and exit.
class RiverPainter {
  RiverPainter(SceneTheme theme, this._marks)
    : _water = fogRamp(Color.lerp(const Color(0xFF4A7C82), theme.skyHorizon, 0.3)!, theme.fog),
      _bed = fogRamp(const Color(0xFF8E9C86), theme.fog),
      _foam = fogRamp(const Color(0xFFE6F1F2), theme.fog),
      _ripple = fogRamp(const Color(0xFF9CC4C6), theme.fog),
      _wheel = fogRamp(shade(GroundMarks.soilTone(theme), -0.24), theme.fog),
      _stone = fogRamp(const Color(0xFF9A9288), theme.fog),
      _stoneShade = fogRamp(const Color(0xFF5E5850), theme.fog);

  static const double _detailCutoff = 0.75;

  final GroundMarks _marks;
  final List<Paint> _water, _bed, _foam, _ripple, _wheel, _stone, _stoneShade;

  /// Draws the ford across one segment. [ground] knows how far along the ford
  /// the segment is, so the entry and exit get foam.
  void draw(Canvas canvas, VisionSeg vision, double fog, Ground ground) {
    const edge = 1 + RoadConfig.shoulder;
    _marks.band(canvas, vision, fog, _water, -40, 40);
    if (fog > _detailCutoff) return;
    final seed = vision.seg.index * 3;
    _marks.band(canvas, vision, fog, _bed, -0.5, 0.5);
    _marks
      ..begin()
      ..add(vision, -0.42, -0.34)
      ..add(vision, 0.34, 0.42)
      ..fill(canvas, _wheel, fog)
      ..begin();
    for (var streak = 0; streak < 4; streak++) {
      final at = pseudoRandom(seed + streak) * 6 - 3;
      _marks.add(vision, at - 0.18, at + 0.18);
    }
    _marks.fill(canvas, _ripple, fog);
    for (var rock = 0; rock < 3; rock++) {
      final base = seed + 20 + rock * 3;
      final side = pseudoRandom(base) < 0.5 ? -1.0 : 1.0;
      final lateral = side * (edge + 0.1 + 2.5 * pseudoRandom(base + 1));
      final radius = 0.03 + 0.05 * pseudoRandom(base + 2);
      _marks.spot(canvas, vision, _stoneShade, fog, lateral, 0.5, radius * 1.15, 0.34);
      _marks.spot(canvas, vision, _stone, fog, lateral, 0.45, radius, 0.28);
    }
    final edgeness = math.min(ground.half, 1 - ground.half);
    if (edgeness < 0.07) _marks.band(canvas, vision, fog, _foam, -1.6, 1.6);
  }
}
