// Dart imports:
import 'dart:ui';

// Project imports:
import '../../rider_pose.dart';
import '../../view/bike_anchors.dart';
import '../../view/bike_view_painter.dart';
import '../../view/part_painter.dart';
import '../../view/rider_view.dart';
import 'bike_panel.dart';
import 'rider_bike.dart';
import 'tail_parts.dart';

/// The bike seen from behind, as the player sees it while racing.
class RearBikePainter extends RiderPartPainter implements BikeViewPainter {
  RearBikePainter(super.look)
    : _frame = RiderBike(look),
      _panels = BikePanels(look),
      _tail = TailParts(look);

  final RiderBike _frame;
  final BikePanels _panels;
  final TailParts _tail;

  @override
  RiderView get view => RiderView.rear;

  @override
  void paintShadow(Canvas canvas, RiderPose pose) => _frame.paintShadow(canvas, pose);

  @override
  void paintBehindRider(Paint paint, Path path, Canvas canvas, RiderPose pose) =>
      _frame.handleBars(paint, path, canvas, pose);

  @override
  void paintInFrontOfRider(Paint paint, Path path, Canvas canvas, RiderPose pose) {
    _frame.paintBody(paint, path, canvas, pose);
    _panels.paint(paint, path, canvas, pose);
    _tail.paint(paint, path, canvas, pose);
  }

  @override
  void paintOverRider(Paint paint, Path path, Canvas canvas, RiderPose pose) =>
      _tail.paintWheel(paint, canvas, pose);

  @override
  BikeAnchors anchors(RiderPose pose) {
    final spec = view.canvas;
    return BikeAnchors(
      seat: Offset(spec.midX, 40),
      leftGrip: handOf(-1, pose),
      rightGrip: handOf(1, pose),
      leftPeg: const Offset(24, 86),
      rightPeg: Offset(spec.width - 24, 86),
      wheelContact: Offset(spec.midX, spec.groundY),
    );
  }
}
