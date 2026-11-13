// Flutter imports:
import 'package:flutter/rendering.dart';

// Project imports:
import 'look/rider_look.dart';
import 'rider_artwork.dart';
import 'rider_frame.dart';
import 'rider_pose.dart';
import 'rig/front_rider.dart';
import 'sheet/bike_figure.dart';
import 'view/rider_view.dart';

/// Rider and bike that can be drawn anywhere, such as a rival.
class RiderSprite {
  RiderSprite({
    this.look = RiderLook.main,
    this.view = RiderView.rear,
  });

  final RiderLook look;
  final RiderView view;
  final RiderPose pose = RiderPose();
  late final BikeFigure _bike = BikeFigure(look);
  late final RiderArtwork _artwork = RiderArtwork(look);
  late final FrontRiderFigure _front = FrontRiderFigure(look);

  static const double bikeTurnShare = 1.0;
  static const double plantedFoot = 0.5;
  static const double width = RiderFrame.width;
  static const double height = RiderFrame.height;

  /// Paints the selected artwork in the current pose.
  void paint(Canvas canvas) {
    canvas
      ..save()
      ..translate(RiderFrame.midX + pose.shake, RiderFrame.groundY)
      ..rotate(pose.lean + pose.tumble)
      ..translate(-RiderFrame.midX, -RiderFrame.groundY + pose.bob);
    if (view == RiderView.front) {
      _paintFront(canvas);
    } else {
      _artwork.paint(
        canvas,
        facing: pose.facing,
        planted: pose.foot > plantedFoot,
      );
    }
    canvas.restore();
  }

  /// Paints the rider and bike seen from the front.
  void _paintFront(Canvas canvas) {
    final bikeYaw = pose.perspective * bikeTurnShare;
    _bike.paint(canvas, bikeYaw, steer: pose.steer, layer: BikeLayer.behind);
    _front.paint(canvas);
    _bike.paint(canvas, bikeYaw, steer: pose.steer, layer: BikeLayer.over);
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
