// Flutter imports:
import 'package:flutter/rendering.dart';

// Project imports:
import '../bike/art/road_bash_bike_painter.dart';
import 'art/road_bash_rider_painter.dart';
import 'look/rider_look.dart';
import 'rider_facing.dart';
import 'rider_painter.dart';
import 'rider_pose.dart';
import 'rider_rig.dart';
import 'view/rider_view.dart';

/// Rider and bike that can be drawn anywhere, such as a rival.
class RiderSprite {
  RiderSprite({
    this.look = RiderLook.main,
    RiderRig? rig,
    this.view = RiderView.rear,
    this.useRoadBashArt = false,
  }) : rig = rig ?? RiderRig() {
    painter = RiderPainter(this.rig, look: look, view: view);
  }

  final RiderLook look;
  final RiderView view;
  final RiderRig rig;
  final bool useRoadBashArt;
  final RiderPose pose = RiderPose();
  final RoadBashRiderPainter _roadBashRider = RoadBashRiderPainter();
  final RoadBashBikePainter _roadBashBike = RoadBashBikePainter();
  RiderFacing facing = RiderFacing.straight;
  late final RiderPainter painter;

  static const double width = RiderPainter.width;
  static const double height = RiderPainter.height;

  /// Paints the selected artwork in the current pose.
  void paint(Canvas canvas) {
    if (!useRoadBashArt) {
      painter.paint(canvas, pose);
      return;
    }
    canvas
      ..save()
      ..translate(RiderPartPainter.midX + pose.shake, RiderPartPainter.groundY)
      ..rotate(pose.lean + pose.tumble)
      ..translate(-RiderPartPainter.midX, -RiderPartPainter.groundY + pose.bob);
    switch (facing) {
      case RiderFacing.left:
        _roadBashBike.paintRearLeft(canvas);
        _roadBashRider.paintRearLeft(canvas);
        break;
      case RiderFacing.right:
        _roadBashBike.paintRearRight(canvas);
        _roadBashRider.paintRearRight(canvas);
        break;
      case RiderFacing.straight:
        _roadBashBike.paintRear(canvas);
        _roadBashRider.paintRear(canvas);
        break;
    }
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
