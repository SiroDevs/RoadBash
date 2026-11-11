// Project imports:
import 'road_projection.dart';

/// The road segments drawn in one frame, found again by their row.
class VisionBuffer {
  VisionBuffer(int capacity)
    : segments = List.generate(capacity, (_) => VisionSeg()),
      _byRow = List.filled(capacity, null);

  /// Every segment slot, of which the first [count] are in use.
  final List<VisionSeg> segments;
  final List<VisionSeg?> _byRow;

  int count = 0;
  int firstRow = -1;
  int lastRow = -1;

  /// Forgets the segments of the last frame.
  void reset() {
    count = 0;
    firstRow = -1;
    lastRow = -1;
    _byRow.fillRange(0, _byRow.length, null);
  }

  /// Takes the next free segment for [row].
  VisionSeg add(int row) {
    final vision = segments[count++];
    _byRow[row] = vision;
    if (firstRow < 0) firstRow = row;
    lastRow = row;
    return vision;
  }

  /// The segment drawn at [row], or null when none was.
  VisionSeg? exact(int row) => _byRow[row];

  /// The segment at [row], or the nearest one for rows before the road.
  VisionSeg? at(int row) => row < firstRow ? _byRow[firstRow] : _byRow[row];

  /// The nearest drawn segment at or before [index].
  VisionSeg? findBack(int index) {
    for (var i = index; i >= firstRow; i--) {
      final vision = _byRow[i];
      if (vision != null) return vision;
    }
    return null;
  }
}
