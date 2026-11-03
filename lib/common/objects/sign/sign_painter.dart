// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../../core/game/road/road_projection.dart';
import '../../../core/game/road/scene_theme.dart';
import '../../../core/game/utils/paint_utils.dart';

/// Paints a plain road sign: a post with a square plate.
class SignPainter {
  SignPainter(SceneTheme theme)
    : _pole = fogRamp(theme.poleColor, theme.fog),
      _face = fogRamp(const Color(0xFFE8E4D8), theme.fog),
      _ink = fogRamp(const Color(0xFF2E3238), theme.fog);

  final List<Paint> _pole, _face, _ink;

  /// Draws a road sign.
  ///
  /// [anchorX] and [anchorY] are the prop's ground point on screen and [width]
  /// and [height] its size in pixels. [vision] is the projected segment it
  /// stands on.
  void draw(Canvas canvas, VisionSeg vision, double anchorX, double anchorY, double width, double height) {
    final poleW = math.max(1.0, width * 0.17);
    canvas.drawRect(
        Rect.fromLTRB(anchorX - poleW, anchorY - height, anchorX + poleW, anchorY + 1), fogged(_pole, vision.fog));
    final plate = Rect.fromLTRB(anchorX - width, anchorY - height, anchorX + width, anchorY - height + width * 2.1);
    canvas.drawRect(plate, fogged(_face, vision.fog));
    canvas.drawRect(plate.deflate(math.max(0.6, width * 0.16)), fogged(_ink, vision.fog));
  }
}
