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

/// Paints the steep mountain side that rises beside the jungle road.
class MountainPainter {
  MountainPainter(SceneTheme theme)
    : _rock = [
        for (final c in _rocks) fogRamp(c, theme.fog),
      ],
      _front = fogRamp(const Color(0xFF3B342D), theme.fog),
      _strata = fogRamp(const Color(0xFF4C4338), theme.fog),
      _forest = fogRamp(theme.treeDark, theme.fog),
      _leaf = fogRamp(theme.treeLight, theme.fog);

  static const List<Color> _rocks = [
    Color(0xFF6B5E4F),
    Color(0xFF5C5246),
    Color(0xFF75685A),
  ];

  final List<List<Paint>> _rock;
  final List<Paint> _front, _strata, _forest, _leaf;
  final Path _path = Path();

  /// Draws a stretch of mountain side between two segments.
  void draw(Canvas canvas, VisionSeg near, VisionSeg far, Prop prop, Vector2 size) {
    final box = BoxFrame(near, far, prop, size);
    if (!box.visible) return;
    canvas
      ..save()
      ..clipRect(Rect.fromLTRB(0, 0, size.x, near.clip));

    drawQuad(canvas, _path, fogged(_rock[prop.tint % _rock.length], far.fog), box.xi1,
        box.base1, box.xi2, box.base2, box.xi2, box.top2, box.xi1, box.top1);
    drawQuad(canvas, _path, fogged(_front, near.fog), box.xi1, box.base1, box.xo1,
        box.base1, box.xo1, box.top1, box.xi1, box.top1);
    _band(canvas, box, _strata, far.fog, 0.22, 0.27);
    _band(canvas, box, _strata, far.fog, 0.48, 0.53);
    _band(canvas, box, _forest, far.fog, 0.0, 0.12);
    _band(canvas, box, _leaf, far.fog, 0.1, 0.16);
    _band(canvas, box, _forest, far.fog, 0.84, 1.0);
    canvas.restore();
  }

  /// Paints a horizontal band of the mountain face between two height
  /// fractions.
  void _band(Canvas canvas, BoxFrame box, List<Paint> ramp, double fog, double f0, double f1) {
    double y(double base, double top, double f) => base + (top - base) * f;
    drawQuad(canvas, _path, fogged(ramp, fog), box.xi1, y(box.base1, box.top1, f0), box.xi2,
        y(box.base2, box.top2, f0), box.xi2, y(box.base2, box.top2, f1), box.xi1,
        y(box.base1, box.top1, f1));
  }
}
