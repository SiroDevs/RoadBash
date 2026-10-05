// Dart imports:
import 'dart:ui';

// Project imports:
import 'road_config.dart';
import 'road_projection.dart';
import 'road_theme.dart';

/// Roadside scenery for one segment: building walls (city) or trees
/// (suburbs). Called far-to-near so nearer objects cover farther ones.
class RoadDecorPainter {
  RoadDecorPainter(this.theme)
      : _walls = [for (final c in theme.wallColors) Paint()..color = c],
        _window = Paint()..color = theme.windowColor,
        _leafDark = Paint()..color = theme.treeDark,
        _leafLight = Paint()..color = theme.treeLight,
        _trunk = Paint()..color = theme.trunk;

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

  // ---- City: slabs of building facade with window bands -------------------
  void _wall(Canvas c, VisSeg v, int side) {
    final block = v.seg.index ~/ 10;
    final key = block * 2 + (side > 0 ? 1 : 0);
    if (roadRand(key * 3 + 1) < 0.12) return; // gap between buildings

    const off = 1.25; // wall distance, in half-road-widths
    final h = 2400 + 3600 * roadRand(key); // world height
    final xa = v.x1 + side * v.w1 * off;
    final xb = v.x2 + side * v.w2 * off;
    _path
      ..reset()
      ..moveTo(xa, v.y1)
      ..lineTo(xb, v.y2)
      ..lineTo(xb, v.y2 - h * v.k2)
      ..lineTo(xa, v.y1 - h * v.k1)
      ..close();
    c.drawPath(_path, _walls[key % _walls.length]);

    if ((v.seg.index ~/ 2).isEven && roadRand(key * 7 + 2) > 0.25) {
      _band(c, v, xa, xb, h, 0.08, 0.44);
      _band(c, v, xa, xb, h, 0.54, 0.90);
    }
  }

  void _band(Canvas c, VisSeg v, double xa, double xb, double h, double f0,
      double f1) {
    _path
      ..reset()
      ..moveTo(xa, v.y1 - h * f0 * v.k1)
      ..lineTo(xb, v.y2 - h * f0 * v.k2)
      ..lineTo(xb, v.y2 - h * f1 * v.k2)
      ..lineTo(xa, v.y1 - h * f1 * v.k1)
      ..close();
    c.drawPath(_path, _window);
  }

  // ---- Suburbs: round trees and pines --------------------------------------
  void _tree(Canvas c, VisSeg v, int side) {
    final i = v.seg.index;
    if (i % 4 != (side > 0 ? 0 : 2)) return; // stagger left / right
    if (roadRand(i * 2 + side + 5) < 0.3) return;

    final off = 1.5 + 2.4 * roadRand(i * 5 + side);
    final s = 0.75 + 0.7 * roadRand(i + 11);
    final x = v.x1 + side * v.w1 * off;
    final y = v.y1;
    final px = v.w1 / RoadConfig.roadWidth; // px per world unit, sideways

    final trunkW = 110 * s * px, trunkH = 650 * s * v.k1;
    final rx = 560 * s * px, ry = 700 * s * v.k1;
    c.drawRect(
        Rect.fromLTWH(x - trunkW / 2, y - trunkH, trunkW, trunkH), _trunk);

    if (roadRand(i * 3 + 1) < 0.55) {
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
