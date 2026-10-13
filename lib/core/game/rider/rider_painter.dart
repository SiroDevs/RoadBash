// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import 'rider_pose.dart';
part 'body/rider_body.dart';
part 'bike/bike_panel.dart';
part 'bike/tail_parts.dart';
part 'bike/rider_bike.dart';

class RiderPainter {
  static const double width = RiderPartPainter.canvasWidth;
  static const double height = RiderPartPainter.canvasHeight;

  /// Lean the painter will accept before the shadow maths stops behaving.
  static const double maxLean = math.pi / 7;

  final RiderBike _bike = RiderBike();
  final RiderBody _body = RiderBody();
  final BikePanels _bikePanels = BikePanels();
  final TailParts _tailParts = TailParts();

  final Paint _paint = Paint()
    ..isAntiAlias = true
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;
  final Path _path = Path();

  void paint(Canvas canva, RiderPose pose) {
    _bike.paintShadow(canva, pose);

    canva.save();
    canva.translate(RiderPartPainter.midX + pose.shake, RiderPartPainter.groundY);
    canva.rotate(pose.lean);
    canva.translate(-RiderPartPainter.midX, -RiderPartPainter.groundY + pose.bob);

    _bike.paintBike(_paint, _path, canva, pose);
    _bikePanels.paintPanels(_paint, _path, canva, pose);
    _tailParts.paintTail(_paint, _path, canva, pose);
    // _body.paintLegs(canva, pose);
    // _body.paintTorso(canva, pose);
    // _body.paintArms(canva, pose);
    // _bike.paintBarEnds(canva, pose);
    // _body.paintHead(canva, pose);
    canva.restore();
  }
}

abstract class RiderPartPainter {
  static const double canvasWidth = 120;
  static const double canvasHeight = 170;
  static const double groundY = 166;
  static const double midX = canvasWidth / 2;

  static const leather = Color(0xFF23242B);

  final Paint ink = Paint()..isAntiAlias = true;
  final Path scratch = Path();

  /// Tucking at speed drops and broadens the back.
  double tuckOf(RiderPose pose) => pose.speed * 5;

  /// Braking lifts the tail toward the camera; power squats it down.
  double tailLift(RiderPose pose) => -pose.pitch * 3.5;

  /// Where a hand meets the grip. [side] is -1 for left and 1 for right.
  /// The bars turn with the input, so the hands are not quite level.
  Offset handOf(int side, RiderPose pose) =>
      Offset(midX + side * 40, 65 + tuckOf(pose) + side * pose.steer * 4);

  void fill(Canvas canva, Rect r, Color color, [double radius = 3]) {
    ink
      ..style = PaintingStyle.fill
      ..color = color;
    canva.drawRRect(RRect.fromRectXY(r, radius, radius), ink);
  }

  void oval(Canvas canva, Rect r, Color color) {
    ink
      ..style = PaintingStyle.fill
      ..color = color;
    canva.drawOval(r, ink);
  }

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

  void limb(Canvas canva, Offset a, Offset b, double w, Color color) {
    ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = w
      ..strokeCap = StrokeCap.round
      ..color = color;
    canva.drawLine(a, b, ink);
    ink.style = PaintingStyle.fill;
  }
}