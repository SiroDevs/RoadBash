// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../../../domain/models/scene_id.dart';
import '../config/road_config.dart';

/// How a scene dresses its finish. Nothing here builds a foreign scene: every
/// scene keeps its own road and scenery, and only gets the race furniture
/// (chequered strip, cones, crowd).
enum FinishLook {
  /// Chequered strip, cones and crowd on the scene's own road.
  plain(padRows: 4, chequerRows: 4),

  /// The city scene: a chequered strip followed by a zebra crossing.
  zebra(padRows: 6, chequerRows: 1),

  /// Thika Road: Museum Hill is the way into Nairobi, so the last stretch
  /// eases into city blocks and a skyline instead of changing at the line.
  cityEntry(padRows: 4, chequerRows: 4);

  const FinishLook({required this.padRows, required this.chequerRows});

  final int padRows;
  final int chequerRows;

  int get padLength => padRows * FinishConfig.rowSegments;
  bool get city => this == cityEntry;
  bool get zebraCrossing => this == zebra;

  /// How far before the line the finish dressing (and, for [cityEntry], the
  /// scenery it replaces) starts, in segments.
  int get lead => city
      ? FinishConfig.cityLead + RoadConfig.maxPropDepth
      : FinishConfig.approach;
}

/// Layout numbers for the finish, in segments unless noted.
abstract final class FinishConfig {
  static FinishLook lookFor(SceneId scene) => switch (scene) {
    SceneId.city => FinishLook.zebra,
    SceneId.thikaRoad => FinishLook.cityEntry,
    _ => FinishLook.plain,
  };

  static const int approach = 64;
  static const int rowSegments = 2;
  static const int padColumns = 14;
  static const int zebraColumns = 9;

  static const double runOutMetres = 300;

  static int get runOut => math.max(
    (runOutMetres / 1000 / RoadConfig.unitKm / RoadConfig.segmentLength).ceil(),
    RoadConfig.drawDistance + 60,
  );

  static const int cityLead = 160;
  static const int skylineRise = 260;

  static const List<Color> blockColors = [
    Color(0xFF1B1F2B),
    Color(0xFF8FA6C9),
    Color(0xFF2B3550),
    Color(0xFF6F7C99),
    Color(0xFF353A47),
    Color(0xFFA9B8D2),
  ];
}
