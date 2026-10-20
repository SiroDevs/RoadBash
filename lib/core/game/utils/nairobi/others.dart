import 'dart:ui';

import '../scenery_shapes.dart';

void drawBuilding2(Canvas canva, Paint paint) => drawPoly(canva, paint, const [
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

void drawPolygon56(Canvas canva, Paint paint) {
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
}

void drawBuilding8(Canvas canva, Paint paint) => drawPoly(canva, paint, const [
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

void drawBuilding22(Canvas canva, Paint paint) => drawPoly(canva, paint, const [
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

void drawBuilding5(Canvas canva, Paint paint) => drawPoly(canva, paint, const [
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

void drawPolygon14(Canvas canva, Paint paint) => drawPoly(canva, paint, const [
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

void drawPolygon15(Canvas canva, Paint paint) => drawPoly(canva, paint, const [
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

void drawPolygon16(Canvas canva, Paint paint) =>
    drawPoly(canva, paint, const [37, 90, 37, 72, 30, 72, 30, 90], color3F48CC);

void drawPolygon18(Canvas canva, Paint paint) => drawPoly(canva, paint, const [
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

void drawBuilding7(Canvas canva, Paint paint) => drawPoly(canva, paint, const [
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

void drawBuilding6(Canvas canva, Paint paint) =>
    drawPoly(canva, paint, const [76, 90, 77, 53, 84, 53, 85, 90], color3F48CC);

void drawBuilding62(Canvas canva, Paint paint) => drawPoly(canva, paint, const [
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

void drawBuilding3(Canvas canva, Paint paint) =>
    drawPoly(canva, paint, const [122, 90, 122, 64, 128, 63, 128, 90], color00A2E8);

void drawPolygon25(Canvas canva, Paint paint) => drawPoly(canva, paint, const [
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

void drawBuilding5a(Canvas canva, Paint paint) =>
    drawOval(canva, paint, const Rect.fromLTRB(124, 40, 127, 44), color99D9EA);

void drawPolygon24Copy(Canvas canva, Paint paint) => drawPoly(canva, paint, const [
  156,
  90,
  156,
  83,
  154,
  83,
  154,
  79,
  135,
  79,
  135,
  81,
  134,
  81,
  133,
  83,
  133,
  90,
], colorFF7F27);

void drawBuilding4(Canvas canva, Paint paint) =>
    drawPoly(canva, paint, const [125, 90, 125, 69, 130, 69, 130, 90], color3F48CC);
