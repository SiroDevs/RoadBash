// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../../config/guardrail_config.dart';
import '../../config/road_config.dart';
import '../../routes/route_stretch.dart';
import '../../track/road_track.dart';
import '../prop.dart';
import '../sign_panel.dart';
import 'scenery_layout.dart';

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

  for (var stretchIndex = 0; stretchIndex < route.length; stretchIndex++) {
    final stretch = route[stretchIndex];
    final base = starts[stretchIndex];
    final next = stretchIndex + 1 < starts.length
        ? starts[stretchIndex + 1]
        : count;
    final len = next - base;
    for (final span in stretch.left) {
      layOutScenery(slots, limit, base, len, span, -1, stretchIndex);
    }
    for (final span in stretch.right) {
      layOutScenery(slots, limit, base, len, span, 1, stretchIndex);
    }
    for (final feature in stretch.features) {
      _feature(slots, limit, base, len, feature);
    }
  }
}

void _medianLamps(
  List<List<Prop>> slots,
  List<RoadSegment> segments,
  int limit,
) {
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

void _feature(
  List<List<Prop>> slots,
  int limit,
  int base,
  int len,
  RouteFeature feature,
) {
  final slotIndex = (base + (feature.at * len).round()).clamp(base + 1, limit);
  if (feature.kind == PropKind.tunnel) {
    for (var k = 0; k < feature.depth && slotIndex + k < limit; k++) {
      slots[slotIndex + k].add(Prop(
        kind: PropKind.tunnel,
        anchor: slotIndex + k,
        side: 1,
        offset: 0,
        width: 0,
        height: feature.height,
        depth: 1,
        detail: k % 4 == 0 ? 1 : 0,
      ));
    }
    return;
  }
  slots[slotIndex].add(Prop(
    kind: feature.kind,
    anchor: slotIndex,
    side: feature.side,
    offset: feature.offset,
    width: feature.width,
    height: feature.height,
    depth: math.min(feature.depth, RoadConfig.maxPropDepth),
    tint: feature.tint,
    detail: feature.detail,
    signs: feature.sign != null
        ? [feature.sign!]
        : feature.panels.isNotEmpty
        ? feature.panels
        : (feature.lines.isEmpty
              ? const []
              : [SignPanel([for (final line in feature.lines) SignRow(line)])]),
    boards: feature.boards,
  ));
}
