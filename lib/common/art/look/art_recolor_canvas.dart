// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Flutter imports:
import 'package:flutter/painting.dart';

// Project imports:
import 'art_palette.dart';

/// Canvas that repaints the generated artwork in a rider's palette.
///
/// Solid fills take the palette color that replaces their drawn color, and
/// large gradient panels, the bike body, are turned to the bike's hue.
class ArtRecolorCanvas implements Canvas {
  ArtRecolorCanvas(ArtPalette palette)
    : _swaps = palette.swapsFrom(ArtPalette.drawn),
      _hueFilter = _hueFilterFor(palette);

  static const double panelMinArea = 1000;

  final Map<Color, Color> _swaps;
  final ColorFilter _hueFilter;

  late Canvas target;

  static ColorFilter _hueFilterFor(ArtPalette palette) {
    final drawnHue = HSLColor.fromColor(ArtPalette.drawn.bike).hue;
    final shift = HSLColor.fromColor(palette.bike).hue - drawnHue;
    final angle = shift * math.pi / 180;
    final cos = math.cos(angle);
    final sin = math.sin(angle);
    return ColorFilter.matrix([
      0.213 + cos * 0.787 - sin * 0.213,
      0.715 - cos * 0.715 - sin * 0.715,
      0.072 - cos * 0.072 + sin * 0.928,
      0, 0,
      0.213 - cos * 0.213 + sin * 0.143,
      0.715 + cos * 0.285 + sin * 0.140,
      0.072 - cos * 0.072 - sin * 0.283,
      0, 0,
      0.213 - cos * 0.213 - sin * 0.787,
      0.715 - cos * 0.715 + sin * 0.715,
      0.072 + cos * 0.928 + sin * 0.072,
      0, 0,
      0, 0, 0, 1, 0,
    ]);
  }

  /// Draws with [paint] recolored, then puts the paint back as it was.
  void _recolored(Paint paint, double area, void Function() draw) {
    final color = paint.color;
    final filter = paint.colorFilter;
    if (paint.shader != null) {
      if (area > panelMinArea) paint.colorFilter = _hueFilter;
    } else if (paint.style == PaintingStyle.fill) {
      paint.color = _swaps[color] ?? color;
    }
    draw();
    paint
      ..color = color
      ..colorFilter = filter;
  }

  @override
  void save() => target.save();

  @override
  void restore() => target.restore();

  @override
  void rotate(double radians) => target.rotate(radians);

  @override
  void translate(double dx, double dy) => target.translate(dx, dy);

  @override
  void drawPath(Path path, Paint paint) {
    final bounds = path.getBounds();
    _recolored(
      paint,
      bounds.width * bounds.height,
      () => target.drawPath(path, paint),
    );
  }

  @override
  void drawOval(Rect rect, Paint paint) =>
      _recolored(paint, 0, () => target.drawOval(rect, paint));

  @override
  void drawRect(Rect rect, Paint paint) =>
      _recolored(paint, 0, () => target.drawRect(rect, paint));

  @override
  void drawRRect(RRect rrect, Paint paint) =>
      _recolored(paint, 0, () => target.drawRRect(rrect, paint));

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnsupportedError('Unsupported canvas call: ${invocation.memberName}');
}
