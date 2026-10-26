// Dart imports:
import 'dart:ui';

// Project imports:
import '../../utils/paint_utils.dart';
import '../scene/scene_theme.dart';
import '../track/road_section.dart';

class RoadSurfacePalette {
  RoadSurfacePalette(SceneTheme theme)
      : dirt = fogRamp(const Color(0xFFB4875C), theme.fog),
        grass = fogRamp(const Color(0xFF6E9A4A), theme.fog),
        paved = fogRamp(const Color(0xFF8F9298), theme.fog),
        planted = fogRamp(const Color(0xFF5E8F3E), theme.fog),
        barrier = fogRamp(const Color(0xFFA4A6A8), theme.fog),
        rail = fogRamp(const Color(0xFFC3C8CE), theme.fog),
        railShadow = fogRamp(const Color(0xFF6C7078), theme.fog);

  final List<Paint> dirt, grass, paved, planted, barrier, rail, railShadow;

  List<Paint> verge(VergeKind kind) => switch (kind) {
    VergeKind.dirt => dirt,
    VergeKind.grass => grass,
    VergeKind.paved => paved,
  };

  List<Paint> median(MedianKind kind) => switch (kind) {
    MedianKind.planted => planted,
    MedianKind.barrier => barrier,
    MedianKind.guardrail => dirt,
    MedianKind.none => paved,
  };
}
