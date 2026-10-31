// Dart imports:
import 'dart:ui';

// Project imports:
import 'look/bike_look.dart';
import 'profile_ink.dart';
import 'rider_pose.dart';

/// Paints the bike itself in the side view, facing right.
class ProfileBike extends ProfileInk {
  ProfileBike(this.bike);

  final BikeLook bike;

  static const double wheelRadius = 34;
  static const double wheelOffset = 80;

  /// Draws the swingarm, fork, exhaust and engine.
  void paintFrame(Canvas canvas) {
    const rearHub = Offset(-wheelOffset, -wheelRadius);
    const frontHub = Offset(wheelOffset, -wheelRadius);
    stroke(canvas, bike.frame, 6, rearHub, const Offset(-8, -44));
    stroke(
      canvas,
      const Color(0xFF9A9A9A),
      7,
      frontHub,
      const Offset(58, -100),
    );
    stroke(
      canvas,
      const Color(0xFF777777),
      8,
      const Offset(-14, -42),
      const Offset(-92, -56),
    );
    stroke(
      canvas,
      const Color(0xFF333333),
      9,
      const Offset(-92, -56),
      const Offset(-98, -57),
    );
    fill(canvas, bike.panelDark, const [
      Offset(-26, -70),
      Offset(30, -70),
      Offset(34, -32),
      Offset(-22, -32),
    ]);
    fill(canvas, bike.frame, const [
      Offset(-18, -62),
      Offset(24, -62),
      Offset(26, -40),
      Offset(-14, -40),
    ]);
  }

  /// Draws the fairing, tank, seat, tail and lights.
  void paintBodywork(Canvas canvas, RiderPose pose) {
    fill(canvas, bike.panel, const [
      Offset(60, -78),
      Offset(44, -34),
      Offset(8, -30),
      Offset(-6, -48),
      Offset(10, -76),
    ]);
    fill(canvas, bike.panel, const [
      Offset(-8, -104),
      Offset(-96, -98),
      Offset(-104, -84),
      Offset(-10, -80),
    ]);
    fill(canvas, bike.accent, const [
      Offset(-30, -103),
      Offset(-96, -98),
      Offset(-100, -91),
      Offset(-30, -95),
    ]);
    fill(
      canvas,
      pose.braking ? const Color(0xFFFF4040) : bike.brakeLight,
      const [
        Offset(-104, -86),
        Offset(-108, -96),
        Offset(-100, -98),
        Offset(-98, -86),
      ],
    );
    fill(canvas, bike.panel, const [
      Offset(-10, -108),
      Offset(34, -112),
      Offset(56, -104),
      Offset(54, -84),
      Offset(10, -76),
      Offset(-6, -86),
    ]);
    fill(canvas, bike.accent, const [
      Offset(0, -100),
      Offset(40, -106),
      Offset(52, -98),
      Offset(0, -90),
    ]);
    fill(canvas, bike.panel, const [
      Offset(40, -112),
      Offset(72, -110),
      Offset(88, -94),
      Offset(64, -82),
      Offset(52, -96),
    ]);
    fill(canvas, const Color(0xC8CFE9F5), const [
      Offset(44, -112),
      Offset(62, -128),
      Offset(70, -112),
    ]);
    fill(canvas, const Color(0xFFFFF2B0), const [
      Offset(72, -96),
      Offset(86, -95),
      Offset(84, -90),
      Offset(70, -90),
    ]);
    stroke(
      canvas,
      bike.frame,
      4,
      const Offset(54, -112),
      const Offset(50, -126),
    );
  }
}
