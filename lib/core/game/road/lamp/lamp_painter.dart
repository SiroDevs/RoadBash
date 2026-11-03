// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../utils/paint_utils.dart';
import '../scene_theme.dart';
import '../universal/road_projection.dart';

/// Paints a street lamp: a pole with an arm reaching over the road.
class LampPainter {
  LampPainter(SceneTheme theme)
    : _pole = fogRamp(theme.poleColor, theme.fog),
      _lampFace = fogRamp(const Color(0xFFE8E4D8), theme.fog);

  final List<Paint> _pole, _lampFace;

  /// Draws a street lamp.
  ///
  /// [anchorX] and [anchorY] are the prop's ground point on screen and [width]
  /// and [height] its size in pixels. [vision] is the projected segment it
  /// stands on. [side] is the side of the road and [arm] the length of the lamp
  /// arm.
  void draw(Canvas canvas, VisionSeg vision, double anchorX, double anchorY, double width, double height,
      int side, double arm) {
    final poleW = math.max(1.0, width * 0.35);
    final paint = fogged(_pole, vision.fog);
    canvas.drawRect(Rect.fromLTRB(anchorX - poleW, anchorY - height, anchorX + poleW, anchorY + 1), paint);
    // Arm over the road
    final reach = -side * width * (5 + arm * 7);
    canvas.drawRect(
        Rect.fromLTRB(math.min(anchorX, anchorX + reach), anchorY - height,
            math.max(anchorX, anchorX + reach), anchorY - height + poleW * 2.2),
        paint);
    canvas.drawRect(
        Rect.fromLTRB(anchorX + reach - poleW * 1.6, anchorY - height + poleW * 2.2,
            anchorX + reach + poleW * 1.6, anchorY - height + poleW * 4.4),
        fogged(_lampFace, vision.fog));
  }
}
