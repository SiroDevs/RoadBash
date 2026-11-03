// Dart imports:
import 'dart:ui';

// Project imports:
import '../../../utils/paint_utils.dart';
import '../../road_projection.dart';
import '../../scene_theme.dart';
import '../ground_marks.dart';
import '../terrain.dart';

/// Paints a pool of mud whose width follows the patch.
class MudPoolPainter {
  MudPoolPainter(SceneTheme theme, this._marks)
    : _mud = fogRamp(const Color(0xFF58391F), theme.fog),
      _shine = fogRamp(const Color(0xFF93704D), theme.fog);

  final GroundMarks _marks;
  final List<Paint> _mud, _shine;

  /// Draws the pool across one segment, with a shine on every other one.
  void draw(Canvas canvas, VisionSeg vision, double fog, Ground ground) {
    if (ground.half < 0.02) return;
    _marks.band(canvas, vision, fog, _mud, ground.center - ground.half, ground.center + ground.half);
    if (vision.seg.index.isEven) {
      final lateral = ground.center - ground.half * 0.35;
      _marks.spot(canvas, vision, _shine, fog, lateral, 0.5, ground.half * 0.28, 0.22);
    }
  }
}
