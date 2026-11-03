// Project imports:
import '../../../core/game/utils/pseudo_random.dart';
import '../universal/prop.dart';

/// Closes the trees over the road with a canopy every other segment.
void layCanopy(List<List<Prop>> slots, int from, int to) {
  for (var index = from; index < to; index += 2) {
    final seed = index * 11 + 4;
    slots[index].add(
      Prop(
        kind: PropKind.canopy,
        anchor: index,
        side: 1,
        offset: 0,
        width: 0,
        height: 1750 + 300 * pseudoRandom(seed),
        detail: pseudoRandom(seed + 1),
      ),
    );
  }
}
