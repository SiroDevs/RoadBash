// Dart imports:
import 'dart:math' as math;

// Project imports:
import 'rider_painter.dart';

/// Size and lift settings of the rider and bike.
class RiderRig {
  static const double sizeFactor = 0.65;

  static const double laneFill = 0.62;
  static const double screenFill = 0.30;

  static const double stockBikeTop = 28;
  static const double stockRiderTop = -46;

  double scale = 1;

  /// Returns the rider height for a lane width and screen height.
  static double heightFor(double lanePx, double screenH) =>
      sizeFactor *
      math.min(
        lanePx * laneFill * RiderPartPainter.canvasHeight /
            RiderPartPainter.canvasWidth,
        screenH * screenFill,
      );

  double bikeHeight = 0;

  double riderHeight = 0;

  /// Total lift of the bike.
  double get bikeLift => bikeHeight;
  /// Total lift of the rider.
  double get riderLift => bikeHeight + riderHeight;

  /// Top position of the bike after lifting.
  double get bikeTop => stockBikeTop - bikeLift;
  /// Top position of the rider after lifting.
  double get riderTop => stockRiderTop - riderLift;
}
