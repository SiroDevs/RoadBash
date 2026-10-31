// Dart imports:
import 'dart:ui';

// Project imports:
import '../../../domain/models/scene_id.dart';

/// Kinds of scene backdrop.
enum BackdropKind { skyline, hills, hillsAndSkyline, sky, ridges }

/// Kinds of roadside decoration.
enum DecorKind { buildings, trees, corridor, jungle, savanna }

/// Colors and settings that define a scene's look.
class SceneTheme {
  const SceneTheme({
    required this.id,
    required this.skyTop,
    required this.skyHorizon,
    required this.backFar,
    required this.backNear,
    required this.ground,
    required this.shoulder,
    required this.edgeLight,
    required this.edgeDark,
    required this.roadLight,
    required this.roadDark,
    required this.fog,
    required this.backdrop,
    required this.decor,
    this.laps = 3,
    this.lanes = 4,
    this.laneColor = const Color(0xFFEDEDF2),
    this.centerColor = const Color(0xFFE7BC33),
    this.wallColors = const [Color(0xFF34476A)],
    this.windowColor = const Color(0xFF1B2638),
    this.roofColor = const Color(0xFF2A3042),
    this.treeDark = const Color(0xFF26592A),
    this.treeLight = const Color(0xFF47883B),
    this.trunk = const Color(0xFF4F3A2B),
    this.poleColor = const Color(0xFF6E737C),
    this.bridgeColor = const Color(0xFFA7A9A4),
    this.bridgeRail = const Color(0xFF3F4650),
    this.signGreen = const Color(0xFF1F6B46),
    this.dualCarriageway = false,
    this.markings = true,
    this.ruts = false,
    this.rutColor = const Color(0xFF8A5A33),
    this.rockColor = const Color(0xFF8A7F73),
  });

  final SceneId id;
  final int laps;
  final int lanes;
  final Color skyTop, skyHorizon, backFar, backNear;

  final Color ground, shoulder;
  final Color edgeLight, edgeDark;
  final Color roadLight, roadDark, laneColor, centerColor;

  final Color fog;
  final BackdropKind backdrop;
  final DecorKind decor;
  final List<Color> wallColors;
  final Color windowColor, roofColor, treeDark, treeLight, trunk, poleColor;

  final Color bridgeColor, bridgeRail, signGreen;
  final bool dualCarriageway;

  final bool markings;

  final bool ruts;
  final Color rutColor, rockColor;

  static const SceneTheme city = SceneTheme(
    id: SceneId.city,
    lanes: 4,
    skyTop: Color(0xFF6F96E4),
    skyHorizon: Color(0xFFCBDAF3),
    backFar: Color(0xFF9AA7C2),
    backNear: Color(0xFF7C8AAC),
    ground: Color(0xFF8A909C),
    shoulder: Color(0xFFB2B7C0),
    edgeLight: Color(0xFFC6CAD2),
    edgeDark: Color(0xFFAFB4BE),
    roadLight: Color(0xFF61626D),
    roadDark: Color(0xFF5B5C67),
    fog: Color(0xFFBCCAE2),
    backdrop: BackdropKind.skyline,
    decor: DecorKind.buildings,
    wallColors: [
      Color(0xFF4E6287),
      Color(0xFF8E9EBC),
      Color(0xFF6C6257),
      Color(0xFF9A8E7C),
      Color(0xFF53565F),
      Color(0xFF7F8793),
    ],
    windowColor: Color(0xFF263347),
    roofColor: Color(0xFF3A4055),
  );

  static const SceneTheme suburbs = SceneTheme(
    id: SceneId.suburbs,
    laps: 4,
    skyTop: Color(0xFF4A83DF),
    skyHorizon: Color(0xFFB6CEF5),
    backFar: Color(0xFF7D9279),
    backNear: Color(0xFF5E7A56),
    ground: Color(0xFF59A341),
    shoulder: Color(0xFF8A6342),
    edgeLight: Color(0xFF9A9FA8),
    edgeDark: Color(0xFF8C919A),
    roadLight: Color(0xFF6B6B79),
    roadDark: Color(0xFF666674),
    fog: Color(0xFFB3C9E6),
    backdrop: BackdropKind.hills,
    decor: DecorKind.trees,
    treeDark: Color(0xFF235226),
    treeLight: Color(0xFF4C8F3C),
    trunk: Color(0xFF553E2D),
  );

