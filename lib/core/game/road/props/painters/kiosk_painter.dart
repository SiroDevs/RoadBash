// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import '../../../utils/paint_utils.dart';
import '../../road_projection.dart';
import '../../scene_theme.dart';
import '../prop.dart';
import 'box_frame.dart';

/// Paints roadside kiosks and shops: painted walls, a sign band, openings and
/// a corrugated iron roof.
class KioskPainter {
  KioskPainter(SceneTheme theme)
    : _walls = [for (final c in _paints) fogRamp(c, theme.fog)],
      _fronts = [for (final c in _paints) fogRamp(shade(c, -0.25), theme.fog)],
      _roof = fogRamp(const Color(0xFF7C8186), theme.fog),
      _roofShade = fogRamp(const Color(0xFF5D6368), theme.fog),
      _sign = fogRamp(const Color(0xFFF4EFE2), theme.fog),
      _opening = fogRamp(const Color(0xFF22252B), theme.fog);

  static const List<Color> _paints = [
    Color(0xFFC8402F),
    Color(0xFF2E8B4F),
    Color(0xFF2C6DB5),
    Color(0xFFE2B33A),
    Color(0xFF2FA09A),
    Color(0xFFE07A2C),
  ];
  static const double _openingCutoff = 0.7;

  final List<List<Paint>> _walls, _fronts;
  final List<Paint> _roof, _roofShade, _sign, _opening;
  final Path _path = Path();

  /// Draws a kiosk between two segments.
  void draw(Canvas canvas, VisionSeg near, VisionSeg far, Prop prop, Vector2 size) {
    final box = BoxFrame(near, far, prop, size);
    if (!box.visible) return;
    final tint = prop.tint % _walls.length;
    canvas
      ..save()
      ..clipRect(Rect.fromLTRB(0, 0, size.x, near.clip));

    drawQuad(canvas, _path, fogged(_walls[tint], far.fog), box.xi1, box.base1, box.xi2,
        box.base2, box.xi2, box.top2, box.xi1, box.top1);
    drawQuad(canvas, _path, fogged(_fronts[tint], near.fog), box.xi1, box.base1, box.xo1,
        box.base1, box.xo1, box.top1, box.xi1, box.top1);

    _strip(canvas, box, _sign, far.fog, 0.66, 0.9, 0.06, 0.94);
    if (near.fog < _openingCutoff) {
      _strip(canvas, box, _opening, far.fog, 0.06, 0.56, 0.12, 0.4);
      _strip(canvas, box, _opening, far.fog, 0.3, 0.55, 0.52, 0.88);
    }
    _roofOver(canvas, box, near, far, prop);
    canvas.restore();
  }

  /// Draws a patch of the road-facing wall between fractions of its depth
  /// ([t0], [t1]) and height ([f0], [f1]).
  void _strip(Canvas canvas, BoxFrame box, List<Paint> ramp, double fog, double f0,
      double f1, double t0, double t1) {
    double x(double t) => box.xi1 + (box.xi2 - box.xi1) * t;
    double y(double t, double f) {
      final base = box.base1 + (box.base2 - box.base1) * t;
      final top = box.top1 + (box.top2 - box.top1) * t;
      return base + (top - base) * f;
    }

    drawQuad(canvas, _path, fogged(ramp, fog), x(t0), y(t0, f0), x(t1), y(t1, f0),
        x(t1), y(t1, f1), x(t0), y(t0, f1));
  }

  /// Draws the corrugated roof sloping up over the top edge.
  void _roofOver(Canvas canvas, BoxFrame box, VisionSeg near, VisionSeg far, Prop prop) {
    final rise1 = prop.height * 0.1 * near.k1;
    final rise2 = prop.height * 0.1 * far.k1;
    drawQuad(canvas, _path, fogged(_roof, far.fog), box.xi1, box.top1, box.xi2, box.top2,
        box.xi2, box.top2 - rise2, box.xi1, box.top1 - rise1);
    drawQuad(canvas, _path, fogged(_roofShade, far.fog), box.xi1, box.top1 - rise1 * 0.5,
        box.xi2, box.top2 - rise2 * 0.5, box.xi2, box.top2 - rise2 * 0.62, box.xi1,
        box.top1 - rise1 * 0.62);
  }
}
