// Dart imports:
import 'dart:ui';

/// Recolors the gradients of the generated artwork while a rider is painted.
///
/// The generated art builds its gradients itself, so a canvas cannot recolor
/// them afterwards. The art calls these factories instead of [Gradient]; they
/// pass the colors through [recolor] when a rider is being painted.
abstract final class ArtGradient {
  /// Maps the drawn gradient colors to the current rider's, or null to keep.
  static List<Color> Function(List<Color> drawn)? recolor;

  static List<Color> _colors(List<Color> colors) {
    final map = recolor;
    return map == null ? colors : map(colors);
  }

  /// Linear gradient, as [Gradient.linear], in the current rider's colors.
  static Gradient linear(
    Offset from,
    Offset to,
    List<Color> colors, [
    List<double>? colorStops,
    TileMode tileMode = TileMode.clamp,
  ]) => Gradient.linear(from, to, _colors(colors), colorStops, tileMode);

  /// Radial gradient, as [Gradient.radial], in the current rider's colors.
  static Gradient radial(
    Offset center,
    double radius,
    List<Color> colors, [
    List<double>? colorStops,
    TileMode tileMode = TileMode.clamp,
  ]) => Gradient.radial(center, radius, _colors(colors), colorStops, tileMode);
}
