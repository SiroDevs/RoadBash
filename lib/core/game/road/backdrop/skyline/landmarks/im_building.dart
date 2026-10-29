// Dart imports:
import 'dart:ui';

// Project imports:
import '../shape_primitives.dart';
import '../skyline_palette.dart';

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

  drawLines(
    canva,
    paint,
    const [
      133,
      50,
      133,
      90,
      132,
      50,
      132,
      90,
      134,
      50,
      134,
      90,
      135,
      50,
      135,
      90,
      138,
      53,
      138,
      90,
      129,
      53,
      129,
      90,
    ],
    colorC3C3C3,
    0.25,
  );
}
