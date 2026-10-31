// Project imports:
import '../../utils/pseudo_random.dart';
import '../props/prop.dart';
import 'finish_config.dart';

/// Lines both sides of the finish with shops and kiosks on flat ground.
void layOutKiosks(List<List<Prop>> slots, int line, FinishLook look) {
  final from = line - FinishConfig.approach;
  final end = line + look.padLength + 40;
  for (final side in const [-1, 1]) {
    var index = from + (side < 0 ? 0 : 4);
    while (index < end) {
      final seed = (index * 2 + (side > 0 ? 1 : 0)) * 17 + 5;
      final depth = 4 + (pseudoRandom(seed) * 4).floor();
      slots[index].add(
        Prop(
          kind: PropKind.kiosk,
          anchor: index,
          side: side,
          offset: 1.55 + 0.12 * pseudoRandom(seed + 1),
          width: 900 + 700 * pseudoRandom(seed + 2),
          height: 620 + 260 * pseudoRandom(seed + 3),
          depth: depth,
          tint: (pseudoRandom(seed + 4) * 6).floor(),
          detail: pseudoRandom(seed + 5),
          phase: PropPhase.finishOnly,
        ),
      );
      index += depth + 1 + (pseudoRandom(seed + 6) * 3).floor();
    }
  }
}
