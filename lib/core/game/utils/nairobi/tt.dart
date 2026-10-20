import 'dart:ui';

import '../scenery_shapes.dart';

void drawTimesTower(Canvas canva, Paint paint) => drawPoly(canva, paint, const [
  162,
  90,
  162,
  43,
  161,
  43,
  161,
  41,
  162,
  41,
  162,
  36,
  158,
  36,
  158,
  34,
  156,
  34,
  156,
  33,
  151,
  33,
  151,
  34,
  149,
  34,
  149,
  36,
  144,
  36,
  144,
  41,
  145,
  41,
  145,
  43,
  144,
  43,
  144,
  90,
], colorB97A57);

void drawTimesTower1(Canvas canva, Paint paint) => drawPoly(canva, paint, const [
  150,
  41,
  150,
  39,
  156,
  39,
  156,
  41,
  161,
  41,
  161,
  43,
  156,
  43,
  156,
  90,
  150,
  90,
  150,
  43,
  145,
  43,
  145,
  41,
], color000000);

void drawTimesTower2(Canvas canva, Paint paint) =>
    drawRect(canva, paint, const Rect.fromLTRB(158, 45, 160, 90), color000000);

void drawTimesTower3(Canvas canva, Paint paint) =>
    drawRect(canva, paint, const Rect.fromLTRB(146, 45, 148, 90), color000000);
