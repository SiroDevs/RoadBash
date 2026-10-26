// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../../utils/paint_utils.dart';
import '../../projection/road_projection.dart';
import '../../scene/scene_theme.dart';
import '../prop.dart';

class StreetFurniturePainter {
  StreetFurniturePainter(SceneTheme theme)
      : _pole = fogRamp(theme.poleColor, theme.fog),
        _signFace = fogRamp(const Color(0xFFE8E4D8), theme.fog),
        _signInk = fogRamp(const Color(0xFF2E3238), theme.fog);

  final List<Paint> _pole, _signFace, _signInk;

  void draw(Canvas c, VisionSeg v, Prop p, double x, double y, double w,
      double h) {
    switch (p.kind) {
      case PropKind.lamp:
        _lamp(c, v, x, y, w, h, p.side);
      case PropKind.sign:
        _sign(c, v, x, y, w, h);
      default:
        break;
    }
  }

  void _lamp(
      Canvas c, VisionSeg v, double x, double y, double w, double h, int side) {
    final poleW = math.max(1.0, w * 0.35);
    final paint = fogged(_pole, v.fog);
    c.drawRect(Rect.fromLTRB(x - poleW, y - h, x + poleW, y + 1), paint);
    // Arm over the road
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

  void _sign(Canvas c, VisionSeg v, double x, double y, double w, double h) {
    final poleW = math.max(1.0, w * 0.17);
    c.drawRect(
        Rect.fromLTRB(x - poleW, y - h, x + poleW, y + 1), fogged(_pole, v.fog));
    final plate = Rect.fromLTRB(x - w, y - h, x + w, y - h + w * 2.1);
    c.drawRect(plate, fogged(_signFace, v.fog));
    c.drawRect(plate.deflate(math.max(0.6, w * 0.16)), fogged(_signInk, v.fog));
  }
}
