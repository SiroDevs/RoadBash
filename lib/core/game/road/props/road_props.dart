import '../scene/scene_theme.dart';
import 'layouts/city_layout.dart';
import 'layouts/suburbs_layout.dart';
import 'layouts/thika_layout.dart';
import 'prop.dart';

export 'prop.dart';

class RoadProps {
  RoadProps(SceneTheme theme, int segmentCount,
      {List<int> sectionStarts = const []})
      : _bySegment = List.filled(segmentCount, const []) {
    final slots = List.generate(segmentCount, (_) => <Prop>[]);
    switch (theme.decor) {
      case DecorKind.buildings:
        layOutCity(slots, segmentCount);
      case DecorKind.trees:
        layOutSuburbs(slots, segmentCount);
      case DecorKind.corridor:
        layOutThikaRoad(slots, segmentCount, sectionStarts);
    }
    for (var i = 0; i < segmentCount; i++) {
      _bySegment[i] = slots[i].isEmpty ? const [] : List.unmodifiable(slots[i]);
    }
  }

  final List<List<Prop>> _bySegment;

  List<Prop> at(int segment) => _bySegment[segment];
}
