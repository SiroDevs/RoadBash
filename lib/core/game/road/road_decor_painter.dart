// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import '../utils/paint_utils.dart';
import 'road_config.dart';
import 'road_projection.dart';
import 'road_props.dart';
import 'road_theme.dart';

/// Draws the scenery the track laid out. Every prop is a fixed object in the
/// world, so this only ever projects it — nothing about a building or a tree
/// is decided here, which is what keeps them from flickering as you pass.
class RoadDecorPainter {
  RoadDecorPainter(this.theme)
      : _wallSide = [
          for (final c in theme.wallColors) fogRamp(c, theme.fog)
        ],
        _wallFront = [
          for (final c in theme.wallColors)
            fogRamp(shade(c, -0.22), theme.fog)
        ],
        _parapet = fogRamp(theme.roofColor, theme.fog),
        _window = fogRamp(theme.windowColor, theme.fog),
        _leafDark = fogRamp(theme.treeDark, theme.fog, antiAlias: true),
        _leafLight = fogRamp(theme.treeLight, theme.fog, antiAlias: true),
        _trunk = fogRamp(theme.trunk, theme.fog),
        _pole = fogRamp(theme.poleColor, theme.fog),
        _signFace = fogRamp(const Color(0xFFE8E4D8), theme.fog),
        _signInk = fogRamp(const Color(0xFF2E3238), theme.fog),
        _shadow = fogRamp(const Color(0x3A000000), theme.fog, antiAlias: true);

  final SceneTheme theme;
  final List<List<Paint>> _wallSide, _wallFront;
  final List<Paint> _parapet, _window, _leafDark, _leafLight, _trunk;
  final List<Paint> _pole, _signFace, _signInk, _shadow;

  final Path _path = Path();
  final Path _grid = Path();
  final SpanPoint _a = SpanPoint();
  final SpanPoint _b = SpanPoint();

  /// Windows stop being resolvable well before the building does.
  static const double _windowCutoff = 0.55;
  static const double _minWindowPixels = 46;

  // --------------------------------------------------------------- buildings

  void drawBox(Canvas c, VisSeg near, VisSeg far, Prop p, Vector2 size) {
    final cx = size.x / 2;
    final horizonY = size.y * RoadConfig.horizonRatio;
    final outer = p.offset + p.width / RoadConfig.roadWidth;

    final xi1 = near.x1 + p.side * near.w1 * p.offset;
    final xo1 = near.x1 + p.side * near.w1 * outer;
    final xi2 = far.x1 + p.side * far.w1 * p.offset;
    final xo2 = far.x1 + p.side * far.w1 * outer;

    final lo = math.min(math.min(xi1, xo1), math.min(xi2, xo2));
    final hi = math.max(math.max(xi1, xo1), math.max(xi2, xo2));
    if (hi < 0 || lo > size.x) return;

    final t1 = near.y1 - p.height * near.k1;
    final t2 = far.y1 - p.height * far.k1;

    c.save();
    c.clipRect(Rect.fromLTRB(0, 0, size.x, near.clip));

    final tint = p.tint % _wallSide.length;
    // The long face catches the light; the end facing the rider is in shade.
    drawQuad(c, _path, fogged(_wallSide[tint], far.fog), xi1, near.y1, xi2,
        far.y1, xi2, t2, xi1, t1);
    drawQuad(c, _path, fogged(_wallFront[tint], near.fog), xi1, near.y1, xo1,
        near.y1, xo1, t1, xi1, t1);

    final cap = p.height * 0.035;
    drawQuad(c, _path, fogged(_parapet, far.fog), xi1, t1, xi2, t2, xi2,
        t2 - cap * far.k1, xi1, t1 - cap * near.k1);

    if (near.fog < _windowCutoff && (near.y1 - t1) > _minWindowPixels) {
      _windows(c, near, far, p, cx, horizonY);
    }
    c.restore();
  }

