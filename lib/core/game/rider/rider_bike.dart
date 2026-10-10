// Dart imports:
import 'dart:ui';

// Project imports:
import 'rider_painter.dart';
import 'rider_pose.dart';

/// Everything in the motorbike.
class RiderBike extends RiderPartPainter {
  static const _bodywork = Color(0xFFC9222B);
  static const _bodywork1 = Color.fromARGB(255, 9, 16, 210);
  static const _bodyShade = Color(0xFF8E1820);
  static const _chrome = Color(0xFFB9BEC6);
  static const _chromeDark = Color(0xFF6E737B);
  static const _tyre = Color(0xFF000000);
  static const _tail = Color(0xFF152326);
  static const _shadowInk = Color(0x4D000000);

  /// Stays flat on the road while the bike banks over it.
  void paintShadow(Canvas c, RiderPose p) {
    final slip = p.lean * 46;
    final squash = 1 - p.lean.abs() * 0.5;
    oval(
      c,
      Rect.fromCenter(
        center: Offset(
          RiderPartPainter.midX + slip * 0.5,
          RiderPartPainter.groundY + 4,
        ),
        width: 96 * squash,
        height: 15,
      ),
      _shadowInk,
    );
  }

  /// Wheel, exhausts and tail: the parts the rider sits in front of.
  void paintRearEnd(Canvas c, RiderPose p) {
    final tail = tailLift(p);
    _tailUnit(c, p, tail);
    _rearWheel(c, p);
    _exhausts(c, tail);
  }

  /// Bar ends and mirrors poking past the gloves. Drawn after the arms.
  void paintBarEnds(Canvas c, RiderPose p) {
    for (final side in const [-1, 1]) {
      final hand = handOf(side, p);
      final tip = Offset(hand.dx + side * 9, hand.dy - 2);
      limb(c, hand, tip, 5, _chromeDark);
      oval(
        c,
        Rect.fromCenter(
          center: Offset(tip.dx + side * 2, tip.dy - 13),
          width: 13,
          height: 9,
        ),
        RiderPartPainter.leather,
      );
      limb(c, tip, Offset(tip.dx + side * 2, tip.dy - 10), 3, _chromeDark);
    }
  }

  void _rearWheel(Canvas c, RiderPose p) {
    fill(c, const Rect.fromLTRB(48, 96, 72, 164), _tyre, 10);
  }

  void _exhausts(Canvas c, double tail) {
    for (final side in const [-1, 1]) {
      final cx = RiderPartPainter.midX + side * 24;
      fill(
        c,
        Rect.fromLTRB(cx - 7, 105 + tail, cx + 7, 121 + tail),
        _tyre,
        8,
      );
      oval(
        c,
        Rect.fromCenter(center: Offset(cx, 113 + tail), width: 13, height: 15),
        _chromeDark,
      );
      oval(
        c,
        Rect.fromCenter(center: Offset(cx, 113 + tail), width: 8, height: 10),
        const Color(0xFF17181B),
      );
    }
  }

  void _tailUnit(Canvas c, RiderPose p, double tail) {
    quad(c, _bodywork1, [
      Offset(72, 68 + tail),
      Offset(82, 78 + tail),
      Offset(82, 85 + tail),
      Offset(72, 78 + tail),
    ]);
    quad(c, _bodywork1, [
      Offset(38, 78 + tail),
      Offset(48, 68 + tail),
      Offset(48, 78 + tail),
      Offset(38, 88 + tail),
    ]);
    quad(c, _tail, [
      Offset(44, 78 + tail),
      Offset(76, 78 + tail),
      Offset(76, 102 + tail),
      Offset(44, 102 + tail),
    ]);
    fill(
      c,
      Rect.fromLTRB(48, 65 + tail, 72, 78 + tail),
      const Color(0xFFFF2B21),
      4,
    );
  }
}
