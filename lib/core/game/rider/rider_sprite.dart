// Flutter imports:
import 'package:flutter/rendering.dart';

// Project imports:
import 'art/user_bike_art_painter.dart';
import 'art/user_rider_art_painter.dart';
import 'look/rider_look.dart';
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
    this.useSuppliedArt = false,
  }) : rig = rig ?? RiderRig() {
    painter = RiderPainter(this.rig, look: look, view: view);
  }

  final RiderLook look;
  final RiderView view;
  final RiderRig rig;
  final bool useSuppliedArt;
  final RiderPose pose = RiderPose();
  late final UserRiderArtPainter _userRider = UserRiderArtPainter(look);
  late final UserBikeArtPainter _userBike = UserBikeArtPainter(look);
  late final RiderPainter painter;

  static const double width = RiderPainter.width;
  static const double height = RiderPainter.height;
  static const double riderLift = 12;

  /// Paints the selected artwork in the current pose.
  void paint(Canvas canvas) {
    if (!useSuppliedArt) {
      painter.paint(canvas, pose);
      return;
    }
    canvas
      ..save()
      ..translate(RiderPartPainter.midX + pose.shake, RiderPartPainter.groundY)
      ..rotate(pose.lean + pose.tumble)
      ..translate(-RiderPartPainter.midX, -RiderPartPainter.groundY + pose.bob);
    _userBike.paint(canvas, pose.perspective);
    _userRider.paintRacing(canvas, pose);
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
