// Project imports:
import '../utils/scenery_shapes.dart';
import 'road_config.dart';
import 'road_prop.dart';
import 'road_props_thika.dart';
import 'road_theme.dart';

export 'road_prop.dart';

/// Lays scenery out along a track once, then hands the renderer a per-segment
/// index of what starts there.
class RoadProps {
  RoadProps(SceneTheme theme, int segmentCount,
      {List<int> sectionStarts = const []})
      : _bySegment = List.filled(segmentCount, const []) {
    final slots = List.generate(segmentCount, (_) => <Prop>[]);
    switch (theme.decor) {
      case DecorKind.buildings:
        _layOutCity(slots, segmentCount);
      case DecorKind.trees:
        _layOutSuburbs(slots, segmentCount);
      case DecorKind.corridor:
        layOutThikaRoad(slots, segmentCount, sectionStarts);
    }
    for (var i = 0; i < segmentCount; i++) {
      _bySegment[i] = slots[i].isEmpty ? const [] : List.unmodifiable(slots[i]);
    }
  }

  final List<List<Prop>> _bySegment;

  List<Prop> at(int segment) => _bySegment[segment];

  /// City blocks: a run of lots down each verge, each lot a single box that
  /// spans several segments, separated by gaps that read as side streets.
  void _layOutCity(List<List<Prop>> slots, int count) {
    for (final side in const [-1, 1]) {
      var i = (side < 0) ? 0 : 7;
      var lot = 0;
      while (i < count - RoadConfig.maxPropDepth) {
        final seed = (i * 2 + (side > 0 ? 1 : 0)) * 31 + 7;
        final gap = pseudoRandom(seed + 3);

        // One lot in six is left open so the skyline breaks up.
        if (gap < 0.17) {
          i += 5 + (gap * 22).floor();
          lot++;
          continue;
        }

        final depth = 9 + (pseudoRandom(seed) * 14).floor();
        final storeys = 3 + (pseudoRandom(seed + 1) * 9).floor();
        slots[i].add(Prop(
          kind: PropKind.building,
          anchor: i,
          side: side,
          // Sidewalk first: nothing is allowed to crowd the tarmac.
          offset: 1.42 + 0.5 * pseudoRandom(seed + 5),
          width: 2600 + 3400 * pseudoRandom(seed + 6),
          height: storeys * 460.0,
          depth: depth,
          tint: lot + (side > 0 ? 1 : 0),
          detail: storeys.toDouble(),
        ));
        i += depth + 1 + (pseudoRandom(seed + 4) * 4).floor();
        lot++;
      }
    }

    // Street furniture, evenly spaced so it reads as a speed reference.
    for (var i = 12; i < count - 2; i += 16) {
      final side = (i ~/ 16).isEven ? -1 : 1;
      slots[i].add(Prop(
        kind: PropKind.lamp,
        anchor: i,
        side: side,
        offset: 1.16,
        width: 90,
        height: 1550,
      ));
    }
    for (var i = 40; i < count - 2; i += 97) {
      slots[i].add(Prop(
        kind: PropKind.sign,
        anchor: i,
        side: -1,
        offset: 1.24,
        width: 300,
        height: 1180,
        detail: pseudoRandom(i),
      ));
    }
  }

  /// Open country: scattered trees that thin out near the tarmac, so the
  /// verge stays readable and the eye is drawn down the road.
  void _layOutSuburbs(List<List<Prop>> slots, int count) {
    for (final side in const [-1, 1]) {
      var i = (side < 0) ? 3 : 11;
      while (i < count - 2) {
        final seed = (i * 2 + (side > 0 ? 1 : 0)) * 17 + 5;
        final r = pseudoRandom(seed);
        final kind = r < 0.42
            ? PropKind.pine
            : (r < 0.86 ? PropKind.broadleaf : PropKind.bush);
        final scale = kind == PropKind.bush
            ? 0.5 + 0.3 * pseudoRandom(seed + 2)
            : 0.8 + 0.6 * pseudoRandom(seed + 2);
        slots[i].add(Prop(
          kind: kind,
          anchor: i,
          side: side,
          offset: 1.7 + 2.9 * pseudoRandom(seed + 1),
          width: 620 * scale,
          height: (kind == PropKind.pine ? 2700 : 2050) * scale,
          detail: pseudoRandom(seed + 3),
        ));
        // 9 - 20 segments apart: roughly two per second at racing speed.
        i += 9 + (pseudoRandom(seed + 4) * 12).floor();
      }
    }

    for (var i = 24; i < count - 2; i += 61) {
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
}
