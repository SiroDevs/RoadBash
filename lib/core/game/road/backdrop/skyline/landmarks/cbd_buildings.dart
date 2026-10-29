// Dart imports:
import 'dart:ui';

// Project imports:
import '../shape_primitives.dart';
import '../skyline_palette.dart';

void drawCbdBuildings(Canvas canva, Paint paint) {
  drawPoly(canva, paint, const [
    125,
    90,
    125,
    69,
    130,
    69,
    130,
    90,
  ], color3F48CC);
  drawPoly(canva, paint, const [
    122,
    90,
    122,
    64,
    128,
    63,
    128,
    90,
  ], color00A2E8);
  drawPoly(canva, paint, const [
    96,
    90,
    96,
    36,
    98,
    36,
    98,
    33,
    108,
    33,
    108,
    36,
    109,
    36,
    109,
    90,
  ], color00A2E8);
  drawPoly(canva, paint, const [
    144,
    90,
    144,
    60,
    143,
    60,
    143,
    59,
    139,
    59,
    139,
    90,
  ], color3F48CC);
  drawPoly(canva, paint, const [
    116,
    90,
    116,
    61,
    117,
    61,
    117,
    60,
    119,
    60,
    119,
    61,
    122,
    61,
    122,
    90,
  ], color00A2E8);
}