  static const SceneTheme thikaRoad = SceneTheme(
    id: SceneId.thikaRoad,
    laps: 1,
    lanes: 3,
    dualCarriageway: true,
    skyTop: Color(0xFF5F86D6),
    skyHorizon: Color(0xFFE2EAF4),
    backFar: Color(0xFF8DA08F),
    backNear: Color(0xFF6E8A6A),
    ground: Color(0xFF9C8458),
    shoulder: Color(0xFFB4875C),
    edgeLight: Color(0xFFC9CBCF),
    edgeDark: Color(0xFFA9ADB4),
    roadLight: Color(0xFF4F5059),
    roadDark: Color(0xFF494A53),
    fog: Color(0xFFD9E2EC),
    backdrop: BackdropKind.sky,
    decor: DecorKind.corridor,
    wallColors: [
      Color(0xFFD9C9A8),
      Color(0xFF8FB0C8),
      Color(0xFFB8765A),
      Color(0xFFA9A9A3),
      Color(0xFFC9D6B5),
      Color(0xFFE0CFA0),
      Color(0xFFC9877A),
      Color(0xFF9C5B48),
    ],
    windowColor: Color(0xFF2E3E4E),
    roofColor: Color(0xFF4A4F57),
    treeDark: Color(0xFF2F6B2E),
    treeLight: Color(0xFF5E9B3F),
    trunk: Color(0xFF5A4332),
  );

  static const SceneTheme jungle = SceneTheme(
    id: SceneId.jungle,
    laps: 1,
    lanes: 2,
    skyTop: Color(0xFF5E9DB0),
    skyHorizon: Color(0xFFCFE6D2),
    backFar: Color(0xFF4F7A5C),
    backNear: Color(0xFF2F5E3C),
    ground: Color(0xFF2B6A2E),
    shoulder: Color(0xFF6B5A3E),
    edgeLight: Color(0xFF8C8F86),
    edgeDark: Color(0xFF7A7E76),
    roadLight: Color(0xFF454A4F),
    roadDark: Color(0xFF3F4449),
    fog: Color(0xFFB8D4C4),
    backdrop: BackdropKind.ridges,
    decor: DecorKind.jungle,
    laneColor: Color(0xFFC9CFC0),
    centerColor: Color(0xFFD9C45A),
    treeDark: Color(0xFF14502A),
    treeLight: Color(0xFF2F8A3E),
    trunk: Color(0xFF4A3524),
  );

  static const SceneTheme dirtRoad = SceneTheme(
    id: SceneId.dirtRoad,
    laps: 1,
    lanes: 2,
    skyTop: Color(0xFF5B96D9),
    skyHorizon: Color(0xFFF3DDB8),
    backFar: Color(0xFFB59A7A),
    backNear: Color(0xFF9C7F5A),
    ground: Color(0xFF9E5A32),
    shoulder: Color(0xFF8F5230),
    edgeLight: Color(0xFFB98550),
    edgeDark: Color(0xFFAD7A47),
    roadLight: Color(0xFFCB9A62),
    roadDark: Color(0xFFC3925B),
    fog: Color(0xFFEAD3AE),
    backdrop: BackdropKind.hills,
    decor: DecorKind.savanna,
    markings: false,
    ruts: true,
    rutColor: Color(0xFF8A5A33),
    rockColor: Color(0xFF8A7F73),
    treeDark: Color(0xFF5C6B2E),
    treeLight: Color(0xFF8E9A45),
    trunk: Color(0xFF4A3828),
  );

  /// Returns the theme for a scene.
  static SceneTheme of(SceneId id) => switch (id) {
    SceneId.city => city,
    SceneId.suburbs => suburbs,
    SceneId.thikaRoad => thikaRoad,
    SceneId.jungle => jungle,
    SceneId.dirtRoad => dirtRoad,
  };
}
