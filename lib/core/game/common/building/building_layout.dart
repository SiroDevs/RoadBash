// Project imports:
import '../../road/routes/route_scenery.dart';
import '../../road/routes/route_stretch.dart';
import '../../utils/pseudo_random.dart';
import '../universal/prop.dart';

/// Places a building and returns the next free position.
///
/// [cursor] is the segment to start at and [seed] drives its random size.
/// [span], [side] and [stretchIndex] are as in [layOutScenery].
int layBuilding(
  List<List<Prop>> slots,
  int cursor,
  int seed,
  SideScenery span,
  int side,
  int stretchIndex,
) {
  final depth = 7 + (pseudoRandom(seed + 1) * 14).floor();
  final storeys = pickInt(span.storeys, pseudoRandom(seed + 2));
  slots[cursor].add(Prop(
    kind: PropKind.building,
    anchor: cursor,
    side: side,
    offset: pickIn(span.setBack, pseudoRandom(seed + 5)),
    width: 2600 + 3400 * pseudoRandom(seed + 6),
    height: storeys * 450.0,
    depth: depth,
    tint: stretchIndex + cursor ~/ 9,
    detail: storeys.toDouble(),
    drop: span.drop,
  ));
  return depth + (pseudoRandom(seed + 3) * 4).floor();
}
