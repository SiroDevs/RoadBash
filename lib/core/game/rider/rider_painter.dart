// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import 'look/bike_look.dart';
import 'look/rider_look.dart';
import 'rider_pose.dart';
import 'rider_rig.dart';

part 'bike/bike_panel.dart';
part 'bike/tail_parts.dart';
part 'bike/rider_bike.dart';
part 'body/gloves.dart';
part 'body/lower_body.dart';
part 'body/upper_body.dart';

class RiderPainter {
  RiderPainter(this.rig, {this.look = RiderLook.main});

  final RiderRig rig;
  final RiderLook look;

  static const double width = RiderPartPainter.canvasWidth;
  static const double height = RiderPartPainter.canvasHeight;

  static const double maxLean = math.pi / 7;

  late final RiderBike _bikeFrame = RiderBike(look);
  late final UpperBody _upperBody = UpperBody(look);
  late final Gloves _gloves = Gloves(look);
  late final LowerBody _lowerBody = LowerBody(look);
  late final BikePanels _bikePanels = BikePanels(look);
  late final TailParts _tailParts = TailParts(look);

  final Paint _paint = Paint()
    ..isAntiAlias = true
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;
  final Path _path = Path();

  void paint(Canvas canva, RiderPose pose) {
    _bikeFrame.paintShadow(canva, pose);

    canva.save();
    canva.translate(RiderPartPainter.midX + pose.shake, RiderPartPainter.groundY);
    canva.rotate(pose.lean);
    canva.translate(-RiderPartPainter.midX, -RiderPartPainter.groundY + pose.bob);

    canva.save();
    canva.translate(0, -rig.bikeLift);
    _bikeFrame.handleBars(_paint, _path, canva, pose);
    canva.restore();

    canva.save();
    canva.translate(0, -rig.riderLift);
    _upperBody.paint(_paint, _path, canva, pose);
    _lowerBody.paint(_paint, _path, canva, pose);
    _gloves.paint(_paint, _path, canva, pose);
    canva.restore();

    canva.save();
    canva.translate(0, -rig.bikeLift);
    _bikeFrame.paintBody(_paint, _path, canva, pose);
    _bikePanels.paint(_paint, _path, canva, pose);
    _tailParts.paint(_paint, _path, canva, pose);
    canva.restore();

    _tailParts.paintWheel(_paint, canva, pose);
    canva.restore();
  }
}

abstract class RiderPartPainter {
  RiderPartPainter(this.look);

  final RiderLook look;
  BikeLook get bike => look.bike;

  static const double canvasWidth = 120;
  static const double canvasHeight = 170;
  static const double groundY = 166;
  static const double midX = canvasWidth / 2;

  final Paint ink = Paint()..isAntiAlias = true;
  final Path scratch = Path();

  double tuckOf(RiderPose pose) => pose.speed * 5;

  double tailLift(RiderPose pose) => -pose.pitch * 3.5;

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
