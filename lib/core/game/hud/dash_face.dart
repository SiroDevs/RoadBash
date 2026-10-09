// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../utils/canvas_text.dart';
import '../utils/paint_utils.dart';
import 'dash_layout.dart';
import 'hud_strings.dart';

/// The static dashboard parts, recorded once into a [Picture].
class DashFace {
  DashFace._();

  static const _ink = Color(0xFF3A3224);

  static Picture build(DashLayout l, HudStrings s) {
    final rec = PictureRecorder();
    final c = Canvas(rec);
    _housing(c, l);
    _dial(c, l.speedC, l.speedR,
        max: 240, major: 40, minors: 4, unit: s.speedUnit);
    _dial(c, l.rpmC, l.rpmR,
        max: 12, major: 3, minors: 3, unit: s.rpmUnit, redFrom: 10);
    _centre(c, l);
    return rec.endRecording();
  }

  static Paint _outline(Color color, double width) => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..color = color;

  static void _housing(Canvas c, DashLayout l) {
    final r = Rect.fromLTWH(l.left, l.top, l.pw, l.ph);
    final dome = Radius.elliptical(l.pw * 0.5, l.ph * 0.8);
    final rr = RRect.fromRectAndCorners(r, topLeft: dome, topRight: dome);
    c.drawRRect(
      rr,
      Paint()
        ..shader = Gradient.linear(r.topCenter, r.bottomCenter,
            const [Color(0xFF30303A), Color(0xFF0B0B10)]),
    );
    c.drawRRect(rr, _outline(const Color(0x44FFFFFF), 2));
  }

  static void _dial(
    Canvas c,
    Offset ctr,
    double r, {
    required int max,
    required int major,
    required int minors,
    required String unit,
    int? redFrom,
  }) {
    c.drawCircle(ctr, r * 1.07, fillPaint(const Color(0xFF050507)));
    c.drawCircle(ctr, r, fillPaint(const Color(0xFFEDE3C8)));

    if (redFrom != null) {
      c.drawArc(
        Rect.fromCircle(center: ctr, radius: r * 0.9),
        DashLayout.dialStart + DashLayout.dialSweep * redFrom / max,
        DashLayout.dialSweep * (max - redFrom) / max,
        false,
        _outline(const Color(0xFFC0301F), r * 0.07),
      );
    }

    final tick = _outline(_ink, math.max(1.0, r * 0.02))
      ..strokeCap = StrokeCap.round;
    final steps = (max ~/ major) * minors;
    for (var i = 0; i <= steps; i++) {
      final isMajor = i % minors == 0;
      final a = DashLayout.dialStart + DashLayout.dialSweep * i / steps;
      c.drawLine(DashLayout.polar(ctr, a, r * 0.86),
          DashLayout.polar(ctr, a, r * (isMajor ? 0.70 : 0.78)), tick);
      if (isMajor) {
        paintText(c, '${(i ~/ minors) * major}',
            DashLayout.polar(ctr, a, r * 0.54), r * 0.18, _ink);
      }
    }
    paintText(c, unit, Offset(ctr.dx, ctr.dy + r * 0.50), r * 0.14, _ink);
  }

  static void _centre(Canvas c, DashLayout l) {
    final rr = RRect.fromRectAndRadius(l.centre, Radius.circular(l.ph * 0.04));
    c.drawRRect(rr, fillPaint(const Color(0xFF0B0B10)));
    c.drawRRect(rr, _outline(const Color(0x66FFFFFF), 2));
  }
}
