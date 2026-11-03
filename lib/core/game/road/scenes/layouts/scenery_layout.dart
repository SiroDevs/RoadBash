// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../../../../../common/objects/building/building_layout.dart';
import '../../../../../common/objects/slip_road/slip_road_layout.dart';
import '../../../../../common/objects/tree/tree_layout.dart';
import '../../../../../common/objects/universal/prop.dart';
import '../../../../../common/objects/wall/wall_layout.dart';
import '../../../utils/pseudo_random.dart';
import '../../routes/route_stretch.dart';

/// Places the side scenery of one stretch.
///
/// [slots] holds the props of each segment and [limit] is the last usable
/// segment. [base] and [len] give the stretch's first segment and length.
/// [span] describes the scenery, [side] is -1 for left or 1 for right, and
/// [stretchIndex] varies the building tints.
void layOutScenery(
  List<List<Prop>> slots,
  int limit,
  int base,
  int len,
  SideScenery span,
  int side,
  int stretchIndex,
) {
  final first = base + (span.from * len).round();
  final last = math.min(base + (span.to * len).round(), limit);
  for (final wall in span.walls) {
    layWalls(slots, limit, base, len, wall, side);
  }
  if (span.service) laySlipRoad(slots, first, last, side);

  var cursor = first + 1;
  while (cursor < last) {
    final seed = ((cursor * 2 + (side > 0 ? 1 : 0)) * 31 + stretchIndex * 7 + 5);
    if (span.lots > 0 && pseudoRandom(seed) < span.lots) {
      cursor += layBuilding(slots, cursor, seed, span, side, stretchIndex) + 1;
      continue;
    }
    if (span.treeStep != null) {
      layTree(slots, cursor, seed, span, side);
      cursor += pickInt(span.treeStep!, pseudoRandom(seed + 4));
    } else {
      cursor += 5 + (pseudoRandom(seed + 4) * 6).floor();
    }
  }
}
