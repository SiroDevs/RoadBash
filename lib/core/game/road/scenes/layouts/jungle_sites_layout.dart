// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../../mountain/mountain_layout.dart';
import '../../tree/canopy_layout.dart';
import '../../universal/prop.dart';
import '../jungle_zones.dart';

/// Dresses each jungle setting: mountain sides, the pass and the canopy.
void layOutJungleSites(List<List<Prop>> slots, int courseEnd) {
  for (final zone in jungleZones) {
    final from = (zone.from * courseEnd).round();
    final to = math.min((zone.to * courseEnd).round(), slots.length - 2);
    switch (zone.site) {
      case JungleSite.mountainRight:
        _clear(slots, from, to);
        layMountains(slots, from, to, 1, 4200);
      case JungleSite.mountainLeft:
        _clear(slots, from, to);
        layMountains(slots, from, to, -1, 4200);
      case JungleSite.pass:
        _clear(slots, from, to);
        layMountains(slots, from, to, -1, 7000, rock: 3, offset: 1.1);
        layMountains(slots, from, to, 1, 7000, rock: 4, offset: 1.1);
      case JungleSite.canopy:
        layCanopy(slots, from, to);
      case JungleSite.river:
        break;
    }
  }
}

/// Removes the trees and signs from a stretch that has a mountain or cliff.
void _clear(List<List<Prop>> slots, int from, int to) {
  for (var index = from; index < to; index++) {
    slots[index].removeWhere((prop) => prop.kind != PropKind.guardrail);
  }
}
