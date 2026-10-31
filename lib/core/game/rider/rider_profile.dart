// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import 'look/rider_look.dart';
import 'profile_bike.dart';
import 'profile_ink.dart';
import 'rider_pose.dart';

/// Paints the bike and rider from the side, facing right.
///
/// Its origin is the ground point under the middle of the bike, and it is
/// drawn at the same scale as the rear view so the two can be swapped.
class RiderProfile extends ProfileInk {
  RiderProfile(this.look) : _bike = ProfileBike(look.bike);

  final RiderLook look;
  final ProfileBike _bike;

  static const double leanShare = 0.5;

  /// Paints the bike and rider in the given pose.
  void paint(Canvas canvas, RiderPose pose) {
    canvas
      ..save()
      ..translate(0, pose.bob)
      ..rotate(pose.lean * leanShare);
    _wheels(canvas, pose);
    _bike.paintFrame(canvas);
    _bike.paintBodywork(canvas, pose);
    _rider(canvas);
    canvas.restore();
  }

  /// Draws both wheels with spinning spokes.
  void _wheels(Canvas canvas, RiderPose pose) {
    const radius = ProfileBike.wheelRadius;
    final spin = pose.phase * 2 * math.pi;
    for (final side in const [-1.0, 1.0]) {
      final center = Offset(side * ProfileBike.wheelOffset, -radius);
      disc(canvas, const Color(0xFF1A1A1A), center, radius);
      disc(canvas, const Color(0xFFBDBDBD), center, radius - 9);
      disc(canvas, const Color(0xFF2A2A2A), center, radius - 13);
      for (var spoke = 0; spoke < 4; spoke++) {
        final angle = spin + spoke * math.pi / 2;
        final direction = Offset(math.cos(angle), math.sin(angle));
        final tip = center + direction * (radius - 12);
        stroke(canvas, const Color(0xFF8A8A8A), 2.2, center, tip);
      }
      disc(canvas, const Color(0xFF555555), center, 5);
    }
  }

  /// Draws the rider crouched over the bike.
  void _rider(Canvas canvas) {
    const hip = Offset(-36, -112);
    const knee = Offset(4, -98);
    const foot = Offset(-6, -60);
    const shoulder = Offset(18, -142);
    const elbow = Offset(40, -130);
    const hand = Offset(51, -124);
    stroke(canvas, look.suit, 17, hip, knee);
    stroke(canvas, look.suit, 13, knee, foot);
    stroke(
      canvas,
      look.boots,
      9,
      const Offset(-12, -59),
      const Offset(4, -58),
    );
    stroke(canvas, look.suit, 24, hip, shoulder);
    stroke(
      canvas,
      look.stripe,
      4,
      const Offset(-28, -118),
      const Offset(14, -136),
    );
    fill(canvas, look.backPatch, const [
      Offset(-46, -120),
      Offset(-34, -126),
      Offset(-30, -112),
      Offset(-42, -108),
    ]);
    stroke(canvas, look.suit, 10, shoulder, elbow);
    stroke(canvas, look.suit, 9, elbow, hand);
    disc(canvas, look.gloves, hand, 6);
    disc(canvas, look.helmet, const Offset(26, -156), 15);
    fill(canvas, const Color(0xFF222222), const [
      Offset(24, -166),
      Offset(40, -160),
      Offset(38, -152),
      Offset(24, -150),
    ]);
    stroke(
      canvas,
      RiderLook.helmetGloss,
      3,
      const Offset(14, -160),
      const Offset(26, -168),
    );
  }
}
