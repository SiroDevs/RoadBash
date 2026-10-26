import 'dart:ui';

final Path path = Path();

void tracePoints(List<double> pts) {
  path
    ..reset()
    ..moveTo(pts[0], pts[1]);
  for (var i = 2; i < pts.length; i += 2) {
    path.lineTo(pts[i], pts[i + 1]);
  }
  path.close();
}

void fillContainer(Canvas canva, Paint paint, Color color) {
  paint
    ..style = PaintingStyle.fill
    ..color = color;
  canva.drawPath(path, paint);
}

void drawEdge(Canvas canva, Paint paint, Color color, [double width = 0.25]) {
  paint
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..color = color;
  canva.drawPath(path, paint);
}

void drawPoly(
  Canvas canva,
  Paint paint,
  List<double> pts,
  Color color, {
  Color? edge,
}) {
  tracePoints(pts);
  fillContainer(canva, paint, color);
  if (edge != null) drawEdge(canva, paint, edge);
}

void drawRect(Canvas canva, Paint paint, Rect r, Color color) {
  path
    ..reset()
    ..addRect(r);
  fillContainer(canva, paint, color);
}

void drawOval(Canvas canva, Paint paint, Rect r, Color color) {
  path
    ..reset()
    ..addOval(r);
  fillContainer(canva, paint, color);
}

void drawLines(
  Canvas canva,
  Paint paint,
  List<double> lines,
  Color color, [
  double w = 0.25,
]) {
  path.reset();
  for (var i = 0; i < lines.length; i += 4) {
    path
      ..moveTo(lines[i], lines[i + 1])
      ..lineTo(lines[i + 2], lines[i + 3]);
  }
  drawEdge(canva, paint, color, w);
}
