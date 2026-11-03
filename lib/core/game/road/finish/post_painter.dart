// Dart imports:
import 'dart:ui';

// Project imports:
import '../../utils/paint_utils.dart';
import '../scene_theme.dart';
import '../universal/road_projection.dart';

/// Paints a black and white striped finish post.
class PostPainter {
  PostPainter(SceneTheme theme)
    : _black = fogRamp(const Color(0xFF17181C), theme.fog),
      _white = fogRamp(const Color(0xFFF2F2EE), theme.fog);

  final List<Paint> _black, _white;

  /// Draws a striped finish post.
  ///
  /// [anchorX] and [anchorY] are the prop's ground point on screen and [width]
  /// and [height] its size in pixels. [vision] is the projected segment it
  /// stands on.
  void draw(Canvas canvas, VisionSeg vision, double anchorX, double anchorY, double width, double height) {
    const bands = 6;
    final bh = height / bands;
    for (var i = 0; i < bands; i++) {
      final top = anchorY - height + bh * i;
      final even = i.isEven;
      canvas.drawRect(
        Rect.fromLTRB(anchorX - width, top, anchorX, top + bh + 0.5),
        fogged(even ? _black : _white, vision.fog),
      );
      canvas.drawRect(
        Rect.fromLTRB(anchorX, top, anchorX + width, top + bh + 0.5),
        fogged(even ? _white : _black, vision.fog),
      );
    }
    canvas.drawRect(
      Rect.fromLTRB(anchorX - width * 1.5, anchorY - bh * 0.4, anchorX + width * 1.5, anchorY + 1),
      fogged(_white, vision.fog),
    );
  }
}
