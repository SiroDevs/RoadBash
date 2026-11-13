// Dart imports:
import 'dart:ui';

// Project imports:
import '../sheet/art_tone.dart';
import 'art_palette.dart';

/// Canvas that repaints the generated artwork in a rider's palette.
///
/// Solid fills take the palette color that replaces their drawn color.
/// Gradients are recolored when they are built, see [ArtGradient].
class ArtRecolorCanvas implements Canvas {
  ArtRecolorCanvas(this.palette)
    : _swaps = {...palette.shadeSwaps, ...palette.swapsFrom(ArtPalette.drawn)};

  final ArtPalette palette;
  final Map<Color, Color> _swaps;

  late Canvas target;

  /// Draws with [paint] recolored, then puts the paint back as it was.
  ///
  /// Gradients are already built in the rider's colors, see [ArtGradient].
  void _recolored(Paint paint, void Function() draw) {
    final color = paint.color;
    final replacement = paint.shader == null ? _swaps[color] : null;
    if (replacement != null) {
      paint.color = switch (paint.style) {
        PaintingStyle.stroke when replacement != color => ToneColors.shaded(
          replacement,
          0.55,
        ),
        _ => replacement,
      };
    }
    try {
      draw();
    } finally {
      paint.color = color;
    }
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
  void clipRect(
    Rect rect, {
    ClipOp clipOp = ClipOp.intersect,
    bool doAntiAlias = true,
  }) => target.clipRect(rect, clipOp: clipOp, doAntiAlias: doAntiAlias);

  @override
  void drawPath(Path path, Paint paint) =>
      _recolored(paint, () => target.drawPath(path, paint));

  @override
  void drawOval(Rect rect, Paint paint) =>
      _recolored(paint, () => target.drawOval(rect, paint));

  @override
  void drawRect(Rect rect, Paint paint) =>
      _recolored(paint, () => target.drawRect(rect, paint));

  @override
  void drawRRect(RRect rrect, Paint paint) =>
      _recolored(paint, () => target.drawRRect(rrect, paint));

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnsupportedError(
    'Unsupported canvas call: ${invocation.memberName}',
  );
}
