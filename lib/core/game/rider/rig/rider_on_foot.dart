// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../art/sheet/part_motion.dart';
import '../look/rider_look.dart';
import 'runner_figure.dart';
import 'runner_pose.dart';

/// The rider's poses off the bike, all drawn facing right in the design box.
class RiderOnFoot {
  RiderOnFoot(RiderLook look) : _figure = RunnerFigure(look);

  static const Offset bodyCentre = Offset(60, 95);
  static const double lyingDrop = 40;

  static const RunnerPose _flung = RunnerPose(
    far: LegJoints(thigh: 0.8, flex: 0.5),
    near: LegJoints(thigh: -0.6, flex: 0.3),
    armFar: -1.4,
    armNear: 1.2,
  );
  static const RunnerPose _idle = RunnerPose(
    far: LegJoints(thigh: 0.04, flex: 0.12),
    near: LegJoints(thigh: -0.04, flex: 0.12),
  );
  static const RunnerPose _legOver = RunnerPose(
    far: LegJoints(thigh: 0.05, flex: 0.12),
    near: LegJoints(thigh: 1.25, flex: 1.35, foot: 0.3),
    armFar: -0.3,
    armNear: -0.5,
    lean: 0.22,
  );

  final RunnerFigure _figure;

  /// Rider flung from the bike, spinning once and landing on his side.
  void paintThrown(Canvas canvas, double progress) {
    final eased = 1 - (1 - progress) * (1 - progress);
    final lying = PartMotion.smooth(0.7, 1, progress);
    final lift = math.sin(math.pi * progress) * 10;
    PartMotion.around(
      canvas,
      bodyCentre,
      () => _figure.paintPose(canvas, _flung),
      angle: math.pi * 2.5 * eased,
      shift: Offset(0, lyingDrop * lying - lift),
    );
  }

  /// Rider pushing himself up from the ground and standing.
  void paintGettingUp(Canvas canvas, double progress) {
    final eased = progress * progress * (3 - 2 * progress);
    final turn = math.pi / 2 * (1 - eased);
    final drop = lyingDrop * (1 - eased);
    PartMotion.around(
      canvas,
      bodyCentre,
      () {
        if (progress < 0.55) {
          _figure.paintPose(canvas, RunnerPose.lerp(_flung, _idle, eased));
        } else {
          _figure.paintStanding(canvas, 0);
        }
      },
      angle: turn,
      shift: Offset(0, drop),
    );
  }

  /// Rider jogging with legs and arms swinging at the given stride time.
  void paintRunning(Canvas canvas, double cycle) =>
      _figure.paintPose(canvas, RunGait.at(cycle));

  /// Rider stepping over the bike; returns true once he sits on the seat.
  bool paintMounting(Canvas canvas, double progress) {
    if (progress >= 0.7) return true;
    final swing = PartMotion.smooth(0.1, 0.6, progress);
    final rise = math.sin(math.pi * swing) * 12;
    final pose = RunnerPose.lerp(_idle, _legOver, swing);
    PartMotion.around(
      canvas,
      bodyCentre,
      () => progress < 0.15
          ? _figure.paintStanding(canvas, 0)
          : _figure.paintPose(canvas, pose),
      shift: Offset(0, -rise),
    );
    return false;
  }
}
