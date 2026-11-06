// Project imports:
import 'civilian_car.dart';

/// Predicts whether a new vehicle would line up with traffic in every lane.
///
/// Each lane drives at a steady speed, so where vehicles will be side by side
/// is known the moment one is placed. A line only matters when traffic fills
/// every lane of the road; otherwise the rider can use a lane with no traffic.
class LaneWallCheck {
  const LaneWallCheck({required this.lanes, required this.roadLanes});

  static const double besideWindow = 1200;
  static const double lookaheadSeconds = 12;
  static const double sampleSeconds = 0.25;

  final int lanes;
  final int roadLanes;

  /// Returns the first lane from [first] on, wrapping round, where a vehicle at
  /// [distance] never lines up with the other lanes, or null if none is clear.
  int? freeLane({
    required List<CivilianCar> cars,
    required List<double> laneSpeeds,
    required int first,
    required double distance,
  }) {
    for (var offset = 0; offset < lanes; offset++) {
      final lane = (first + offset) % lanes;
      if (!_formsWall(cars, lane, distance, laneSpeeds[lane])) return lane;
    }
    return null;
  }

  /// True when a vehicle would have a neighbour in every other lane at once.
  bool _formsWall(
    List<CivilianCar> cars,
    int lane,
    double distance,
    double speed,
  ) {
    if (lanes < 2 || lanes < roadLanes) return false;
    final allLanes = (1 << lanes) - 1;
    for (
      var seconds = 0.0;
      seconds <= lookaheadSeconds;
      seconds += sampleSeconds
    ) {
      final position = distance + speed * seconds;
      var covered = 1 << lane;
      for (final car in cars) {
        if (!car.active || car.lane == lane) continue;
        final gap = car.distance + car.speed * seconds - position;
        if (gap.abs() < besideWindow) covered |= 1 << car.lane;
      }
      if (covered == allLanes) return true;
    }
    return false;
  }
}
