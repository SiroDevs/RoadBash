// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../../../../common/objects/building/city_blocks_layout.dart';
import '../../../../common/objects/kiosk/kiosk_layout.dart';
import '../../../../common/objects/universal/prop.dart';
import '../config/road_config.dart';
import '../scene_theme.dart';
import '../track/road_track.dart';
import 'cone_layout.dart';
import 'crowd_layout.dart';
import 'finish_config.dart';
import 'post_layout.dart';

/// Dresses the finish of the last lap. Every scene gets chequered cones and a
/// crowd on its own road; Thika Road also eases into city blocks, because
/// Museum Hill leads into Nairobi. All of it only shows on the last lap (see
/// FinishZone).
void layOutFinish(List<List<Prop>> slots, RoadTrack track, SceneTheme theme) {
  final look = FinishConfig.lookFor(theme.id);
  final line = track.finishIndex;
  final from = math.max(1, line - FinishConfig.approach);
  if (look.city) {
    final cityFrom = math.max(1, line - FinishConfig.cityLead);
    _clearScenery(slots, track.count, cityFrom);
    layCityBlocks(slots, track, theme, cityFrom);
  }
  if (look.hasMarket) {
    _clearScenery(slots, track.count, from - 6);
    layOutKiosks(slots, line, look);
  }
  layPosts(slots, from, line, look);
  layLaneCones(slots, line, look);
  layCrowd(slots, track, theme, from, line, look);
}

/// Thika's own scenery from [from] to the end of the lap steps aside on the
/// last lap for the city blocks. Median guardrails and lamps stay, they are
/// part of the road.
void _clearScenery(List<List<Prop>> slots, int count, int from) {
  final start = math.max(0, from - RoadConfig.maxPropDepth);
  for (var i = start; i < count; i++) {
    slots[i] = [
      for (final p in slots[i])
        if (p.kind != PropKind.guardrail &&
            p.kind != PropKind.lamp &&
            p.anchor + p.depth >= from)
          p.withPhase(PropPhase.hiddenAtFinish)
        else
          p,
    ];
  }
}
