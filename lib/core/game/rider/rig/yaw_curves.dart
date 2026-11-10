// Project imports:
import '../art/sheet/part_motion.dart';

/// How each part of the seated rider answers to yaw, from -1 to 1 (0 is straight).
abstract final class YawCurves {
  static const double helmetFull = 0.5;
  static const double torsoFull = 0.9;
  static const double farArmBehindFrom = 0.12;

  /// Helmet turn from 0 to 1; it leads the body.
  static double helmet(double yaw) => (yaw.abs() / helmetFull).clamp(0.0, 1.0);

  /// Torso turn from 0 to 1; it lags behind the helmet.
  static double torso(double yaw) => PartMotion.smooth(0, torsoFull, yaw.abs());

  /// Share of the side helmet and side leg blended over the rear art.
  static double sideFade(double yaw) =>
      PartMotion.smooth(0.55, 0.95, helmet(yaw));

  /// True when the far arm sits behind the torso.
  static bool farArmBehind(double yaw) => yaw.abs() >= farArmBehindFrom;
}
