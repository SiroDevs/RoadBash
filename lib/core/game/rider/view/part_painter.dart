// Dart imports:
import 'dart:ui';

// Project imports:
import '../look/bike_look.dart';
import '../look/rider_look.dart';
import '../rider_pose.dart';

/// Base class for painters of the bike and rider parts.
abstract class RiderPartPainter {
  RiderPartPainter(this.look);

  final RiderLook look;
  /// Bike colors of the current look.
  BikeLook get bike => look.bike;

  static const double canvasWidth = 120;
  static const double canvasHeight = 170;
  static const double groundY = 166;
  static const double midX = canvasWidth / 2;

  final Paint ink = Paint()..isAntiAlias = true;
  final Path scratch = Path();

  /// Returns how far the rider tucks forward.
  double tuckOf(RiderPose pose) => pose.speed * 5;

  /// Returns how much the tail lifts with the bike's pitch.
  double tailLift(RiderPose pose) => -pose.pitch * 3.5;

  /// Returns the hand position on a handlebar side.
  Offset handOf(int side, RiderPose pose) =>
      Offset(midX + side * 40, 65 + tuckOf(pose) + side * pose.steer * 4);

  /// Fills a rounded rectangle.
  void fill(Canvas canva, Rect rect, Color color, [double radius = 3]) {
    ink
      ..style = PaintingStyle.fill
      ..color = color;
    canva.drawRRect(RRect.fromRectXY(rect, radius, radius), ink);
  }

  /// Fills an oval.
  void oval(Canvas canva, Rect rect, Color color) {
    ink
      ..style = PaintingStyle.fill
      ..color = color;
    canva.drawOval(rect, ink);
  }

  /// Fills a polygon through the given points.
  void quad(Canvas canva, Color color, List<Offset> pts) {
    ink
      ..style = PaintingStyle.fill
      ..color = color;
    scratch.reset();
    scratch.moveTo(pts.first.dx, pts.first.dy);
    for (var i = 1; i < pts.length; i++) {
      scratch.lineTo(pts[i].dx, pts[i].dy);
    }
    scratch.close();
    canva.drawPath(scratch, ink);
  }

  /// Draws a limb as a thick line between two points.
  void limb(Canvas canva, Offset start, Offset end, double width, Color color) {
    ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..color = color;
    canva.drawLine(start, end, ink);
    ink.style = PaintingStyle.fill;
  }
}
