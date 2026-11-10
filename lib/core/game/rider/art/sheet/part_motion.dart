// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import 'art_ink.dart';

/// Moves a drawn piece around a pivot without touching its artwork.
class PartMotion {
  /// Runs [draw] with the canvas turned and scaled around [pivot].
  static void around(
    Canvas canvas,
    Offset pivot,
    void Function() draw, {
    double angle = 0,
    double scaleX = 1,
    double scaleY = 1,
    Offset shift = Offset.zero,
  }) {
    canvas
      ..save()
      ..translate(pivot.dx + shift.dx, pivot.dy + shift.dy)
      ..rotate(angle)
      ..scale(scaleX, scaleY)
      ..translate(-pivot.dx, -pivot.dy);
    draw();
    canvas.restore();
  }

  /// Flips the canvas left to right around the vertical line at [midX].
  static void mirror(Canvas canvas, double midX) {
    canvas
      ..translate(midX * 2, 0)
      ..scale(-1, 1);
  }

  /// Draws a limb piece with its lower end pulled down by [amount].
  static void stretched(
    Canvas canvas,
    InkedPart piece,
    Offset origin,
    double amount, {
    double span = 9,
  }) {
    final path = Path();
    for (var index = 0; index < piece.inks.length; index++) {
      path.reset();
      final points = piece.part.shapes[index].points;
      for (var at = 0; at < points.length; at++) {
        final weight = ((points[at].dy - origin.dy) / span).clamp(0.0, 1.0);
        final dy = points[at].dy + amount * weight;
        if (at == 0) {
          path.moveTo(points[at].dx, dy);
        } else {
          path.lineTo(points[at].dx, dy);
        }
      }
      path.close();
      canvas.drawPath(path, piece.inks[index].fill);
      canvas.drawPath(path, piece.inks[index].edge);
    }
  }

  /// Angle of a joint segment measured from straight down, forward positive.
  static double fromDown(Offset start, Offset end) =>
      math.atan2(end.dx - start.dx, end.dy - start.dy);

  /// Smooth 0 to 1 step between two edges.
  static double smooth(double from, double to, double value) {
    final amount = ((value - from) / (to - from)).clamp(0.0, 1.0);
    return amount * amount * (3 - 2 * amount);
  }
}
