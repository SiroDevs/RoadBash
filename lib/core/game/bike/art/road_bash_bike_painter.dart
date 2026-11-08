// GENERATED layer selection from the RoadBashBike Flutter Painter project.

// Dart imports:
import 'dart:ui';

// Project imports:
import 'layers/rear_left_angle/rear_left_angle_layer.dart';
import 'layers/rear_right_angle/rear_right_angle_layer.dart';
import 'layers/rear_straight/rear_straight_layer.dart';

class RoadBashBikePainter {
  static const double width = 120;
  static const double height = 170;
  static const Color color000000 = Color(0xFF000000);
  static const Color colorFFFFFF = Color(0xFFFFFFFF);

  final RoadBashBikeRearStraightLayer _rear = RoadBashBikeRearStraightLayer();
  final RoadBashBikeRearLeftAngleLayer _left = RoadBashBikeRearLeftAngleLayer();
  final RoadBashBikeRearRightAngleLayer _right =
      RoadBashBikeRearRightAngleLayer();

  void paintRear(Canvas canvas) => _rear.paint(canvas);

  void paintRearLeft(Canvas canvas) => _left.paint(canvas);

  void paintRearRight(Canvas canvas) => _right.paint(canvas);
}
