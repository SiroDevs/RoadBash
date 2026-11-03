// Dart imports:
import 'dart:ui';

// Project imports:
import '../road_projection.dart';
import '../scene_theme.dart';
import 'dirt/loose_soil_painter.dart';
import 'dirt/mud_pool_painter.dart';
import 'dirt/pothole_painter.dart';
import 'dirt/stone_painter.dart';
import 'dirt/vehicle_track_painter.dart';
import 'ground_marks.dart';
import 'river/river_painter.dart';
import 'terrain.dart';

/// Chooses the painter for the loose soil, stones, potholes, mud pools and
/// river ford on the road.
class GroundPainter {
  GroundPainter(SceneTheme theme) : this._(theme, GroundMarks());

  GroundPainter._(SceneTheme theme, GroundMarks marks)
    : this._with(theme, marks, VehicleTrackPainter(theme, marks));

  GroundPainter._with(SceneTheme theme, GroundMarks marks, VehicleTrackPainter track)
    : _loose = LooseSoilPainter(theme, marks, track),
      _stones = StonePainter(theme, marks, track),
      _potholes = PotholePainter(theme, marks),
      _mud = MudPoolPainter(theme, marks),
      _river = RiverPainter(theme, marks);

  static const double _detailCutoff = 0.75;
  static const double _poolCutoff = 0.92;

  final LooseSoilPainter _loose;
  final StonePainter _stones;
  final PotholePainter _potholes;
  final MudPoolPainter _mud;
  final RiverPainter _river;

  /// Draws the ground marks of one segment.
  void draw(Canvas canvas, VisionSeg vision, double fog) {
    final ground = vision.seg.ground;
    final detailed = fog < _detailCutoff;
    switch (ground.terrain) {
      case Terrain.firm:
        return;
      case Terrain.loose:
        _loose.draw(canvas, vision, fog, ground, detailed: detailed);
      case Terrain.stony:
        if (detailed) _stones.draw(canvas, vision, fog, ground);
      case Terrain.water:
        if (fog < _poolCutoff) _river.draw(canvas, vision, fog, ground);
      case Terrain.potholed:
        if (detailed) _potholes.draw(canvas, vision, fog, ground);
      case Terrain.muddy:
        if (fog < _poolCutoff) _mud.draw(canvas, vision, fog, ground);
    }
  }
}
