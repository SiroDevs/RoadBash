// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../../../common/art/rider_frame.dart';

/// Size and lift settings of the rider and bike.
class RiderRig {
  static const double sizeFactor = 1.0;

  static const double laneFill = 0.62;
  static const double screenFill = 0.60;

  double scale = 1;

  static const double bigScreenScale = 0.75;
  static const double smallScreenScale = 1.4;

  /// Scale for the screen: down on square and landscape, up on portrait.
  static double screenScale(double screenW, double screenH) =>
      screenW >= screenH ? bigScreenScale : smallScreenScale;

  /// Returns the rider height for a lane width and the screen size.
  static double heightFor(double lanePx, double screenW, double screenH) =>
      sizeFactor *
      screenScale(screenW, screenH) *
      math.min(
        lanePx * laneFill * RiderFrame.height / RiderFrame.width,
        screenH * screenFill,
      );
}
