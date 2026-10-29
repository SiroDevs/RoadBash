// Project imports:
import '../track/road_section.dart';
import 'road_config.dart';

/// Where the median guardrails stand and how far a rider may lean on them.
///
/// Offsets are in road units (-1..1 is the carriageway, the same units the
/// road painter and props use).
abstract final class GuardrailConfig {
  /// Rail on the rider's side of the median, and the one on the far side.
  static const double nearOffset = 1 + RoadConfig.shoulder + 0.03;
  static const double farOffset =
      1 + RoadConfig.shoulder + RoadConfig.medianWidth - 0.03;

  /// Concrete barrier medians are painted flat; this is its near edge.
  static const double barrierOffset =
      1 + RoadConfig.shoulder + RoadConfig.medianWidth * 0.35;

  /// Half the width of the bike, so the rider's side touches the rail rather
  /// than their centre line.
  static const double riderClearance = 0.08;

  /// Segments covered by one rail prop (one post per span, ~2 m apart).
  static const int span = 4;

  // Heights above the road, in world units.
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
