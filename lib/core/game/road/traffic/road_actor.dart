// Dart imports:
import 'dart:ui';

/// Something that rides on the road, such as a rival.
abstract interface class RoadActor {
  double get distance;
  double get lateral;

  /// Paints the actor with its wheels on [ground].
  ///
  /// [yaw] is the angle in radians between the camera's line of sight and the
  /// actor's heading; it is positive when the actor is right of the camera.
  void paint(Canvas canvas, Offset ground, double height, double yaw);
}
