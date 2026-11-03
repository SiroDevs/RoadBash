// Project imports:
import '../universal/prop.dart';
import 'finish_config.dart';

/// Places the finish gantry posts along the pad.
void layPosts(List<List<Prop>> slots, int from, int line, FinishLook look) {
  final end = line + look.padLength + 14;
  for (var i = from; i < end; i += 3) {
    for (final side in const [-1, 1]) {
      slots[i].add(
        Prop(
          kind: PropKind.post,
          anchor: i,
          side: side,
          offset: 1.2,
          width: 55,
          height: 330,
          phase: PropPhase.finishOnly,
        ),
      );
    }
  }
}
