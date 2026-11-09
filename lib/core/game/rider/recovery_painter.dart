import 'dart:math' as math;
import 'dart:ui';

import 'art/user_bike_art_painter.dart';
import 'art/user_rider_art_painter.dart';
import 'look/rider_look.dart';
import 'rider_pose.dart';
import 'view/part_painter.dart';

/// Paints the fall, roadside run, mount and return using the supplied parts.
class RecoveryPainter extends RiderPartPainter {
  RecoveryPainter(super.look)
    : _bikeArt = UserBikeArtPainter(look),
      _riderArt = UserRiderArtPainter(look);

  static const Rect _fadeBounds = Rect.fromLTWH(-1600, -200, 3200, 420);

  final UserBikeArtPainter _bikeArt;
  final UserRiderArtPainter _riderArt;
  final RiderPose _pose = RiderPose();

  /// Paints the bike and rider at separate road positions during recovery.
  void paint(
    Canvas canvas, {
    required bool running,
    required bool mounting,
    required bool returning,
    required double time,
    required double fallSide,
    required double runProgress,
    required double mountProgress,
    required double returnProgress,
    required double steerOffset,
    required double fallProgress,
    required double runLateral,
    required double bikeLateral,
    required double crashLateral,
    required double currentLateral,
    required double lateralScale,
  }) {
    final bikePosition = returning
        ? _mix(bikeLateral, 0, returnProgress)
        : (running || mounting
              ? bikeLateral
              : _mix(crashLateral, bikeLateral, fallProgress));
    final bikeTilt = returning
        ? 0.0
        : mounting
        ? 1 - mountProgress
        : fallProgress;
    _drawBike(
      canvas,
      _canvasX(bikePosition, currentLateral, lateralScale),
      fallSide,
      bikeTilt,
    );

    if (running) {
      final lateral = runLateral + steerOffset;
      _drawRunner(
        canvas,
        _canvasX(lateral, currentLateral, lateralScale),
        fallSide,
        time,
      );
    } else if (mounting) {
      final riderX = _canvasX(
        _mix(runLateral, bikeLateral, mountProgress),
        currentLateral,
        lateralScale,
      );
      _drawFaded(canvas, 1 - mountProgress, () {
        _drawRunner(canvas, riderX, fallSide, time);
      });
      _drawFaded(canvas, mountProgress, () {
        _drawMounted(canvas, riderX, fallSide);
      });
    } else if (returning) {
      final position = _mix(bikeLateral, 0, returnProgress);
      _drawMounted(
        canvas,
        _canvasX(position, currentLateral, lateralScale),
        fallSide,
      );
    } else {
      final landed = _mix(crashLateral, fallSide * 1.52, fallProgress);
      final riderX = _canvasX(landed, currentLateral, lateralScale);
      if (fallProgress < 0.55) {
        _drawMounted(canvas, riderX, fallSide);
      } else {
        _drawFallen(canvas, riderX, fallSide);
      }
    }
  }

  void _drawBike(Canvas canvas, double x, double side, double tilt) {
    oval(
      canvas,
      Rect.fromCenter(
        center: Offset(x, RiderPartPainter.groundY - 1),
        width: 72,
        height: 9,
      ),
      const Color(0x55000000),
    );
    canvas
      ..save()
      ..translate(x, RiderPartPainter.groundY - 2)
      ..rotate(side * 1.3 * tilt)
      ..scale(0.46)
      ..translate(-RiderPartPainter.midX, -RiderPartPainter.groundY);
    _bikeArt.paint(canvas, side * 0.7);
    canvas.restore();
  }

  void _drawRunner(Canvas canvas, double x, double side, double time) {
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
    _riderArt.paintRunning(canvas, time * 9);
    canvas.restore();
  }

  void _drawMounted(Canvas canvas, double x, double side) {
    canvas
      ..save()
      ..translate(x, RiderPartPainter.groundY - 2)
      ..scale(0.62)
      ..translate(-RiderPartPainter.midX, -RiderPartPainter.groundY);
    _pose
      ..perspective = side * 0.65
      ..foot = 0;
    _riderArt.paintRacing(canvas, _pose);
    canvas.restore();
  }

  void _drawFallen(Canvas canvas, double x, double side) {
    oval(
      canvas,
      Rect.fromCenter(
        center: Offset(x, RiderPartPainter.groundY - 1),
        width: 46,
        height: 7,
      ),
      const Color(0x44000000),
    );
    canvas
      ..save()
      ..translate(x, RiderPartPainter.groundY - 3)
      ..rotate(side * math.pi / 2)
      ..scale(0.45)
      ..translate(-RiderPartPainter.midX, -RiderPartPainter.groundY);
    _pose.perspective = 0;
    _riderArt.paintRacing(canvas, _pose);
    canvas.restore();
  }

  void _drawFaded(Canvas canvas, double opacity, void Function() paint) {
    if (opacity <= 0) return;
    canvas.saveLayer(
      _fadeBounds,
      Paint()..color = Color.fromARGB((opacity * 255).round(), 255, 255, 255),
    );
    paint();
    canvas.restore();
  }

  double _canvasX(double lateral, double current, double scale) =>
      RiderPartPainter.midX + (lateral - current) * scale;

  double _mix(double start, double end, double amount) =>
      start + (end - start) * amount.clamp(0.0, 1.0);
}
