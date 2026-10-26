import '../../../utils/pseudo_random.dart';
import '../../config/road_config.dart';
import '../prop.dart';

void layOutCity(List<List<Prop>> slots, int count) {
  for (final side in const [-1, 1]) {
    var i = (side < 0) ? 0 : 7;
    var lot = 0;
    while (i < count - RoadConfig.maxPropDepth) {
      final seed = (i * 2 + (side > 0 ? 1 : 0)) * 31 + 7;
      final gap = pseudoRandom(seed + 3);

      if (gap < 0.17) {
        i += 5 + (gap * 22).floor();
        lot++;
        continue;
      }

      final depth = 9 + (pseudoRandom(seed) * 14).floor();
      final storeys = 3 + (pseudoRandom(seed + 1) * 9).floor();
      slots[i].add(Prop(
        kind: PropKind.building,
        anchor: i,
        side: side,
        offset: 1.42 + 0.5 * pseudoRandom(seed + 5),
        width: 2600 + 3400 * pseudoRandom(seed + 6),
        height: storeys * 460.0,
        depth: depth,
        tint: lot + (side > 0 ? 1 : 0),
        detail: storeys.toDouble(),
      ));
      i += depth + 1 + (pseudoRandom(seed + 4) * 4).floor();
      lot++;
    }
  }

  for (var i = 12; i < count - 2; i += 16) {
    final side = (i ~/ 16).isEven ? -1 : 1;
    slots[i].add(Prop(
      kind: PropKind.lamp,
      anchor: i,
      side: side,
      offset: 1.16,
      width: 90,
      height: 1550,
    ));
  }
  for (var i = 40; i < count - 2; i += 97) {
    slots[i].add(Prop(
      kind: PropKind.sign,
      anchor: i,
      side: -1,
      offset: 1.24,
      width: 300,
      height: 1180,
      detail: pseudoRandom(i),
    ));
  }
}
