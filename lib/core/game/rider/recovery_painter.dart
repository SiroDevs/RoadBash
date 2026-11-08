// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../bike/art/road_bash_bike_painter.dart';
import 'art/road_bash_rider_painter.dart';
import 'view/part_painter.dart';

/// Ground-level rider and motorcycle artwork used between a wipeout and remount.
/// Coordinates match the rear rider sprite so it scales cleanly in the race.
class RecoveryPainter extends RiderPartPainter {
  RecoveryPainter(super.look);

  final RoadBashBikePainter _bikeArt = RoadBashBikePainter();
  final RoadBashRiderPainter _riderArt = RoadBashRiderPainter();

  void paint(
    Canvas canvas, {
    required bool running,
    required double time,
    required double fallSide,
    required double runProgress,
    required double steerOffset,
    required double fallProgress,
  }) {
    _drawBike(canvas, fallSide, fallProgress);
    if (running) {
      _drawRunner(canvas, fallSide, runProgress, steerOffset, time);
    } else if (fallProgress < 0.55) {
      _drawMountedRider(canvas, fallSide, fallProgress);
    } else {
      _drawFallenRider(canvas, fallSide);
    }
  }

  void _drawBike(Canvas canvas, double side, double fallProgress) {
    oval(
      canvas,
      Rect.fromCenter(
        center: Offset(
          RiderPartPainter.midX + side * 17,
          RiderPartPainter.groundY - 1,
        ),
        width: 72,
        height: 9,
      ),
      const Color(0x55000000),
    );
    canvas
      ..save()
      ..translate(
        RiderPartPainter.midX + side * 17,
        RiderPartPainter.groundY - 2,
      )
      ..rotate(side * 1.3 * fallProgress)
      ..scale(0.46)
      ..translate(-RiderPartPainter.midX, -RiderPartPainter.groundY);
    _bikeArt.paintRear(canvas);
    canvas.restore();
  }

  void _drawRunner(
    Canvas canvas,
    double side,
    double progress,
    double steerOffset,
    double time,
  ) {
    final eased = progress * progress * (3 - 2 * progress);
    final startX = RiderPartPainter.midX + side * 42;
    final bikeX = RiderPartPainter.midX + side * 17;
    final x = startX + (bikeX - startX) * eased + steerOffset * 40;
    final bounce = math.sin(time * 13).abs() * 1.5;
    oval(
      canvas,
      Rect.fromCenter(
        center: Offset(x, RiderPartPainter.groundY - 1),
        width: 22,
        height: 5,
      ),
      const Color(0x44000000),
    );
    canvas
      ..save()
      ..translate(x, RiderPartPainter.groundY - bounce)
      ..scale(side > 0 ? -0.58 : 0.58, 0.58)
      ..translate(-RiderPartPainter.midX, -RiderPartPainter.groundY);
    _riderArt.paintRunning(canvas);
    canvas.restore();
  }

  void _drawMountedRider(Canvas canvas, double side, double progress) {
    canvas
      ..save()
      ..translate(
        RiderPartPainter.midX + side * 17,
        RiderPartPainter.groundY - 2,
      )
      ..rotate(side * 1.3 * progress)
      ..scale(0.62)
      ..translate(-RiderPartPainter.midX, -RiderPartPainter.groundY);
    _riderArt.paintRear(canvas);
    canvas.restore();
  }

  void _drawFallenRider(Canvas canvas, double side) {
    oval(
      canvas,
      Rect.fromCenter(
        center: Offset(
          RiderPartPainter.midX + side * 35,
          RiderPartPainter.groundY - 1,
        ),
        width: 46,
        height: 7,
      ),
      const Color(0x44000000),
    );
    canvas
      ..save()
      ..translate(
        RiderPartPainter.midX + side * 35,
        RiderPartPainter.groundY - 3,
      )
      ..rotate(side * math.pi / 2)
      ..scale(0.45)
      ..translate(-RiderPartPainter.midX, -RiderPartPainter.groundY);
    _riderArt.paintRear(canvas);
    canvas.restore();
  }
}
