// Dart imports:
import 'dart:ui';

// Project imports:
import '../../../../../domain/models/scene_id.dart';
import '../../../utils/paint_utils.dart';
import '../../../utils/pseudo_random.dart';
import '../../road_projection.dart';
import '../../scene_theme.dart';
import '../ground_marks.dart';
import '../terrain.dart';
import 'vehicle_track_painter.dart';

/// Paints loose soil: bare earth where the tarmac is gone, and streaks of
/// dust lying across the road.
class LooseSoilPainter {
  LooseSoilPainter(SceneTheme theme, this._marks, this._track)
    : _bare = theme.id == SceneId.jungle,
      _dirt = fogRamp(shade(theme.shoulder, -0.04), theme.fog),
      _soil = fogRamp(shade(GroundMarks.soilTone(theme), 0.16), theme.fog);

  final GroundMarks _marks;
  final VehicleTrackPainter _track;
  final bool _bare;
  final List<Paint> _dirt, _soil;

  /// Draws the loose soil of one segment; streaks only when [detailed].
  void draw(Canvas canvas, VisionSeg vision, double fog, Ground ground, {required bool detailed}) {
    if (_bare) _marks.band(canvas, vision, fog, _dirt, -1, 1);
    if (!detailed) return;
    final seed = vision.seg.index * 5;
    _marks.begin();
    for (var streak = 0; streak < 3; streak++) {
      final at = pseudoRandom(seed + streak) * 1.7 - 0.85;
      final width = 0.04 + 0.07 * pseudoRandom(seed + streak + 40);
      if (GroundMarks.onLane(ground, at, width)) continue;
      _marks.add(vision, at - width, at + width);
    }
    _marks.fill(canvas, _soil, fog);
    _track.draw(canvas, vision, fog, ground);
  }
}
