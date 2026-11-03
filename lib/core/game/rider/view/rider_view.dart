// Dart imports:
import 'dart:ui';

/// The size of the drawing area of one view, in pixels, and where the ground
/// and the bike's centre line sit in it.
class RiderCanvas {
  const RiderCanvas({
    required this.width,
    required this.height,
    required this.groundY,
  });

  final double width;
  final double height;
  final double groundY;

  /// Horizontal centre of the drawing area.
  double get midX => width / 2;

  /// Flips a horizontal position, so the right view can reuse the left view.
  double mirrorX(double x) => width - x;

  /// Returns [point] flipped horizontally.
  Offset mirror(Offset point) => Offset(width - point.dx, point.dy);
}

/// The four ways the rider and bike can be seen.
enum RiderView {
  /// From behind: what the player sees while racing.
  rear(RiderCanvas(width: 120, height: 170, groundY: 166)),

  /// From the front.
  front(RiderCanvas(width: 120, height: 170, groundY: 166)),

  /// From the left side, the bike pointing left.
  left(RiderCanvas(width: 200, height: 170, groundY: 166)),

  /// From the right side, the bike pointing right.
  right(RiderCanvas(width: 200, height: 170, groundY: 166));

  const RiderView(this.canvas);

  final RiderCanvas canvas;

  /// True for the two side views.
  bool get isSide => this == left || this == right;
}
