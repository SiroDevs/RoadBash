import 'dart:ui';

import '../scenery_shapes.dart';

void drawDomeBuilding(Canvas canva, Paint paint) => drawPoly(canva, paint, const [
  190,
  90,
  190,
  58,
  188,
  58,
  188,
  57,
  177,
  57,
  177,
  58,
  175,
  58,
  175,
  90,
], color7092BE);

void drawDomeBuilding1(Canvas canva, Paint paint) =>
    drawOval(canva, paint, const Rect.fromLTRB(178, 53, 187, 60), color7092BE);
