// Dart imports:
import 'dart:math' as math;

abstract class AppBreakpoints {
  static const double small = 576;

  static const double medium = 1000;

  static const double large = 1400;

  static const double comfortableAspect = 1.6;

  static double layoutWidth(double width, double height) {
    if (height <= 0) return width;
    return math.min(width, height * comfortableAspect);
  }
}
