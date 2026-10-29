// Project imports:
import '../track/road_section.dart';
import 'road_config.dart';

/// Where the median guardrails stand and how far a rider may lean on them.
///
/// Offsets are in road units (-1..1 is the carriageway, the same units the
/// road painter and props use).
abstract final class GuardrailConfig {
  static const double nearOffset = 1 + RoadConfig.shoulder + 0.03;
  static const double farOffset =
      1 + RoadConfig.shoulder + RoadConfig.medianWidth - 0.03;

  static const double barrierOffset =
      1 + RoadConfig.shoulder + RoadConfig.medianWidth * 0.35;

  static const double riderClearance = 0.08;

  static const int span = 4;

  static const double beamBottom = 190;
  static const double valleyBottom = 238;
  static const double valleyTop = 282;
  static const double beamTop = 330;
  static const double postHalfWidth = 24;

  /// Does this median get standing guardrails?
  static bool isDrawn(MedianKind kind) =>
      kind == MedianKind.guardrail || kind == MedianKind.planted;

  /// Furthest right the rider can go on this section, or null when nothing
  /// stands between the carriageway and the verge.
  static double? riderLimit(Section section) => switch (section.median) {
    MedianKind.guardrail || MedianKind.planted => nearOffset - riderClearance,
    MedianKind.barrier => barrierOffset - riderClearance,
    MedianKind.none => null,
  };
}
