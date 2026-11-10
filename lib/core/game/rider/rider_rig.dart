// Dart imports:
import 'dart:math' as math;

// Project imports:
import 'rider_frame.dart';

/// Size and lift settings of the rider and bike.
class RiderRig {
  static const double sizeFactor = 1.0;

  static const double laneFill = 0.62;
  static const double screenFill = 0.60;

  double scale = 1;

  /// Returns the rider height for a lane width and screen height.
  static double heightFor(double lanePx, double screenH) =>
      sizeFactor *
      math.min(
        lanePx * laneFill * RiderFrame.height /
            RiderFrame.width,
        screenH * screenFill,
      );
}
