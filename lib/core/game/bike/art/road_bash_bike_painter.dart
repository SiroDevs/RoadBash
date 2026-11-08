import 'dart:ui';

import '../../rider/look/rider_look.dart';
import '../../rider/rider_facing.dart';
import 'layers/rear_left_angle/rear_left_angle_layer.dart';
import 'layers/rear_right_angle/rear_right_angle_layer.dart';
import 'layers/rear_straight/rear_straight_layer.dart';

class RoadBashBikePainter {
  RoadBashBikePainter(RiderLook look)
    : _bodyFilter = _mapBlackAndWhite(
        dark: look.bike.panelDark,
        base: look.bike.panel,
      );

  static const double width = 120;
  static const double height = 170;
  static const Color color000000 = Color(0xFF000000);
  static const Color colorFFFFFF = Color(0xFFFFFFFF);

  final ColorFilter _bodyFilter;
  final RoadBashBikeRearStraightLayer _rear = RoadBashBikeRearStraightLayer();
  final RoadBashBikeRearLeftAngleLayer _left = RoadBashBikeRearLeftAngleLayer();
  final RoadBashBikeRearRightAngleLayer _right = RoadBashBikeRearRightAngleLayer();

  void paintRear(Canvas canvas, RiderFacing facing) {
    final layer = switch (facing) {
      RiderFacing.left => _left,
      RiderFacing.straight => _rear,
      RiderFacing.right => _right,
    };
    canvas.saveLayer(
      const Rect.fromLTWH(0, 0, width, height),
      Paint()..colorFilter = _bodyFilter,
    );
    layer.paint(canvas);
    canvas.restore();
  }

  static ColorFilter _mapBlackAndWhite({
    required Color dark,
    required Color base,
  }) => ColorFilter.matrix([
    (base.red - dark.red) / 255, 0, 0, 0, dark.red.toDouble(),
    (base.green - dark.green) / 255, 0, 0, 0, dark.green.toDouble(),
    (base.blue - dark.blue) / 255, 0, 0, 0, dark.blue.toDouble(),
    0, 0, 0, 1, 0,
  ]);
}
