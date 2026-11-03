// Dart imports:
import 'dart:ui';

// Project imports:
import '../../road/scene_theme.dart';
import '../../utils/paint_utils.dart';

/// The leaf and trunk colours shared by every tree and bush of a scene.
class FoliagePalette {
  FoliagePalette(SceneTheme theme)
    : leafDark = fogRamp(theme.treeDark, theme.fog, antiAlias: true),
      leafLight = fogRamp(theme.treeLight, theme.fog, antiAlias: true),
      trunk = fogRamp(theme.trunk, theme.fog);

  final List<Paint> leafDark;
  final List<Paint> leafLight;
  final List<Paint> trunk;
}
