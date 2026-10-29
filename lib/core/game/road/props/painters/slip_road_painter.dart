// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import '../../../utils/paint_utils.dart';
import '../../road_projection.dart';
import '../../scene_theme.dart';
import '../prop.dart';

/// Paints slip roads that branch off the main road.
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

  /// Draws a slip road between two segments.
  void draw(Canvas canvas, VisionSeg near, VisionSeg far, Prop prop, Vector2 size) {
    final aNear = _edge + _gapAt(prop, near.seg.index);
    final aFar = _edge + _gapAt(prop, far.seg.index);

    canvas.save();
    canvas.clipRect(Rect.fromLTRB(0, 0, size.x, near.clip));

    if (prop.detail != 0) {
      _quad(canvas, near, far, prop.side, _edge, aNear, _edge, aFar, _gore);
    } else {
      _quad(canvas, near, far, prop.side, _edge + 0.04, _edge + 0.07, _edge + 0.04,
          _edge + 0.07, _rail);
    }
    _quad(canvas, near, far, prop.side, aNear, aNear + _lane, aFar, aFar + _lane,
        _asphalt);
    if (near.fog < 0.8) {
      _quad(canvas, near, far, prop.side, aNear + _lane - 0.03, aNear + _lane,
          aFar + _lane - 0.03, aFar + _lane, _line);
    }
    canvas.restore();
  }

  /// Returns the gap to the main road at a segment.
  double _gapAt(Prop prop, int index) {
    if (prop.detail == 0) return _gap;
    final progress = ((index - prop.anchor) / prop.depth).clamp(0.0, 1.0);
    return _spread * (prop.detail > 0 ? progress : 1 - progress);
  }

  /// Draws one quad of the slip road.
  ///
  /// [side] is the side of the road. [n0] and [n1] are the offsets of the near
  /// edge, [f0] and [f1] those of the far edge, and [ramp] holds the fogged
  /// paints.
  void _quad(Canvas canvas, VisionSeg near, VisionSeg far, int side, double n0,
      double n1, double f0, double f1, List<Paint> ramp) {
    drawQuad(
      canvas,
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
