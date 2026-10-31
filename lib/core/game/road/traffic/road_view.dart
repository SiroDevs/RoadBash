// Package imports:
import 'package:flame/components.dart' show Vector2;

// Project imports:
import '../config/road_config.dart';
import '../props/road_props.dart';
import '../road_projection.dart';
import '../track/road_track.dart';

/// Camera data of the last drawn frame, used to project things on the road.
class RoadView {
  RoadView(this.track, this.props);

  final RoadTrack track;
  final RoadProps props;
  final List<double> _cameraX = List.filled(RoadConfig.drawDistance, 0);
  final List<double> _curveStep = List.filled(RoadConfig.drawDistance, 0);
  final List<double> _clipY = List.filled(RoadConfig.drawDistance, 0);
  final List<bool> _seen = List.filled(RoadConfig.drawDistance, false);

  Vector2 size = Vector2.zero();
  double trkPosition = 0;
  double cameraY = 0;
  double spread = 1;
  int baseIndex = 0;

  double lastCameraX = 0;
  double lastClipY = 0;
  int lastRow = 0;

  /// Starts a new frame for the given camera.
  ///
  /// [screen] is the game size, [position] the camera's track position,
  /// [height] its height above the road, [widen] how far the road is
  /// widened to fill the screen and [base] the index of its segment.
  void begin(
    Vector2 screen,
    double position,
    double height,
    double widen,
    int base,
  ) {
    size = screen;
    trkPosition = position;
    cameraY = height;
    spread = widen;
    baseIndex = base;
    _seen.fillRange(0, _seen.length, false);
  }

  /// Records the camera offset used for the segment [index] rows ahead.
  void note(int index, double cameraX, double curveStep) {
    _cameraX[index] = cameraX;
    _curveStep[index] = curveStep;
  }

  /// Marks a segment as visible, with the screen row that clips it.
  void markSeen(int index, double clipY) {
    _seen[index] = true;
    _clipY[index] = clipY;
  }

  /// Returns the scenery row at which something on [row] should be drawn.
  ///
  /// Roadside boxes next to it are drawn first, so it is never hidden by a
  /// building that really stands behind it.
  int paintRow(int row) => props.coverStart(baseIndex, row);

  /// Projects the road point [depth] ahead of the camera into [out].
  ///
  /// Returns false when that part of the road is not visible, for example
  /// behind a hill crest or outside the drawn distance.
  bool project(double depth, ProjectionPoint out) {
    const length = RoadConfig.segmentLength;
    final row = (trkPosition + depth) / length;
    final whole = row.floor();
    final index = whole - (trkPosition / length).floor();
    if (index < 0 || index >= RoadConfig.drawDistance || !_seen[index]) {
      return false;
    }
    final segment = track.segments[(baseIndex + index) % track.count];
    final fraction = row - whole;
    final looped = segment.index < baseIndex;
    final cameraZ = trkPosition - (looped ? track.length : 0);
    lastCameraX = _cameraX[index] - _curveStep[index] * fraction;
    lastClipY = _clipY[index];
    lastRow = index;
    out.project(
      segment.y1 + (segment.y2 - segment.y1) * fraction,
      (segment.index + fraction) * length,
      lastCameraX,
      cameraY,
      cameraZ,
      size,
      spread,
    );
    return true;
  }
}
