// Dart imports:
import 'dart:ui';

// Project imports:
import '../rider_pose.dart';
import 'bike_anchors.dart';
import 'rider_view.dart';

/// Draws the rider (the person, not the bike) as seen from one view.
abstract class BodyViewPainter {
  /// The view this painter draws.
  RiderView get view;

  /// Paints the rider: helmet, torso, arms, gloves and legs. [anchors] says
  /// where the grips, pegs and seat of the bike are for [pose].
  void paint(Paint paint, Path path, Canvas canvas, RiderPose pose, BikeAnchors anchors);
}
