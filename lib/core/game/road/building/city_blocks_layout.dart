// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../../utils/pseudo_random.dart';
import '../scene_theme.dart';
import '../track/road_track.dart';
import '../universal/config/road_config.dart';
import '../universal/prop.dart';
import '../universal/road_side.dart';

/// City blocks lining Thika's run-in, all the way to the end of the lap (the
/// last segments are skipped: they wrap round behind the camera).
void layCityBlocks(
  List<List<Prop>> slots,
  RoadTrack track,
  SceneTheme theme,
  int from,
) {
  final to = track.count - RoadConfig.maxPropDepth - 4;
  for (final side in const [-1, 1]) {
    var index = from + 6 + (side < 0 ? 0 : 5);
    while (index < to) {
      final seed = (index * 2 + (side > 0 ? 1 : 0)) * 29 + 13;
      if (pseudoRandom(seed + 7) < 0.12) {
        index += 4;
        continue;
      }
      final depth = math.min(8 + (pseudoRandom(seed) * 8).floor(), to - index);
      final storeys = 4 + (pseudoRandom(seed + 1) * 6).floor();
      final setBack = side > 0 && isFarRight(track, theme, index) ? 4.1 : 1.65;
      slots[index].add(
        Prop(
          kind: PropKind.block,
          anchor: index,
          side: side,
          offset: setBack + 0.45 * pseudoRandom(seed + 2),
          width: 2600 + 3000 * pseudoRandom(seed + 3),
          height: storeys * 460.0,
          depth: depth,
          tint: index ~/ 7 + (side > 0 ? 1 : 0),
          detail: storeys.toDouble(),
          phase: PropPhase.finishOnly,
        ),
      );
      index += depth + 1 + (pseudoRandom(seed + 4) * 3).floor();
    }
  }
}
