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

  void draw(Canvas c, VisionSeg v, Prop p, double x, double y, double w,
      double h) {
    switch (p.kind) {
      case PropKind.post:
        _post(c, v, x, y, w, h);
      case PropKind.spectator:
        _spectator(c, v, p, x, y, w, h);
      default:
        break;
    }
  }

  void _post(Canvas c, VisionSeg v, double x, double y, double w, double h) {
    const bands = 6;
    final bh = h / bands;
    for (var i = 0; i < bands; i++) {
      final top = y - h + bh * i;
      final even = i.isEven;
      c.drawRect(
        Rect.fromLTRB(x - w, top, x, top + bh + 0.5),
        fogged(even ? _black : _white, v.fog),
      );
      c.drawRect(
        Rect.fromLTRB(x, top, x + w, top + bh + 0.5),
        fogged(even ? _white : _black, v.fog),
      );
    }
    c.drawRect(
      Rect.fromLTRB(x - w * 1.5, y - bh * 0.4, x + w * 1.5, y + 1),
      fogged(_white, v.fog),
    );
  }

  void _spectator(Canvas c, VisionSeg v, Prop p, double x, double y, double w,
      double h) {
    final shirt = fogged(_shirt[p.tint % _shirt.length], v.fog);
    final skin = fogged(
      _skin[(p.detail * _skin.length).floor() % _skin.length],
      v.fog,
    );
    final legH = h * 0.42, torsoH = h * 0.34, headR = math.max(1.0, h * 0.1);
    final hip = y - legH, shoulder = hip - torsoH;

    c.drawRect(
      Rect.fromLTRB(x - w * 0.7, hip, x + w * 0.7, y + 1),
      fogged(_trousers, v.fog),
    );
    c.drawRect(Rect.fromLTRB(x - w, shoulder, x + w, hip + 1), shirt);
    if (p.detail > 0.5) {
      // Cheering, one arm up.
      c.drawRect(
        Rect.fromLTRB(x + w, shoulder - torsoH * 0.5, x + w * 1.55, shoulder + 1),
        shirt,
      );
    }
    c.drawCircle(Offset(x, shoulder - headR), headR, skin);
  }
}
