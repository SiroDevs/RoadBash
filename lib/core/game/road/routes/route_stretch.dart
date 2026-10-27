import '../props/prop.dart';
import '../props/sign_panel.dart';
import '../props/wall_style.dart';
import '../track/road_section.dart';

const int segmentsPerShot = 18;

class RoutePiece {
  const RoutePiece(this.weight, {this.curve = 0, this.hill = 0, this.section});

  final double weight;
  final double curve;
  final double hill;
  final Section? section;
}

class TreeMix {
  const TreeMix(this.acacia, this.pine, this.broadleaf, this.bush);

  final double acacia, pine, broadleaf, bush;

  PropKind pick(double r) {
    final total = acacia + pine + broadleaf + bush;
    final x = r * total;
    if (x < acacia) return PropKind.acacia;
    if (x < acacia + pine) return PropKind.pine;
    if (x < acacia + pine + broadleaf) return PropKind.broadleaf;
    return PropKind.bush;
  }

  static const savanna = TreeMix(0.7, 0.05, 0.1, 0.15);
  static const belt = TreeMix(0, 0.85, 0.15, 0);
  static const leafy = TreeMix(0, 0.15, 0.7, 0.15);
  static const garden = TreeMix(0, 0.05, 0.75, 0.2);
}

class WallRun {
  const WallRun(this.style, this.from, this.to, {this.offset = 1.2});

  final WallStyle style;
  final double from, to, offset;
}

class SideScenery {
  const SideScenery({
    this.from = 0,
    this.to = 1,
    this.lots = 0,
    this.storeys = (2, 4),
    this.setBack = (2.2, 3.0),
    this.treeStep,
    this.treeSetBack = (2.0, 4.0),
    this.mix = TreeMix.leafy,
    this.walls = const [],
    this.service = false,
    this.drop = 0,
  });

  final double from, to;
  final double lots;
  final (int, int) storeys;
  final (double, double) setBack;
  final (int, int)? treeStep;
  final (double, double) treeSetBack;
  final TreeMix mix;
  final List<WallRun> walls;
  final bool service;
  final double drop;
}

class RouteFeature {
  const RouteFeature._(
    this.kind,
    this.at, {
    this.side = 1,
    this.tint = 0,
    this.depth = 0,
    this.detail = 0,
    required this.offset,
    this.width = 0,
    required this.height,
    this.lines = const [],
    this.panels = const [],
    this.boards = const [],
    this.sign,
  });

  const RouteFeature.footbridge(double at, {int style = 0})
    : this._(PropKind.footbridge, at, tint: style, offset: 1.2, height: 1950);

  const RouteFeature.overpass(double at, {int style = 0})
    : this._(PropKind.overpass, at, tint: style, offset: 1.5, height: 2500);

  const RouteFeature.gantry(
    double at, {
    List<SignPanel> panels = const [],
    List<SignBoard> boards = const [],
  }) : this._(
         PropKind.gantry,
         at,
         offset: 1.2,
         height: 3000,
         panels: panels,
         boards: boards,
       );

  const RouteFeature.exit(double at, {int side = -1, int length = 24})
    : this._(
        PropKind.slipRoad,
        at,
        side: side,
        depth: length,
        detail: 1,
        offset: 1.15,
        height: 0,
      );

  const RouteFeature.entry(double at, {int side = -1, int length = 24})
    : this._(
        PropKind.slipRoad,
        at,
        side: side,
        depth: length,
        detail: -1,
        offset: 1.15,
        height: 0,
      );

  const RouteFeature.billboard(
    double at, {
    int side = 1,
    int face = 0,
    List<String> lines = const [],
    double width = 560,
    double height = 2900,
  }) : this._(
         PropKind.billboard,
         at,
         side: side,
         tint: face,
         offset: side < 0 ? 1.7 : 3.9,
         width: width,
         height: height,
         lines: lines,
       );

  const RouteFeature.exitSign(
    double at, {
    int side = -1,
    int blue = 0,
    double width = 360,
    double height = 1250,
    double? offset,
    List<String> lines = const [],
    List<SignPanel> panels = const [],
  }) : this._(
         PropKind.exitSign,
         at,
         side: side,
         tint: blue,
         offset: offset ?? (side < 0 ? 1.3 : 3.8),
         width: width,
         height: height,
         lines: lines,
         panels: panels,
       );

  /// Blue numbered exit board (see [SignPanel.numbered]) standing in the
  /// gore beside a left-hand slip road.
  const RouteFeature.exitSignNumbered(
    double at,
    SignPanel panel, {
    int side = -1,
  }) : this._(
         PropKind.exitSign,
         at,
         side: side,
         tint: 1,
         offset: 1.42,
         width: 430,
         height: 1250,
         sign: panel,
       );

  /// Green named exit board (see [SignPanel.named]) with destinations and
  /// road codes.
  const RouteFeature.exitSignNamed(double at, SignPanel panel, {int side = -1})
    : this._(
        PropKind.exitSign,
        at,
        side: side,
        tint: 0,
        offset: 1.42,
        width: 450,
        height: 1250,
        sign: panel,
      );

  const RouteFeature.building(
    double at, {
    int side = 1,
    int storeys = 4,
    int depth = 12,
    double width = 4200,
    double setBack = 4.0,
    int tint = 0,
  }) : this._(
         PropKind.building,
         at,
         side: side,
         tint: tint,
         depth: depth,
         detail: storeys * 1.0,
         offset: setBack,
         width: width,
         height: storeys * 450.0,
       );

  const RouteFeature.tunnel(double at, int length)
    : this._(PropKind.tunnel, at, depth: length, offset: 0, height: 1500);

  final PropKind kind;
  final double at;
  final int side;
  final int tint;
  final int depth;
  final double detail;
  final double offset;
  final double width;
  final double height;
  final List<String> lines;
  final List<SignPanel> panels;
  final List<SignBoard> boards;

  /// A single board for the exit-sign factories.
  final SignPanel? sign;
}

class RouteStretch {
  const RouteStretch(
    this.name,
    this.shots, {
    this.pieces = const [RoutePiece(1)],
    this.section = Section.plain,
    this.left = const [],
    this.right = const [],
    this.features = const [],
  });

  final String name;
  final int shots;
  final List<RoutePiece> pieces;
  final Section section;
  final List<SideScenery> left, right;
  final List<RouteFeature> features;

  int get length => shots * segmentsPerShot;
}
