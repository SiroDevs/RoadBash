// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../road/config/vehicle_config.dart';
import '../road/road_renderer.dart';
import 'race_controller.dart';
import 'rival_racer.dart';
import 'rival_sight.dart';

/// Gathers what a rival can see: the player and the nearest rival ahead.
class RivalLookout {
  final RivalSight _sight = RivalSight();

  /// Refreshes the sight for [self] from the race, the road and its peers.
  RivalSight look(RivalRacer self, RaceController race, RoadRenderer road) {
    final reference = math.max(self.speed, VehicleConfig.maxSpeed * 0.3);
    _sight
      ..ownDistance = self.ridden
      ..ownSpeed = self.speed
      ..ownLateral = self.lateral
      ..playerDistance = road.fullDistance
      ..playerSpeed = road.speed
      ..playerLateral = road.playerX
      ..raceLength = race.raceLength
      ..peerGapSeconds = null;
    for (final other in self.peers) {
      final gap = other.ridden - self.ridden;
      final seconds = gap / reference;
      final nearest = _sight.peerGapSeconds;
      if (identical(other, self) || gap <= 0) continue;
      if ((other.lateral - self.lateral).abs() > 0.45) continue;
      if (nearest != null && seconds >= nearest) continue;
      _sight
        ..peerGapSeconds = seconds
        ..peerLateral = other.lateral;
    }
    return _sight;
  }
}
