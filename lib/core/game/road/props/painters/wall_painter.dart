// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import '../../../utils/paint_utils.dart';
import '../../road_projection.dart';
import '../../scene_theme.dart';
import '../prop.dart';
import '../wall_style.dart';
import 'box_frame.dart';

class WallPainter {
  WallPainter(SceneTheme theme)
      : _face = [
          for (final c in _faces) fogRamp(c, theme.fog),
        ],
        _end = [
          for (final c in _faces) fogRamp(shade(c, -0.25), theme.fog),
        ],
        _cap = [
          for (final c in _faces) fogRamp(shade(c, 0.18), theme.fog),
        ],
        _strata = fogRamp(const Color(0xFF7A4A33), theme.fog);

  static const List<Color> _faces = [
    Color(0xFFA39B8C),
    Color(0xFF9A9A96),
    Color(0xFFB2744F),
    Color(0xFFE9E6DC),
    Color(0xFF8E908F),
    Color(0xFF3F6FA8),
  ];

  final List<List<Paint>> _face, _end, _cap;
  final List<Paint> _strata;
  final Path _path = Path();

  void draw(Canvas canvas, VisionSeg near, VisionSeg far, Prop prop, Vector2 size) {
    final box = BoxFrame(near, far, prop, size);
    if (!box.visible) return;
    final style = prop.tint % _face.length;

    canvas.save();
    canvas.clipRect(Rect.fromLTRB(0, 0, size.x, near.clip));

    drawQuad(canvas, _path, fogged(_face[style], far.fog), box.xi1, box.base1, box.xi2,
        box.base2, box.xi2, box.top2, box.xi1, box.top1);
    drawQuad(canvas, _path, fogged(_end[style], near.fog), box.xi1, box.base1, box.xo1,
        box.base1, box.xo1, box.top1, box.xi1, box.top1);
    final cap = prop.height * 0.04;
    drawQuad(canvas, _path, fogged(_cap[style], far.fog), box.xi1, box.top1, box.xi2,
        box.top2, box.xi2, box.top2 - cap * far.k1, box.xi1,
        box.top1 - cap * near.k1);

    if (prop.tint == WallStyle.rock.index && near.fog < 0.7) {
      _path.reset();
      for (final f in const [0.3, 0.55, 0.8]) {
        final a1 = near.y1 - prop.height * f * near.k1;
        final a2 = far.y1 - prop.height * f * far.k1;
        final th = prop.height * 0.05;
        addQuad(_path, box.xi1, a1, box.xi2, a2, box.xi2,
            a2 - th * far.k1, box.xi1, a1 - th * near.k1);
      }
      canvas.drawPath(_path, fogged(_strata, near.fog));
    }
    canvas.restore();
  }
}
