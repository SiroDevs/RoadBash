// Dart imports:
import 'dart:ui';

/// Layout numbers for the finish plaza that closes every race, in segments
/// unless noted. The line sits where the lap's own road ends; the run-out is
/// extra flat road after it, so the rider coasts into the plaza instead of
/// seeing the start of the lap again.
abstract final class FinishConfig {
  /// Cones, crowd and city blocks start this far before the line.
  static const int approach = 64;

  /// The chequered pad across the road: rows of [rowSegments] segments.
  static const int padRows = 6;
  static const int rowSegments = 2;
  static const int padColumns = 14;
  static const int padLength = padRows * rowSegments;

  /// Flat road laid after the line.
  static const int runOut = 90;

  /// Where the building that closes the street stands, counted from the line.
  static const int wallAt = 60;
  static const int wallDepth = 4;

  /// The skyline starts climbing over the horizon this far before the line.
  static const int skylineRise = 120;

  /// City blocks lining the plaza: near-black and pale blue faces, like the
  /// classic finish street.
  static const List<Color> blockColors = [
    Color(0xFF1B1F2B),
    Color(0xFF8FA6C9),
    Color(0xFF2B3550),
    Color(0xFF6F7C99),
    Color(0xFF353A47),
    Color(0xFFA9B8D2),
  ];
}
