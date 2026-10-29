// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../../utils/pseudo_random.dart';
import '../config/road_config.dart';
import '../props/prop.dart';
import '../scene_theme.dart';
import '../track/road_track.dart';
import 'finish_config.dart';

/// Dresses the end of the track as the finish plaza: chequered cones, a
/// crowd, city blocks on both sides and a building closing the street. All of
/// it only shows on the last lap (see FinishZone).
void layOutFinish(List<List<Prop>> slots, RoadTrack track, SceneTheme theme) {
  final line = track.baseCount;
  final from = math.max(1, line - FinishConfig.approach);
  _clearScenery(slots, line, from);
  _posts(slots, from, line);
  _crowd(slots, track, theme, from, line);
  _blocks(slots, track, theme, from, line);
  _endWall(slots, line);
}

bool _farRight(RoadTrack track, SceneTheme theme, int i) =>
    theme.dualCarriageway && track.segments[i].section.hasOpposite;

/// Ordinary scenery in (or reaching into) the plaza steps aside on the last
/// lap. Median guardrails and lamps stay, they are part of the road.
void _clearScenery(List<List<Prop>> slots, int line, int from) {
  final start = math.max(0, from - RoadConfig.maxPropDepth);
  for (var i = start; i < line; i++) {
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

void _posts(List<List<Prop>> slots, int from, int line) {
  final end = line + FinishConfig.padLength + 14;
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

void _crowd(
  List<List<Prop>> slots,
  RoadTrack track,
  SceneTheme theme,
  int from,
  int line,
) {
  final end = line + FinishConfig.padLength + 34;
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

void _blocks(
  List<List<Prop>> slots,
  RoadTrack track,
  SceneTheme theme,
  int from,
  int line,
) {
  final to = line + FinishConfig.wallAt - 6;
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

/// One wide building across the whole street, so the road ends at a city
/// block instead of running on into the start of the lap.
void _endWall(List<List<Prop>> slots, int line) {
  final i = line + FinishConfig.wallAt;
  slots[i].add(
    Prop(
      kind: PropKind.block,
      anchor: i,
      side: 1,
      offset: -7,
      width: 60000,
      height: 3400,
      depth: FinishConfig.wallDepth,
      tint: 0,
      detail: 7,
      phase: PropPhase.finishOnly,
    ),
  );
}
