import 'sign_panel.dart';

enum PropKind {
  building,
  broadleaf,
  pine,
  acacia,
  bush,
  lamp,
  sign,
  billboard,
  exitSign,
  wall,
  slipRoad,
  tunnel,
  footbridge,
  gantry,
  overpass;

  bool get spansRoad =>
      this == footbridge || this == gantry || this == overpass;
}

class Prop {
  const Prop({
    required this.kind,
    required this.anchor,
    required this.side,
    required this.offset,
    required this.width,
    required this.height,
    this.depth = 0,
    this.tint = 0,
    this.detail = 0,
    this.drop = 0,
    this.signs = const [],
  });

  final PropKind kind;
  final int anchor;
  final int side;
  final double offset;
  final double width;
  final double height;
  final int depth;
  final int tint;
  final double detail;
  final double drop;
  final List<SignPanel> signs;
}
