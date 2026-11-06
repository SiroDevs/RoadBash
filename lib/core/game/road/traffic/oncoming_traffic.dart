// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../config/vehicle_config.dart';
import 'civilian_car.dart';
import 'civilian_palette.dart';
import 'lane_gap_check.dart';
import 'traffic_profile.dart';

/// Vehicles driving toward the player on the lanes right of the yellow line.
class OncomingTraffic {
  OncomingTraffic({
    required this.profile,
    required this.roadLanes,
    required this.firstLane,
    required this.laneCount,
    required this.firstIndex,
    required this.laneCenters,
    required this.raceLength,
    required this.random,
  }) : cars = List.generate(
         laneCount > 0 ? profile.oncomingPoolSize : 0,
         (position) => CivilianCar(firstIndex + position, oncoming: true),
       ),
       laneSpeeds = [
         for (var slot = 0; slot < laneCount; slot++)
           -_slotSpeed(profile, slot, laneCount, random),
       ],
       _gapCheck = LaneGapCheck(firstLane: firstLane, laneCount: laneCount);

  final TrafficProfile profile;
  final int roadLanes;
  final int firstLane;
  final int laneCount;
  final int firstIndex;
  final List<double> laneCenters;
  final double raceLength;
  final math.Random random;
  final List<CivilianCar> cars;
  final List<double> laneSpeeds;
  final LaneGapCheck _gapCheck;
  bool _seeded = false;
  double _requiredGap = 0;

  // Lane next to the yellow line is the fast one; the outer lane is the slow one.
  static double _slotSpeed(
    TrafficProfile profile,
    int slot,
    int laneCount,
    math.Random random,
  ) {
    final fastness = laneCount > 1 ? (laneCount - 1 - slot) / (laneCount - 1) : 0.5;
    final share =
        profile.minSpeed +
        (profile.maxSpeed - profile.minSpeed) * fastness +
        (random.nextDouble() - 0.5) * 0.03;
    return share * VehicleConfig.maxSpeed;
  }

  double get _finishLimit => raceLength - TrafficProfile.finishClear;

  /// Retires vehicles the player has passed and sends new ones from far ahead.
  void update(double playerDistance) {
    if (cars.isEmpty) return;
    final cutoff = playerDistance - TrafficProfile.behind;
    for (final car in cars) {
      if (car.active && car.distance < cutoff) car.park();
    }
    if (_seeded) {
      _spawnAtHorizon(playerDistance);
    } else {
      _seeded = true;
      _fillRoad(playerDistance);
    }
  }

  // Spreads the first vehicles over the road ahead of the start.
  void _fillRoad(double playerDistance) {
    var distance = playerDistance + TrafficProfile.startClear;
    final horizon = playerDistance + TrafficProfile.ahead;
    for (final car in cars) {
      if (distance > horizon || distance > _finishLimit) return;
      distance = _place(car, distance, playerDistance) + _requiredGap;
    }
  }

  // Adds a vehicle at the far end once the previous one has come closer.
  void _spawnAtHorizon(double playerDistance) {
    final horizon = playerDistance + TrafficProfile.ahead;
    if (horizon > _finishLimit) return;
    var farthest = -double.infinity;
    CivilianCar? spare;
    for (final car in cars) {
      if (car.active) {
        farthest = math.max(farthest, car.distance);
      } else {
        spare ??= car;
      }
    }
    if (spare == null || horizon - farthest < _requiredGap) return;
    _place(spare, horizon, playerDistance);
  }

  // Puts a vehicle on the road and returns where it was placed.
  double _place(CivilianCar car, double distance, double playerDistance) {
    final slot = _gapCheck.findSlot(
      cars: cars,
      laneSpeeds: laneSpeeds,
      firstChoice: firstLane + random.nextInt(laneCount),
      distance: distance,
      playerDistance: playerDistance,
      clearGap: profile.oncomingClearGap,
      push: profile.oncomingSpacing * 0.35,
      limit: _finishLimit,
    );
    final slotIndex = slot.lane - firstLane;
    car.place(
      kind: profile.pickKind(laneCount - 1 - slotIndex, laneCount, random),
      color: CivilianPalette.randomBody(random),
      accent: CivilianPalette.randomAccent(random),
      distance: slot.distance,
      lane: slot.lane,
      lateral: laneCenters[slot.lane],
      speed: laneSpeeds[slotIndex],
      laneWidth: 2 / roadLanes,
    );
    _requiredGap = profile.oncomingSpacing * (0.8 + 0.4 * random.nextDouble());
    return slot.distance;
  }
}
