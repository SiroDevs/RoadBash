// Project imports:
part of '../rider_painter.dart';

/// Everything in the motorbike.
class RiderBike extends RiderPartPainter {
  void paintBike(Paint paint, Path path, Canvas canva, RiderPose pose) {
    _paintBody(paint, path, canva, pose);
  }

  /// Stays flat on the road while the bike banks over it.
  void paintShadow(Canvas canva, RiderPose pose) {
    final slip = pose.lean * 46;
    final squash = 1 - pose.lean.abs() * 0.5;
    oval(
      canva,
      Rect.fromCenter(
        center: Offset(
          RiderPartPainter.midX + slip * 0.5,
          RiderPartPainter.groundY + 4,
        ),
        width: 96 * squash,
        height: 15,
      ),
      Color(0x4D000000),
    );
  }

  /// Bar ends and mirrors poking past the gloves. Drawn after the arms.
  void paintBarEnds(Canvas canva, RiderPose pose) {
    for (final side in const [-1, 1]) {
      final hand = handOf(side, pose);
      final tip = Offset(hand.dx + side * 9, hand.dy - 2);
      limb(canva, hand, tip, 5, Color(0xFF6E737B));
      oval(
        canva,
        Rect.fromCenter(
          center: Offset(tip.dx + side * 2, tip.dy - 13),
          width: 13,
          height: 9,
        ),
        RiderPartPainter.leather,
      );
      limb(
        canva,
        tip,
        Offset(tip.dx + side * 2, tip.dy - 10),
        3,
        Color(0xFF6E737B),
      );
    }
  }

  void _paintBody(Paint paint, Path path, Canvas canva, RiderPose pose) {
    path
      ..reset()
      ..moveTo(46.0, 32.0)
      ..lineTo(54.0, 29.0)
      ..lineTo(64.0, 29.0)
      ..lineTo(75.0, 32.0)
      ..lineTo(81.0, 37.0)
      ..lineTo(84.0, 45.0)
      ..lineTo(88.0, 47.0)
      ..lineTo(89.0, 52.0)
      ..lineTo(91.0, 53.0)
      ..lineTo(91.0, 60.0)
      ..lineTo(88.0, 63.0)
      ..lineTo(87.0, 65.0)
      ..lineTo(88.0, 68.0)
      ..lineTo(87.0, 73.0)
      ..lineTo(87.0, 78.0)
      ..lineTo(83.0, 85.0)
      ..lineTo(83.0, 91.0)
      ..lineTo(84.0, 93.0)
      ..lineTo(84.0, 93.0)
      ..lineTo(71.0, 105.0)
      ..lineTo(47.0, 104.0)
      ..lineTo(47.0, 129.0)
      ..lineTo(44.0, 129.0)
      ..lineTo(43.0, 124.0)
      ..lineTo(42.0, 124.0)
      ..lineTo(41.0, 117.0)
      ..lineTo(35.0, 113.0)
      ..lineTo(36.0, 111.0)
      ..lineTo(41.0, 111.0)
      ..lineTo(41.0, 108.0)
      ..lineTo(39.0, 106.0)
      ..lineTo(36.0, 106.0)
      ..lineTo(34.0, 104.0)
      ..lineTo(36.0, 103.0)
      ..lineTo(36.0, 101.0)
      ..lineTo(29.0, 100.0)
      ..lineTo(29.0, 98.0)
      ..lineTo(37.0, 99.0)
      ..lineTo(37.0, 97.0)
      ..lineTo(35.0, 94.0)
      ..lineTo(36.0, 83.0)
      ..lineTo(33.0, 82.0)
      ..lineTo(31.0, 78.0)
      ..lineTo(29.0, 73.0)
      ..lineTo(29.0, 69.0)
      ..lineTo(31.0, 69.0)
      ..lineTo(31.0, 67.0)
      ..lineTo(31.0, 63.0)
      ..lineTo(30.0, 60.0)
      ..lineTo(29.0, 55.0)
      ..lineTo(29.0, 52.0)
      ..lineTo(31.0, 52.0)
      ..lineTo(31.0, 47.0)
      ..lineTo(36.0, 44.0)
      ..lineTo(39.0, 41.0)
      ..lineTo(41.0, 36.0)
      ..close();
    paint
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF000000);
    canva.drawPath(path, paint);
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.25
      ..color = const Color(0xFFC3C3C3);
    canva.drawPath(path, paint);
  }
}
