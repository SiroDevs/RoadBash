import 'dart:ui';

import '../shape_primitives.dart';
import '../skyline_palette.dart';

void drawParliament(Canvas canva, Paint paint) {
  drawPoly(canva, paint, const [
    72,
    90,
    72,
    65,
    70,
    65,
    70,
    58,
    69,
    58,
    69,
    56,
    69,
    58,
    68,
    58,
    68,
    65,
    67,
    65,
    67,
    90,
  ], colorFF7F27);
  drawRect(
    canva,
    paint,
    const Rect.fromLTRB(66.5, 54.5, 69.5, 55.0),
    color000000,
  );
  drawRect(
    canva,
    paint,
    const Rect.fromLTRB(66.5, 55.5, 69.5, 56.0),
    colorED1C24,
  );
  drawRect(
    canva,
    paint,
    const Rect.fromLTRB(66.5, 55.5, 69.5, 55.0),
    color22B14C,
  );

  drawPoly(canva, paint, const [
    78,
    68,
    78,
    51,
    81,
    51,
    81,
    47,
    82,
    47,
    82,
    29,
    83,
    29,
    83,
    25,
    84,
    25,
    84,
    21,
    88,
    14,
    88,
    11,
    88,
    14,
    91,
    21,
    91,
    25,
    92,
    25,
    92,
    29,
    93,
    29,
    93,
    47,
    95,
    47,
    95,
    51,
    98,
    51,
    98,
    68,
  ], colorB97A57);

  drawPoly(canva, paint, const [
    100,
    90,
    100,
    81,
    98,
    81,
    98,
    68,
    78,
    68,
    78,
    81,
    75,
    81,
    75,
    90,
  ], color880015);

  //parliament
  drawRect(canva, paint, const Rect.fromLTRB(86, 51, 90, 80), color000000);
}
