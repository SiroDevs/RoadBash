// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../../../utils/pseudo_random.dart';
import '../../config/guardrail_config.dart';
import '../../config/road_config.dart';
import '../../routes/route_stretch.dart';
import '../../track/road_track.dart';
import '../prop.dart';
import '../sign_panel.dart';

void layOutRoute(
  List<List<Prop>> slots,
  List<RoadSegment> segments,
  List<int> starts,
  List<RouteStretch> route,
) {
  final count = segments.length;
  final limit = count - RoadConfig.maxPropDepth - 2;
  _medianLamps(slots, segments, limit);
  _guardrails(slots, segments);

  for (var z = 0; z < route.length; z++) {
    final stretch = route[z];
    final base = starts[z];
    final len = (z + 1 < starts.length ? starts[z + 1] : count) - base;
    for (final span in stretch.left) {
      _scenery(slots, limit, base, len, span, -1, z);
    }
    for (final span in stretch.right) {
      _scenery(slots, limit, base, len, span, 1, z);
    }
    for (final feature in stretch.features) {
      _feature(slots, limit, base, len, feature);
    }
  }
}

void _medianLamps(List<List<Prop>> slots, List<RoadSegment> segments, int limit) {
  for (var i = 6; i < limit; i += 18) {
    if (!segments[i].section.hasOpposite) continue;
    slots[i].add(Prop(
      kind: PropKind.lamp,
      anchor: i,
      side: 1,
      offset: 1.33,
      width: 100,
      height: 1900,
      detail: 1,
    ));
  }
}

/// Guardrails along both edges of every median, one prop per few segments.
/// They run the whole lap (a prop reaching past the end just wraps), so there
/// is no gap at the start/finish line.
void _guardrails(List<List<Prop>> slots, List<RoadSegment> segments) {
  for (var i = 0; i < segments.length; i += GuardrailConfig.span) {
    if (!GuardrailConfig.isDrawn(segments[i].section.median)) continue;
    slots[i].add(Prop(
      kind: PropKind.guardrail,
      anchor: i,
      side: 1,
      offset: GuardrailConfig.nearOffset,
      width: 0,
      height: GuardrailConfig.beamTop,
      depth: GuardrailConfig.span,
    ));
  }
}

void _scenery(
  List<List<Prop>> slots,
  int limit,
  int base,
  int len,
  SideScenery span,
  int side,
  int z,
) {
  final a = base + (span.from * len).round();
  final b = math.min(base + (span.to * len).round(), limit);
  for (final wall in span.walls) {
    _walls(slots, limit, base, len, wall, side);
  }
  if (span.service) _service(slots, a, b, side);

  var i = a + 1;
  while (i < b) {
    final seed = ((i * 2 + (side > 0 ? 1 : 0)) * 31 + z * 7 + 5);
    if (span.lots > 0 && pseudoRandom(seed) < span.lots) {
      i += _building(slots, i, seed, span, side, z) + 1;
      continue;
    }
    if (span.treeStep != null) {
      _tree(slots, i, seed, span, side);
      i += pickInt(span.treeStep!, pseudoRandom(seed + 4));
    } else {
      i += 5 + (pseudoRandom(seed + 4) * 6).floor();
    }
  }
}

int _building(
  List<List<Prop>> slots,
  int i,
  int seed,
  SideScenery span,
  int side,
  int z,
) {
  final depth = 7 + (pseudoRandom(seed + 1) * 14).floor();
  final storeys = pickInt(span.storeys, pseudoRandom(seed + 2));
  slots[i].add(Prop(
    kind: PropKind.building,
    anchor: i,
    side: side,
    offset: pickIn(span.setBack, pseudoRandom(seed + 5)),
    width: 2600 + 3400 * pseudoRandom(seed + 6),
    height: storeys * 450.0,
    depth: depth,
    tint: z + i ~/ 9,
    detail: storeys.toDouble(),
    drop: span.drop,
  ));
  return depth + (pseudoRandom(seed + 3) * 4).floor();
}

void _tree(List<List<Prop>> slots, int i, int seed, SideScenery span, int side) {
  final kind = span.mix.pick(pseudoRandom(seed + 2));
  final scale = kind == PropKind.bush
      ? 0.5 + 0.3 * pseudoRandom(seed + 7)
      : 0.8 + 0.6 * pseudoRandom(seed + 7);
  final (width, height) = switch (kind) {
    PropKind.acacia => (900.0, 1500.0),
    PropKind.pine => (620.0, 2700.0),
    _ => (620.0, 2050.0),
  };
  slots[i].add(Prop(
    kind: kind,
    anchor: i,
    side: side,
    offset: pickIn(span.treeSetBack, pseudoRandom(seed + 8)),
    width: width * scale,
    height: height * scale,
    detail: pseudoRandom(seed + 9),
  ));
}

void _walls(
  List<List<Prop>> slots,
  int limit,
  int base,
  int len,
  WallRun run,
  int side,
) {
  final a = base + (run.from * len).round();
  final b = math.min(base + (run.to * len).round(), limit);
  for (var i = a; i < b; i += 12) {
    slots[i].add(Prop(
      kind: PropKind.wall,
      anchor: i,
      side: side,
      offset: run.offset,
      width: 200,
      height: run.style.height,
      depth: math.min(12, b - i),
      tint: run.style.index,
    ));
  }
}

void _service(List<List<Prop>> slots, int a, int b, int side) {
  for (var i = a; i < b; i += 24) {
    slots[i].add(Prop(
      kind: PropKind.slipRoad,
      anchor: i,
      side: side,
      offset: 1.2,
      width: 0,
      height: 0,
      depth: math.min(24, b - i),
    ));
  }
}

void _feature(
  List<List<Prop>> slots,
  int limit,
  int base,
  int len,
  RouteFeature f,
) {
  final i = (base + (f.at * len).round()).clamp(base + 1, limit);
  if (f.kind == PropKind.tunnel) {
    for (var k = 0; k < f.depth && i + k < limit; k++) {
      slots[i + k].add(Prop(
        kind: PropKind.tunnel,
        anchor: i + k,
        side: 1,
        offset: 0,
        width: 0,
        height: f.height,
        depth: 1,
        detail: k % 4 == 0 ? 1 : 0,
      ));
    }
    return;
  }
  slots[i].add(Prop(
    kind: f.kind,
    anchor: i,
    side: f.side,
    offset: f.offset,
    width: f.width,
    height: f.height,
    depth: math.min(f.depth, RoadConfig.maxPropDepth),
    tint: f.tint,
    detail: f.detail,
    signs: f.sign != null
        ? [f.sign!]
        : f.panels.isNotEmpty
        ? f.panels
        : (f.lines.isEmpty
              ? const []
              : [SignPanel([for (final line in f.lines) SignRow(line)])]),
    boards: f.boards,
  ));
}
