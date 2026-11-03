// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../../../core/game/road/routes/route_scenery.dart';
import '../../../core/game/road/routes/route_stretch.dart';
import '../universal/prop.dart';

/// Places a wall run.
///
/// [limit], [base] and [len] bound the stretch as in [layOutScenery]. [run]
/// gives the wall style and range, and [side] the side of the road.
void layWalls(
  List<List<Prop>> slots,
  int limit,
  int base,
  int len,
  WallRun run,
  int side,
) {
  final first = base + (run.from * len).round();
  final last = math.min(base + (run.to * len).round(), limit);
  for (var i = first; i < last; i += 12) {
    slots[i].add(Prop(
      kind: PropKind.wall,
      anchor: i,
      side: side,
      offset: run.offset,
      width: 200,
      height: run.style.height,
      depth: math.min(12, last - i),
      tint: run.style.index,
    ));
  }
}
