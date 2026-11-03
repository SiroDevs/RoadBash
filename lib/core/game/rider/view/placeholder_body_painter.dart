// Dart imports:
import 'dart:ui';

// Project imports:
import '../look/rider_look.dart';
import '../rider_pose.dart';
import 'bike_anchors.dart';
import 'body_view_painter.dart';
import 'part_painter.dart';
import 'rider_view.dart';

/// A schematic rider for a view that has not been drawn yet: torso, head, arms
/// to the grips and legs to the pegs, all taken from the bike's anchors. The
/// front, left and right body painters start as this; replace the pieces with
/// the real drawing one at a time.
class PlaceholderBodyPainter extends RiderPartPainter implements BodyViewPainter {
  PlaceholderBodyPainter(RiderLook look, this.view) : super(look);

  @override
  final RiderView view;

  @override
  void paint(Paint paint, Path path, Canvas canvas, RiderPose pose, BikeAnchors anchors) {
    final hip = anchors.seat;
    final reach = view.isSide ? anchors.rightGrip : Offset((anchors.leftGrip.dx + anchors.rightGrip.dx) / 2, anchors.leftGrip.dy);
    final shoulder = Offset(hip.dx + (reach.dx - hip.dx) * 0.4, hip.dy - 38 + tuckOf(pose));

    for (final side in [-1, 1]) {
      limb(canvas, hip, anchors.pegOf(side), 11, look.suit);
      limb(canvas, shoulder, anchors.gripOf(side), 7, look.suit);
    }
    limb(canvas, hip, shoulder, 22, look.suit);
    oval(canvas, Rect.fromCenter(center: shoulder + const Offset(0, -16), width: 24, height: 26), look.helmet);
    for (final side in [-1, 1]) {
      oval(canvas, Rect.fromCenter(center: anchors.gripOf(side), width: 9, height: 9), look.gloves);
    }
  }
}
