// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../../../domain/models/level_rules.dart';
import '../../../domain/models/scene_id.dart';
import '../police/police_chase.dart';
import '../road/road_renderer.dart';
import '../road/scene_theme.dart';
import '../road/traffic/traffic_flow.dart';
import '../road/traffic/traffic_profile.dart';
import 'race_controller.dart';

/// The civilian traffic and police patrol of a scene.
class SceneTraffic {
  SceneTraffic._(this.flow, this.police);

  /// Builds the traffic and patrol for [scene] on its road and race, as the
  /// level's [rules] set them.
  factory SceneTraffic.of(
    SceneId scene,
    SceneTheme theme,
    RoadRenderer road,
    RaceController race,
    LevelRules rules,
  ) {
    final profile = TrafficProfile.of(scene).withCounts(
      sameWay: rules.trafficPerLap,
      oncoming: rules.oncomingPerLap,
      lapLength: race.lapLength,
    );
    return SceneTraffic._(
      TrafficFlow(
        profile: profile,
        lanes: theme.lanes,
        track: road.track,
        raceLength: race.raceLength,
        guarded: theme.dualCarriageway,
        trafficLanes: TrafficProfile.trafficLanes(scene, theme.lanes),
        oncomingLanes: TrafficProfile.oncomingLanes(scene, theme.lanes),
        seed: 7919 + scene.index * 31,
      ),
      PoliceChase(
        enabled: profile.police && rules.police,
        fineAmount: rules.policeFine,
        random: math.Random(4001 + scene.index),
      ),
    );
  }

  /// Civilian vehicles sharing the road with the race.
  final TrafficFlow flow;

  /// The police patrol that chases a speeding or reckless player.
  final PoliceChase police;
}
