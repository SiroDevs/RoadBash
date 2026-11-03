// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../../utils/pseudo_random.dart';
import '../universal/config/road_config.dart';
import '../universal/prop.dart';

/// Raises a run of mountain boxes of varying height along one side.
void layMountains(
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
