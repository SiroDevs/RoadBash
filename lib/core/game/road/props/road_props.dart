// Project imports:
import '../finish/finish_layout.dart';
import '../routes/thika/thika_route.dart';
import '../scene_theme.dart';
import '../track/road_track.dart';
import 'layouts/city_layout.dart';
import 'layouts/jungle_layout.dart';
import 'layouts/route_layout.dart';
import 'layouts/savanna_layout.dart';
import 'layouts/suburbs_layout.dart';
import 'prop.dart';

export 'prop.dart';

class RoadProps {
  RoadProps(SceneTheme theme, RoadTrack track)
    : _bySegment = List.filled(track.count, const []) {
    final count = track.count;
    final base = track.baseCount;
    final slots = List.generate(count, (_) => <Prop>[]);
    // The lap's own scenery stops at the finish line; the finish plaza after
    // it is laid out separately.
    switch (theme.decor) {
      case DecorKind.buildings:
        layOutCity(slots, base);
      case DecorKind.trees:
        layOutSuburbs(slots, base);
      case DecorKind.corridor:
        layOutRoute(
          slots,
          track.segments.sublist(0, base),
          track.sectionStarts,
          thikaRoute,
        );
      case DecorKind.jungle:
        layOutJungle(slots, base);
      case DecorKind.savanna:
        layOutSavanna(slots, base);
    }
    layOutFinish(slots, track, theme);
    for (var i = 0; i < count; i++) {
      _bySegment[i] = slots[i].isEmpty ? const [] : List.unmodifiable(slots[i]);
    }
  }

  final List<List<Prop>> _bySegment;

  List<Prop> at(int segment) => _bySegment[segment];
}
