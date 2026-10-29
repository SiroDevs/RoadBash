// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../../utils/pseudo_random.dart';
import '../config/road_config.dart';
import '../props/prop.dart';
import '../scene_theme.dart';
import '../track/road_track.dart';
import 'finish_config.dart';

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
    _blocks(slots, track, theme, cityFrom);
  }
  _posts(slots, from, line, look);
  _laneCones(slots, line, look);
  _crowd(slots, track, theme, from, line, look);
}

bool _farRight(RoadTrack track, SceneTheme theme, int i) =>
    theme.dualCarriageway && track.segments[i].section.hasOpposite;

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

void _posts(List<List<Prop>> slots, int from, int line, FinishLook look) {
  final end = line + look.padLength + 14;
  for (var i = from; i < end; i += 3) {
    for (final side in const [-1, 1]) {
      slots[i].add(
        Prop(
          kind: PropKind.post,
          anchor: i,
          side: side,
          offset: 1.2,
          width: 55,
          height: 330,
          phase: PropPhase.finishOnly,
        ),
      );
    }
  }
}

/// Cones standing in the road itself around the finish, on the lane lines.
void _laneCones(List<List<Prop>> slots, int line, FinishLook look) {
  const lanes = [-0.62, -0.12, 0.38, 0.8];
  final end = line + look.padLength + 36;
  for (var i = line - 24; i < end; i += 5) {
    final x = lanes[(pseudoRandom(i + 5) * lanes.length).floor()];
    slots[i].add(
      Prop(
        kind: PropKind.post,
        anchor: i,
        side: x < 0 ? -1 : 1,
        offset: x.abs(),
        width: 55,
        height: 330,
        phase: PropPhase.finishOnly,
      ),
    );
  }
}

void _crowd(
  List<List<Prop>> slots,
  RoadTrack track,
  SceneTheme theme,
  int from,
  int line,
  FinishLook look,
) {
  final end = line + look.padLength + 34;
  for (var i = from + 4; i < end; i += 2) {
    for (final side in const [-1, 1]) {
      final seed = i * 7 + (side > 0 ? 3 : 0) + 11;
      if (pseudoRandom(seed) > 0.62) continue;
      final group = 1 + (pseudoRandom(seed + 1) * 3).floor();
      final base = side > 0 && _farRight(track, theme, i) ? 1.28 : 1.34;
      for (var g = 0; g < group; g++) {
        slots[i].add(
          Prop(
            kind: PropKind.spectator,
            anchor: i,
            side: side,
            offset: base + 0.1 * pseudoRandom(seed + 2) + g * 0.075,
            width: 95,
            height: 580 + 100 * pseudoRandom(seed + g + 3),
            tint: (pseudoRandom(seed + g + 4) * 8).floor(),
            detail: pseudoRandom(seed + g + 9),
            phase: PropPhase.finishOnly,
          ),
        );
      }
    }
  }
}

/// City blocks lining Thika's run-in, all the way to the end of the lap (the
/// last segments are skipped: they wrap round behind the camera).
void _blocks(
  List<List<Prop>> slots,
  RoadTrack track,
  SceneTheme theme,
  int from,
) {
  final to = track.count - RoadConfig.maxPropDepth - 4;
  for (final side in const [-1, 1]) {
    var i = from + 6 + (side < 0 ? 0 : 5);
    while (i < to) {
      final seed = (i * 2 + (side > 0 ? 1 : 0)) * 29 + 13;
      if (pseudoRandom(seed + 7) < 0.12) {
        i += 4;
        continue;
      }
      final depth = math.min(8 + (pseudoRandom(seed) * 8).floor(), to - i);
      final storeys = 4 + (pseudoRandom(seed + 1) * 6).floor();
      final setBack = side > 0 && _farRight(track, theme, i) ? 4.1 : 1.65;
      slots[i].add(
        Prop(
          kind: PropKind.block,
          anchor: i,
          side: side,
          offset: setBack + 0.45 * pseudoRandom(seed + 2),
          width: 2600 + 3000 * pseudoRandom(seed + 3),
          height: storeys * 460.0,
          depth: depth,
          tint: i ~/ 7 + (side > 0 ? 1 : 0),
          detail: storeys.toDouble(),
          phase: PropPhase.finishOnly,
        ),
      );
      i += depth + 1 + (pseudoRandom(seed + 4) * 3).floor();
    }
  }
}
