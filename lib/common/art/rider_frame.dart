// Dart imports:
import 'dart:math' as math;

/// The drawing box of the rider and bike, in design pixels.
abstract final class RiderFrame {
  static const double width = 120;
  static const double height = 170;
  static const double groundY = 166;
  static const double midX = width / 2;
  static const double maxLean = math.pi / 7;
}
