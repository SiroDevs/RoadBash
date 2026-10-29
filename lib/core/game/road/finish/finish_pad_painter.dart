// Dart imports:
import 'dart:ui';

// Project imports:
import '../../utils/paint_utils.dart';
import '../config/road_config.dart';
import '../road_projection.dart';
import '../scene_theme.dart';
import 'finish_config.dart';

/// The finish strip painted over the road (and its shoulders): chequered, or
/// lengthwise zebra stripes on the rows the scene's look asks for.
class FinishPadPainter {
  FinishPadPainter(SceneTheme theme)
    : _black = fogRamp(const Color(0xFF17181C), theme.fog),
      _white = fogRamp(const Color(0xFFF2F2EE), theme.fog);

  final List<Paint> _black, _white;
  final Path _path = Path();

  void draw(Canvas c, VisionSeg v, int row, {required bool zebra}) {
    final cols = zebra ? FinishConfig.zebraColumns : FinishConfig.padColumns;
    const left = -1 - RoadConfig.shoulder;
    const width = 2 + 2 * RoadConfig.shoulder;
    for (final dark in const [true, false]) {
      _path.reset();
      for (var col = 0; col < cols; col++) {
        if ((zebra ? col.isEven : (col + row).isEven) != dark) continue;
        final a = left + width * col / cols;
        final b = left + width * (col + 1) / cols;
        addQuad(
          _path,
          v.x1 + v.w1 * a,
          v.y1,
          v.x1 + v.w1 * b,
          v.y1,
          v.x2 + v.w2 * b,
          v.y2,
          v.x2 + v.w2 * a,
          v.y2,
        );
      }
      c.drawPath(_path, fogged(dark ? _black : _white, v.fog));
    }
  }
}
