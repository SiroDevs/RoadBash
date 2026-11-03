// Dart imports:
import 'dart:ui';

// Project imports:
import '../../utils/paint_utils.dart';
import '../../utils/pseudo_random.dart';
import '../scene_theme.dart';
import '../universal/ground/terrain.dart';
import '../universal/ground_marks.dart';
import '../universal/road_projection.dart';

/// Paints potholes inside a patch of broken road.
class PotholePainter {
  PotholePainter(SceneTheme theme, this._marks)
    : _hole = fogRamp(const Color(0xFF3A2616), theme.fog),
      _rim = fogRamp(shade(theme.roadLight, 0.14), theme.fog);

  final GroundMarks _marks;
  final List<Paint> _hole, _rim;

  /// Draws one or two potholes inside the patch of one segment.
  void draw(Canvas canvas, VisionSeg vision, double fog, Ground ground) {
    final seed = vision.seg.index * 11 + 5;
    final count = 1 + (pseudoRandom(seed) * 2).floor();
    for (var hole = 0; hole < count; hole++) {
      final base = seed + hole * 3;
      final lateral = ground.center + (pseudoRandom(base + 1) * 2 - 1) * ground.half;
      final along = 0.2 + 0.6 * pseudoRandom(base + 2);
      final radius = 0.05 + 0.06 * pseudoRandom(base + 3);
      _marks.spot(canvas, vision, _rim, fog, lateral, along, radius * 1.25, 0.55);
      _marks.spot(canvas, vision, _hole, fog, lateral, along, radius, 0.44);
    }
  }
}
