import '../routes/thika/thika_route.dart';
import '../scene_theme.dart';
import '../track/road_track.dart';
import 'layouts/city_layout.dart';
import 'layouts/route_layout.dart';
import 'layouts/suburbs_layout.dart';
import 'prop.dart';

export 'prop.dart';

class RoadProps {
  RoadProps(SceneTheme theme, RoadTrack track)
    : _bySegment = List.filled(track.count, const []) {
    final count = track.count;
    final slots = List.generate(count, (_) => <Prop>[]);
    switch (theme.decor) {
      case DecorKind.buildings:
        layOutCity(slots, count);
      case DecorKind.trees:
        layOutSuburbs(slots, count);
      case DecorKind.corridor:
        layOutRoute(slots, track.segments, track.sectionStarts, thikaRoute);
    }
    for (var i = 0; i < count; i++) {
      _bySegment[i] = slots[i].isEmpty ? const [] : List.unmodifiable(slots[i]);
    }
  }

  final List<List<Prop>> _bySegment;

  List<Prop> at(int segment) => _bySegment[segment];
}
