// Flutter imports:
import 'package:flutter/rendering.dart';

// Project imports:
import 'art/sheet/bike_figure.dart';
import 'look/rider_look.dart';
import 'rider_frame.dart';
import 'rider_pose.dart';
import 'rider_rig.dart';
import 'rig/front_rider.dart';
import 'rig/seated_rider.dart';
import 'view/rider_view.dart';

/// Rider and bike that can be drawn anywhere, such as a rival.
class RiderSprite {
  RiderSprite({
    this.look = RiderLook.main,
    RiderRig? rig,
    this.view = RiderView.rear,
  }) : rig = rig ?? RiderRig();

  final RiderLook look;
  final RiderView view;
  final RiderRig rig;
  final RiderPose pose = RiderPose();
  late final BikeFigure _bike = BikeFigure(look);
  late final SeatedRiderFigure _seated = SeatedRiderFigure(look);
  late final FrontRiderFigure _front = FrontRiderFigure(look);

  static const double bikeTurnShare = 1.0;
  static const double width = RiderFrame.width;
  static const double height = RiderFrame.height;

  /// Paints the selected artwork in the current pose.
  void paint(Canvas canvas) {
    canvas
      ..save()
      ..translate(RiderFrame.midX + pose.shake, RiderFrame.groundY)
      ..rotate(pose.lean + pose.tumble)
      ..translate(-RiderFrame.midX, -RiderFrame.groundY + pose.bob);
    final bikeYaw = pose.perspective * bikeTurnShare;
    _bike.paint(canvas, bikeYaw, steer: pose.steer, layer: BikeLayer.behind);
    if (view == RiderView.front) {
      _front.paint(canvas);
    } else {
      _seated.paint(canvas, pose);
    }
    _bike.paint(canvas, bikeYaw, steer: pose.steer, layer: BikeLayer.over);
    canvas.restore();
  }

  /// Paints the sprite with its wheels on the ground point.
  void paintAt(Canvas canvas, Offset ground, double scale) {
    canvas
      ..save()
      ..translate(
        ground.dx - view.canvas.midX * scale,
        ground.dy - view.canvas.groundY * scale,
      )
      ..scale(scale);
    paint(canvas);
    canvas.restore();
  }
}

/// Custom painter that draws a [RiderSprite].
class RiderSpritePainter extends CustomPainter {
  RiderSpritePainter(this.sprite);

  final RiderSprite sprite;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.height / RiderSprite.height;
    sprite.paintAt(
      canvas,
      Offset(size.width / 2, sprite.view.canvas.groundY * scale),
      scale,
    );
  }

  @override
  bool shouldRepaint(RiderSpritePainter old) => true;
}
