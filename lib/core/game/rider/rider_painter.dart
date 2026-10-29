// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import 'look/bike_look.dart';
import 'look/rider_look.dart';
import 'rider_pose.dart';
import 'rider_rig.dart';

part 'bike/bike_middle_panels.dart';
part 'bike/bike_panel.dart';
part 'bike/tail_covers.dart';
part 'bike/tail_parts.dart';
part 'bike/rider_bike.dart';
part 'body/gloves.dart';
part 'body/helmet.dart';
part 'body/lower_body.dart';
part 'body/upper_body.dart';

/// Paints the bike and rider from a pose.
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

  /// Paints the bike and rider in the given pose.
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
