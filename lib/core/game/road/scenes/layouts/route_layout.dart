// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../../../common/guardrail/guardrail_layout.dart';
import '../../../common/lamp/lamp_layout.dart';
import '../../../common/universal/prop.dart';
import '../../../common/universal/sign_panel.dart';
import '../../config/road_config.dart';
import '../../routes/route_stretch.dart';
import '../../track/road_track.dart';
import 'scenery_layout.dart';

/// Places scenery and features along a route from its stretches.
void layOutRoute(
  List<List<Prop>> slots,
  List<RoadSegment> segments,
  List<int> starts,
  List<RouteStretch> route,
) {
  final count = segments.length;
  final limit = count - RoadConfig.maxPropDepth - 2;
  layMedianLamps(slots, segments, limit);
  layGuardrails(slots, segments);

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

/// Places one route feature on its segment.
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
