// Dart imports:
import 'dart:ui';

// Project imports:
import '../../../utils/paint_utils.dart';
import '../../../utils/pseudo_random.dart';
import '../../road_projection.dart';
import '../../scene_theme.dart';
import '../ground_marks.dart';
import '../terrain.dart';
import 'vehicle_track_painter.dart';

/// Paints a scatter of stones across a stony stretch of road.
class StonePainter {
  StonePainter(SceneTheme theme, this._marks, this._track)
    : _stone = fogRamp(const Color(0xFF9A9288), theme.fog),
      _shade = fogRamp(const Color(0xFF5E5850), theme.fog);

  final GroundMarks _marks;
  final VehicleTrackPainter _track;
  final List<Paint> _stone, _shade;

  /// Draws the stones of one segment, keeping clear of the firm line.
  void draw(Canvas canvas, VisionSeg vision, double fog, Ground ground) {
    _track.draw(canvas, vision, fog, ground);
    final seed = vision.seg.index * 7 + 3;
    final count = 2 + (pseudoRandom(seed) * 3).floor();
    for (var stone = 0; stone < count; stone++) {
      final base = seed + stone * 3;
      final lateral = pseudoRandom(base + 1) * 1.7 - 0.85;
      final along = pseudoRandom(base + 2);
      final radius = 0.012 + 0.03 * pseudoRandom(base + 3);
      if (GroundMarks.onLane(ground, lateral, radius)) continue;
      _marks.spot(canvas, vision, _shade, fog, lateral + radius * 0.3, along, radius * 1.1, 0.4);
      _marks.spot(canvas, vision, _stone, fog, lateral, along, radius, 0.32);
    }
  }
}
