// Project imports:
part of '../rider_painter.dart';

/// Everything the rider wears: legs, torso, arms and helmet.
class RiderTorso extends RiderPartPainter {
  static const _helmetShell = Color(0xFFF2C21C);
  static const _helmetShade = Color(0xFFC79A0F);
  static const _helmetGloss = Color(0x66FFFFFF);
  static const _suitMain = Color(0xFFC63F96);
  static const _suitPanel = Color(0xFFE9E3F0);
  static const _suitTrim = Color(0xFFF2C21C);
  // static const _suitLower = Color(0xFFE8551D);
  static const _boot = Color(0xFF131316);
  // static const _glove = Color(0xFF191A1E);

  static const double _mid = RiderPartPainter.midX;

  void paintLegs(Canvas canva, RiderPose pose) {
    final tail = tailLift(pose);

    // Right leg stays tucked against the tank.
    quad(canva, RiderPartPainter.leather, [
      Offset(82, 54),
      Offset(108, 58),
      Offset(86, 102 + tail),
      Offset(85, 90 + tail),
    ]);
    fill(canva, Rect.fromLTRB(90, 106 + tail, 88, 100 + tail), _boot, 4);

    // Left leg swings out and down as the bike comes to a stop.
    final drop = 34 * pose.foot;
    canva.save();
    canva.translate(40, 72);
    canva.rotate(0.5 * pose.foot);
    canva.translate(-40, -72);
    quad(canva, RiderPartPainter.leather, [
      const Offset(32, 78),
      const Offset(48, 74),
      Offset(49, 108 + tail + drop),
      Offset(34, 112 + tail + drop),
    ]);
    fill(
      canva,
      Rect.fromLTRB(32, 106 + tail + drop, 50, 120 + tail + drop),
      _boot,
      4,
    );
    canva.restore();
  }

  void paintTorso(Canvas canva, RiderPose pose) {
    final tuck = tuckOf(pose);

    scratch.reset();
    scratch
      ..moveTo(30,  tuck) // top left, left horizontal position 
      ..cubicTo(25, 70 + tuck, 40, 65 + tuck, 40, 50 + tuck * 0.4)
      ..lineTo(80, 60 + tuck * 0.9) // bottom right, right horizontal position
      ..cubicTo(95, 70 + tuck, 80, 10 + tuck, 80, 5 + tuck)
      ..close();
    ink
      ..style = PaintingStyle.fill
      ..color = _suitMain;
    canva.drawPath(scratch, ink);

    // Spine panel.
    quad(canva, _suitPanel, [
      Offset(52, 40 + tuck),
      Offset(68, 40 + tuck),
      Offset(70, 60 + tuck * 0.4),
      Offset(50, 60 + tuck * 0.4),
    ]);

    // Shoulder armour.
    fill(canva, Rect.fromLTRB(30, 32 + tuck, 49, 20 + tuck), _suitTrim, 9);
    fill(canva, Rect.fromLTRB(70, 32 + tuck, 93, 20 + tuck), _suitTrim, 9);
    fill(canva, Rect.fromLTRB(42, 30 + tuck, 76, 22 + tuck), _suitMain, 7);
  }

  /// Sleeves and gloves, reaching for the grips [RiderBike] draws over them.
  void paintArms(Canvas canva, RiderPose pose) {
    final tuck = tuckOf(pose);

    for (final side in const [-1, 1]) {
      final shoulder = Offset(_mid + side * 27, 32 + tuck);
      final hand = handOf(side, pose);
      limb(canva, shoulder, hand, 18, _suitMain);
      limb(canva, shoulder, hand, 7, _suitTrim);
    }
  }

  void paintHead(Canvas canva, RiderPose pose) {
    final neckY = 44 + tuckOf(pose);

    fill(
      canva,
      Rect.fromLTRB(53, neckY - 30, 67, neckY - 20),
      RiderPartPainter.leather,
      5,
    );

    canva.save();
    canva.translate(_mid, neckY);
    canva.rotate(-pose.lean * 0.3);
    canva.translate(-_mid, -neckY);

    final cy = neckY - 50;
    oval(
      canva,
      Rect.fromCenter(center: Offset(_mid, cy), width: 42, height: 44),
      _helmetShell,
    );
    quad(canva, _helmetShade, [
      Offset(_mid - 19, cy + 6),
      Offset(_mid + 19, cy + 6),
      Offset(_mid + 15, cy + 20),
      Offset(_mid - 15, cy + 20),
    ]);
    fill(
      canva,
      Rect.fromLTRB(_mid - 9, cy - 20, _mid + 9, cy - 8),
      _helmetShade,
      5,
    );
    oval(
      canva,
      Rect.fromCenter(center: Offset(_mid - 9, cy - 9), width: 15, height: 11),
      _helmetGloss,
    );
    canva.restore();
  }
}
