// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../../../utils/pseudo_random.dart';
import '../../config/road_config.dart';
import '../../terrain/jungle_zones.dart';
import '../prop.dart';

/// Dresses each jungle setting: mountain sides, the pass and the canopy.
void layOutJungleSites(List<List<Prop>> slots, int courseEnd) {
  for (final zone in jungleZones) {
    final from = (zone.from * courseEnd).round();
    final to = math.min((zone.to * courseEnd).round(), slots.length - 2);
    switch (zone.site) {
      case JungleSite.mountainRight:
        _clear(slots, from, to);
        _mountains(slots, from, to, 1, 4200);
      case JungleSite.mountainLeft:
        _clear(slots, from, to);
        _mountains(slots, from, to, -1, 4200);
      case JungleSite.pass:
        _clear(slots, from, to);
        _mountains(slots, from, to, -1, 7000, rock: 3, offset: 1.1);
        _mountains(slots, from, to, 1, 7000, rock: 4, offset: 1.1);
      case JungleSite.canopy:
        _canopy(slots, from, to);
      case JungleSite.river:
        break;
    }
  }
}

/// Removes the trees and signs from a stretch that has a mountain or cliff.
void _clear(List<List<Prop>> slots, int from, int to) {
  for (var index = from; index < to; index++) {
    slots[index].removeWhere((prop) => prop.kind != PropKind.guardrail);
  }
}

/// Raises a run of mountain boxes of varying height along one side.
void _mountains(
  List<List<Prop>> slots,
  int from,
  int to,
  int side,
  double tallest, {
  int? rock,
  double offset = 1.16,
}) {
  var index = from;
  while (index < to) {
    final seed = index * 13 + (side > 0 ? 7 : 3);
    final depth = math.min(6 + (pseudoRandom(seed) * 5).floor(), RoadConfig.maxPropDepth);
    slots[index].add(
      Prop(
        kind: PropKind.mountain,
        anchor: index,
        side: side,
        offset: offset + 0.04 * pseudoRandom(seed + 1),
        width: 3600,
        height: tallest * (0.75 + 0.45 * pseudoRandom(seed + 2)),
        depth: depth,
        tint: rock ?? (pseudoRandom(seed + 3) * 3).floor(),
        detail: rock == null ? pseudoRandom(seed + 4) : (side > 0 ? 0.5 + 0.5 * pseudoRandom(seed + 4) : 0.2 * pseudoRandom(seed + 4)),
      ),
    );
    index += depth;
  }
}

/// Closes the trees over the road with a canopy every other segment.
void _canopy(List<List<Prop>> slots, int from, int to) {
  for (var index = from; index < to; index += 2) {
    final seed = index * 11 + 4;
    slots[index].add(
      Prop(
        kind: PropKind.canopy,
        anchor: index,
        side: 1,
        offset: 0,
        width: 0,
        height: 1750 + 300 * pseudoRandom(seed),
        detail: pseudoRandom(seed + 1),
      ),
    );
  }
}
