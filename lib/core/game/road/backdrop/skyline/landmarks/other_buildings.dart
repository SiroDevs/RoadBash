import 'dart:ui';

import '../shape_primitives.dart';
import '../skyline_palette.dart';

void drawOtherBuildings(Canvas canva, Paint paint) {
  drawPoly(canva, paint, const [37, 90, 37, 72, 30, 72, 30, 90], color3F48CC);
  drawPoly(canva, paint, const [
    12,
    90,
    12,
    65,
    13,
    64,
    13,
    63,
    22,
    63,
    22,
    90,
  ], colorC8BFE7);
  drawPoly(canva, paint, const [
    34,
    90,
    34,
    60,
    32,
    60,
    32,
    56,
    23,
    56,
    23,
    77,
    20,
    77,
    20,
    78,
    19,
    78,
    19,
    90,
  ], color7092BE);
  drawPoly(canva, paint, const [
    50,
    90,
    50,
    68,
    51,
    68,
    51,
    67,
    52,
    67,
    52,
    65,
    53,
    65,
    53,
    64,
    54,
    62,
    56,
    61,
    64,
    61,
    65,
    90,
  ], color3F48CC);

  drawPoly(canva, paint, const [
    43,
    46,
    43,
    90,
    30,
    90,
    30,
    45,
    34,
    45,
    34,
    46,
  ], color00A2E8);

  drawPoly(canva, paint, const [
    20,
    90,
    20,
    83,
    35,
    83,
    35,
    90,
    30,
    90,
    30,
    88,
    25,
    88,
    25,
    90,
  ], colorB97A57);
}
