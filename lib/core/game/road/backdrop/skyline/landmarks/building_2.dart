import 'dart:ui';

import '../shape_primitives.dart';
import '../skyline_palette.dart';

void drawBuilding2(Canvas canva, Paint paint) {
  drawPoly(canva, paint, const [
    76,
    90,
    76,
    41,
    72,
    41,
    72,
    40,
    68,
    40,
    68,
    41,
    65,
    41,
    64,
    90,
  ], color00A2E8);

  drawPoly(canva, paint, const [76, 90, 77, 53, 84, 53, 85, 90], color3F48CC);
}
