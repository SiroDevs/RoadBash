// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../../../../common/objects/guardrail/guardrail_config.dart';
import '../config/vehicle_config.dart';
import '../track/road_track.dart';
import 'civilian_car.dart';
import 'civilian_palette.dart';
import 'lane_gap_check.dart';
import 'oncoming_traffic.dart';
import 'traffic_lookout.dart';
import 'traffic_profile.dart';

/// Keeps a fixed pool of civilian vehicles on the road ahead of the player.
///
/// Every lane has its own steady speed, so vehicles in one lane never catch
/// each other. A vehicle left behind the player is moved to the front of the
/// pack, and is placed in the lane that keeps it clear of the other vehicles.
/// Roads with a yellow line also carry [oncoming] traffic on their right lanes.
class TrafficFlow with TrafficLookout {
  TrafficFlow({
    required this.profile,
    required this.lanes,
    required this.track,
    required this.raceLength,
    required this.guarded,
    required this.trafficLanes,
    this.oncomingLanes = 0,
    int seed = 1,
  }) : _random = math.Random(seed),
       cars = List.generate(profile.poolSize, CivilianCar.new),
       laneCenters = [
         for (var k = 0; k < lanes; k++) -1 + (2 / lanes) * (k + 0.5),
       ] {
    oncoming = OncomingTraffic(
      profile: profile,
      roadLanes: lanes,
      firstLane: trafficLanes,
      laneCount: oncomingLanes,
      firstIndex: cars.length,
      laneCenters: laneCenters,
      raceLength: raceLength,
      random: _random,
    );
    cars.addAll(oncoming.cars);
  }

  static const double _pushShare = 0.35;

  final TrafficProfile profile;
  final int lanes;
  final RoadTrack track;
  final double raceLength;

  /// True on roads with a median guardrail that vehicles must keep clear of.
  final bool guarded;

  /// How many lanes from the left edge the traffic drives in; it keeps left.
  final int trafficLanes;

  /// How many lanes right of the yellow line carry traffic toward the player.
  final int oncomingLanes;

  final math.Random _random;
  final List<CivilianCar> _spent = [];
  late final LaneGapCheck _gapCheck = LaneGapCheck(
    firstLane: 0,
    laneCount: trafficLanes,
  );

  /// The vehicles driving toward the player.
  late final OncomingTraffic oncoming;

  @override
  final List<CivilianCar> cars;

  late final List<CivilianCar> _sameWay = cars.sublist(0, profile.poolSize);

  @override
  final List<double> laneCenters;

  late final List<double> laneSpeeds = [
    for (var k = 0; k < trafficLanes; k++)
      (profile.minSpeed +
              (profile.maxSpeed - profile.minSpeed) *
                  (trafficLanes > 1 ? k / (trafficLanes - 1) : 0.5) +
              (_random.nextDouble() - 0.5) * 0.03) *
          VehicleConfig.maxSpeed,
  ];

  /// Moves the vehicles and recycles the ones left behind.
  void update(double dt, double playerDistance, double playerZ) {
    for (final car in cars) {
      if (!car.active) continue;
      car.drive(dt);
      if (guarded) _hugLane(car, playerZ);
    }
    _recycle(playerDistance);
    oncoming.update(playerDistance);
  }

  /// Moves vehicles left behind, and any not yet on the road, to the front.
  void _recycle(double playerDistance) {
    final cutoff = playerDistance - TrafficProfile.behind;
    _spent.clear();
    for (final car in _sameWay) {
      if (!car.active || car.distance < cutoff) _spent.add(car);
    }
    if (_spent.isEmpty) return;
    for (final car in _spent) {
      car.park();
    }

    var front = playerDistance + TrafficProfile.startClear;
    for (final car in _sameWay) {
      if (car.active && car.distance > front) front = car.distance;
    }
    for (final car in _spent) {
      front += profile.spacing * (0.8 + 0.4 * _random.nextDouble());
      if (front > _finishLimit) {
        car.park();
      } else {
        front = _spawn(car, front, playerDistance);
      }
    }
  }

  double get _finishLimit => raceLength - TrafficProfile.finishClear;

  /// Puts a vehicle on the road and returns where it was placed.
  ///
  /// It takes the lane whose neighbours stay furthest away while the player
  /// rides past; when every lane is crowded it moves up the road a little.
  double _spawn(CivilianCar car, double distance, double playerDistance) {
    final slot = _gapCheck.findSlot(
      cars: cars,
      laneSpeeds: laneSpeeds,
      firstChoice: _random.nextInt(trafficLanes),
      distance: distance,
      playerDistance: playerDistance,
      clearGap: profile.clearGap,
      push: profile.spacing * _pushShare,
      limit: _finishLimit,
    );
    car.place(
      kind: profile.pickKind(slot.lane, trafficLanes, _random),
      color: CivilianPalette.randomBody(_random),
      accent: CivilianPalette.randomAccent(_random),
      distance: slot.distance,
      lane: slot.lane,
      lateral: laneCenters[slot.lane],
      speed: laneSpeeds[slot.lane],
      laneWidth: 2 / lanes,
    );
    return slot.distance;
  }

  /// Keeps a vehicle clear of the median guardrail.
  void _hugLane(CivilianCar car, double playerZ) {
    final section = track.at(car.distance + playerZ).section;
    final limit = GuardrailConfig.riderLimit(section);
    final centre = laneCenters[car.lane];
    car.target = limit == null
        ? centre
        : math.min(centre, limit - car.halfWidth - 0.08);
  }
}
