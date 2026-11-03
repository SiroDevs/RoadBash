// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../universal/prop.dart';

/// Places slip road lanes along a stretch.
void laySlipRoad(List<List<Prop>> slots, int first, int last, int side) {
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
