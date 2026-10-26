import 'dart:ui';

import '../shape_primitives.dart';
import '../skyline_palette.dart';

void drawBuilding1(Canvas canva, Paint paint) {
  drawPoly(
    canva,
    paint,
    const [
      120,
      43,
      120,
      33,
      121,
      33,
      121,
      43,
      123,
      43,
      123,
      20,
      122,
      18,
      121,
      20,
      121,
      43,
    ],
    color99D9EA,
    edge: color99D9EA,
  );
  path.reset();
  for (var y = 20.0; y <= 42; y += 2) {
    path
      ..moveTo(y < 34 ? 121 : 120, y)
      ..lineTo(123, y);
  }
  drawEdge(canva, paint, color99D9EA);

  drawPoly(canva, paint, const [
    134,
    46,
    134,
    90,
    120,
    90,
    119,
    43,
    128,
    43,
    128,
    44,
    129,
    44,
    129,
    42,
    132,
    42,
    132,
    46,
  ], color99D9EA);
  drawOval(canva, paint, const Rect.fromLTRB(124, 40, 127, 44), color99D9EA);
}
