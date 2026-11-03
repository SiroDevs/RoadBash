// Project imports:
import '../../../../common/objects/universal/prop.dart';
import '../../utils/pseudo_random.dart';
import '../scene_theme.dart';
import '../track/road_side.dart';
import '../track/road_track.dart';
import 'finish_config.dart';

/// Places the crowd beside the finish pad.
///
/// [from] is the first segment to fill, [line] the finish line segment and
/// [look] the finish style that sets the pad length.
void layCrowd(
  List<List<Prop>> slots,
  RoadTrack track,
  SceneTheme theme,
  int from,
  int line,
  FinishLook look,
) {
  final end = line + look.padLength + 34;
  for (var i = from + 4; i < end; i += 2) {
    for (final side in const [-1, 1]) {
      final seed = i * 7 + (side > 0 ? 3 : 0) + 11;
      if (pseudoRandom(seed) > 0.62) continue;
      final group = 1 + (pseudoRandom(seed + 1) * 3).floor();
      final base = side > 0 && isFarRight(track, theme, i) ? 1.28 : 1.34;
      for (var g = 0; g < group; g++) {
        slots[i].add(
          Prop(
            kind: PropKind.spectator,
            anchor: i,
            side: side,
            offset: base + 0.1 * pseudoRandom(seed + 2) + g * 0.075,
            width: 95,
            height: 580 + 100 * pseudoRandom(seed + g + 3),
            tint: (pseudoRandom(seed + g + 4) * 8).floor(),
            detail: pseudoRandom(seed + g + 9),
            phase: PropPhase.finishOnly,
          ),
        );
      }
    }
  }
}
