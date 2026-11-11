// Project imports:
import '../../../domain/models/level_rules.dart';
import '../../../domain/models/scene_id.dart';
import '../police/police_chase.dart';
import '../road/config/vehicle_config.dart';
import '../road/road_renderer.dart';
import '../road/scene_theme.dart';
import '../road/traffic/road_traffic.dart';
import '../road/traffic/traffic_flow.dart';
import 'race_controller.dart';
import 'rival/rival_racer.dart';
import 'scene_traffic.dart';

/// Everything a race is made of: the road, the race rules, rivals and traffic.
class RaceWorld {
  RaceWorld._(this.road, this.race, this.racers, this.flow, this.police);

  /// Builds the world for a scene and wires the road to its traffic.
  factory RaceWorld.build({
    required SceneId scene,
    required LevelRules rules,
    required String playerName,
    required double briefingSeconds,
  }) {
    final theme = SceneTheme.of(scene);
    final laps = rules.lapsFor(scene, theme.laps);
    final road = RoadRenderer(theme, laps: laps)
      ..speedLimitKmh = rules.maxSpeedKmh
      ..nastyCrashesEnabled = rules.hospital;
    final race = RaceController(
      scene: scene,
      laps: laps,
      lapLength: road.track.length,
      runOut: road.track.runOutLength,
      playerName: playerName,
      rules: rules,
      rivals: RaceController.lineup(rules),
      briefingSeconds: briefingSeconds,
    );
    final speedLimit = rules.speedShare(VehicleConfig.topSpeedKmh);
    final racers = [
      for (var i = 0; i < race.rivals.length; i++)
        RivalRacer(
          race.rivals[i],
          i,
          theme.lanes,
          fieldSize: race.rivals.length,
          speedLimit: speedLimit,
        ),
    ];
    final traffic = SceneTraffic.of(scene, theme, road, race, rules);
    for (final racer in racers) {
      racer.peers = racers;
      racer.flow = traffic.flow;
    }
    road.traffic = RoadTraffic(
      [...racers, ...traffic.flow.cars, traffic.police.cop],
      theme.lanes,
    );
    return RaceWorld._(road, race, racers, traffic.flow, traffic.police);
  }

  final RoadRenderer road;
  final RaceController race;
  final List<RivalRacer> racers;
  final TrafficFlow flow;
  final PoliceChase police;

  /// Stumbles a runner on foot when traffic strikes near the fallen bike.
  void checkRunnerHazards() {
    for (final car in flow.cars) {
      if (!car.active) continue;
      final along = (car.distance - road.fullDistance).abs();
      final across = (car.lateral - road.crash.runX).abs();
      if (along < 140 && across < car.halfWidth + 0.12) {
        road.crash.stumble();
        break;
      }
    }
  }
}
