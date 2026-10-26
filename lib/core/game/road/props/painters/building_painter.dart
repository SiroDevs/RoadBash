// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import '../../../utils/paint_utils.dart';
import '../../config/road_config.dart';
import '../../road_projection.dart';
import '../../scene_theme.dart';
import '../prop.dart';
import 'box_frame.dart';

class BuildingPainter {
  BuildingPainter(SceneTheme theme)
      : _wallSide = [
          for (final c in theme.wallColors) fogRamp(c, theme.fog)
        ],
        _wallFront = [
          for (final c in theme.wallColors)
            fogRamp(shade(c, -0.22), theme.fog)
        ],
        _parapet = fogRamp(theme.roofColor, theme.fog),
        _window = fogRamp(theme.windowColor, theme.fog);

  final List<List<Paint>> _wallSide, _wallFront;
  final List<Paint> _parapet, _window;

  final Path _path = Path();
  final Path _grid = Path();
  final SpanPoint _a = SpanPoint();
  final SpanPoint _b = SpanPoint();

  static const double _windowCutoff = 0.55;
  static const double _minWindowPixels = 46;

  void draw(Canvas c, VisionSeg near, VisionSeg far, Prop p, Vector2 size) {
    final cx = size.x / 2;
    final horizonY = size.y * RoadConfig.horizonRatio;

    final box = BoxFrame(near, far, p, size);
    if (!box.visible) return;
    final xi1 = box.xi1, xo1 = box.xo1, xi2 = box.xi2;
    final t1 = box.top1, t2 = box.top2;

    c.save();
    c.clipRect(Rect.fromLTRB(0, 0, size.x, near.clip));

    final tint = p.tint % _wallSide.length;
    // Faces
    drawQuad(c, _path, fogged(_wallSide[tint], far.fog), xi1, box.base1, xi2,
        box.base2, xi2, t2, xi1, t1);
    drawQuad(c, _path, fogged(_wallFront[tint], near.fog), xi1, box.base1, xo1,
        box.base1, xo1, t1, xi1, t1);

    // Parapet
    final cap = p.height * 0.035;
    drawQuad(c, _path, fogged(_parapet, far.fog), xi1, t1, xi2, t2, xi2,
        t2 - cap * far.k1, xi1, t1 - cap * near.k1);

    // Windows
    if (near.fog < _windowCutoff && (near.y1 - t1) > _minWindowPixels) {
      _windows(c, near, far, p, cx, horizonY);
    }
    c.restore();
  }

  void _windows(Canvas c, VisionSeg near, VisionSeg far, Prop p, double cx,
      double horizonY) {
    final storeys = p.detail.round().clamp(2, 10);
    final cols = (p.depth ~/ 3).clamp(2, 8);
    _grid.reset();

    for (var col = 0; col < cols; col++) {
      _a.lerp(near, far, (col + 0.2) / cols, cx, horizonY);
      _b.lerp(near, far, (col + 0.8) / cols, cx, horizonY);
      final xa = _a.x + p.side * _spanHalfWidth(near, far, _a.k) * p.offset;
      final xb = _b.x + p.side * _spanHalfWidth(near, far, _b.k) * p.offset;

      for (var row = 0; row < storeys; row++) {
        final f0 = (row + 0.28) / storeys, f1 = (row + 0.76) / storeys;
        addQuad(
          _grid,
          xa, _a.y - p.height * f0 * _a.k,
          xb, _b.y - p.height * f0 * _b.k,
          xb, _b.y - p.height * f1 * _b.k,
          xa, _a.y - p.height * f1 * _a.k,
        );
      }
    }
    c.drawPath(_grid, fogged(_window, near.fog));
  }

  double _spanHalfWidth(VisionSeg near, VisionSeg far, double k) =>
      k * (near.w1 / near.k1);
}
