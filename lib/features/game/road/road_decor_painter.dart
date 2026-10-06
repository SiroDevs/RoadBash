// Dart imports:
import 'dart:ui';

// Project imports:
import '../utils/paint_utils.dart';
import '../utils/pseudo_random.dart';
import 'road_config.dart';
import 'road_projection.dart';
import 'road_theme.dart';

/// Roadside scenery for one segment: building walls (city) or trees
/// (suburbs). Called far-to-near so nearer objects cover farther ones.
class RoadDecorPainter {
  RoadDecorPainter(this.theme)
      : _walls = [for (final c in theme.wallColors) fillPaint(c)],
        _window = fillPaint(theme.windowColor),
        _leafDark = fillPaint(theme.treeDark),
        _leafLight = fillPaint(theme.treeLight),
        _trunk = fillPaint(theme.trunk);

  final SceneTheme theme;
  final List<Paint> _walls;
  final Paint _window, _leafDark, _leafLight, _trunk;
  final Path _path = Path();

  void draw(Canvas c, VisSeg v, double screenW) {
    c.save();
    c.clipRect(Rect.fromLTRB(0, 0, screenW, v.clip));
    for (final side in const [-1, 1]) {
      if (theme.decor == DecorKind.buildings) {
        _wall(c, v, side);
      } else {
        _tree(c, v, side);
      }
    }
    c.restore();
  }

  void _wall(Canvas c, VisSeg v, int side) {
    final block = v.seg.index ~/ 10;
    final key = block * 2 + (side > 0 ? 1 : 0);
    if (pseudoRandom(key * 3 + 1) < 0.12) return;

    const off = 1.25;
    final h = 2400 + 3600 * pseudoRandom(key);
    final xa = v.x1 + side * v.w1 * off;
    final xb = v.x2 + side * v.w2 * off;
    drawQuad(c, _path, _walls[key % _walls.length], xa, v.y1, xb, v.y2, xb,
        v.y2 - h * v.k2, xa, v.y1 - h * v.k1);

    if ((v.seg.index ~/ 2).isEven && pseudoRandom(key * 7 + 2) > 0.25) {
      _band(c, v, xa, xb, h, 0.08, 0.44);
      _band(c, v, xa, xb, h, 0.54, 0.90);
    }
  }

  void _band(Canvas c, VisSeg v, double xa, double xb, double h, double f0,
      double f1) {
    drawQuad(c, _path, _window, xa, v.y1 - h * f0 * v.k1, xb,
        v.y2 - h * f0 * v.k2, xb, v.y2 - h * f1 * v.k2, xa,
        v.y1 - h * f1 * v.k1);
  }

  void _tree(Canvas c, VisSeg v, int side) {
    final i = v.seg.index;
    if (i % 4 != (side > 0 ? 0 : 2)) return;
    if (pseudoRandom(i * 2 + side + 5) < 0.3) return;

    final off = 1.5 + 2.4 * pseudoRandom(i * 5 + side);
    final s = 0.75 + 0.7 * pseudoRandom(i + 11);
    final x = v.x1 + side * v.w1 * off;
    final y = v.y1;
    final px = v.w1 / RoadConfig.roadWidth;

    final trunkW = 110 * s * px, trunkH = 650 * s * v.k1;
    final rx = 560 * s * px, ry = 700 * s * v.k1;
    c.drawRect(
        Rect.fromLTWH(x - trunkW / 2, y - trunkH, trunkW, trunkH), _trunk);

    if (pseudoRandom(i * 3 + 1) < 0.55) {
      c.drawOval(
          Rect.fromCenter(
              center: Offset(x, y - trunkH - ry * 0.55),
              width: rx * 2,
              height: ry * 1.4),
          _leafDark);
      c.drawOval(
          Rect.fromCenter(
              center: Offset(x - rx * 0.2, y - trunkH - ry * 0.75),
              width: rx * 1.3,
              height: ry * 0.9),
          _leafLight);
    } else {
      _path
        ..reset()
        ..moveTo(x, y - trunkH - ry * 2.0)
        ..lineTo(x + rx * 0.8, y - trunkH * 0.7)
        ..lineTo(x - rx * 0.8, y - trunkH * 0.7)
        ..close();
      c.drawPath(_path, _leafDark);
    }
  }
}
