// Project imports:
import '../utils/scenery_shapes.dart';
import 'road_config.dart';
import 'road_prop.dart';
import 'thika_zones.dart';

/// Lays out Thika Rd's roadside once per race.
void layOutThikaRoad(List<List<Prop>> slots, int count, List<int> starts) {
  if (starts.isEmpty) starts = const [0];
  _verges(slots, count, starts);
  _lamps(slots, count);
  _span(slots, count, starts);
}

void _verges(List<List<Prop>> slots, int count, List<int> starts) {
  for (final side in const [-1, 1]) {
    var i = side < 0 ? 2 : 6;
    while (i < count - RoadConfig.maxPropDepth) {
      final zone = thikaZones[thikaZoneAt(i, starts)];
      final seed = (i * 2 + (side > 0 ? 1 : 0)) * 29 + 11;

      if (pseudoRandom(seed) < zone.lot) {
        final depth = 8 + (pseudoRandom(seed + 1) * 14).floor();
        final storeys = zone.storeys.$1 +
            (pseudoRandom(seed + 2) * (zone.storeys.$2 - zone.storeys.$1 + 1))
                .floor();
        slots[i].add(Prop(
          kind: PropKind.building,
          anchor: i,
          side: side,
          offset: pickIn(zone.setBack, pseudoRandom(seed + 3)),
          width: 2400 + 3600 * pseudoRandom(seed + 4),
          height: storeys * 450.0,
          depth: depth,
          tint: i ~/ 7 + (side > 0 ? 1 : 0),
          detail: storeys.toDouble(),
        ));
        i += depth + 1 + (pseudoRandom(seed + 5) * 5).floor();
        continue;
      }

      final r = pseudoRandom(seed + 6);
      final kind = r < zone.pines
          ? PropKind.pine
          : (r < 0.88 ? PropKind.broadleaf : PropKind.bush);
      final scale = kind == PropKind.bush
          ? 0.5 + 0.3 * pseudoRandom(seed + 7)
          : 0.8 + 0.6 * pseudoRandom(seed + 7);
      slots[i].add(Prop(
        kind: kind,
        anchor: i,
        side: side,
        offset: pickIn(zone.treeSetBack, pseudoRandom(seed + 8)),
        width: 620 * scale,
        height: (kind == PropKind.pine ? 2700 : 2050) * scale,
        detail: pseudoRandom(seed + 9),
      ));
      final span = zone.treeStep.$2 - zone.treeStep.$1;
      i += zone.treeStep.$1 + (pseudoRandom(seed + 10) * span).floor();
    }
  }
}

/// Street lights down the median, evenly spaced as a speed reference.
void _lamps(List<List<Prop>> slots, int count) {
  for (var i = 12; i < count - 2; i += 18) {
    slots[i].add(Prop(
      kind: PropKind.lamp,
      anchor: i,
      side: (i ~/ 18).isEven ? -1 : 1,
      offset: 1.16,
      width: 90,
      height: 1550,
    ));
  }
}

/// Things that cross the carriageway: place-name gantries at the start of
/// each stretch and at the finish, footbridges, and the flyovers.
void _span(List<List<Prop>> slots, int count, List<int> starts) {
  bool nearStart(int i) => starts.any((s) => i >= s - 14 && i <= s + 24);

  for (var z = 0; z < starts.length && z < thikaSignLabels.length; z++) {
    slots[starts[z] + 14].add(Prop(
      kind: PropKind.gantry,
      anchor: starts[z] + 14,
      side: 1,
      offset: 1.2,
      width: 0,
      height: 2500,
      tint: z,
    ));
  }
  // The finish line is the lap join, so the last sign sits just before it.
  slots[count - 8].add(Prop(
    kind: PropKind.gantry,
    anchor: count - 8,
    side: 1,
    offset: 1.2,
    width: 0,
    height: 2500,
    tint: 3,
  ));

  final flyoverAt = <int>{
    for (final (z, off) in thikaFlyovers)
      if (z < starts.length && starts[z] + off < count - 20) starts[z] + off,
  };

  for (var z = 0; z < starts.length && z < thikaZones.length; z++) {
    final end = z + 1 < starts.length ? starts[z + 1] : count;
    final every = thikaZones[z].bridgeEvery;
    for (var i = starts[z] + every ~/ 2; i < end - 30; i += every) {
      final at = i + (pseudoRandom(i) * 24).floor();
      if (nearStart(at) || flyoverAt.any((f) => (f - at).abs() < 40)) continue;
      slots[at].add(Prop(
        kind: PropKind.footbridge,
        anchor: at,
        side: 1,
        offset: 1.2,
        width: 0,
        height: 1950,
      ));
    }
  }

  for (final at in flyoverAt) {
    slots[at].add(Prop(
      kind: PropKind.overpass,
      anchor: at,
      side: 1,
      offset: 1.5,
      width: 0,
      height: 2500,
    ));
  }
}
