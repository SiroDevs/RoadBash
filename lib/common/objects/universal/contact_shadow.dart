// Dart imports:
import 'dart:ui';

// Project imports:
import '../../../core/game/road/road_projection.dart';
import '../../../core/game/road/scene_theme.dart';
import '../../../core/game/utils/paint_utils.dart';

/// The soft shadow an object casts on the ground where it stands.
class ContactShadow {
  ContactShadow(SceneTheme theme)
    : _shadow = fogRamp(const Color(0x3A000000), theme.fog, antiAlias: true);

  final List<Paint> _shadow;

  /// Draws the shadow under an object standing at ([anchorX], [anchorY]).
  void draw(Canvas canvas, VisionSeg vision, double anchorX, double anchorY, double radius) {
    if (radius < 1.2) return;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(anchorX, anchorY), width: radius * 2.1, height: radius * 0.62),
      fogged(_shadow, vision.fog),
    );
  }
}
