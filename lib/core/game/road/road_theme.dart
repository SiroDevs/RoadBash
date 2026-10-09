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
  });

  final SceneId id;
  final int laps;
  final int lanes;
  final Color skyTop, skyHorizon, backFar, backNear;

  /// Verge either side of the road, and the strip of dirt or kerb that
  /// separates it from the tarmac.
  final Color ground, shoulder;
  final Color edgeLight, edgeDark;
  final Color roadLight, roadDark, laneColor, centerColor;

  /// What distant geometry dissolves into. Matched to the backdrop at the
  /// horizon so the road's far end has nothing to give itself away with.
  final Color fog;
  final BackdropKind backdrop;
  final DecorKind decor;
  final List<Color> wallColors;
  final Color windowColor, roofColor, treeDark, treeLight, trunk, poleColor;

  static const SceneTheme city = SceneTheme(
    id: SceneId.city,
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

  static SceneTheme of(SceneId id) => id == SceneId.city ? city : suburbs;
}
