// Project imports:
import 'sign_panel.dart';

enum PropKind {
  building,
  broadleaf,
  pine,
  acacia,
  bush,
  palm,
  rock,
  lamp,
  sign,
  billboard,
  exitSign,
  wall,
  guardrail,
  slipRoad,
  tunnel,
  footbridge,
  gantry,
  overpass,
  block,
  post,
  spectator;

  bool get spansRoad =>
      this == footbridge || this == gantry || this == overpass;
}

/// When a prop is drawn relative to the finish plaza on the last lap.
enum PropPhase { always, finishOnly, hiddenAtFinish }

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
    this.boards = const [],
    this.phase = PropPhase.always,
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
  final List<SignBoard> boards;
  final PropPhase phase;

  Prop withPhase(PropPhase phase) => Prop(
    kind: kind,
    anchor: anchor,
    side: side,
    offset: offset,
    width: width,
    height: height,
    depth: depth,
    tint: tint,
    detail: detail,
    drop: drop,
    signs: signs,
    boards: boards,
    phase: phase,
  );
}
