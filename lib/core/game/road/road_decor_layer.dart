// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart' show Vector2;

// Project imports:
import '../../../common/objects/universal/prop_painter.dart';
import 'config/road_config.dart';
import 'finish/finish_zone.dart';
import 'road_projection.dart';
import 'road_props.dart';
import 'track/road_track.dart';
import 'traffic/road_traffic.dart';
import 'vision_buffer.dart';

/// Draws the scenery and rivals of a frame from the far end to the near end.
class RoadDecorLayer {
  RoadDecorLayer(this.track, this.props, this.finish, this.painter);

  final RoadTrack track;
  final RoadProps props;
  final FinishZone finish;
  final PropPainter painter;

  /// Draws every prop and rival row of the segments in [view].
  void draw(
    Canvas canvas,
    VisionBuffer view,
    int baseIdx,
    Vector2 size,
    RoadTraffic? traffic,
  ) {
    final near = view.exact(view.firstRow)!;
    final limit = math.min(RoadConfig.decorDistance, view.lastRow + 1);
    for (var n = limit - 1; n >= -RoadConfig.maxPropDepth; n--) {
      final anchor = n < view.firstRow ? near : view.exact(n);
      if (anchor != null) _drawProps(canvas, view, baseIdx, n, anchor, size);
      traffic?.paintAt(canvas, n, view.at, size);
    }
  }

  /// Draws the props anchored on [row] using the segment [anchor].
  void _drawProps(
    Canvas canvas,
    VisionBuffer view,
    int baseIdx,
    int row,
    VisionSeg anchor,
    Vector2 size,
  ) {
    final list = props.at((baseIdx + row + track.count * 2) % track.count);
    for (final prop in list) {
      if (!finish.shows(prop)) continue;
      if (prop.depth == 0) {
        painter.drawBillboard(canvas, anchor, prop, size);
        continue;
      }
      final backRow = math.min(row + prop.depth, view.lastRow);
      if (backRow <= view.firstRow) continue;
      final back = view.exact(backRow) ?? view.findBack(backRow);
      if (back == null || back == anchor) continue;
      painter.drawBox(canvas, anchor, back, prop, size);
    }
  }
}
