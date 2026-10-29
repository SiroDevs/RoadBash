import 'dart:ui';

import 'package:flutter/rendering.dart';

import 'look/rider_look.dart';
import 'rider_painter.dart';
import 'rider_pose.dart';
import 'rider_rig.dart';

class RiderSprite {
  RiderSprite({this.look = RiderLook.main, RiderRig? rig})
    : rig = rig ?? RiderRig() {
    painter = RiderPainter(this.rig, look: look);
  }

  final RiderLook look;
  final RiderRig rig;
  final RiderPose pose = RiderPose();
  late final RiderPainter painter;

  static const double width = RiderPainter.width;
  static const double height = RiderPainter.height;

  void paintAt(Canvas canvas, Offset ground, double scale) {
    canvas
      ..save()
      ..translate(
        ground.dx - RiderPartPainter.midX * scale,
        ground.dy - RiderPartPainter.groundY * scale,
      )
      ..scale(scale);
    painter.paint(canvas, pose);
    canvas.restore();
  }
}

class RiderSpritePainter extends CustomPainter {
  RiderSpritePainter(this.sprite);

  final RiderSprite sprite;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.height / RiderSprite.height;
    sprite.paintAt(
      canvas,
      Offset(size.width / 2, RiderPartPainter.groundY * scale),
      scale,
    );
  }

  @override
  bool shouldRepaint(RiderSpritePainter old) => true;
}
