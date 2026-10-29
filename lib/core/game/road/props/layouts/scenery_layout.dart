// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../../../utils/pseudo_random.dart';
import '../../routes/route_stretch.dart';
import '../prop.dart';

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
    _walls(slots, limit, base, len, wall, side);
  }
  if (span.service) _service(slots, first, last, side);

  var cursor = first + 1;
  while (cursor < last) {
    final seed = ((cursor * 2 + (side > 0 ? 1 : 0)) * 31 + stretchIndex * 7 + 5);
    if (span.lots > 0 && pseudoRandom(seed) < span.lots) {
      cursor += _building(slots, cursor, seed, span, side, stretchIndex) + 1;
      continue;
    }
    if (span.treeStep != null) {
      _tree(slots, cursor, seed, span, side);
      cursor += pickInt(span.treeStep!, pseudoRandom(seed + 4));
    } else {
      cursor += 5 + (pseudoRandom(seed + 4) * 6).floor();
    }
  }
}

/// Places a building and returns the next free position.
///
/// [cursor] is the segment to start at and [seed] drives its random size.
/// [span], [side] and [stretchIndex] are as in [layOutScenery].
int _building(
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

/// Places one tree.
void _tree(List<List<Prop>> slots, int cursor, int seed, SideScenery span, int side) {
  final kind = span.mix.pick(pseudoRandom(seed + 2));
  final scale = kind == PropKind.bush
      ? 0.5 + 0.3 * pseudoRandom(seed + 7)
      : 0.8 + 0.6 * pseudoRandom(seed + 7);
  final (width, height) = switch (kind) {
    PropKind.acacia => (900.0, 1500.0),
    PropKind.pine => (620.0, 2700.0),
    _ => (620.0, 2050.0),
  };
  slots[cursor].add(Prop(
    kind: kind,
    anchor: cursor,
    side: side,
    offset: pickIn(span.treeSetBack, pseudoRandom(seed + 8)),
    width: width * scale,
    height: height * scale,
    detail: pseudoRandom(seed + 9),
  ));
}

/// Places a wall run.
///
/// [limit], [base] and [len] bound the stretch as in [layOutScenery]. [run]
/// gives the wall style and range, and [side] the side of the road.
void _walls(
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

/// Places slip road lanes along a stretch.
void _service(List<List<Prop>> slots, int first, int last, int side) {
  for (var i = first; i < last; i += 24) {
    slots[i].add(Prop(
      kind: PropKind.slipRoad,
      anchor: i,
      side: side,
      offset: 1.2,
      width: 0,
      height: 0,
      depth: math.min(24, last - i),
    ));
  }
}
