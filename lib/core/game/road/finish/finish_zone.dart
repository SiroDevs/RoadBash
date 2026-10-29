// Project imports:
import '../config/road_config.dart';
import '../props/prop.dart';
import 'finish_config.dart';

/// Tracks whether the finish plaza is in play for the current frame.
///
/// The plaza only exists on the last lap: props tagged [PropPhase.finishOnly]
/// are drawn while it is [on], and the ordinary scenery that would clash with
/// it ([PropPhase.hiddenAtFinish]) is skipped.
class FinishZone {
  FinishZone({required this.line, required this.laps, required this.lapLength});

  /// Index of the first pad segment, which is also the first run-out segment.
  final int line;
  final int laps;
  final double lapLength;

  bool on = false;

  /// 0..1, how far the skyline has climbed over the horizon.
  double rise = 0;

  /// First segment that is no longer drawn while the plaza is on.
  int get cutIndex =>
      line + FinishConfig.wallAt + FinishConfig.wallDepth + 2;

  void update(double trackPosition, double fullDistance) {
    const seg = RoadConfig.segmentLength;
    final ahead = (line * seg - trackPosition) / seg;
    const reach = FinishConfig.approach + 200 + 20;
    on = fullDistance >= (laps - 1) * lapLength && ahead < reach;
    rise = on
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
    if (d < 0 || d >= FinishConfig.padLength) return -1;
    return d ~/ FinishConfig.rowSegments;
  }
}
