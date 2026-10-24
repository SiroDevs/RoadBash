// Dart imports:
import 'dart:math' as math;

/// Same breakpoints as Tupange: a layout is `small` up to [small], `medium`
/// up to [medium] and `large` above that.
abstract class AppBreakpoints {
  /// Max layout width for a small layout (phones in portrait).
  static const double small = 576;

  /// Max layout width for a medium layout (phones in landscape, tablets,
  /// narrow windows).
  static const double medium = 1000;

  /// Max layout width for a large layout (desktop and web windows).
  static const double large = 1400;

  /// RoadBash is a landscape-first game, so width alone is not enough: a phone
  /// held sideways is 850px wide but only 390px tall. Height is therefore
  /// turned into the width a comfortable 16:10 window of that height would
  /// have, and the smaller of the two decides the tier. Short windows land in
  /// a compact tier on their own, which is what keeps every screen visible.
  static const double comfortableAspect = 1.6;

  static double layoutWidth(double width, double height) {
    if (height <= 0) return width;
    return math.min(width, height * comfortableAspect);
  }
}
