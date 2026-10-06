// Dart imports:
import 'dart:ui';

// Project imports:
import '../../../domain/models/scene_id.dart';

enum BackdropKind { skyline, hills }

enum DecorKind { buildings, trees }

class SceneTheme {
  const SceneTheme({
    required this.id,
    required this.skyTop,
    required this.skyHorizon,
    required this.backFar,
    required this.backNear,
    required this.groundLight,
    required this.groundDark,
    required this.edgeLight,
    required this.edgeDark,
    required this.roadLight,
    required this.roadDark,
    required this.backdrop,
    required this.decor,
    this.laps = 3,
    this.lanes = 4,
    this.laneColor = const Color(0xFFE9E9EF),
    this.centerColor = const Color(0xFFE3B93C),
    this.wallColors = const [Color(0xFF34476A)],
    this.windowColor = const Color(0xFF1B2638),
    this.treeDark = const Color(0xFF2F6B2E),
    this.treeLight = const Color(0xFF4F9A3E),
    this.trunk = const Color(0xFF5B4030),
  });

  final SceneId id;
  final int laps;
  final int lanes;
  final Color skyTop, skyHorizon, backFar, backNear;
  final Color groundLight, groundDark, edgeLight, edgeDark;
  final Color roadLight, roadDark, laneColor, centerColor;
  final BackdropKind backdrop;
  final DecorKind decor;
  final List<Color> wallColors;
  final Color windowColor, treeDark, treeLight, trunk;

  static const SceneTheme city = SceneTheme(
    id: SceneId.city,
    skyTop: Color(0xFF7C9EE8),
    skyHorizon: Color(0xFFC3D6F6),
    backFar: Color(0xFF8795B8),
    backNear: Color(0xFF64739A),
    groundLight: Color(0xFF8E94A2),
    groundDark: Color(0xFF858B99),
    edgeLight: Color(0xFFBFC3CC),
    edgeDark: Color(0xFFA9ADB8),
    roadLight: Color(0xFF5E5F6B),
    roadDark: Color(0xFF595A66),
    backdrop: BackdropKind.skyline,
    decor: DecorKind.buildings,
    wallColors: [
      Color(0xFF34476A),
      Color(0xFF5F7DA8),
      Color(0xFF4A4E5C),
      Color(0xFF8798B8),
    ],
  );

  static const SceneTheme suburbs = SceneTheme(
    id: SceneId.suburbs,
    skyTop: Color(0xFF4F86E0),
    skyHorizon: Color(0xFFAAC9F7),
    backFar: Color(0xFF6E8268),
    backNear: Color(0xFF55704F),
    groundLight: Color(0xFF4F9A3A),
    groundDark: Color(0xFF468F33),
    edgeLight: Color(0xFF8A6844),
    edgeDark: Color(0xFF7F5E3E),
    roadLight: Color(0xFF6A6A78),
    roadDark: Color(0xFF656573),
    backdrop: BackdropKind.hills,
    decor: DecorKind.trees,
  );

  static SceneTheme of(SceneId id) => id == SceneId.city ? city : suburbs;
}
