// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import 'bike/bike_painters.dart';
import 'body/body_painters.dart';
import 'look/rider_look.dart';
import 'rider_pose.dart';
import 'rider_rig.dart';
import 'view/bike_view_painter.dart';
import 'view/body_view_painter.dart';
import 'view/part_painter.dart';
import 'view/rider_view.dart';

export 'view/part_painter.dart';

/// Paints the bike and rider from a pose, as seen from one view.
///
/// The bike and the rider are drawn by separate painters for the view. The
/// bike goes down in layers around the rider: parts behind him, then the
/// rider, then the parts in front of him, then the parts above everything.
class RiderPainter {
  RiderPainter(
    this.rig, {
    this.look = RiderLook.main,
    this.view = RiderView.rear,
  }) : _bike = bikePainterFor(view, look),
       _body = bodyPainterFor(view, look);

  final RiderRig rig;
  final RiderLook look;
  final RiderView view;

  static const double width = RiderPartPainter.canvasWidth;
  static const double height = RiderPartPainter.canvasHeight;

  static const double maxLean = math.pi / 7;

  final BikeViewPainter _bike;
  final BodyViewPainter _body;

  final Paint _paint = Paint()
    ..isAntiAlias = true
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;
  final Path _path = Path();

  /// Paints the bike and rider in the given pose.
  void paint(Canvas canva, RiderPose pose) {
    final spec = view.canvas;
    _bike.paintShadow(canva, pose);

    canva.save();
    canva.translate(spec.midX + pose.shake, spec.groundY);
    canva.rotate(pose.lean + pose.tumble);
    canva.translate(-spec.midX, -spec.groundY + pose.bob);

    canva.save();
    canva.translate(0, -rig.bikeLift);
    _bike.paintBehindRider(_paint, _path, canva, pose);
    canva.restore();

    canva.save();
    canva.translate(0, -rig.riderLift);
    _body.paint(_paint, _path, canva, pose, _bike.anchors(pose));
    canva.restore();

    canva.save();
    canva.translate(0, -rig.bikeLift);
    _bike.paintInFrontOfRider(_paint, _path, canva, pose);
    canva.restore();

    _bike.paintOverRider(_paint, _path, canva, pose);
    canva.restore();
  }
}
