// GENERATED layer selection from the RoadBashRider Flutter Painter project.

// Dart imports:
import 'dart:ui';

// Project imports:
import 'layers/rear_crouch/rear_crouch_layer.dart';
import 'layers/rear_crouch_left/rear_crouch_left_layer.dart';
import 'layers/rear_crouch_right/rear_crouch_right_layer.dart';
import 'layers/running/running_layer.dart';

class RoadBashRiderPainter {
  static const double width = 120;
  static const double height = 170;
  static const Color color000000 = Color(0xFF000000);
  static const Color colorFFFFFF = Color(0xFFFFFFFF);
  static const Color colorED1C24 = Color(0xFFED1C24);

  final RoadBashRiderRearCrouchLayer _rear = RoadBashRiderRearCrouchLayer();
  final RoadBashRiderRearCrouchLeftLayer _left =
      RoadBashRiderRearCrouchLeftLayer();
  final RoadBashRiderRearCrouchRightLayer _right =
      RoadBashRiderRearCrouchRightLayer();
  final RoadBashRiderRunningLayer _running = RoadBashRiderRunningLayer();

  void paintRear(Canvas canvas) => _rear.paint(canvas);

  void paintRearLeft(Canvas canvas) => _left.paint(canvas);

  void paintRearRight(Canvas canvas) => _right.paint(canvas);

  void paintRunning(Canvas canvas) => _running.paint(canvas);
}