  /// A grid of lit panes on the long face, stepped along the building in
  /// world depth so the rows converge with the building instead of sliding.
  void _windows(Canvas c, VisSeg near, VisSeg far, Prop p, double cx,
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

  /// Road half-width in pixels at the depth whose vertical scale is [k].
  /// Both scale with 1/z, so the ratio is fixed along the span.
  double _spanHalfWidth(VisSeg near, VisSeg far, double k) =>
      k * (near.w1 / near.k1);

  // -------------------------------------------------------------- billboards

  void drawBillboard(Canvas c, VisSeg v, Prop p, Vector2 size) {
    final px = v.w1 / RoadConfig.roadWidth;
    final halfW = p.width * px;
    final x = v.x1 + p.side * v.w1 * p.offset;
    if (x + halfW * 2 < 0 || x - halfW * 2 > size.x) return;

    final y = v.y1;
    final h = p.height * v.k1;
    if (h < 1.5) return;

    c.save();
    c.clipRect(Rect.fromLTRB(0, 0, size.x, v.clip));
    switch (p.kind) {
      case PropKind.broadleaf:
        _broadleaf(c, v, x, y, halfW, h);
      case PropKind.pine:
        _pine(c, v, x, y, halfW, h);
      case PropKind.bush:
        _bush(c, v, x, y, halfW, h);
      case PropKind.lamp:
        _lamp(c, v, x, y, halfW, h, p.side);
      case PropKind.sign:
        _sign(c, v, x, y, halfW, h);
      case PropKind.building:
        break;
    }
    c.restore();
  }

  void _contact(Canvas c, VisSeg v, double x, double y, double r) {
    if (r < 1.2) return;
    c.drawOval(
        Rect.fromCenter(center: Offset(x, y), width: r * 2.1, height: r * 0.62),
        fogged(_shadow, v.fog));
  }

  void _broadleaf(Canvas c, VisSeg v, double x, double y, double w, double h) {
    _contact(c, v, x, y, w * 0.9);
    final trunkW = math.max(1.0, w * 0.17);
    final trunkTop = y - h * 0.42;
    c.drawRect(Rect.fromLTRB(x - trunkW, trunkTop, x + trunkW, y + 1),
        fogged(_trunk, v.fog));

    final crownY = y - h * 0.68;
    c.drawOval(
        Rect.fromCenter(
            center: Offset(x, crownY), width: w * 2, height: h * 0.62),
        fogged(_leafDark, v.fog));
    c.drawOval(
        Rect.fromCenter(
            center: Offset(x - w * 0.26, crownY - h * 0.1),
            width: w * 1.25,
            height: h * 0.36),
        fogged(_leafLight, v.fog));
  }

  void _pine(Canvas c, VisSeg v, double x, double y, double w, double h) {
    _contact(c, v, x, y, w * 0.7);
    final trunkW = math.max(1.0, w * 0.13);
    c.drawRect(Rect.fromLTRB(x - trunkW, y - h * 0.22, x + trunkW, y + 1),
        fogged(_trunk, v.fog));

    _path.reset();
    for (var tier = 0; tier < 3; tier++) {
      final base = y - h * (0.18 + tier * 0.26);
      final tip = base - h * 0.42;
      final half = w * (1.0 - tier * 0.24);
      _path
        ..moveTo(x, tip)
        ..lineTo(x + half, base)
        ..lineTo(x - half, base)
        ..close();
    }
    c.drawPath(_path, fogged(_leafDark, v.fog));

    _path.reset();
    _path
      ..moveTo(x, y - h)
      ..lineTo(x + w * 0.3, y - h * 0.74)
      ..lineTo(x - w * 0.3, y - h * 0.74)
      ..close();
    c.drawPath(_path, fogged(_leafLight, v.fog));
  }

  void _bush(Canvas c, VisSeg v, double x, double y, double w, double h) {
    _contact(c, v, x, y, w * 0.8);
    c.drawOval(
        Rect.fromCenter(
            center: Offset(x, y - h * 0.42), width: w * 2, height: h * 0.9),
        fogged(_leafDark, v.fog));
    c.drawOval(
        Rect.fromCenter(
            center: Offset(x - w * 0.3, y - h * 0.58),
            width: w * 1.1,
            height: h * 0.45),
        fogged(_leafLight, v.fog));
  }

  void _lamp(
      Canvas c, VisSeg v, double x, double y, double w, double h, int side) {
    final poleW = math.max(1.0, w * 0.35);
    final paint = fogged(_pole, v.fog);
    c.drawRect(Rect.fromLTRB(x - poleW, y - h, x + poleW, y + 1), paint);
    // Arm reaching out over the road.
    final reach = -side * w * 5;
    c.drawRect(
        Rect.fromLTRB(math.min(x, x + reach), y - h,
            math.max(x, x + reach), y - h + poleW * 2.2),
        paint);
    c.drawRect(
        Rect.fromLTRB(x + reach - poleW * 1.6, y - h + poleW * 2.2,
            x + reach + poleW * 1.6, y - h + poleW * 4.4),
        fogged(_signFace, v.fog));
  }

  void _sign(Canvas c, VisSeg v, double x, double y, double w, double h) {
    final poleW = math.max(1.0, w * 0.17);
    c.drawRect(
        Rect.fromLTRB(x - poleW, y - h, x + poleW, y + 1), fogged(_pole, v.fog));
    final plate = Rect.fromLTRB(x - w, y - h, x + w, y - h + w * 2.1);
    c.drawRect(plate, fogged(_signFace, v.fog));
    c.drawRect(plate.deflate(math.max(0.6, w * 0.16)), fogged(_signInk, v.fog));
  }
}
