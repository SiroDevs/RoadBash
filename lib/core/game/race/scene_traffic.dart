// Dart imports:
import 'dart:math' as math;

// Project imports:
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

  /// Builds the traffic and patrol for [scene] on its road and race.
  factory SceneTraffic.of(SceneId scene, SceneTheme theme, RoadRenderer road, RaceController race) {
    final profile = TrafficProfile.of(scene);
    return SceneTraffic._(
      TrafficFlow(
        profile: profile,
        lanes: theme.lanes,
        track: road.track,
        raceLength: race.raceLength,
        guarded: theme.dualCarriageway,
        seed: 7919 + scene.index * 31,
      ),
      PoliceChase(
        enabled: profile.police,
        random: math.Random(4001 + scene.index),
      ),
    );
  }

  /// Civilian vehicles sharing the road with the race.
  final TrafficFlow flow;

  /// The police patrol that chases a speeding or reckless player.
  final PoliceChase police;
}
