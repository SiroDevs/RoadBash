// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../../utils/paint_utils.dart';
import '../../road_projection.dart';
import '../../scene_theme.dart';
import '../prop.dart';

class TreePainter {
  TreePainter(SceneTheme theme)
      : _leafDark = fogRamp(theme.treeDark, theme.fog, antiAlias: true),
        _leafLight = fogRamp(theme.treeLight, theme.fog, antiAlias: true),
        _trunk = fogRamp(theme.trunk, theme.fog),
        _shadow = fogRamp(const Color(0x3A000000), theme.fog, antiAlias: true);

  final List<Paint> _leafDark, _leafLight, _trunk, _shadow;
  final Path _path = Path();

  void draw(Canvas c, VisionSeg v, Prop p, double x, double y, double w,
      double h) {
    switch (p.kind) {
      case PropKind.broadleaf:
        _broadleaf(c, v, x, y, w, h);
      case PropKind.pine:
        _pine(c, v, x, y, w, h);
      case PropKind.bush:
        _bush(c, v, x, y, w, h);
      case PropKind.acacia:
        _acacia(c, v, x, y, w, h);
      default:
        break;
    }
  }

  void _contact(Canvas c, VisionSeg v, double x, double y, double r) {
    if (r < 1.2) return;
    c.drawOval(
        Rect.fromCenter(center: Offset(x, y), width: r * 2.1, height: r * 0.62),
        fogged(_shadow, v.fog));
  }

  void _broadleaf(Canvas c, VisionSeg v, double x, double y, double w, double h) {
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

  void _pine(Canvas c, VisionSeg v, double x, double y, double w, double h) {
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

  void _acacia(Canvas c, VisionSeg v, double x, double y, double w, double h) {
    _contact(c, v, x, y, w * 0.8);
    final trunkW = math.max(1.0, w * 0.1);
    c.drawRect(Rect.fromLTRB(x - trunkW, y - h * 0.6, x + trunkW, y + 1),
        fogged(_trunk, v.fog));
    c.drawOval(
        Rect.fromCenter(
            center: Offset(x, y - h * 0.68), width: w * 2.4, height: h * 0.3),
        fogged(_leafDark, v.fog));
    c.drawOval(
        Rect.fromCenter(
            center: Offset(x - w * 0.2, y - h * 0.74),
            width: w * 1.5,
            height: h * 0.16),
        fogged(_leafLight, v.fog));
  }

  void _bush(Canvas c, VisionSeg v, double x, double y, double w, double h) {
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
}
