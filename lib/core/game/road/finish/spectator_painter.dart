// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../common/universal/prop.dart';
import '../../utils/paint_utils.dart';
import '../road_projection.dart';
import '../scene_theme.dart';

/// Paints a spectator in the finish crowd.
class SpectatorPainter {
  SpectatorPainter(SceneTheme theme)
    : _trousers = fogRamp(const Color(0xFF2B3140), theme.fog),
      _skin = [for (final c in _skins) fogRamp(c, theme.fog)],
      _shirt = [for (final c in _shirts) fogRamp(c, theme.fog)];

  static const List<Color> _skins = [
    Color(0xFF8D5A3B),
    Color(0xFF6B4228),
    Color(0xFFB07A55),
    Color(0xFF4A2D1D),
  ];
  static const List<Color> _shirts = [
    Color(0xFFD23B32),
    Color(0xFF2E6BC6),
    Color(0xFFF2C230),
    Color(0xFF3FA05B),
    Color(0xFFEDE7D6),
    Color(0xFFB04CB8),
    Color(0xFFE8782E),
    Color(0xFF2A2D33),
  ];

  final List<Paint> _trousers;
  final List<List<Paint>> _skin, _shirt;

  /// Draws a spectator.
  ///
  /// [anchorX] and [anchorY] are the prop's ground point on screen and [width]
  /// and [height] its size in pixels. [vision] is the projected segment it
  /// stands on.
  void draw(Canvas canvas, VisionSeg vision, Prop prop, double anchorX, double anchorY, double width,
      double height) {
    final shirt = fogged(_shirt[prop.tint % _shirt.length], vision.fog);
    final skin = fogged(
      _skin[(prop.detail * _skin.length).floor() % _skin.length],
      vision.fog,
    );
    final legH = height * 0.42, torsoH = height * 0.34, headR = math.max(1.0, height * 0.1);
    final hip = anchorY - legH, shoulder = hip - torsoH;

    canvas.drawRect(
      Rect.fromLTRB(anchorX - width * 0.7, hip, anchorX + width * 0.7, anchorY + 1),
      fogged(_trousers, vision.fog),
    );
    canvas.drawRect(Rect.fromLTRB(anchorX - width, shoulder, anchorX + width, hip + 1), shirt);
    if (prop.detail > 0.5) {
      // Cheering, one arm up.
      canvas.drawRect(
        Rect.fromLTRB(anchorX + width, shoulder - torsoH * 0.5, anchorX + width * 1.55, shoulder + 1),
        shirt,
      );
    }
    canvas.drawCircle(Offset(anchorX, shoulder - headR), headR, skin);
  }
}
