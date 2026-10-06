// Dart imports:
import 'dart:ui';

Paint fillPaint(Color color, {bool antiAlias = true}) => Paint()
  ..color = color
  ..isAntiAlias = antiAlias;

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
