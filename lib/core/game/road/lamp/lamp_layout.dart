// Project imports:
import '../track/road_track.dart';
import '../universal/prop.dart';

/// Adds lamps along the median of dual carriageways.
void layMedianLamps(
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
