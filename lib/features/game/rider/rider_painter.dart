// Dart imports:
import 'dart:ui';

// Project imports:
import '../utils/paint_utils.dart';
import 'rider_pose.dart';

/// Bike and rider from behind, in a 100 x 140 design box.
class RiderPainter {
  static const double width = 100;
  static const double height = 140;

  final Paint _paint = Paint();

  void _fill(Canvas c, double l, double t, double r, double b, int argb,
      [double rad = 4]) {
    _paint
      ..style = PaintingStyle.fill
      ..color = Color(argb);
    c.drawRRect(RRect.fromLTRBR(l, t, r, b, Radius.circular(rad)), _paint);
  }

  void _line(Canvas c, Offset a, Offset b, double w, int argb) {
    _paint
      ..color = Color(argb)
      ..strokeWidth = w
      ..strokeCap = StrokeCap.round;
    c.drawLine(a, b, _paint);
  }

  void _circle(Canvas c, Offset at, double r, int argb) {
    _paint
      ..style = PaintingStyle.fill
      ..color = Color(argb);
    c.drawCircle(at, r, _paint);
  }

  void paint(Canvas c, RiderPose p) {
    c.drawOval(const Rect.fromLTWH(14, 128, 72, 14),
        fillPaint(const Color(0x59000000)));

    c.save();
    c.translate(50 + p.shake, 138);
    c.rotate(p.lean);
    c.translate(-50, -138 + p.bob);

    _tyre(c, p.phase);
    _fill(c, 26, 100, 36, 124, 0xFF9A9A9A);
    _fill(c, 64, 100, 74, 124, 0xFF9A9A9A);
    _fill(c, 35, 70, 65, 98, 0xFFD6252B, 8);
    _fill(c, 43, 90, 57, 95, p.braking ? 0xFFFF2020 : 0xFFFF8A80, 2);

    _leftLeg(c, p.foot);
    _fill(c, 57, 58, 71, 102, 0xFF1F3A5F, 6);

    _fill(c, 32, 22, 68, 78, 0xFFF2A900, 10);
    _fill(c, 47, 24, 53, 76, 0xFF2B2B2B, 3);

    _line(c, const Offset(37, 36), const Offset(15, 30), 9, 0xFFF2A900);
    _line(c, const Offset(63, 36), const Offset(85, 30), 9, 0xFFF2A900);
    _line(c, const Offset(8, 29), const Offset(92, 29), 4, 0xFF3A3A3A);
    _circle(c, const Offset(11, 29), 4.5, 0xFF111111);
    _circle(c, const Offset(89, 29), 4.5, 0xFF111111);

    _circle(c, const Offset(50, 14), 15, 0xFFF4F4F4);
    _fill(c, 47, 0, 53, 27, 0xFFD6252B, 3);
    c.restore();
  }

  void _tyre(Canvas c, double phase) {
    _fill(c, 41, 88, 59, 140, 0xFF121212, 6);
    for (var n = 0; n < 4; n++) {
      final y = 88 + ((n * 13 + phase) % 52);
      _paint.color = const Color(0xFF2E2E2E);
      c.drawRect(Rect.fromLTWH(41, y, 18, 3), _paint);
    }
  }

  /// Swings out and lengthens as [foot] goes 0 to 1, until the boot is on
  /// the road.
  void _leftLeg(Canvas c, double foot) {
    final extra = 38 * foot;
    c.save();
    c.translate(36, 60);
    c.rotate(0.45 * foot);
    c.translate(-36, -60);
    _fill(c, 29, 58, 43, 102 + extra, 0xFF1F3A5F, 6);
    if (foot > 0.05) _fill(c, 26, 98 + extra, 46, 108 + extra, 0xFF141414, 4);
    c.restore();
  }
}
