import 'dart:ui';

import '../shape_primitives.dart';
import '../skyline_palette.dart';

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
  drawLines(
    canva,
    paint,
    const [114, 88, 121, 88, 107, 84, 128, 84, 124, 79.5, 111.5, 79.5],
    colorB97A57,
    0.5,
  );
  drawPoly(canva, paint, const [118.0, 74, 117.5, 84, 118.5, 84], colorB97A57);
  drawPoly(canva, paint, const [115.5, 84, 118.0, 74, 114.5, 84], colorB97A57);
  drawPoly(canva, paint, const [112.5, 84, 118.0, 74, 111.5, 84], colorB97A57);
  drawPoly(canva, paint, const [118.0, 74, 120.0, 84, 121.5, 84], colorB97A57);
  drawPoly(canva, paint, const [118.0, 74, 108.5, 84, 109.5, 84], colorB97A57);
  drawPoly(canva, paint, const [118.0, 74, 123.0, 84, 124.0, 84], colorB97A57);
  drawPoly(canva, paint, const [118.0, 74, 125.5, 84, 126.5, 84], colorB97A57);

  drawPoly(canva, paint, const [118.5, 84, 118.0, 89, 117.5, 84], colorB97A57);
  drawPoly(canva, paint, const [118.0, 89, 120.0, 84, 120.5, 84], colorB97A57);
  drawPoly(canva, paint, const [118.5, 89, 115.0, 84, 114.5, 84], colorB97A57);
  drawPoly(canva, paint, const [118.5, 89, 112.0, 84, 111.5, 84], colorB97A57);
  drawPoly(canva, paint, const [118.0, 89, 123.0, 84, 123.5, 84], colorB97A57);
  drawPoly(canva, paint, const [118.0, 89, 109.5, 84, 108.5, 84], colorB97A57);
  drawPoly(canva, paint, const [118.0, 89, 125.5, 84, 126.5, 84], colorB97A57);
}
