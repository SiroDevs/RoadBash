// Dart imports:
import 'dart:math' as math;

/// Start-line slots: rivals line up abreast on both sides of the centred player.
abstract final class StartGrid {
  static const double spacing = 0.4;
  static const double outerLimit = 0.88;
  static const double packedSpacing = 0.2;
  static const double innerLimit = 0.25;

  /// Sideways slot of rival [index] among [count], alternating left and right.
  static double lateralFor(int index, int count) {
    final rows = (count + 1) ~/ 2;
    final step = math.min(spacing, outerLimit / math.max(rows, 1));
    final side = index.isEven ? -1.0 : 1.0;
    return side * (index ~/ 2 + 1) * step;
  }

  /// Lateral position rival [index] of [count] settles into after the start.
  ///
  /// It stays on the side it started from and keeps its order from the centre,
  /// so rivals never cross each other or the player while pulling away. A side
  /// with more riders than lanes packs the extra riders in beside the outer lane.
  static double settledFor(int index, int count, int lanes) {
    final width = 2 / lanes;
    final lanesPerSide = math.max(1, lanes ~/ 2);
    final firstLane = lanes.isOdd ? width : width / 2;
    final outerLane = firstLane + width * (lanesPerSide - 1);
    final ridersOnSide = (count + (index.isEven ? 1 : 0)) ~/ 2;
    final fromCentre = index ~/ 2;
    final room = math.max(0.0, outerLane - innerLimit);
    final spacing = math.min(
      packedSpacing,
      room / math.max(ridersOnSide - 1, 1),
    );
    final offset = ridersOnSide <= lanesPerSide
        ? firstLane + width * fromCentre
        : outerLane - spacing * (ridersOnSide - 1 - fromCentre);
    return (index.isEven ? -1.0 : 1.0) * offset;
  }
}
