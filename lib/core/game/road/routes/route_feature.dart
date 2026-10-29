// Project imports:
import '../props/prop.dart';
import '../props/sign_panel.dart';

/// A roadside feature placed at a point along a route stretch.
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

  final SignPanel? sign;
}
