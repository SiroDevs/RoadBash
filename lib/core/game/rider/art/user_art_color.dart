import 'dart:ui';

/// Recolors the supplied single-ink vector shapes for a rider or bike.
ColorFilter userArtColorFilter(Color color) {
  final red = (color.r * 255).roundToDouble();
  final green = (color.g * 255).roundToDouble();
  final blue = (color.b * 255).roundToDouble();
  return ColorFilter.matrix([
    0,
    0,
    0,
    0,
    red,
    0,
    0,
    0,
    0,
    green,
    0,
    0,
    0,
    0,
    blue,
    0,
    0,
    0,
    1,
    0,
  ]);
}
