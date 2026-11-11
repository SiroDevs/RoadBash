// Dart imports:
import 'dart:math' as math;

/// Start-line slots: rivals line up abreast on both sides of the centred player.
abstract final class StartGrid {
  static const double spacing = 0.4;
  static const double outerLimit = 0.88;

  /// Sideways slot of rival [index] among [count], alternating left and right.
  static double lateralFor(int index, int count) {
    final rows = (count + 1) ~/ 2;
    final step = math.min(spacing, outerLimit / math.max(rows, 1));
    final side = index.isEven ? -1.0 : 1.0;
    return side * (index ~/ 2 + 1) * step;
  }
}
