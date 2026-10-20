import 'dart:ui';

import '../scenery_shapes.dart';

void drawKicc(Canvas canva, Paint paint) {
  drawPoly(
    canva,
    paint,
    const [
      104,
      90,
      104,
      43,
      106,
      43,
      106,
      42,
      105,
      42,
      105,
      41,
      102,
      39,
      105,
      38,
      104,
      37,
      115,
      37,
      114,
      38,
      117,
      39,
      114,
      41,
      114,
      42,
      113,
      42,
      113,
      43,
      115,
      43,
      115,
      90,
    ],
    colorB97A57,
    edge: colorB97A57,
  );
  path
    ..reset()
    ..addRect(const Rect.fromLTRB(105, 41, 114, 42));
  for (var y = 43.0; y <= 88; y += 1.5) {
    path.addRect(Rect.fromLTRB(103.5, y, 115.5, y + 1));
  }
  fillContainer(canva, paint, color7F7F7F);
  drawLines(canva, paint, const [102, 39, 117, 39], colorB97A57);
  drawLines(canva, paint, const [
    102,
    39,
    117,
    39,
    105,
    38,
    114.5,
    38,
  ], color7F7F7F);

  // smaller cone in Kicc
  drawPoly(canva, paint, const [
    114,
    90,
    114,
    88,
    106,
    84,
    118,
    73,
    129,
    84,
    121,
    88,
    121,
    90,
  ], colorFF7F27);
}
