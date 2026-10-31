// Project imports:
import '../config/road_config.dart';
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

/// Places the roadside props along the track.
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
      case DecorKind.jungle:
        layOutJungle(slots, count);
      case DecorKind.savanna:
        layOutSavanna(slots, count);
    }
    layOutFinish(slots, track, theme);
    for (var i = 0; i < count; i++) {
      _bySegment[i] = slots[i].isEmpty ? const [] : List.unmodifiable(slots[i]);
    }
  }

  final List<List<Prop>> _bySegment;

  /// Returns the props anchored on a segment.
  List<Prop> at(int segment) => _bySegment[segment];

  /// Returns the first row of the roadside boxes that run alongside [row].
  ///
  /// Rows count from the camera's segment [baseIndex]. A box is drawn at its
  /// first row, so something standing on the road beside it must be drawn
  /// no earlier than that row. Returns [row] when no box is alongside.
  int coverStart(int baseIndex, int row) {
    final count = _bySegment.length;
    for (var start = row - RoadConfig.maxPropDepth; start < row; start++) {
      final list = _bySegment[(baseIndex + start + count * 2) % count];
      for (final prop in list) {
        final isBox = prop.depth > 0 &&
            !prop.kind.spansRoad &&
            prop.kind != PropKind.tunnel;
        if (isBox && start + prop.depth >= row) return start;
      }
    }
    return row;
  }
}
