// Project imports:
import '../../../utils/pseudo_random.dart';
import '../prop.dart';

void layOutSuburbs(List<List<Prop>> slots, int count) {
  for (final side in const [-1, 1]) {
    var cursor = (side < 0) ? 3 : 11;
    while (cursor < count - 2) {
      final seed = (cursor * 2 + (side > 0 ? 1 : 0)) * 17 + 5;
      final roll = pseudoRandom(seed);
      final kind = roll < 0.42
          ? PropKind.pine
          : (roll < 0.86 ? PropKind.broadleaf : PropKind.bush);
      final scale = kind == PropKind.bush
          ? 0.5 + 0.3 * pseudoRandom(seed + 2)
          : 0.8 + 0.6 * pseudoRandom(seed + 2);
      slots[cursor].add(Prop(
        kind: kind,
        anchor: cursor,
        side: side,
        offset: 1.7 + 2.9 * pseudoRandom(seed + 1),
        width: 620 * scale,
        height: (kind == PropKind.pine ? 2700 : 2050) * scale,
        detail: pseudoRandom(seed + 3),
      ));
      cursor += 9 + (pseudoRandom(seed + 4) * 12).floor();
    }
  }

  for (var i = 24; i < count - 2; i += 61) {
    slots[i].add(Prop(
      kind: PropKind.sign,
      anchor: i,
      side: -1,
      offset: 1.3,
      width: 260,
      height: 1050,
      detail: pseudoRandom(i + 2),
    ));
  }
}
