// Dart imports:
import 'dart:ui';

// Project imports:
import '../shape_primitives.dart';
import '../skyline_palette.dart';

/// Draws the third generic building.
void drawBuilding3(Canvas canva, Paint paint) {
  drawPoly(canva, paint, const [
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

  drawRect(canva, paint, const Rect.fromLTRB(135, 82, 136, 83), colorC3C3C3);
  drawRect(canva, paint, const Rect.fromLTRB(137, 82, 138, 83), colorC3C3C3);
  drawRect(canva, paint, const Rect.fromLTRB(139, 82, 140, 83), colorC3C3C3);
  drawRect(canva, paint, const Rect.fromLTRB(141, 82, 142, 83), colorC3C3C3);
  drawRect(canva, paint, const Rect.fromLTRB(143, 82, 144, 83), colorC3C3C3);
  drawRect(canva, paint, const Rect.fromLTRB(145, 82, 146, 83), colorC3C3C3);
  drawRect(canva, paint, const Rect.fromLTRB(147, 82, 148, 83), colorC3C3C3);
  drawRect(canva, paint, const Rect.fromLTRB(149, 82, 150, 83), colorC3C3C3);
  drawRect(canva, paint, const Rect.fromLTRB(151, 82, 152, 83), colorC3C3C3);

  drawRect(canva, paint, const Rect.fromLTRB(136, 85, 138, 89), colorB97A57);
  drawRect(canva, paint, const Rect.fromLTRB(140, 85, 142, 89), colorB97A57);
  drawRect(canva, paint, const Rect.fromLTRB(144, 85, 146, 89), colorB97A57);
  drawRect(canva, paint, const Rect.fromLTRB(148, 85, 150, 89), colorB97A57);
  drawRect(canva, paint, const Rect.fromLTRB(152, 85, 154, 89), colorB97A57);
}
