// Dart imports:
import 'dart:ui';

// Project imports:
import '../../utils/paint_utils.dart';
import '../../utils/pseudo_random.dart';
import '../scene_theme.dart';
import '../universal/prop.dart';
import '../universal/road_projection.dart';

/// Paints the leaf canopy that closes over the jungle road.
class CanopyPainter {
  CanopyPainter(SceneTheme theme)
    : _dark = fogRamp(theme.treeDark, theme.fog),
      _light = fogRamp(theme.treeLight, theme.fog),
      _sun = fogRamp(const Color(0xFFC9E39A), theme.fog);

  final List<Paint> _dark, _light, _sun;
  final Path _path = Path();

  static const int _blobs = 5;
  static const double _skipFog = 0.93;

  /// Draws one slice of canopy above the road between [left] and [right].
  void draw(Canvas canvas, VisionSeg vision, Prop prop, double left, double right) {
    if (vision.fog > _skipFog) return;
    final scale = vision.k1;
    final top = vision.y1 - prop.height * scale;
    final thickness = 520 * scale;
    drawQuad(canvas, _path, fogged(_dark, vision.fog), left, top - thickness,
        right, top - thickness, right, top + thickness * 0.5, left, top + thickness * 0.5);

    final seed = vision.seg.index * 9 + 2;
    for (var blob = 0; blob < _blobs; blob++) {
      final base = seed + blob * 4;
      final across = pseudoRandom(base + 1);
      final x = left + (right - left) * across;
      final y = top + thickness * (0.1 + 0.75 * pseudoRandom(base + 2));
      final radius = (240 + 260 * pseudoRandom(base + 3)) * scale;
      final ramp = blob.isEven ? _light : _dark;
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x, y), width: radius * 2.2, height: radius * 1.3),
        fogged(ramp, vision.fog),
      );
    }
    if (pseudoRandom(seed + 31) > 0.72) {
      final x = left + (right - left) * pseudoRandom(seed + 32);
      canvas.drawCircle(Offset(x, top + thickness * 0.3), 90 * scale, fogged(_sun, vision.fog));
    }
  }
}
