// Dart imports:
import 'dart:math' as math;

// Project imports:
import 'rider_painter.dart';

class RiderRig {
  static const double sizeFactor = 0.65;

  static const double laneFill = 0.62;
  static const double screenFill = 0.30;

  static const double stockBikeTop = 28;
  static const double stockRiderTop = -46;

  double scale = 1;

  static double heightFor(double lanePx, double screenH) =>
      sizeFactor *
      math.min(
        lanePx * laneFill * RiderPartPainter.canvasHeight /
            RiderPartPainter.canvasWidth,
        screenH * screenFill,
      );

  double bikeHeight = 0;

  double riderHeight = 0;

  double get bikeLift => bikeHeight;
  double get riderLift => bikeHeight + riderHeight;

  double get bikeTop => stockBikeTop - bikeLift;
  double get riderTop => stockRiderTop - riderLift;
}
