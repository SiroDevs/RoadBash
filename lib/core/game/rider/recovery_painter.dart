// Dart imports:
import 'dart:ui';

// Project imports:
import 'art/sheet/bike_figure.dart';
import 'look/rider_look.dart';
import 'rider_pose.dart';
import 'rig/rider_on_foot.dart';
import 'rig/seated_rider.dart';

/// Paints the fall, roadside run, mount and return as separate objects.
class RecoveryPainter {
  RecoveryPainter(RiderLook look)
    : _bike = BikeFigure(look),
      _seated = SeatedRiderFigure(look),
      _onFoot = RiderOnFoot(look);

  static const double groundY = 166;
  static const double midX = 60;
  static const double figureScale = 0.6;
  static const double strideLength = 45;
  static const double minCycleRate = 0.15;

  final BikeFigure _bike;
  final SeatedRiderFigure _seated;
  final RiderOnFoot _onFoot;
  final RiderPose _pose = RiderPose();
  double _cycle = 0;
  double _lastRun = 0;
  double _lastTime = 0;
  final Paint _shadow = Paint()..color = const Color(0x44000000);

  /// Paints the bike and rider at their own road positions during recovery.
  void paint(
    Canvas canvas, {
    required bool running,
    required bool standing,
    required bool mounting,
    required bool returning,
    required double time,
    required double fallSide,
    required double standProgress,
    required double mountProgress,
    required double returnProgress,
    required double fallProgress,
    required double runLateral,
    required double bikeLateral,
    required double crashLateral,
    required double currentLateral,
    required double lateralScale,
  }) {
    _advanceStride(running, runLateral, lateralScale, time);
    double screenX(double lateral) =>
        midX + (lateral - currentLateral) * lateralScale;
    final recovering = running || standing || mounting || returning;
    if (returning) {
      _paintReturn(canvas, fallSide, returnProgress);
      return;
    }
    final bikePosition = recovering
        ? bikeLateral
        : crashLateral + (bikeLateral - crashLateral) * fallProgress;
    final bikeTilt = mounting
        ? 1 - mountProgress
        : (recovering ? 1.0 : fallProgress);
    _paintBike(canvas, screenX(bikePosition), fallSide, bikeTilt);
    final riderLateral = recovering
        ? runLateral
        : crashLateral + (runLateral - crashLateral) * fallProgress;
    if (mounting) {
      final lateral = runLateral + (bikeLateral - runLateral) * mountProgress;
      _paintMounting(canvas, screenX(lateral), fallSide, mountProgress);
    } else {
      _paintOnFoot(
        canvas,
        screenX(riderLateral),
        fallSide,
        running: running,
        standing: standing,
        standProgress: standProgress,
        fallProgress: fallProgress,
        time: time,
      );
    }
  }

  /// Moves the stride on by the ground the runner covered, so feet do not slide.
  void _advanceStride(
    bool running,
    double runLateral,
    double scale,
    double time,
  ) {
    final elapsed = (time - _lastTime).clamp(0.0, 0.1).toDouble();
    if (running) {
      final travel = (runLateral - _lastRun).abs() * scale / figureScale;
      _cycle += travel / strideLength + minCycleRate * elapsed;
    }
    _lastRun = runLateral;
    _lastTime = time;
  }

  void _paintBike(Canvas canvas, double x, double side, double tilt) {
    _paintShadow(canvas, x, 72);
    canvas
      ..save()
      ..translate(x, groundY - 2)
      ..rotate(side * 1.3 * tilt)
      ..scale(figureScale)
      ..translate(-midX, -groundY);
    _bike.paint(canvas, side * 0.7 * tilt);
    canvas.restore();
  }

  void _paintOnFoot(
    Canvas canvas,
    double x,
    double side, {
    required bool running,
    required bool standing,
    required double standProgress,
    required double fallProgress,
    required double time,
  }) {
    _paintShadow(canvas, x, 30);
    final towardBike = -side;
    final facing = (running ? towardBike : side) >= 0 ? 1.0 : -1.0;
    canvas
      ..save()
      ..translate(x, groundY - 2)
      ..scale(figureScale * facing, figureScale)
      ..translate(-midX, -groundY);
    if (running) {
      _onFoot.paintRunning(canvas, _cycle);
    } else if (standing) {
      _onFoot.paintGettingUp(canvas, standProgress);
    } else if (fallProgress < 0.12) {
      _paintSeatedAt(canvas);
    } else {
      _onFoot.paintThrown(canvas, fallProgress);
    }
    canvas.restore();
  }

  void _paintMounting(Canvas canvas, double x, double side, double progress) {
    _paintShadow(canvas, x, 30);
    canvas
      ..save()
      ..translate(x, groundY - 2)
      ..scale(figureScale * (-side >= 0 ? 1 : -1), figureScale)
      ..translate(-midX, -groundY);
    final seated = _onFoot.paintMounting(canvas, progress);
    canvas.restore();
    if (!seated) return;
    canvas
      ..save()
      ..translate(x, groundY - 2)
      ..scale(figureScale)
      ..translate(-midX, -groundY);
    _paintSeatedAt(canvas);
    canvas.restore();
  }

  void _paintReturn(Canvas canvas, double side, double progress) {
    final yaw = -side * 0.65 * (1 - progress);
    _paintShadow(canvas, midX, 72);
    canvas
      ..save()
      ..translate(midX, groundY - 2)
      ..scale(figureScale)
      ..translate(-midX, -groundY);
    _bike.paint(canvas, yaw);
    _pose
      ..perspective = yaw
      ..foot = 0;
    _seated.paint(canvas, _pose);
    canvas.restore();
  }

  void _paintSeatedAt(Canvas canvas) {
    _pose
      ..perspective = 0
      ..foot = 0;
    _seated.paint(canvas, _pose);
  }

  void _paintShadow(Canvas canvas, double x, double width) {
    canvas.drawOval(
      Rect.fromCenter(center: Offset(x, groundY - 1), width: width, height: 7),
      _shadow,
    );
  }
}
