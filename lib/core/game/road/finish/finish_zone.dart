// Project imports:
import '../config/road_config.dart';
import '../props/prop.dart';
import 'finish_config.dart';

/// Knows whether the finish is in play for the current frame.
///
/// The finish only exists on the last lap: props tagged
/// [PropPhase.finishOnly] are drawn while it is [on], and scenery it replaces
/// ([PropPhase.hiddenAtFinish]) is skipped.
class FinishZone {
  FinishZone({
    required this.line,
    required this.laps,
    required this.lapLength,
    required this.look,
  });

  /// Index of the first pad segment: the race ends here on the last lap.
  final int line;
  final int laps;

  /// Length of the whole track, which every lap loops over.
  final double lapLength;
  final FinishLook look;

  bool on = false;

  /// 0..1, how far the skyline has climbed over the horizon (Thika only).
  double rise = 0;

  void update(double trackPosition, double fullDistance) {
    const seg = RoadConfig.segmentLength;
    final ahead = (line * seg - trackPosition) / seg;
    final reach = look.lead + RoadConfig.decorDistance + 20;
    on = fullDistance >= (laps - 1) * lapLength && ahead < reach;
    rise = on && look.city
        ? (1 - ahead / FinishConfig.skylineRise).clamp(0.0, 1.0).toDouble()
        : 0.0;
  }

  bool shows(Prop p) => switch (p.phase) {
    PropPhase.always => true,
    PropPhase.finishOnly => on,
    PropPhase.hiddenAtFinish => !on,
  };

  /// Row of the pad this segment belongs to, or -1 when it is not on the pad.
  int padRow(int index) {
    final d = index - line;
    if (d < 0 || d >= look.padLength) return -1;
    return d ~/ FinishConfig.rowSegments;
  }

  bool isZebra(int row) => look.zebraCrossing && row >= look.chequerRows;
}
