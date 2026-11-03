// Dart imports:
import 'dart:ui';

// Project imports:
import '../rider_pose.dart';
import 'bike_anchors.dart';
import 'rider_view.dart';

/// Draws the bike as seen from one view.
///
/// The bike is drawn in three layers around the rider, so that the rider can
/// sit inside it: parts behind the rider, parts in front of the rider (tank,
/// fairing, tail) and parts above everything.
abstract class BikeViewPainter {
  /// The view this painter draws.
  RiderView get view;

  /// Paints the shadow on the ground, before anything else.
  void paintShadow(Canvas canvas, RiderPose pose);

  /// Paints the parts the rider hides, such as the far handlebar or wheel.
  void paintBehindRider(Paint paint, Path path, Canvas canvas, RiderPose pose);

  /// Paints the parts that cover the rider, such as the tank and fairing.
  void paintInFrontOfRider(Paint paint, Path path, Canvas canvas, RiderPose pose);

  /// Paints the parts drawn over everything, such as the near wheel.
  void paintOverRider(Paint paint, Path path, Canvas canvas, RiderPose pose);

  /// Returns where the rider attaches to the bike for [pose].
  BikeAnchors anchors(RiderPose pose);
}
