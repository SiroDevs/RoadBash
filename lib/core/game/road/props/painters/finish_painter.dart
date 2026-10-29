// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../../utils/paint_utils.dart';
import '../../road_projection.dart';
import '../../scene_theme.dart';
import '../prop.dart';

/// Chequered cones and the cheering crowd of the finish plaza.
class FinishPainter {
  FinishPainter(SceneTheme theme)
    : _black = fogRamp(const Color(0xFF17181C), theme.fog),
      _white = fogRamp(const Color(0xFFF2F2EE), theme.fog),
      _trousers = fogRamp(const Color(0xFF2B3140), theme.fog),
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

  final List<Paint> _black, _white, _trousers;
  final List<List<Paint>> _skin, _shirt;

  /// Draws a finish-area prop such as a post or spectator.
  ///
  /// [anchorX] and [anchorY] are the prop's ground point on screen and [width]
  /// and [height] its size in pixels. [vision] is the projected segment it
  /// stands on.
  void draw(Canvas canvas, VisionSeg vision, Prop prop, double anchorX, double anchorY, double width,
      double height) {
    switch (prop.kind) {
      case PropKind.post:
        _post(canvas, vision, anchorX, anchorY, width, height);
      case PropKind.spectator:
        _spectator(canvas, vision, prop, anchorX, anchorY, width, height);
      default:
        break;
    }
  }

  /// Draws a striped finish post.
  ///
  /// [anchorX] and [anchorY] are the prop's ground point on screen and [width]
  /// and [height] its size in pixels. [vision] is the projected segment it
  /// stands on.
  void _post(Canvas canvas, VisionSeg vision, double anchorX, double anchorY, double width, double height) {
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

  /// Draws a spectator.
  ///
  /// [anchorX] and [anchorY] are the prop's ground point on screen and [width]
  /// and [height] its size in pixels. [vision] is the projected segment it
  /// stands on.
  void _spectator(Canvas canvas, VisionSeg vision, Prop prop, double anchorX, double anchorY, double width,
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
