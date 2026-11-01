// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart' show Vector2;

// Project imports:
import '../../utils/paint_utils.dart';
import '../config/road_config.dart';
import '../road_projection.dart';
import '../scene_theme.dart';
import '../track/road_section.dart';

/// Paints cliff edges beside the road: a rock face dropping away to a valley.
class CliffPainter {
  CliffPainter(SceneTheme theme)
    : _valley = fogRamp(const Color(0xFF1E4631), theme.fog),
      _face = fogRamp(const Color(0xFF4A3F33), theme.fog),
      _faceAlt = fogRamp(const Color(0xFF5A4D3E), theme.fog),
      _lip = fogRamp(const Color(0xFF8A7A62), theme.fog);

  static const double _edge = 1 + RoadConfig.shoulder;
  static const double _drop = 0.55;
  static const double _skipFog = 0.95;

  final List<Paint> _valley, _face, _faceAlt, _lip;
  final Path _path = Path();
  final Path _clip = Path();

  /// Draws the cliffs of the segments in [visions] (near to far), from the far
  /// end back, kept to the ground outside the road.
  void draw(Canvas canvas, List<VisionSeg> visions, int count, Vector2 size) {
    for (final side in const [-1.0, 1.0]) {
      if (!_hasCliff(visions, count, side)) continue;
      _clipOutside(visions, count, side, size);
      canvas
        ..save()
        ..clipPath(_clip);
      for (var index = count - 1; index >= 0; index--) {
        final vision = visions[index];
        if (_isCliff(vision, side) && vision.fog < _skipFog) {
          _segment(canvas, vision, side, size);
        }
      }
      canvas.restore();
    }
  }

  bool _isCliff(VisionSeg vision, double side) {
    final section = vision.seg.section;
    return (side < 0 ? section.left : section.right) == VergeKind.cliff;
  }

  bool _hasCliff(List<VisionSeg> visions, int count, double side) {
    for (var index = 0; index < count; index++) {
      if (_isCliff(visions[index], side)) return true;
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

  /// Draws the valley and the rock face of one segment.
  void _segment(Canvas canvas, VisionSeg vision, double side, Vector2 size) {
    final outer = side < 0 ? -50.0 : size.x + 50;
    final x1 = vision.x1 + side * vision.w1 * _edge;
    final x2 = vision.x2 + side * vision.w2 * _edge;
    final drop1 = vision.w1 * _drop;
    final drop2 = vision.w2 * _drop;
    final fog = vision.fog;

    drawQuad(canvas, _path, fogged(_valley, fog), x1, vision.y1 + drop1, outer,
        vision.y1 + drop1, outer, vision.y2, x2, vision.y2);
    final ramp = (vision.seg.index ~/ 4).isEven ? _face : _faceAlt;
    drawQuad(canvas, _path, fogged(ramp, fog), x1, vision.y1, x2, vision.y2, x2,
        vision.y2 + drop2, x1, vision.y1 + drop1);
    drawQuad(canvas, _path, fogged(_lip, fog), x1, vision.y1, x2, vision.y2,
        x2 - side * vision.w2 * 0.05, vision.y2, x1 - side * vision.w1 * 0.05, vision.y1);
  }
}
