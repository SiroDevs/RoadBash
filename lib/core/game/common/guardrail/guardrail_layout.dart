// Project imports:
import '../../road/track/road_track.dart';
import '../universal/prop.dart';
import 'guardrail_config.dart';

/// Guardrails along both edges of every median, one prop per few segments.
/// They run the whole lap (a prop reaching past the end just wraps), so there
/// is no gap at the start/finish line.
void layGuardrails(List<List<Prop>> slots, List<RoadSegment> segments) {
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
