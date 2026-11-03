// Project imports:
import '../../../../../common/objects/tree/jungle_tree_layout.dart';
import '../../../../../common/objects/universal/prop.dart';
import '../../../utils/pseudo_random.dart';
import 'jungle_sites_layout.dart';

/// Dense tropical growth: a close row of big trees and palms hugging the
/// road, a second row behind them and ferns in the gaps.
void layOutJungle(List<List<Prop>> slots, int count, int courseEnd) {
  for (final side in const [-1, 1]) {
    layJungleRow(slots, count, side, start: side < 0 ? 1 : 3, near: true);
    layJungleRow(slots, count, side, start: side < 0 ? 4 : 2, near: false);
  }

  layOutJungleSites(slots, courseEnd);

  for (var i = 30; i < count - 2; i += 83) {
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
