// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import 'rider_bike.dart';
import 'rider_body.dart';
import 'rider_pose.dart';

/// Draws the whole rider by sequencing [RiderBike] and [RiderBody].
class RiderPainter {
  static const double width = RiderPartPainter.canvasWidth;
  static const double height = RiderPartPainter.canvasHeight;

  /// Lean the painter will accept before the shadow maths stops behaving.
  static const double maxLean = math.pi / 7;

  final RiderBike _bike = RiderBike();
  final RiderBody _body = RiderBody();

  void paint(Canvas c, RiderPose p) {
    _bike.paintShadow(c, p);

    c.save();
    c.translate(RiderPartPainter.midX + p.shake, RiderPartPainter.groundY);
    c.rotate(p.lean);
    c.translate(-RiderPartPainter.midX, -RiderPartPainter.groundY + p.bob);

    // _bike.paintRearEnd(c, p);
    // _body.paintLegs(c, p);
    _body.paintTorso(c, p);
    // _body.paintArms(c, p);
    // _bike.paintBarEnds(c, p);
    // _body.paintHead(c, p);
    c.restore();
  }
}

/// Shared drawing kit for [RiderBike] and [RiderBody].
abstract class RiderPartPainter {
  static const double canvasWidth = 120;
  static const double canvasHeight = 170;
  static const double groundY = 166;
  static const double midX = canvasWidth / 2;

  static const leather = Color(0xFF23242B);

  final Paint ink = Paint()..isAntiAlias = true;
  final Path scratch = Path();

  /// Tucking at speed drops and broadens the back.
  double tuckOf(RiderPose p) => p.speed * 5;

  /// Braking lifts the tail toward the camera; power squats it down.
  double tailLift(RiderPose p) => -p.pitch * 3.5;

  /// Where a hand meets the grip. [side] is -1 for left and 1 for right.
  /// The bars turn with the input, so the hands are not quite level.
  Offset handOf(int side, RiderPose p) =>
      Offset(midX + side * 40, 65 + tuckOf(p) + side * p.steer * 4);

  void fill(Canvas c, Rect r, Color color, [double radius = 3]) {
    ink
      ..style = PaintingStyle.fill
      ..color = color;
    c.drawRRect(RRect.fromRectXY(r, radius, radius), ink);
  }

  void oval(Canvas c, Rect r, Color color) {
    ink
      ..style = PaintingStyle.fill
      ..color = color;
    c.drawOval(r, ink);
  }

  void quad(Canvas c, Color color, List<Offset> pts) {
    ink
      ..style = PaintingStyle.fill
      ..color = color;
    scratch.reset();
    scratch.moveTo(pts.first.dx, pts.first.dy);
    for (var i = 1; i < pts.length; i++) {
      scratch.lineTo(pts[i].dx, pts[i].dy);
    }
    scratch.close();
    c.drawPath(scratch, ink);
  }

  void limb(Canvas c, Offset a, Offset b, double w, Color color) {
    ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = w
      ..strokeCap = StrokeCap.round
      ..color = color;
    c.drawLine(a, b, ink);
    ink.style = PaintingStyle.fill;
  }
}