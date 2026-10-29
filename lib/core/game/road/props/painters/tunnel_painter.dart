// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import '../../../utils/paint_utils.dart';
import '../../road_projection.dart';
import '../../scene_theme.dart';
import '../prop.dart';

/// Paints tunnels over the road.
class TunnelPainter {
  TunnelPainter(SceneTheme theme)
      : _ceiling = fogRamp(const Color(0xFF34363A), theme.fog),
        _slab = fogRamp(const Color(0xFF8E908F), theme.fog),
        _light = fogRamp(const Color(0xFFFFE9A8), theme.fog);

  final List<Paint> _ceiling, _slab, _light;
  final Path _path = Path();

  static const double _reach = 1.14;
  static const double _slabThickness = 420;

  /// Draws a tunnel between two segments.
  void draw(Canvas canvas, VisionSeg near, VisionSeg far, Prop prop, Vector2 size) {
    final l1 = near.x1 - near.w1 * _reach, r1 = near.x1 + near.w1 * _reach;
    final l2 = far.x1 - far.w1 * _reach, r2 = far.x1 + far.w1 * _reach;
    final t1 = near.y1 - prop.height * near.k1;
    final t2 = far.y1 - prop.height * far.k1;

    canvas.save();
    canvas.clipRect(Rect.fromLTRB(0, 0, size.x, near.clip));

    drawQuad(canvas, _path, fogged(_ceiling, far.fog), l1, t1, r1, t1, r2, t2, l2, t2);

    if (prop.detail > 0 && near.fog < 0.85) {
      final mid1 = near.x1, mid2 = far.x1;
      final hw1 = near.w1 * 0.05, hw2 = far.w1 * 0.05;
      drawQuad(canvas, _path, fogged(_light, near.fog), mid1 - hw1, t1, mid1 + hw1,
          t1, mid2 + hw2, t2, mid2 - hw2, t2);
    }

    final th = _slabThickness * near.k1;
    drawQuad(canvas, _path, fogged(_slab, near.fog), l1, t1, r1, t1, r1, t1 - th,
        l1, t1 - th);
    canvas.restore();
  }
}
