// Project imports:
import '../../../domain/models/traffic_offence.dart';
import '../road/road_renderer.dart';
import '../road/traffic/traffic_flow.dart';
import 'race_controller.dart';

/// Books an offence when the player rides on the oncoming side for too long.
///
/// Pulling out to overtake and returning to the left lanes is allowed. Staying
/// right of the yellow line for more than [overtakeSeconds] is an offence, and
/// each new stay on the wrong side can be booked again. It only goes on the
/// results; riding the wrong side endangers the rider, so no police come for it.
class WrongSideWatch {
  static const double overtakeSeconds = 4;
  static const double _lineMargin = 0.05;

  double _seconds = 0;
  bool _booked = false;

  /// Watches the player for one frame.
  void update(
    double dt,
    RaceController race,
    RoadRenderer road,
    TrafficFlow flow,
  ) {
    final line = -1 + 2 * flow.trafficLanes / flow.lanes;
    final wrongSide = flow.oncomingLanes > 0 && road.playerX > line + _lineMargin;
    if (!wrongSide || !race.running) {
      _seconds = 0;
      _booked = false;
      return;
    }
    _seconds += dt;
    if (_booked || _seconds < overtakeSeconds) return;
    _booked = true;
    race.commit(TrafficOffence.wrongSide);
  }
}
