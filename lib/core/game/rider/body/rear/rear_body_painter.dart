// Dart imports:
import 'dart:ui';

// Project imports:
import '../../look/rider_look.dart';
import '../../rider_pose.dart';
import '../../view/bike_anchors.dart';
import '../../view/body_view_painter.dart';
import '../../view/rider_view.dart';
import 'gloves.dart';
import 'lower_body.dart';
import 'upper_body.dart';

/// The rider seen from behind, as the player sees it while racing.
class RearBodyPainter implements BodyViewPainter {
  RearBodyPainter(RiderLook look)
    : _upper = UpperBody(look),
      _gloves = Gloves(look),
      _lower = LowerBody(look);

  final UpperBody _upper;
  final Gloves _gloves;
  final LowerBody _lower;

  @override
  RiderView get view => RiderView.rear;

  @override
  void paint(Paint paint, Path path, Canvas canvas, RiderPose pose, BikeAnchors anchors) {
    _upper.paint(paint, path, canvas, pose);
    _lower.paint(paint, path, canvas, pose);
    _gloves.paint(paint, path, canvas, pose);
  }
}
