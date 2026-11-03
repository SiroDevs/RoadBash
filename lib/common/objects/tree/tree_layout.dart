// Project imports:
import '../../../core/game/road/routes/route_scenery.dart';
import '../../../core/game/road/routes/route_stretch.dart';
import '../../../core/game/utils/pseudo_random.dart';
import '../universal/prop.dart';

/// Places one tree.
void layTree(List<List<Prop>> slots, int cursor, int seed, SideScenery span, int side) {
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
