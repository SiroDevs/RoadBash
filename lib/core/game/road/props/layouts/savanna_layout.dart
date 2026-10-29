// Project imports:
import '../../../utils/pseudo_random.dart';
import '../prop.dart';

/// Open dry country: scattered flat-topped acacias, thorn bushes and
/// boulders, with plenty of empty space between them.
void layOutSavanna(List<List<Prop>> slots, int count) {
  for (final side in const [-1, 1]) {
    var i = side < 0 ? 4 : 13;
    while (i < count - 2) {
      final seed = (i * 2 + (side > 0 ? 1 : 0)) * 19 + 3;
      final r = pseudoRandom(seed);
      final kind = r < 0.34
          ? PropKind.acacia
          : (r < 0.70 ? PropKind.bush : PropKind.rock);
      final scale = switch (kind) {
        PropKind.acacia => 0.9 + 0.7 * pseudoRandom(seed + 2),
        PropKind.rock => 0.5 + 0.7 * pseudoRandom(seed + 2),
        _ => 0.5 + 0.4 * pseudoRandom(seed + 2),
      };
      slots[i].add(Prop(
        kind: kind,
        anchor: i,
        side: side,
        offset: 1.5 + 3.8 * pseudoRandom(seed + 1),
        width: (kind == PropKind.rock ? 520 : 640) * scale,
        height: scale *
            switch (kind) {
              PropKind.acacia => 2600.0,
              PropKind.rock => 700.0,
              _ => 1500.0,
            },
        detail: pseudoRandom(seed + 3),
      ));
      i += 8 + (pseudoRandom(seed + 4) * 16).floor();
    }
  }

  for (var i = 28; i < count - 2; i += 77) {
    slots[i].add(Prop(
      kind: PropKind.sign,
      anchor: i,
      side: 1,
      offset: 1.25,
      width: 240,
      height: 950,
      detail: pseudoRandom(i + 2),
    ));
  }
}
