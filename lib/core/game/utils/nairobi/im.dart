import 'dart:ui';

import '../scenery_shapes.dart';

void drawImBuilding(Canvas canva, Paint paint) {
  drawPoly(canva, paint, const [
    128,
    90,
    128,
    53,
    129,
    53,
    129,
    51,
    130,
    51,
    130,
    49,
    137,
    49,
    137,
    51,
    138,
    51,
    138,
    53,
    139,
    53,
    139,
    90,
  ], color000000);

  drawLines(
    canva,
    paint,
    const [130.5, 46, 130.5, 89.5, 136.5, 46, 136.5, 89.5],
    color00A2E8,
    1,
  );
}
