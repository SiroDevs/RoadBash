// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/rendering.dart';

// Project imports:
import 'look/rider_look.dart';
import 'rider_painter.dart';
import 'rider_pose.dart';
import 'rider_profile.dart';
import 'rider_rig.dart';

/// Rider and bike that can be drawn anywhere, such as a rival.
class RiderSprite {
  RiderSprite({this.look = RiderLook.main, RiderRig? rig})
    : rig = rig ?? RiderRig() {
    painter = RiderPainter(this.rig, look: look);
  }

  final RiderLook look;
  final RiderRig rig;
  final RiderPose pose = RiderPose();
  late final RiderPainter painter;
  late final RiderProfile profile = RiderProfile(look);

  static const double _sideStart = 0.26;
  static const double _sideFull = 0.34;
  static const double _narrowest = 0.46;
  static const double _turnStart = 0.3;
  static const double _turnEnd = 1.25;

  static const double width = RiderPainter.width;
  static const double height = RiderPainter.height;

  /// Paints the sprite with its wheels on the ground point.
  ///
  /// [yaw] is the angle between the camera's line of sight and the bike's
  /// heading. Small angles show the rear view; larger ones turn the bike to
  /// a side view that faces the middle of the road.
  void paintAt(
    Canvas canvas,
    Offset ground,
    double scale, {
    double yaw = 0,
  }) {
    final side = ((yaw.abs() - _sideStart) / (_sideFull - _sideStart))
        .clamp(0.0, 1.0)
        .toDouble();
    canvas
      ..save()
      ..translate(
        ground.dx - RiderPartPainter.midX * scale,
        ground.dy - RiderPartPainter.groundY * scale,
      )
      ..scale(scale);
    if (side < 1) _blend(canvas, 1 - side, () => painter.paint(canvas, pose));
    if (side > 0) {
      _blend(canvas, side, () => _paintSide(canvas, yaw));
    }
    canvas.restore();
  }

  /// Paints the side view, narrowed to suit how far the bike is turned.
  void _paintSide(Canvas canvas, double yaw) {
    final turn = ((yaw.abs() - _turnStart) / (_turnEnd - _turnStart))
        .clamp(0.0, 1.0)
        .toDouble();
    final eased = turn * turn * (3 - 2 * turn);
    final squeeze = _narrowest + (1 - _narrowest) * eased;
    canvas
      ..save()
      ..translate(RiderPartPainter.midX, RiderPartPainter.groundY)
      ..scale(yaw > 0 ? -squeeze : squeeze, 1);
    profile.paint(canvas, pose);
    canvas.restore();
  }

  /// Runs [draw], fading it when [opacity] is below one.
  void _blend(Canvas canvas, double opacity, VoidCallback draw) {
    if (opacity >= 1) {
      draw();
      return;
    }
    canvas.saveLayer(null, Paint()..color = Color.fromRGBO(0, 0, 0, opacity));
    draw();
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
      Offset(size.width / 2, RiderPartPainter.groundY * scale),
      scale,
    );
  }

  @override
  bool shouldRepaint(RiderSpritePainter old) => true;
}
