// Dart imports:
import 'dart:ui';

// Project imports:
import '../../utils/paint_utils.dart';
import '../scene_theme.dart';
import '../universal/ground/terrain.dart';
import '../universal/ground_marks.dart';
import '../universal/road_projection.dart';

/// Paints the firm line where vehicles have packed the ground down, with two
/// wheel tracks in it.
class VehicleTrackPainter {
  VehicleTrackPainter(SceneTheme theme, this._marks)
    : _packed = fogRamp(shade(GroundMarks.soilTone(theme), -0.1), theme.fog),
      _wheel = fogRamp(shade(GroundMarks.soilTone(theme), -0.24), theme.fog);

  final GroundMarks _marks;
  final List<Paint> _packed, _wheel;

  /// Draws the firm line of one segment, if the ground has one.
  void draw(Canvas canvas, VisionSeg vision, double fog, Ground ground) {
    if (!ground.hasLane) return;
    final centre = ground.laneCenter;
    final half = ground.laneHalf;
    _marks.band(canvas, vision, fog, _packed, centre - half, centre + half);
    final track = half * 0.55;
    _marks
      ..begin()
      ..add(vision, centre - track - 0.03, centre - track + 0.03)
      ..add(vision, centre + track - 0.03, centre + track + 0.03)
      ..fill(canvas, _wheel, fog);
  }
}
