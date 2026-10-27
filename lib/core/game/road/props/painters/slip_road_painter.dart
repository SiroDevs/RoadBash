// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import '../../../utils/paint_utils.dart';
import '../../projection/road_projection.dart';
import '../../scene/scene_theme.dart';
import '../prop.dart';

class SlipRoadPainter {
  SlipRoadPainter(SceneTheme theme)
      : _asphalt = fogRamp(theme.roadDark, theme.fog),
        _gore = fogRamp(const Color(0xFFC9CACB), theme.fog),
        _line = fogRamp(theme.laneColor, theme.fog),
        _rail = fogRamp(const Color(0xFFB9BEC4), theme.fog);

  final List<Paint> _asphalt, _gore, _line, _rail;
  final Path _path = Path();

  static const double _edge = 1.13;
  static const double _lane = 0.55;
  static const double _gap = 0.12;
  static const double _spread = 0.9;

  void draw(Canvas c, VisionSeg near, VisionSeg far, Prop p, Vector2 size) {
    final aNear = _edge + _gapAt(p, near.seg.index);
    final aFar = _edge + _gapAt(p, far.seg.index);

    c.save();
    c.clipRect(Rect.fromLTRB(0, 0, size.x, near.clip));

    if (p.detail != 0) {
      // Gore
      _quad(c, near, far, p.side, _edge, aNear, _edge, aFar, _gore);
    } else {
      // Guard rail
      _quad(c, near, far, p.side, _edge + 0.04, _edge + 0.07, _edge + 0.04,
          _edge + 0.07, _rail);
    }
    // Slip lane
    _quad(c, near, far, p.side, aNear, aNear + _lane, aFar, aFar + _lane,
        _asphalt);
    // Lane edge
    if (near.fog < 0.8) {
      _quad(c, near, far, p.side, aNear + _lane - 0.03, aNear + _lane,
          aFar + _lane - 0.03, aFar + _lane, _line);
    }
    c.restore();
  }

  double _gapAt(Prop p, int index) {
    if (p.detail == 0) return _gap;
    final t = ((index - p.anchor) / p.depth).clamp(0.0, 1.0);
    return _spread * (p.detail > 0 ? t : 1 - t);
  }

  void _quad(Canvas c, VisionSeg near, VisionSeg far, int side, double n0,
      double n1, double f0, double f1, List<Paint> ramp) {
    drawQuad(
      c,
      _path,
      fogged(ramp, far.fog),
      near.x1 + side * near.w1 * n0,
      near.y1,
      near.x1 + side * near.w1 * n1,
      near.y1,
      far.x1 + side * far.w1 * f1,
      far.y1,
      far.x1 + side * far.w1 * f0,
      far.y1,
    );
  }
}
