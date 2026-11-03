// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart' show Vector2;

// Project imports:
import '../../road/config/road_config.dart';
import '../../road/road_projection.dart';
import '../../road/scene_theme.dart';
import '../../road/track/road_section.dart';
import '../../utils/paint_utils.dart';
import '../../utils/pseudo_random.dart';

/// Paints the edge of a drop beside the road: a guardrail or a grass lip, a
/// rock face falling away, and a hazy valley of treetops far below.
class CliffPainter {
  CliffPainter(SceneTheme theme)
    : _valley = fogRamp(const Color(0xFF3A6F57), theme.fog),
      _treetop = fogRamp(const Color(0xFF2A5A40), theme.fog),
      _treetopLight = fogRamp(const Color(0xFF4D8660), theme.fog),
      _face = fogRamp(const Color(0xFF7A5B3E), theme.fog),
      _faceAlt = fogRamp(const Color(0xFF8E6C48), theme.fog),
      _lip = fogRamp(const Color(0xFF6E9A3C), theme.fog),
      _rail = fogRamp(const Color(0xFFBDC1C4), theme.fog),
      _post = fogRamp(const Color(0xFF6C7175), theme.fog);

  static const double _edge = 1 + RoadConfig.shoulder;
  static const double _drop = 0.9;
  static const double _lipWidth = 0.16;
  static const double _skipFog = 0.95;
  static const double _detailFog = 0.6;

  final List<Paint> _valley, _treetop, _treetopLight, _face, _faceAlt, _lip, _rail, _post;
  final Path _path = Path();
  final Path _clip = Path();

  /// Draws the drops of the segments in [visions] (near to far), from the far
  /// end back, kept to the ground outside the road.
  void draw(Canvas canvas, List<VisionSeg> visions, int count, Vector2 size) {
    for (final side in const [-1.0, 1.0]) {
      if (!_hasDrop(visions, count, side)) continue;
      _clipOutside(visions, count, side, size);
      canvas
        ..save()
        ..clipPath(_clip);
      for (var index = count - 1; index >= 0; index--) {
        final vision = visions[index];
        if (_kind(vision, side) != null && vision.fog < _skipFog) {
          _segment(canvas, vision, side, size);
        }
      }
      canvas.restore();
    }
  }

  /// Returns the verge kind on [side] if it ends in a drop.
  VergeKind? _kind(VisionSeg vision, double side) {
    final section = vision.seg.section;
    final kind = side < 0 ? section.left : section.right;
    return kind == VergeKind.cliff || kind == VergeKind.ledge ? kind : null;
  }

  bool _hasDrop(List<VisionSeg> visions, int count, double side) {
    for (var index = 0; index < count; index++) {
      if (_kind(visions[index], side) != null) return true;
    }
    return false;
  }

  /// Builds the region on [side] of the road edge, so nothing paints on the road.
  void _clipOutside(List<VisionSeg> visions, int count, double side, Vector2 size) {
    final outer = side < 0 ? -50.0 : size.x + 50;
    final first = visions[0];
    _clip
      ..reset()
      ..moveTo(first.x1 + side * first.w1 * _edge, size.y + 50);
    for (var index = 0; index < count; index++) {
      final vision = visions[index];
      _clip.lineTo(vision.x1 + side * vision.w1 * _edge, vision.y1);
    }
    final last = visions[count - 1];
    _clip
      ..lineTo(last.x2 + side * last.w2 * _edge, last.y2)
      ..lineTo(outer, last.y2)
      ..lineTo(outer, size.y + 50)
      ..close();
  }

  /// Draws the valley, the rock face and the guardrail or lip of one segment.
  void _segment(Canvas canvas, VisionSeg vision, double side, Vector2 size) {
    final outer = side < 0 ? -50.0 : size.x + 50;
    final x1 = vision.x1 + side * vision.w1 * _edge;
    final x2 = vision.x2 + side * vision.w2 * _edge;
    final drop1 = vision.w1 * _drop;
    final drop2 = vision.w2 * _drop;
    final fog = vision.fog;

    drawQuad(canvas, _path, fogged(_valley, fog), x1, vision.y1 + drop1, outer,
        vision.y1 + drop1, outer, vision.y2, x2, vision.y2);
    if (fog < _detailFog) _treetops(canvas, vision, side, x1, drop1);
    final ramp = (vision.seg.index ~/ 3).isEven ? _face : _faceAlt;
    drawQuad(canvas, _path, fogged(ramp, fog), x1, vision.y1, x2, vision.y2, x2,
        vision.y2 + drop2, x1, vision.y1 + drop1);

    if (_kind(vision, side) == VergeKind.ledge) {
      _lipOver(canvas, vision, side, x1, x2);
    } else if (fog < _detailFog) {
      _guardrail(canvas, vision, side, x1, x2);
    }
  }

  /// Draws a few treetops far below the edge.
  void _treetops(Canvas canvas, VisionSeg vision, double side, double edgeX, double drop) {
    final seed = vision.seg.index * 5 + 1;
    for (var top = 0; top < 3; top++) {
      final across = 0.7 + 3.2 * pseudoRandom(seed + top * 3);
      final x = edgeX + side * across * vision.w1;
      final y = vision.y1 + drop * (0.85 + 0.6 * pseudoRandom(seed + top * 3 + 1));
      final radius = vision.w1 * (0.3 + 0.3 * pseudoRandom(seed + top * 3 + 2));
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x, y), width: radius * 2.4, height: radius * 1.4),
        fogged(top.isEven ? _treetop : _treetopLight, vision.fog),
      );
    }
  }

  /// Draws the grassy lip along a ledge, as on a coast road.
  void _lipOver(Canvas canvas, VisionSeg vision, double side, double x1, double x2) {
    final out1 = x1 + side * vision.w1 * _lipWidth;
    final out2 = x2 + side * vision.w2 * _lipWidth;
    drawQuad(canvas, _path, fogged(_lip, vision.fog), x1, vision.y1, x2, vision.y2, out2,
        vision.y2, out1, vision.y1);
  }

  /// Draws a steel guardrail on posts along the edge of the drop.
  void _guardrail(Canvas canvas, VisionSeg vision, double side, double x1, double x2) {
    final top1 = vision.y1 - vision.w1 * 0.2, low1 = vision.y1 - vision.w1 * 0.14;
    final top2 = vision.y2 - vision.w2 * 0.2, low2 = vision.y2 - vision.w2 * 0.14;
    drawQuad(canvas, _path, fogged(_rail, vision.fog), x1, top1, x2, top2, x2, low2, x1, low1);
    if (vision.seg.index % 4 != 0) return;
    final half = math.max(0.8, vision.w1 * 0.012);
    drawQuad(canvas, _path, fogged(_post, vision.fog), x1 - half, vision.y1, x1 + half,
        vision.y1, x1 + half, top1, x1 - half, top1);
  }
}
