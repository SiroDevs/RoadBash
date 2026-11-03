// Project imports:
import '../../utils/pseudo_random.dart';
import '../universal/prop.dart';
import 'finish_config.dart';

/// Cones standing in the road itself around the finish, on the lane lines.
void layLaneCones(List<List<Prop>> slots, int line, FinishLook look) {
  const lanes = [-0.62, -0.12, 0.38, 0.8];
  final end = line + look.padLength + 36;
  for (var i = line - 24; i < end; i += 5) {
    final lane = lanes[(pseudoRandom(i + 5) * lanes.length).floor()];
    slots[i].add(
      Prop(
        kind: PropKind.post,
        anchor: i,
        side: lane < 0 ? -1 : 1,
        offset: lane.abs(),
        width: 55,
        height: 330,
        phase: PropPhase.finishOnly,
      ),
    );
  }
}
