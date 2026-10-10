// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../utils/canvas_text.dart';
import '../utils/paint_utils.dart';
import 'dashboard_layout.dart';
import 'hud_strings.dart';

class DashboardFace {
  DashboardFace._();

  static const _ink = Color(0xFF3A3224);

  static Picture build(DashboardLayout layout, HudStrings strings) {
    final rec = PictureRecorder();
    final canva = Canvas(rec);
    _housing(canva, layout);
    _dial(
      canva,
      layout.speedOffset,
      layout.speedRadius,
      max: 240,
      major: 40,
      minors: 4,
      unit: strings.speedUnit,
    );
    _dial(
      canva,
      layout.rpmOffset,
      layout.rpmRadius,
      max: 12,
      major: 3,
      minors: 3,
      unit: strings.rpmUnit,
      redFrom: 10,
    );
    _centre(canva, layout);
    return rec.endRecording();
  }

  static Paint _outline(Color color, double width) => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..color = color;

  static void _housing(Canvas canva, DashboardLayout l) {
    final r = Rect.fromLTWH(l.left, l.top, l.pw, l.ph);
    final dome = Radius.elliptical(l.pw * 0.5, l.ph * 0.8);
    final rr = RRect.fromRectAndCorners(r, topLeft: dome, topRight: dome);
    canva.drawRRect(
      rr,
      Paint()
        ..shader = Gradient.linear(r.topCenter, r.bottomCenter, const [
          Color(0xFF30303A),
          Color(0xFF0B0B10),
        ]),
    );
    canva.drawRRect(rr, _outline(const Color(0x44FFFFFF), 2));
  }

  static void _dial(
    Canvas canva,
    Offset ctr,
    double radius, {
    required int max,
    required int major,
    required int minors,
    required String unit,
    int? redFrom,
  }) {
    canva.drawCircle(ctr, radius * 1.07, fillPaint(const Color(0xFF050507)));
    canva.drawCircle(ctr, radius, fillPaint(const Color(0xFFEDE3C8)));

    if (redFrom != null) {
      canva.drawArc(
        Rect.fromCircle(center: ctr, radius: radius * 0.9),
        DashboardLayout.dialStart + DashboardLayout.dialSweep * redFrom / max,
        DashboardLayout.dialSweep * (max - redFrom) / max,
        false,
        _outline(const Color(0xFFC0301F), radius * 0.07),
      );
    }

    final tick = _outline(_ink, math.max(1.0, radius * 0.02))
      ..strokeCap = StrokeCap.round;
    final steps = (max ~/ major) * minors;
    for (var i = 0; i <= steps; i++) {
      final isMajor = i % minors == 0;
      final a =
          DashboardLayout.dialStart + DashboardLayout.dialSweep * i / steps;
      canva.drawLine(
        DashboardLayout.polar(ctr, a, radius * 0.86),
        DashboardLayout.polar(ctr, a, radius * (isMajor ? 0.70 : 0.78)),
        tick,
      );
      if (isMajor) {
        paintText(
          canva,
          '${(i ~/ minors) * major}',
          DashboardLayout.polar(ctr, a, radius * 0.54),
          radius * 0.18,
          _ink,
        );
      }
    }
    paintText(
      canva,
      unit,
      Offset(ctr.dx, ctr.dy + radius * 0.50),
      radius * 0.14,
      _ink,
    );
  }

  static void _centre(Canvas c, DashboardLayout l) {
    final rr = RRect.fromRectAndRadius(l.centre, Radius.circular(l.ph * 0.04));
    c.drawRRect(rr, fillPaint(const Color(0xFF0B0B10)));
    c.drawRRect(rr, _outline(const Color(0x66FFFFFF), 2));
  }
}
