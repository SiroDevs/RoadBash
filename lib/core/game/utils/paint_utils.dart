// Dart imports:
import 'dart:ui';

// Project imports:
import '../road/road_config.dart';

Paint fillPaint(Color color, {bool antiAlias = true}) => Paint()
  ..color = color
  ..isAntiAlias = antiAlias;

Color shade(Color c, double amount) =>
    Color.lerp(c, amount < 0 ? const Color(0xFF000000) : const Color(0xFFFFFFFF),
        amount.abs())!;

/// Paints for one colour pre-blended toward [fog] across the draw distance.
///
/// Blending per segment would allocate a Color and a Paint for every one of
/// the couple of hundred segments drawn each frame; this builds the whole
/// ramp once and the render loop just indexes it.
List<Paint> fogRamp(Color base, Color fog, {bool antiAlias = false}) =>
    List.generate(RoadConfig.fogSteps, (i) {
      final t = i / (RoadConfig.fogSteps - 1);
      return fillPaint(Color.lerp(base, fog, t)!, antiAlias: antiAlias);
    });

Paint fogged(List<Paint> ramp, double fog) {
  final i = (fog * (ramp.length - 1)).round();
  return ramp[i < 0 ? 0 : (i >= ramp.length ? ramp.length - 1 : i)];
}

void addQuad(Path p, double x1, double y1, double x2, double y2, double x3,
    double y3, double x4, double y4) {
  p
    ..moveTo(x1, y1)
    ..lineTo(x2, y2)
    ..lineTo(x3, y3)
    ..lineTo(x4, y4)
    ..close();
}

void drawQuad(Canvas c, Path p, Paint paint, double x1, double y1, double x2,
    double y2, double x3, double y3, double x4, double y4) {
  p.reset();
  addQuad(p, x1, y1, x2, y2, x3, y3, x4, y4);
  c.drawPath(p, paint);
}
