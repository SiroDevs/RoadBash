// Project imports:
import '../utils/pseudo_random.dart';
import 'road_config.dart';
import 'road_theme.dart';

enum PropKind {
  /// A box standing along the road, [depth] segments long.
  building,

  /// Flat billboards anchored to a single segment.
  broadleaf,
  pine,
  bush,
  lamp,
  sign,
}

/// One piece of roadside scenery, pinned to a segment for the whole race.
///
/// Everything a prop needs is decided once, at track build time. Nothing is
/// derived from the segment the camera happens to be on, so a prop never
/// changes size, colour or height while you drive past it.
class Prop {
  const Prop({
    required this.kind,
    required this.anchor,
    required this.side,
    required this.offset,
    required this.width,
    required this.height,
    this.depth = 0,
    this.tint = 0,
    this.detail = 0,
  });

  final PropKind kind;

  /// Segment index the prop stands on.
  final int anchor;

  /// -1 for the left verge, 1 for the right.
  final int side;

  /// Distance from the road centre to the near face, in half-road-widths.
  final double offset;

  /// World units across (buildings) or half-width (billboards).
  final double width;

  /// World units tall.
  final double height;

  /// Segments the prop runs back along the road. 0 for billboards.
  final int depth;

  /// Palette slot for buildings.
  final int tint;

  /// Free parameter: window-grid density, canopy shape, sign face.
  final double detail;
}

/// Lays scenery out along a track once, then hands the renderer a per-segment
/// index of what starts there.
class RoadProps {
  RoadProps(SceneTheme theme, int segmentCount)
      : _bySegment = List.filled(segmentCount, const []) {
    final slots = List.generate(segmentCount, (_) => <Prop>[]);
    if (theme.decor == DecorKind.buildings) {
      _layOutCity(slots, segmentCount);
    } else {
      _layOutSuburbs(slots, segmentCount);
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
        side: 1,
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
        side: (i ~/ 61).isEven ? 1 : -1,
        offset: 1.3,
        width: 260,
        height: 1050,
        detail: pseudoRandom(i + 2),
      ));
    }
  }
}
