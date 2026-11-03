// Dart imports:
import 'dart:ui';

// Project imports:
import '../../../core/game/road/road_projection.dart';
import '../../../core/game/road/scene_theme.dart';
import '../../../core/game/utils/paint_utils.dart';
import '../universal/contact_shadow.dart';

/// Paints a boulder beside the road.
class RockPainter {
  RockPainter(SceneTheme theme, this._shadow)
    : _rock = fogRamp(theme.rockColor, theme.fog, antiAlias: true),
      _rockLight = fogRamp(shade(theme.rockColor, 0.22), theme.fog, antiAlias: true);

  final ContactShadow _shadow;
  final List<Paint> _rock, _rockLight;
  final Path _path = Path();

  /// Draws the boulder resting at ([anchorX], [anchorY]).
  void draw(Canvas canvas, VisionSeg vision, double anchorX, double anchorY, double width, double height) {
    _shadow.draw(canvas, vision, anchorX, anchorY, width * 0.9);
    _path
      ..reset()
      ..moveTo(anchorX - width, anchorY)
      ..lineTo(anchorX - width * 0.82, anchorY - height * 0.55)
      ..lineTo(anchorX - width * 0.25, anchorY - height)
      ..lineTo(anchorX + width * 0.5, anchorY - height * 0.82)
      ..lineTo(anchorX + width, anchorY - height * 0.2)
      ..lineTo(anchorX + width * 0.9, anchorY)
      ..close();
    canvas.drawPath(_path, fogged(_rock, vision.fog));
    _path
      ..reset()
      ..moveTo(anchorX - width * 0.82, anchorY - height * 0.55)
      ..lineTo(anchorX - width * 0.25, anchorY - height)
      ..lineTo(anchorX + width * 0.5, anchorY - height * 0.82)
      ..lineTo(anchorX + width * 0.05, anchorY - height * 0.5)
      ..close();
    canvas.drawPath(_path, fogged(_rockLight, vision.fog));
  }
}
